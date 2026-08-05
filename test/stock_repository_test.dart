import 'dart:io';
import 'dart:convert';

import 'package:control_stok_celu/core/errors/app_exception.dart';
import 'package:control_stok_celu/core/money/money.dart';
import 'package:control_stok_celu/core/tax/tax_calculator.dart';
import 'package:control_stok_celu/data/db/app_database.dart';
import 'package:control_stok_celu/data/repositories/drift_stock_repository.dart';
import 'package:control_stok_celu/domain/stock/stock_models.dart';
import 'package:drift/drift.dart' hide isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  group('Stock repository', () {
    late AppDatabase database;
    late DriftStockRepository repository;

    setUp(() {
      database = AppDatabase(executor: NativeDatabase.memory());
      repository = DriftStockRepository(database);
    });

    tearDown(() async {
      await database.close();
    });

    Future<void> expectProductInvariants(String productId) async {
      final stock = await repository.getProductStock(productId);
      expect(stock.stockTotal, greaterThanOrEqualTo(0));
      expect(stock.stockReserved, greaterThanOrEqualTo(0));
      expect(stock.stockReserved, lessThanOrEqualTo(stock.stockTotal));
      expect(stock.stockAvailable, stock.stockTotal - stock.stockReserved);
    }

    Future<int> movementCountByReference(String referenceId) async {
      final rows = await (database.select(database.stockMovements)
            ..where((t) => t.referenceId.equals(referenceId)))
          .get();
      return rows.length;
    }

    Future<int> auditCountByEntity(String entityType, String entityId) async {
      final rows = await (database.select(database.auditLogs)
            ..where((t) =>
                t.entityType.equals(entityType) & t.entityId.equals(entityId)))
          .get();
      return rows.length;
    }

    test('create product, receive stock, reserve, cancel and confirm sale',
        () async {
      await repository.createProduct(
        const CreateProductInput(
          id: 'p1',
          internalCode: 'COD-1',
          name: 'Coca Cola 1.5L',
          costCents: 10000,
          salePriceCents: 15050,
        ),
      );

      await repository.receiveStock(
        ReceiveStockInput(
          batchId: 'b1',
          productId: 'p1',
          quantity: 50,
          unitCostCents: 10000,
          receivedAt: DateTime.utc(2026, 8, 1),
          expiresAt: DateTime.utc(2026, 10, 1),
        ),
      );

      var stock = await repository.getProductStock('p1');
      expect(stock.stockTotal, 50);
      expect(stock.stockReserved, 0);
      expect(stock.stockAvailable, 50);

      await repository.createReservation(
        CreateReservationInput(
          reservationId: 'r1',
          createdAt: DateTime.utc(2026, 8, 2),
          lines: const <ReservationLineInput>[
            ReservationLineInput(
              itemId: 'ri1',
              productId: 'p1',
              quantity: 10,
              unitPriceCents: 15050,
              taxRateBps: 2100,
              discountCents: 0,
            ),
          ],
        ),
      );

      stock = await repository.getProductStock('p1');
      expect(stock.stockTotal, 50);
      expect(stock.stockReserved, 10);
      expect(stock.stockAvailable, 40);

      await repository.cancelReservation('r1', DateTime.utc(2026, 8, 3));
      stock = await repository.getProductStock('p1');
      expect(stock.stockTotal, 50);
      expect(stock.stockReserved, 0);
      expect(stock.stockAvailable, 50);

      await repository.createReservation(
        CreateReservationInput(
          reservationId: 'r2',
          createdAt: DateTime.utc(2026, 8, 4),
          lines: const <ReservationLineInput>[
            ReservationLineInput(
              itemId: 'ri2',
              productId: 'p1',
              quantity: 20,
              unitPriceCents: 15050,
              taxRateBps: 2100,
              discountCents: 0,
            ),
          ],
        ),
      );

      await repository.confirmReservationSale(
        ConfirmSaleInput(
          saleId: 's1',
          reservationId: 'r2',
          confirmedAt: DateTime.utc(2026, 8, 5),
        ),
      );

      stock = await repository.getProductStock('p1');
      expect(stock.stockTotal, 30);
      expect(stock.stockReserved, 0);
      expect(stock.stockAvailable, 30);
    });

    test('reject reserve and direct sale above available stock', () async {
      await repository.createProduct(
        const CreateProductInput(
          id: 'p2',
          internalCode: 'COD-2',
          name: 'Fernet Branca 750ml',
        ),
      );
      await repository.receiveStock(
        ReceiveStockInput(
          batchId: 'b2',
          productId: 'p2',
          quantity: 10,
          unitCostCents: 8000,
          receivedAt: DateTime.utc(2026, 8, 1),
        ),
      );

      expect(
        () => repository.createReservation(
          CreateReservationInput(
            reservationId: 'r3',
            createdAt: DateTime.utc(2026, 8, 2),
            lines: const <ReservationLineInput>[
              ReservationLineInput(
                itemId: 'ri3',
                productId: 'p2',
                quantity: 11,
                unitPriceCents: 12000,
                taxRateBps: 2100,
                discountCents: 0,
              ),
            ],
          ),
        ),
        throwsA(isA<ConflictException>()),
      );

      expect(
        () => repository.createDirectSale(
          CreateDirectSaleInput(
            saleId: 's2',
            createdAt: DateTime.utc(2026, 8, 2),
            lines: const <DirectSaleLineInput>[
              DirectSaleLineInput(
                itemId: 'si2',
                productId: 'p2',
                quantity: 11,
                unitPriceCents: 12000,
                taxRateBps: 2100,
                discountCents: 0,
              ),
            ],
          ),
        ),
        throwsA(isA<ConflictException>()),
      );
    });

    test('fifo uses the oldest batch first', () async {
      await repository.createProduct(
        const CreateProductInput(
          id: 'p3',
          internalCode: 'COD-3',
          name: 'Leche X',
        ),
      );
      await repository.receiveStock(
        ReceiveStockInput(
          batchId: 'ba',
          productId: 'p3',
          quantity: 100,
          unitCostCents: 5000,
          receivedAt: DateTime.utc(2026, 8, 1),
          expiresAt: DateTime.utc(2026, 9, 1),
        ),
      );
      await repository.receiveStock(
        ReceiveStockInput(
          batchId: 'bb',
          productId: 'p3',
          quantity: 100,
          unitCostCents: 6000,
          receivedAt: DateTime.utc(2026, 8, 10),
          expiresAt: DateTime.utc(2026, 12, 1),
        ),
      );

      await repository.createDirectSale(
        CreateDirectSaleInput(
          saleId: 's3',
          createdAt: DateTime.utc(2026, 8, 11),
          lines: const <DirectSaleLineInput>[
            DirectSaleLineInput(
              itemId: 'si3',
              productId: 'p3',
              quantity: 120,
              unitPriceCents: 9000,
              taxRateBps: 2100,
              discountCents: 0,
            ),
          ],
        ),
      );

      final batchA = await (database.select(database.productBatches)
            ..where((t) => t.id.equals('ba')))
          .getSingle();
      final batchB = await (database.select(database.productBatches)
            ..where((t) => t.id.equals('bb')))
          .getSingle();
      expect(batchA.quantityTotal, 0);
      expect(batchB.quantityTotal, 80);
      expect(batchA.expiresAt?.toUtc(), DateTime.utc(2026, 9, 1));
      expect(batchB.expiresAt?.toUtc(), DateTime.utc(2026, 12, 1));
    });

    test('prevent double cancellation and double confirmation', () async {
      await repository.createProduct(
        const CreateProductInput(
          id: 'p4',
          internalCode: 'COD-4',
          name: 'Producto 4',
        ),
      );
      await repository.receiveStock(
        ReceiveStockInput(
          batchId: 'b4',
          productId: 'p4',
          quantity: 10,
          unitCostCents: 1000,
          receivedAt: DateTime.utc(2026, 8, 1),
        ),
      );
      await repository.createReservation(
        CreateReservationInput(
          reservationId: 'r4',
          createdAt: DateTime.utc(2026, 8, 1),
          lines: const <ReservationLineInput>[
            ReservationLineInput(
              itemId: 'ri4',
              productId: 'p4',
              quantity: 5,
              unitPriceCents: 2000,
              taxRateBps: 2100,
              discountCents: 0,
            ),
          ],
        ),
      );
      await repository.cancelReservation('r4', DateTime.utc(2026, 8, 2));
      expect(
        () => repository.cancelReservation('r4', DateTime.utc(2026, 8, 3)),
        throwsA(isA<ConflictException>()),
      );

      await repository.createReservation(
        CreateReservationInput(
          reservationId: 'r5',
          createdAt: DateTime.utc(2026, 8, 4),
          lines: const <ReservationLineInput>[
            ReservationLineInput(
              itemId: 'ri5',
              productId: 'p4',
              quantity: 5,
              unitPriceCents: 2000,
              taxRateBps: 2100,
              discountCents: 0,
            ),
          ],
        ),
      );
      await repository.confirmReservationSale(
        ConfirmSaleInput(
          saleId: 's5',
          reservationId: 'r5',
          confirmedAt: DateTime.utc(2026, 8, 5),
        ),
      );
      expect(
        () => repository.confirmReservationSale(
          ConfirmSaleInput(
            saleId: 's5b',
            reservationId: 'r5',
            confirmedAt: DateTime.utc(2026, 8, 6),
          ),
        ),
        throwsA(isA<ConflictException>()),
      );
    });

    test('money and tax calculations remain precise', () {
      const calculator = TaxCalculator();
      final breakdown = calculator.fromNet(netCents: 15050, taxRateBps: 2100);
      expect(breakdown.taxCents, 3161);
      expect(breakdown.grossCents, 18211);

      final lineProfit = ((15050 - 10000) * 2) - 500;
      expect(lineProfit, 9600);
    });

    test('data persists when reopening sqlite file', () async {
      final file = File(
          '${Directory.systemTemp.path}/control_stok_celu_persist_test.sqlite');
      if (file.existsSync()) {
        file.deleteSync();
      }

      var persistentDb = AppDatabase(executor: NativeDatabase(file));
      var persistentRepo = DriftStockRepository(persistentDb);
      await persistentRepo.createProduct(
        const CreateProductInput(
          id: 'p5',
          internalCode: 'COD-5',
          name: 'Persistente',
        ),
      );
      await persistentRepo.receiveStock(
        ReceiveStockInput(
          batchId: 'b5',
          productId: 'p5',
          quantity: 7,
          unitCostCents: 3000,
          receivedAt: DateTime.utc(2026, 8, 1),
        ),
      );
      await persistentDb.close();

      persistentDb = AppDatabase(executor: NativeDatabase(file));
      persistentRepo = DriftStockRepository(persistentDb);
      final stock = await persistentRepo.getProductStock('p5');
      expect(stock.stockTotal, 7);
      expect(stock.stockReserved, 0);
      await persistentDb.close();
      if (file.existsSync()) {
        file.deleteSync();
      }
    });

    test('failed operation rolls back completely', () async {
      await repository.createProduct(
        const CreateProductInput(
          id: 'p6',
          internalCode: 'COD-6',
          name: 'Rollback',
        ),
      );
      await repository.receiveStock(
        ReceiveStockInput(
          batchId: 'b6',
          productId: 'p6',
          quantity: 10,
          unitCostCents: 1000,
          receivedAt: DateTime.utc(2026, 8, 1),
        ),
      );

      try {
        await repository.createReservation(
          CreateReservationInput(
            reservationId: 'r6',
            createdAt: DateTime.utc(2026, 8, 2),
            lines: const <ReservationLineInput>[
              ReservationLineInput(
                itemId: 'ri6a',
                productId: 'p6',
                quantity: 5,
                unitPriceCents: 1000,
                taxRateBps: 2100,
                discountCents: 0,
              ),
              ReservationLineInput(
                itemId: 'ri6b',
                productId: 'missing-product',
                quantity: 1,
                unitPriceCents: 1000,
                taxRateBps: 2100,
                discountCents: 0,
              ),
            ],
          ),
        );
        fail('Expected reservation creation to fail');
      } catch (_) {}

      final stock = await repository.getProductStock('p6');
      expect(stock.stockTotal, 10);
      expect(stock.stockReserved, 0);
      final reservations = await database.select(database.reservations).get();
      expect(reservations, isEmpty);
      expect(await auditCountByEntity('reservation', 'r6'), 0);
      await expectProductInvariants('p6');
    });

    test('duplicate cancellation is rejected without extra side effects',
        () async {
      await repository.createProduct(
        const CreateProductInput(
          id: 'p7',
          internalCode: 'COD-7',
          name: 'Producto 7',
        ),
      );
      await repository.receiveStock(
        ReceiveStockInput(
          batchId: 'b7',
          productId: 'p7',
          quantity: 10,
          unitCostCents: 3000,
          receivedAt: DateTime.utc(2026, 8, 1),
        ),
      );
      await repository.createReservation(
        CreateReservationInput(
          reservationId: 'r7',
          createdAt: DateTime.utc(2026, 8, 2),
          lines: const <ReservationLineInput>[
            ReservationLineInput(
              itemId: 'ri7',
              productId: 'p7',
              quantity: 4,
              unitPriceCents: 5000,
              taxRateBps: 2100,
              discountCents: 0,
            ),
          ],
        ),
      );

      await repository.cancelReservation('r7', DateTime.utc(2026, 8, 3));
      final stockAfterFirstCancel = await repository.getProductStock('p7');
      final movementCount = await movementCountByReference('r7');
      final auditCount = await auditCountByEntity('reservation', 'r7');

      await expectLater(
        () => repository.cancelReservation('r7', DateTime.utc(2026, 8, 4)),
        throwsA(isA<ConflictException>()),
      );

      final stockAfterSecondAttempt = await repository.getProductStock('p7');
      expect(
          stockAfterSecondAttempt.stockTotal, stockAfterFirstCancel.stockTotal);
      expect(stockAfterSecondAttempt.stockReserved,
          stockAfterFirstCancel.stockReserved);
      expect(await movementCountByReference('r7'), movementCount);
      expect(await auditCountByEntity('reservation', 'r7'), auditCount);
      await expectProductInvariants('p7');
    });

    test(
        'duplicate sale confirmation is rejected without duplicate stock impact',
        () async {
      await repository.createProduct(
        const CreateProductInput(
          id: 'p8',
          internalCode: 'COD-8',
          name: 'Producto 8',
        ),
      );
      await repository.receiveStock(
        ReceiveStockInput(
          batchId: 'b8',
          productId: 'p8',
          quantity: 12,
          unitCostCents: 2000,
          receivedAt: DateTime.utc(2026, 8, 1),
        ),
      );
      await repository.createReservation(
        CreateReservationInput(
          reservationId: 'r8',
          createdAt: DateTime.utc(2026, 8, 2),
          lines: const <ReservationLineInput>[
            ReservationLineInput(
              itemId: 'ri8',
              productId: 'p8',
              quantity: 6,
              unitPriceCents: 4000,
              taxRateBps: 2100,
              discountCents: 0,
            ),
          ],
        ),
      );

      await repository.confirmReservationSale(
        ConfirmSaleInput(
          saleId: 's8',
          reservationId: 'r8',
          confirmedAt: DateTime.utc(2026, 8, 3),
        ),
      );

      final saleItemsBefore = await (database.select(database.saleItems)
            ..where((t) => t.saleId.equals('s8')))
          .get();
      final stockBefore = await repository.getProductStock('p8');
      final movementsBefore = await movementCountByReference('s8');
      final auditBefore = await auditCountByEntity('sale', 's8');

      await expectLater(
        () => repository.confirmReservationSale(
          ConfirmSaleInput(
            saleId: 's8b',
            reservationId: 'r8',
            confirmedAt: DateTime.utc(2026, 8, 4),
          ),
        ),
        throwsA(isA<ConflictException>()),
      );

      final saleItemsAfter = await (database.select(database.saleItems)
            ..where((t) => t.saleId.equals('s8')))
          .get();
      final stockAfter = await repository.getProductStock('p8');
      expect(saleItemsAfter.length, saleItemsBefore.length);
      expect(stockAfter.stockTotal, stockBefore.stockTotal);
      expect(stockAfter.stockReserved, stockBefore.stockReserved);
      expect(await movementCountByReference('s8'), movementsBefore);
      expect(await auditCountByEntity('sale', 's8'), auditBefore);
      await expectProductInvariants('p8');
    });

    test('duplicate reservation creation is rejected and keeps stock unchanged',
        () async {
      await repository.createProduct(
        const CreateProductInput(
          id: 'p9',
          internalCode: 'COD-9',
          name: 'Producto 9',
        ),
      );
      await repository.receiveStock(
        ReceiveStockInput(
          batchId: 'b9',
          productId: 'p9',
          quantity: 15,
          unitCostCents: 1200,
          receivedAt: DateTime.utc(2026, 8, 1),
        ),
      );

      await repository.createReservation(
        CreateReservationInput(
          reservationId: 'r9',
          createdAt: DateTime.utc(2026, 8, 2),
          lines: const <ReservationLineInput>[
            ReservationLineInput(
              itemId: 'ri9',
              productId: 'p9',
              quantity: 5,
              unitPriceCents: 3500,
              taxRateBps: 2100,
              discountCents: 0,
            ),
          ],
        ),
      );

      final stockAfterFirst = await repository.getProductStock('p9');
      await expectLater(
        () => repository.createReservation(
          CreateReservationInput(
            reservationId: 'r9',
            createdAt: DateTime.utc(2026, 8, 3),
            lines: const <ReservationLineInput>[
              ReservationLineInput(
                itemId: 'ri9b',
                productId: 'p9',
                quantity: 2,
                unitPriceCents: 3500,
                taxRateBps: 2100,
                discountCents: 0,
              ),
            ],
          ),
        ),
        throwsA(isA<ConflictException>()),
      );

      final stockAfterSecond = await repository.getProductStock('p9');
      expect(stockAfterSecond.stockTotal, stockAfterFirst.stockTotal);
      expect(stockAfterSecond.stockReserved, stockAfterFirst.stockReserved);
      expect(await auditCountByEntity('reservation', 'r9'), 1);
      await expectProductInvariants('p9');
    });

    test('nonexistent operations fail without stock movements or fake audit',
        () async {
      await expectLater(
        () => repository.cancelReservation(
            'missing-reservation', DateTime.utc(2026, 8, 1)),
        throwsA(isA<NotFoundException>()),
      );
      await expectLater(
        () => repository.confirmReservationSale(
          ConfirmSaleInput(
            saleId: 'missing-sale-confirm',
            reservationId: 'missing-reservation',
            confirmedAt: DateTime.utc(2026, 8, 1),
          ),
        ),
        throwsA(isA<NotFoundException>()),
      );
      await expectLater(
        () => repository.adjustStock(
          StockAdjustmentInput(
            adjustmentId: 'adj-missing-product',
            productId: 'missing-product',
            deltaQuantity: 1,
            createdAt: DateTime.utc(2026, 8, 1),
          ),
        ),
        throwsA(isA<NotFoundException>()),
      );

      await repository.createProduct(
        const CreateProductInput(
          id: 'p10',
          internalCode: 'COD-10',
          name: 'Producto 10',
        ),
      );
      await expectLater(
        () => repository.adjustStock(
          StockAdjustmentInput(
            adjustmentId: 'adj-missing-batch',
            productId: 'p10',
            batchId: 'missing-batch',
            deltaQuantity: 1,
            createdAt: DateTime.utc(2026, 8, 1),
          ),
        ),
        throwsA(isA<NotFoundException>()),
      );

      await expectLater(
        () => repository.createReturn(
          CreateReturnInput(
            returnId: 'ret-missing-sale',
            saleId: 'missing-sale',
            createdAt: DateTime.utc(2026, 8, 1),
            lines: const <ReturnLineInput>[
              ReturnLineInput(
                id: 'ret-line',
                saleItemId: 'missing-sale-item',
                batchId: 'missing-batch',
                productId: 'p10',
                quantity: 1,
              ),
            ],
          ),
        ),
        throwsA(isA<NotFoundException>()),
      );

      final allMovements = await database.select(database.stockMovements).get();
      final allAudits = await database.select(database.auditLogs).get();
      expect(allMovements, isEmpty);
      expect(allAudits, isEmpty);
      await expectProductInvariants('p10');
    });

    test(
        'stock invariants hold after stock in, reserve, cancel, sale, return and adjustment',
        () async {
      await repository.createProduct(
        const CreateProductInput(
          id: 'p11',
          internalCode: 'COD-11',
          name: 'Producto 11',
        ),
      );
      await repository.receiveStock(
        ReceiveStockInput(
          batchId: 'b11',
          productId: 'p11',
          quantity: 20,
          unitCostCents: 1000,
          receivedAt: DateTime.utc(2026, 8, 1),
        ),
      );
      await expectProductInvariants('p11');

      await repository.createReservation(
        CreateReservationInput(
          reservationId: 'r11',
          createdAt: DateTime.utc(2026, 8, 2),
          lines: const <ReservationLineInput>[
            ReservationLineInput(
              itemId: 'ri11',
              productId: 'p11',
              quantity: 8,
              unitPriceCents: 2000,
              taxRateBps: 2100,
              discountCents: 0,
            ),
          ],
        ),
      );
      await expectProductInvariants('p11');

      await repository.cancelReservation('r11', DateTime.utc(2026, 8, 3));
      await expectProductInvariants('p11');

      await repository.createDirectSale(
        CreateDirectSaleInput(
          saleId: 's11',
          createdAt: DateTime.utc(2026, 8, 4),
          lines: const <DirectSaleLineInput>[
            DirectSaleLineInput(
              itemId: 'si11',
              productId: 'p11',
              quantity: 5,
              unitPriceCents: 3000,
              taxRateBps: 2100,
              discountCents: 0,
            ),
          ],
        ),
      );
      await expectProductInvariants('p11');

      await repository.createReturn(
        CreateReturnInput(
          returnId: 'ret11',
          saleId: 's11',
          createdAt: DateTime.utc(2026, 8, 5),
          lines: const <ReturnLineInput>[
            ReturnLineInput(
              id: 'ret-line11',
              saleItemId: 'si11',
              batchId: 'b11',
              productId: 'p11',
              quantity: 2,
            ),
          ],
        ),
      );
      await expectProductInvariants('p11');

      await repository.adjustStock(
        StockAdjustmentInput(
          adjustmentId: 'adj11',
          productId: 'p11',
          batchId: 'b11',
          deltaQuantity: -3,
          reason: 'merma',
          createdAt: DateTime.utc(2026, 8, 6),
        ),
      );
      await expectProductInvariants('p11');
      expect(await auditCountByEntity('stock_adjustment', 'adj11'), 1);
      expect(await auditCountByEntity('return', 'ret11'), 1);
    });

    test(
        'batch integrity reserve 150 then cancel then direct sale 150 with fifo',
        () async {
      await repository.createProduct(
        const CreateProductInput(
          id: 'p12',
          internalCode: 'COD-12',
          name: 'Producto 12',
        ),
      );
      await repository.receiveStock(
        ReceiveStockInput(
          batchId: 'b12a',
          productId: 'p12',
          quantity: 100,
          unitCostCents: 1000,
          receivedAt: DateTime.utc(2026, 8, 1),
        ),
      );
      await repository.receiveStock(
        ReceiveStockInput(
          batchId: 'b12b',
          productId: 'p12',
          quantity: 100,
          unitCostCents: 2000,
          receivedAt: DateTime.utc(2026, 8, 2),
        ),
      );

      await repository.createReservation(
        CreateReservationInput(
          reservationId: 'r12',
          createdAt: DateTime.utc(2026, 8, 3),
          lines: const <ReservationLineInput>[
            ReservationLineInput(
              itemId: 'ri12',
              productId: 'p12',
              quantity: 150,
              unitPriceCents: 2500,
              taxRateBps: 2100,
              discountCents: 0,
            ),
          ],
        ),
      );

      final batch12aReserved = await (database.select(database.productBatches)
            ..where((t) => t.id.equals('b12a')))
          .getSingle();
      final batch12bReserved = await (database.select(database.productBatches)
            ..where((t) => t.id.equals('b12b')))
          .getSingle();
      expect(batch12aReserved.quantityReserved, 100);
      expect(batch12bReserved.quantityReserved, 50);

      await repository.cancelReservation('r12', DateTime.utc(2026, 8, 4));
      final batch12aAfterCancel =
          await (database.select(database.productBatches)
                ..where((t) => t.id.equals('b12a')))
              .getSingle();
      final batch12bAfterCancel =
          await (database.select(database.productBatches)
                ..where((t) => t.id.equals('b12b')))
              .getSingle();
      expect(batch12aAfterCancel.quantityTotal, 100);
      expect(batch12aAfterCancel.quantityReserved, 0);
      expect(batch12bAfterCancel.quantityTotal, 100);
      expect(batch12bAfterCancel.quantityReserved, 0);

      await repository.createDirectSale(
        CreateDirectSaleInput(
          saleId: 's12',
          createdAt: DateTime.utc(2026, 8, 5),
          lines: const <DirectSaleLineInput>[
            DirectSaleLineInput(
              itemId: 'si12',
              productId: 'p12',
              quantity: 150,
              unitPriceCents: 2600,
              taxRateBps: 2100,
              discountCents: 0,
            ),
          ],
        ),
      );

      final batch12aAfterSale = await (database.select(database.productBatches)
            ..where((t) => t.id.equals('b12a')))
          .getSingle();
      final batch12bAfterSale = await (database.select(database.productBatches)
            ..where((t) => t.id.equals('b12b')))
          .getSingle();
      expect(batch12aAfterSale.quantityTotal, 0);
      expect(batch12bAfterSale.quantityTotal, 50);
      await expectProductInvariants('p12');
    });

    test(
        'persistence keeps product, batch, movement, reservation and sale after reopen',
        () async {
      final file = File(
          '${Directory.systemTemp.path}/control_stok_celu_persist_hardening.sqlite');
      if (file.existsSync()) {
        file.deleteSync();
      }

      var db = AppDatabase(executor: NativeDatabase(file));
      var repo = DriftStockRepository(db);
      await repo.createProduct(
        const CreateProductInput(
          id: 'p13',
          internalCode: 'COD-13',
          name: 'Persistencia Completa',
        ),
      );
      await repo.receiveStock(
        ReceiveStockInput(
          batchId: 'b13',
          productId: 'p13',
          quantity: 20,
          unitCostCents: 1000,
          receivedAt: DateTime.utc(2026, 8, 1),
        ),
      );
      await repo.createReservation(
        CreateReservationInput(
          reservationId: 'r13',
          createdAt: DateTime.utc(2026, 8, 2),
          lines: const <ReservationLineInput>[
            ReservationLineInput(
              itemId: 'ri13',
              productId: 'p13',
              quantity: 8,
              unitPriceCents: 2000,
              taxRateBps: 2100,
              discountCents: 0,
            ),
          ],
        ),
      );
      await repo.confirmReservationSale(
        ConfirmSaleInput(
          saleId: 's13',
          reservationId: 'r13',
          confirmedAt: DateTime.utc(2026, 8, 3),
        ),
      );
      await db.close();

      db = AppDatabase(executor: NativeDatabase(file));
      repo = DriftStockRepository(db);
      expect(
          await (db.select(db.products)..where((t) => t.id.equals('p13')))
              .getSingleOrNull(),
          isNotNull);
      expect(
          await (db.select(db.productBatches)..where((t) => t.id.equals('b13')))
              .getSingleOrNull(),
          isNotNull);
      expect(
          await (db.select(db.stockMovements)
                ..where((t) => t.referenceId.equals('s13')))
              .getSingleOrNull(),
          isNotNull);
      expect(
          await (db.select(db.reservations)..where((t) => t.id.equals('r13')))
              .getSingleOrNull(),
          isNotNull);
      expect(
          await (db.select(db.sales)..where((t) => t.id.equals('s13')))
              .getSingleOrNull(),
          isNotNull);
      final stock = await repo.getProductStock('p13');
      expect(stock.stockTotal, 12);
      expect(stock.stockReserved, 0);
      await db.close();
      if (file.existsSync()) {
        file.deleteSync();
      }
    });

    test('receive stock rejects duplicate batch and keeps state unchanged',
        () async {
      await repository.createProduct(
        const CreateProductInput(
          id: 'p14-dup',
          internalCode: 'COD-14-DUP',
          name: 'Producto duplicado lote',
        ),
      );

      await repository.receiveStock(
        ReceiveStockInput(
          batchId: 'b14-dup',
          productId: 'p14-dup',
          quantity: 10,
          unitCostCents: 1000,
          receivedAt: DateTime.utc(2026, 8, 1),
        ),
      );

      final stockBefore = await repository.getProductStock('p14-dup');
      await expectLater(
        () => repository.receiveStock(
          ReceiveStockInput(
            batchId: 'b14-dup',
            productId: 'p14-dup',
            quantity: 2,
            unitCostCents: 900,
            receivedAt: DateTime.utc(2026, 8, 2),
          ),
        ),
        throwsA(isA<ConflictException>()),
      );

      final stockAfter = await repository.getProductStock('p14-dup');
      expect(stockAfter.stockTotal, stockBefore.stockTotal);
      expect(stockAfter.stockReserved, stockBefore.stockReserved);

      final batches = await (database.select(database.productBatches)
            ..where((t) => t.productId.equals('p14-dup')))
          .get();
      expect(batches.length, 1);
      expect(await movementCountByReference('b14-dup'), 1);
      expect(await auditCountByEntity('stock', 'p14-dup'), 1);
    });

    test(
        'adjustment that breaks reserved invariant is rejected and rolled back',
        () async {
      await repository.createProduct(
        const CreateProductInput(
          id: 'p15-adj',
          internalCode: 'COD-15-ADJ',
          name: 'Producto ajuste reservado',
        ),
      );
      await repository.receiveStock(
        ReceiveStockInput(
          batchId: 'b15-adj',
          productId: 'p15-adj',
          quantity: 10,
          unitCostCents: 1500,
          receivedAt: DateTime.utc(2026, 8, 1),
        ),
      );
      await repository.createReservation(
        CreateReservationInput(
          reservationId: 'r15-adj',
          createdAt: DateTime.utc(2026, 8, 2),
          lines: const <ReservationLineInput>[
            ReservationLineInput(
              itemId: 'ri15-adj',
              productId: 'p15-adj',
              quantity: 8,
              unitPriceCents: 2200,
              taxRateBps: 2100,
              discountCents: 0,
            ),
          ],
        ),
      );

      final before = await repository.getProductStock('p15-adj');
      await expectLater(
        () => repository.adjustStock(
          StockAdjustmentInput(
            adjustmentId: 'adj15-fail',
            productId: 'p15-adj',
            deltaQuantity: -5,
            createdAt: DateTime.utc(2026, 8, 3),
            reason: 'ajuste inválido',
          ),
        ),
        throwsA(isA<ConflictException>()),
      );

      final after = await repository.getProductStock('p15-adj');
      expect(after.stockTotal, before.stockTotal);
      expect(after.stockReserved, before.stockReserved);
      expect(await movementCountByReference('adj15-fail'), 0);
      expect(await auditCountByEntity('stock_adjustment', 'adj15-fail'), 0);
      await expectProductInvariants('p15-adj');
    });

    test(
        'batch adjustment cannot go below batch reserved and keeps batch intact',
        () async {
      await repository.createProduct(
        const CreateProductInput(
          id: 'p16-batch',
          internalCode: 'COD-16-BATCH',
          name: 'Producto lote reservado',
        ),
      );
      await repository.receiveStock(
        ReceiveStockInput(
          batchId: 'b16-batch',
          productId: 'p16-batch',
          quantity: 10,
          unitCostCents: 1800,
          receivedAt: DateTime.utc(2026, 8, 1),
        ),
      );
      await repository.createReservation(
        CreateReservationInput(
          reservationId: 'r16-batch',
          createdAt: DateTime.utc(2026, 8, 2),
          lines: const <ReservationLineInput>[
            ReservationLineInput(
              itemId: 'ri16-batch',
              productId: 'p16-batch',
              quantity: 8,
              unitPriceCents: 3000,
              taxRateBps: 2100,
              discountCents: 0,
            ),
          ],
        ),
      );

      final batchBefore = await (database.select(database.productBatches)
            ..where((t) => t.id.equals('b16-batch')))
          .getSingle();
      await expectLater(
        () => repository.adjustStock(
          StockAdjustmentInput(
            adjustmentId: 'adj16-fail',
            productId: 'p16-batch',
            batchId: 'b16-batch',
            deltaQuantity: -9,
            createdAt: DateTime.utc(2026, 8, 3),
            reason: 'ajuste inválido de lote',
          ),
        ),
        throwsA(isA<ConflictException>()),
      );

      final batchAfter = await (database.select(database.productBatches)
            ..where((t) => t.id.equals('b16-batch')))
          .getSingle();
      expect(batchAfter.quantityTotal, batchBefore.quantityTotal);
      expect(batchAfter.quantityReserved, batchBefore.quantityReserved);
      expect(await movementCountByReference('adj16-fail'), 0);
      expect(await auditCountByEntity('stock_adjustment', 'adj16-fail'), 0);
      await expectProductInvariants('p16-batch');
    });

    test('migration basics, indexes, WAL and FTS5 are available', () async {
      final file = File(
          '${Directory.systemTemp.path}/control_stok_celu_migration_test.sqlite');
      if (file.existsSync()) {
        file.deleteSync();
      }

      var migrationDb = AppDatabase(executor: NativeDatabase(file));
      await migrationDb.customSelect('SELECT 1').get();

      final fkRow =
          await migrationDb.customSelect('PRAGMA foreign_keys;').getSingle();
      expect(fkRow.read<int>('foreign_keys'), 1);

      final journalRow =
          await migrationDb.customSelect('PRAGMA journal_mode;').getSingle();
      final journalMode =
          (journalRow.data.values.first as String).toLowerCase();
      expect(journalMode, 'wal');

      final indexRows = await migrationDb
          .customSelect(
              "SELECT name, sql FROM sqlite_master WHERE type='index' AND tbl_name='products';")
          .get();
      final indexSql = indexRows
          .map((row) => (row.readNullable<String>('sql') ?? '').toLowerCase())
          .toList();
      expect(indexSql.any((sql) => sql.contains('internal_code')), isTrue);
      expect(indexSql.any((sql) => sql.contains('barcode')), isTrue);
      expect(indexSql.any((sql) => sql.contains('name')), isTrue);

      final ftsRows = await migrationDb
          .customSelect(
              "SELECT name FROM sqlite_master WHERE type='table' AND name='products_fts';")
          .get();
      expect(ftsRows, isNotEmpty);

      await migrationDb.close();
      migrationDb = AppDatabase(executor: NativeDatabase(file));
      await migrationDb.into(migrationDb.products).insert(
            ProductsCompanion.insert(
              id: 'p14',
              internalCode: 'COD-14',
              name: 'FTS Producto',
              createdAt: DateTime.utc(2026, 8, 1),
              updatedAt: DateTime.utc(2026, 8, 1),
            ),
          );
      await migrationDb.upsertProductFts(
        productId: 'p14',
        name: 'FTS Producto',
        internalCode: 'COD-14',
      );
      final ftsResult = await migrationDb.searchProducts('FTS*');
      expect(ftsResult, isNotEmpty);
      await migrationDb.close();
      if (file.existsSync()) {
        file.deleteSync();
      }
    });

    test(
        'money calculations cover integer, decimals, vat, discounts and rounding',
        () {
      const calculator = TaxCalculator();

      final integerPrice = Money.fromCents(10000);
      final decimalPrice = Money.fromDecimalString('150.75');
      expect(integerPrice.cents, 10000);
      expect(decimalPrice.cents, 15075);

      final vat = calculator.fromNet(netCents: 15075, taxRateBps: 2100);
      expect(vat.taxCents, 3166);
      expect(vat.grossCents, 18241);

      final fromGross =
          calculator.fromGross(grossCents: 18241, taxRateBps: 2100);
      expect(fromGross.netCents + fromGross.taxCents, 18241);

      final percentageDiscount =
          Money.applyPercentBps(baseCents: 10000, rateBps: 1250);
      final fixedDiscount = 345;
      final discounted = 10000 - percentageDiscount - fixedDiscount;
      expect(percentageDiscount, 1250);
      expect(discounted, 8405);

      final roundedProfit = ((15075 - 10001) * 3) - fixedDiscount;
      expect(roundedProfit, 14877);
    });

    test('stock-in persists stock, batch and movement after reopen', () async {
      final file = File(
          '${Directory.systemTemp.path}/control_stok_celu_stock_in_persist.sqlite');
      if (file.existsSync()) {
        file.deleteSync();
      }

      var db = AppDatabase(executor: NativeDatabase(file));
      var repo = DriftStockRepository(db);
      await repo.createProduct(
        const CreateProductInput(
          id: 'p17-in',
          internalCode: 'COD-17-IN',
          name: 'Persistencia ingreso',
        ),
      );
      await repo.receiveStock(
        ReceiveStockInput(
          batchId: 'b17-in',
          productId: 'p17-in',
          quantity: 11,
          unitCostCents: 1900,
          receivedAt: DateTime.utc(2026, 8, 1),
        ),
      );

      final stockBeforeClose = await repo.getProductStock('p17-in');
      expect(stockBeforeClose.stockTotal, 11);
      expect(stockBeforeClose.stockReserved, 0);

      await db.close();

      db = AppDatabase(executor: NativeDatabase(file));
      repo = DriftStockRepository(db);

      final stockAfterReopen = await repo.getProductStock('p17-in');
      expect(stockAfterReopen.stockTotal, 11);
      expect(stockAfterReopen.stockReserved, 0);

      final batch = await (db.select(db.productBatches)
            ..where((t) => t.id.equals('b17-in')))
          .getSingleOrNull();
      expect(batch, isNotNull);
      expect(batch!.productId, 'p17-in');

      final movement = await (db.select(db.stockMovements)
            ..where((t) =>
                t.referenceId.equals('b17-in') &
                t.movementType.equals('stock_in')))
          .getSingleOrNull();
      expect(movement, isNotNull);
      expect(movement!.productId, 'p17-in');

      await db.close();
      if (file.existsSync()) {
        file.deleteSync();
      }
    });

    test('stock-adjustment persists stock and movement after reopen', () async {
      final file = File(
          '${Directory.systemTemp.path}/control_stok_celu_adjust_persist.sqlite');
      if (file.existsSync()) {
        file.deleteSync();
      }

      var db = AppDatabase(executor: NativeDatabase(file));
      var repo = DriftStockRepository(db);
      await repo.createProduct(
        const CreateProductInput(
          id: 'p18-adj',
          internalCode: 'COD-18-ADJ',
          name: 'Persistencia ajuste',
        ),
      );
      await repo.receiveStock(
        ReceiveStockInput(
          batchId: 'b18-adj',
          productId: 'p18-adj',
          quantity: 10,
          unitCostCents: 1200,
          receivedAt: DateTime.utc(2026, 8, 1),
        ),
      );
      await repo.adjustStock(
        StockAdjustmentInput(
          adjustmentId: 'adj18-ok',
          productId: 'p18-adj',
          deltaQuantity: -3,
          reason: 'conteo final',
          createdAt: DateTime.utc(2026, 8, 2),
        ),
      );

      final stockBeforeClose = await repo.getProductStock('p18-adj');
      expect(stockBeforeClose.stockTotal, 7);
      expect(stockBeforeClose.stockReserved, 0);

      await db.close();

      db = AppDatabase(executor: NativeDatabase(file));
      repo = DriftStockRepository(db);

      final stockAfterReopen = await repo.getProductStock('p18-adj');
      expect(stockAfterReopen.stockTotal, 7);
      expect(stockAfterReopen.stockReserved, 0);

      final movement = await (db.select(db.stockMovements)
            ..where((t) =>
                t.referenceId.equals('adj18-ok') &
                t.movementType.equals('stock_adjustment')))
          .getSingleOrNull();
      expect(movement, isNotNull);
      expect(movement!.productId, 'p18-adj');

      await db.close();
      if (file.existsSync()) {
        file.deleteSync();
      }
    });

    test('stock-in writes audit log with action entity before after and date',
        () async {
      await repository.createProduct(
        const CreateProductInput(
          id: 'p19-audit-in',
          internalCode: 'COD-19-AUD-IN',
          name: 'Auditoria ingreso',
        ),
      );

      await repository.receiveStock(
        ReceiveStockInput(
          batchId: 'b19-audit-in',
          productId: 'p19-audit-in',
          quantity: 5,
          unitCostCents: 2100,
          receivedAt: DateTime.utc(2026, 8, 1),
        ),
      );

      final audit = await (database.select(database.auditLogs)
            ..where((t) =>
                t.entityType.equals('stock') &
                t.entityId.equals('p19-audit-in') &
                t.action.equals('stock_in')))
          .getSingleOrNull();
      expect(audit, isNotNull);
      expect(audit!.createdAt, isNotNull);

      final before =
          jsonDecode(audit.beforeJson ?? '{}') as Map<String, dynamic>;
      final after = jsonDecode(audit.afterJson ?? '{}') as Map<String, dynamic>;

      expect(before['product_id'], 'p19-audit-in');
      expect(before['stock_total'], 0);
      expect(after['product_id'], 'p19-audit-in');
      expect(after['stock_total'], 5);
      expect(after['batch_id'], 'b19-audit-in');
      expect(after['quantity'], 5);
    });

    test(
        'stock-adjustment writes audit log with action entity before after and date',
        () async {
      await repository.createProduct(
        const CreateProductInput(
          id: 'p20-audit-adj',
          internalCode: 'COD-20-AUD-ADJ',
          name: 'Auditoria ajuste',
        ),
      );
      await repository.receiveStock(
        ReceiveStockInput(
          batchId: 'b20-audit-adj',
          productId: 'p20-audit-adj',
          quantity: 9,
          unitCostCents: 1700,
          receivedAt: DateTime.utc(2026, 8, 1),
        ),
      );

      await repository.adjustStock(
        StockAdjustmentInput(
          adjustmentId: 'adj20-audit',
          productId: 'p20-audit-adj',
          deltaQuantity: -2,
          reason: 'ajuste controlado',
          createdAt: DateTime.utc(2026, 8, 2),
        ),
      );

      final audit = await (database.select(database.auditLogs)
            ..where((t) =>
                t.entityType.equals('stock_adjustment') &
                t.entityId.equals('adj20-audit') &
                t.action.equals('stock_adjustment')))
          .getSingleOrNull();
      expect(audit, isNotNull);
      expect(audit!.createdAt, isNotNull);

      final before =
          jsonDecode(audit.beforeJson ?? '{}') as Map<String, dynamic>;
      final after = jsonDecode(audit.afterJson ?? '{}') as Map<String, dynamic>;

      expect(before['product_id'], 'p20-audit-adj');
      expect(before['stock_total'], 9);
      expect(after['product_id'], 'p20-audit-adj');
      expect(after['stock_total'], 7);
      expect(after['delta_quantity'], -2);
      expect(after['reason'], 'ajuste controlado');
    });

    test('draft reservation has no stock impact until reserved', () async {
      await repository.createProduct(
        const CreateProductInput(
          id: 'p21-draft',
          internalCode: 'COD-21-DRAFT',
          name: 'Producto borrador',
          costCents: 1000,
        ),
      );
      await repository.receiveStock(
        ReceiveStockInput(
          batchId: 'b21-draft',
          productId: 'p21-draft',
          quantity: 10,
          unitCostCents: 1000,
          receivedAt: DateTime.utc(2026, 8, 1),
        ),
      );

      await repository.createReservationDraft(
        CreateReservationDraftInput(
          reservationId: 'r21-draft',
          createdAt: DateTime.utc(2026, 8, 2),
          lines: const <DraftReservationLineInput>[
            DraftReservationLineInput(
              itemId: 'ri21-draft',
              productId: 'p21-draft',
              quantity: 4,
              unitPriceCents: 2500,
              taxRateBps: 2100,
              discountCents: 0,
            ),
          ],
        ),
      );

      final stockAfterDraft = await repository.getProductStock('p21-draft');
      expect(stockAfterDraft.stockTotal, 10);
      expect(stockAfterDraft.stockReserved, 0);
      expect(await movementCountByReference('r21-draft'), 0);

      final reservation = await (database.select(database.reservations)
            ..where((t) => t.id.equals('r21-draft')))
          .getSingle();
      expect(reservation.status, 'draft');

      await repository.reserveDraftReservation(
        'r21-draft',
        DateTime.utc(2026, 8, 3),
      );
      final stockAfterReserve = await repository.getProductStock('p21-draft');
      expect(stockAfterReserve.stockTotal, 10);
      expect(stockAfterReserve.stockReserved, 4);
      expect(await movementCountByReference('r21-draft'), 1);
      await expectProductInvariants('p21-draft');
    });

    test('delete draft reservation marks deleted without stock movement',
        () async {
      await repository.createProduct(
        const CreateProductInput(
          id: 'p22-delete',
          internalCode: 'COD-22-DELETE',
          name: 'Producto eliminar borrador',
        ),
      );
      await repository.receiveStock(
        ReceiveStockInput(
          batchId: 'b22-delete',
          productId: 'p22-delete',
          quantity: 9,
          unitCostCents: 900,
          receivedAt: DateTime.utc(2026, 8, 1),
        ),
      );
      await repository.createReservationDraft(
        CreateReservationDraftInput(
          reservationId: 'r22-delete',
          createdAt: DateTime.utc(2026, 8, 2),
          lines: const <DraftReservationLineInput>[
            DraftReservationLineInput(
              itemId: 'ri22-delete',
              productId: 'p22-delete',
              quantity: 3,
              unitPriceCents: 1800,
              taxRateBps: 2100,
              discountCents: 0,
            ),
          ],
        ),
      );

      await repository.deleteReservation(
        'r22-delete',
        DateTime.utc(2026, 8, 3),
      );

      final stock = await repository.getProductStock('p22-delete');
      expect(stock.stockTotal, 9);
      expect(stock.stockReserved, 0);
      expect(await movementCountByReference('r22-delete'), 0);

      final reservation = await (database.select(database.reservations)
            ..where((t) => t.id.equals('r22-delete')))
          .getSingle();
      expect(reservation.status, 'deleted');
      expect(reservation.deletedAt, isNotNull);
      await expectProductInvariants('p22-delete');
    });

    test('delete reserved reservation releases reserved stock and allocations',
        () async {
      await repository.createProduct(
        const CreateProductInput(
          id: 'p23-delete-reserved',
          internalCode: 'COD-23-DEL-RES',
          name: 'Producto eliminar reservado',
        ),
      );
      await repository.receiveStock(
        ReceiveStockInput(
          batchId: 'b23-delete-reserved',
          productId: 'p23-delete-reserved',
          quantity: 12,
          unitCostCents: 950,
          receivedAt: DateTime.utc(2026, 8, 1),
        ),
      );
      await repository.createReservationDraft(
        CreateReservationDraftInput(
          reservationId: 'r23-delete-reserved',
          createdAt: DateTime.utc(2026, 8, 2),
          lines: const <DraftReservationLineInput>[
            DraftReservationLineInput(
              itemId: 'ri23-delete-reserved',
              productId: 'p23-delete-reserved',
              quantity: 5,
              unitPriceCents: 2200,
              taxRateBps: 2100,
              discountCents: 0,
            ),
          ],
        ),
      );
      await repository.reserveDraftReservation(
        'r23-delete-reserved',
        DateTime.utc(2026, 8, 3),
      );

      await repository.deleteReservation(
        'r23-delete-reserved',
        DateTime.utc(2026, 8, 4),
      );

      final stock = await repository.getProductStock('p23-delete-reserved');
      expect(stock.stockTotal, 12);
      expect(stock.stockReserved, 0);

      final allocations = await (database.select(database.batchAllocations)
            ..where((t) => t.reservationItemId.equals('ri23-delete-reserved')))
          .get();
      expect(allocations, isNotEmpty);
      expect(allocations.every((a) => a.state == 'deleted'), isTrue);
      expect(allocations.every((a) => a.quantityReserved == 0), isTrue);
      expect(allocations.every((a) => a.quantitySold == 0), isTrue);
      await expectProductInvariants('p23-delete-reserved');
    });

    test('confirm draft reservation sale persists totals and sold status',
        () async {
      await repository.createProduct(
        const CreateProductInput(
          id: 'p24-draft-sale',
          internalCode: 'COD-24-DRAFT-SALE',
          name: 'Producto venta desde borrador',
          costCents: 1000,
        ),
      );
      await repository.receiveStock(
        ReceiveStockInput(
          batchId: 'b24a-draft-sale',
          productId: 'p24-draft-sale',
          quantity: 10,
          unitCostCents: 1000,
          receivedAt: DateTime.utc(2026, 8, 1),
        ),
      );
      await repository.receiveStock(
        ReceiveStockInput(
          batchId: 'b24b-draft-sale',
          productId: 'p24-draft-sale',
          quantity: 10,
          unitCostCents: 1000,
          receivedAt: DateTime.utc(2026, 8, 2),
        ),
      );
      await repository.createReservationDraft(
        CreateReservationDraftInput(
          reservationId: 'r24-draft-sale',
          createdAt: DateTime.utc(2026, 8, 3),
          lines: const <DraftReservationLineInput>[
            DraftReservationLineInput(
              itemId: 'ri24-draft-sale',
              productId: 'p24-draft-sale',
              quantity: 12,
              unitPriceCents: 2000,
              taxRateBps: 2100,
              discountCents: 100,
            ),
          ],
        ),
      );

      await repository.confirmDraftReservationSale(
        ConfirmSaleInput(
          saleId: 's24-draft-sale',
          reservationId: 'r24-draft-sale',
          confirmedAt: DateTime.utc(2026, 8, 4),
        ),
      );

      final stock = await repository.getProductStock('p24-draft-sale');
      expect(stock.stockTotal, 8);
      expect(stock.stockReserved, 0);

      final sale = await (database.select(database.sales)
            ..where((t) => t.id.equals('s24-draft-sale')))
          .getSingle();
      expect(sale.status, 'sold');
      expect(sale.subtotalCents, 23900);
      expect(sale.taxCents, 5019);
      expect(sale.discountCents, 100);
      expect(sale.totalCents, 28919);
      expect(sale.estimatedProfitCents, 11900);

      final reservation = await (database.select(database.reservations)
            ..where((t) => t.id.equals('r24-draft-sale')))
          .getSingle();
      expect(reservation.status, 'sold');
      await expectProductInvariants('p24-draft-sale');
    });

    test('commercial status transition matrix matches domain rules', () {
      const allowed = <CommercialStatus, Set<CommercialStatus>>{
        CommercialStatus.draft: <CommercialStatus>{
          CommercialStatus.reserved,
          CommercialStatus.sold,
          CommercialStatus.deleted,
        },
        CommercialStatus.reserved: <CommercialStatus>{
          CommercialStatus.sold,
          CommercialStatus.cancelled,
          CommercialStatus.deleted,
        },
        CommercialStatus.sold: <CommercialStatus>{},
        CommercialStatus.cancelled: <CommercialStatus>{},
        CommercialStatus.deleted: <CommercialStatus>{},
      };

      for (final current in CommercialStatus.values) {
        for (final next in CommercialStatus.values) {
          final expected = allowed[current]!.contains(next);
          expect(
            current.canTransitionTo(next),
            expected,
            reason:
                'Transicion inesperada para ${current.dbValue} -> ${next.dbValue}',
          );
        }
      }
    });

    test('repository rejects forbidden transitions without side effects',
        () async {
      await repository.createProduct(
        const CreateProductInput(
          id: 'p25-matrix',
          internalCode: 'COD-25-MATRIX',
          name: 'Producto matriz',
        ),
      );
      await repository.receiveStock(
        ReceiveStockInput(
          batchId: 'b25-matrix',
          productId: 'p25-matrix',
          quantity: 12,
          unitCostCents: 1000,
          receivedAt: DateTime.utc(2026, 8, 1),
        ),
      );

      await repository.createReservationDraft(
        CreateReservationDraftInput(
          reservationId: 'r25-draft',
          createdAt: DateTime.utc(2026, 8, 2),
          lines: const <DraftReservationLineInput>[
            DraftReservationLineInput(
              itemId: 'ri25-draft',
              productId: 'p25-matrix',
              quantity: 2,
              unitPriceCents: 2000,
              taxRateBps: 2100,
              discountCents: 0,
            ),
          ],
        ),
      );

      final stockBefore = await repository.getProductStock('p25-matrix');
      final movementsBefore = await movementCountByReference('r25-draft');
      final auditsBefore = await auditCountByEntity('reservation', 'r25-draft');
      await expectLater(
        () =>
            repository.cancelReservation('r25-draft', DateTime.utc(2026, 8, 3)),
        throwsA(isA<ConflictException>()),
      );
      final stockAfter = await repository.getProductStock('p25-matrix');
      expect(stockAfter.stockTotal, stockBefore.stockTotal);
      expect(stockAfter.stockReserved, stockBefore.stockReserved);
      expect(await movementCountByReference('r25-draft'), movementsBefore);
      expect(
          await auditCountByEntity('reservation', 'r25-draft'), auditsBefore);

      await repository.reserveDraftReservation(
        'r25-draft',
        DateTime.utc(2026, 8, 4),
      );
      await expectLater(
        () => repository.reserveDraftReservation(
          'r25-draft',
          DateTime.utc(2026, 8, 5),
        ),
        throwsA(isA<ConflictException>()),
      );
      await repository.cancelReservation('r25-draft', DateTime.utc(2026, 8, 6));
      await expectLater(
        () =>
            repository.deleteReservation('r25-draft', DateTime.utc(2026, 8, 7)),
        throwsA(isA<ConflictException>()),
      );
      await expectLater(
        () => repository.confirmDraftReservationSale(
          ConfirmSaleInput(
            saleId: 's25-cancelled',
            reservationId: 'r25-draft',
            confirmedAt: DateTime.utc(2026, 8, 7),
          ),
        ),
        throwsA(isA<ConflictException>()),
      );

      await repository.createReservationDraft(
        CreateReservationDraftInput(
          reservationId: 'r25-deleted',
          createdAt: DateTime.utc(2026, 8, 8),
          lines: const <DraftReservationLineInput>[
            DraftReservationLineInput(
              itemId: 'ri25-deleted',
              productId: 'p25-matrix',
              quantity: 2,
              unitPriceCents: 2000,
              taxRateBps: 2100,
              discountCents: 0,
            ),
          ],
        ),
      );
      await repository.deleteReservation(
          'r25-deleted', DateTime.utc(2026, 8, 9));
      await expectLater(
        () => repository.cancelReservation(
            'r25-deleted', DateTime.utc(2026, 8, 10)),
        throwsA(isA<ConflictException>()),
      );
      await expectLater(
        () => repository.reserveDraftReservation(
          'r25-deleted',
          DateTime.utc(2026, 8, 10),
        ),
        throwsA(isA<ConflictException>()),
      );

      await repository.createReservationDraft(
        CreateReservationDraftInput(
          reservationId: 'r25-sold',
          createdAt: DateTime.utc(2026, 8, 11),
          lines: const <DraftReservationLineInput>[
            DraftReservationLineInput(
              itemId: 'ri25-sold',
              productId: 'p25-matrix',
              quantity: 3,
              unitPriceCents: 2200,
              taxRateBps: 2100,
              discountCents: 0,
            ),
          ],
        ),
      );
      await repository.confirmDraftReservationSale(
        ConfirmSaleInput(
          saleId: 's25-sold',
          reservationId: 'r25-sold',
          confirmedAt: DateTime.utc(2026, 8, 12),
        ),
      );
      await expectLater(
        () =>
            repository.cancelReservation('r25-sold', DateTime.utc(2026, 8, 13)),
        throwsA(isA<ConflictException>()),
      );
      await expectLater(
        () =>
            repository.deleteReservation('r25-sold', DateTime.utc(2026, 8, 13)),
        throwsA(isA<ConflictException>()),
      );
      await expectLater(
        () => repository.reserveDraftReservation(
          'r25-sold',
          DateTime.utc(2026, 8, 13),
        ),
        throwsA(isA<ConflictException>()),
      );
      await expectLater(
        () => repository.confirmDraftReservationSale(
          ConfirmSaleInput(
            saleId: 's25-sold-again',
            reservationId: 'r25-sold',
            confirmedAt: DateTime.utc(2026, 8, 13),
          ),
        ),
        throwsA(isA<ConflictException>()),
      );

      await expectProductInvariants('p25-matrix');
    });

    test('selling reservation A does not consume reserved stock from B',
        () async {
      await repository.createProduct(
        const CreateProductInput(
          id: 'p26-isolation',
          internalCode: 'COD-26-ISO',
          name: 'Producto aislamiento',
        ),
      );
      await repository.receiveStock(
        ReceiveStockInput(
          batchId: 'b26-isolation',
          productId: 'p26-isolation',
          quantity: 10,
          unitCostCents: 1000,
          receivedAt: DateTime.utc(2026, 8, 1),
        ),
      );

      await repository.createReservation(
        CreateReservationInput(
          reservationId: 'r26-a',
          createdAt: DateTime.utc(2026, 8, 2),
          lines: const <ReservationLineInput>[
            ReservationLineInput(
              itemId: 'ri26-a',
              productId: 'p26-isolation',
              quantity: 4,
              unitPriceCents: 2000,
              taxRateBps: 2100,
              discountCents: 0,
            ),
          ],
        ),
      );
      await repository.createReservation(
        CreateReservationInput(
          reservationId: 'r26-b',
          createdAt: DateTime.utc(2026, 8, 3),
          lines: const <ReservationLineInput>[
            ReservationLineInput(
              itemId: 'ri26-b',
              productId: 'p26-isolation',
              quantity: 3,
              unitPriceCents: 2100,
              taxRateBps: 2100,
              discountCents: 0,
            ),
          ],
        ),
      );

      await repository.confirmReservationSale(
        ConfirmSaleInput(
          saleId: 's26-a',
          reservationId: 'r26-a',
          confirmedAt: DateTime.utc(2026, 8, 4),
        ),
      );

      final stock = await repository.getProductStock('p26-isolation');
      expect(stock.stockTotal, 6);
      expect(stock.stockReserved, 3);

      final reservationB = await (database.select(database.reservations)
            ..where((t) => t.id.equals('r26-b')))
          .getSingle();
      expect(reservationB.status, 'reserved');

      final batch = await (database.select(database.productBatches)
            ..where((t) => t.id.equals('b26-isolation')))
          .getSingle();
      expect(batch.quantityTotal, 6);
      expect(batch.quantityReserved, 3);

      final allocationsB = await (database.select(database.batchAllocations)
            ..where((t) => t.reservationItemId.equals('ri26-b')))
          .get();
      expect(allocationsB, isNotEmpty);
      expect(allocationsB.every((a) => a.state == 'reserved'), isTrue);
      expect(
          allocationsB.fold<int>(0, (sum, a) => sum + a.quantityReserved), 3);

      await expectProductInvariants('p26-isolation');
    });

    test('migration v2 to v3 adds columns and backfills allocation quantities',
        () async {
      final file = File(
          '${Directory.systemTemp.path}/control_stok_celu_migration_v2_v3.sqlite');
      if (file.existsSync()) {
        file.deleteSync();
      }

      final raw = sqlite.sqlite3.open(file.path);
      raw.execute('PRAGMA user_version = 2;');
      raw.execute('''
        CREATE TABLE customers (
          id TEXT PRIMARY KEY NOT NULL,
          name TEXT NOT NULL,
          phone TEXT,
          notes TEXT,
          is_active INTEGER NOT NULL DEFAULT 1,
          created_at INTEGER NOT NULL,
          updated_at INTEGER NOT NULL
        );
      ''');
      raw.execute('''
        CREATE TABLE reservations (
          id TEXT PRIMARY KEY NOT NULL,
          customer_id TEXT,
          status TEXT NOT NULL DEFAULT 'draft',
          notes TEXT,
          created_at INTEGER NOT NULL,
          updated_at INTEGER NOT NULL,
          canceled_at INTEGER,
          confirmed_at INTEGER
        );
      ''');
      raw.execute('''
        CREATE TABLE batch_allocations (
          id TEXT PRIMARY KEY NOT NULL,
          product_id TEXT NOT NULL,
          batch_id TEXT NOT NULL,
          reservation_item_id TEXT,
          sale_item_id TEXT,
          quantity INTEGER NOT NULL,
          state TEXT NOT NULL DEFAULT 'reserved',
          created_at INTEGER NOT NULL
        );
      ''');
      raw.execute('''
        INSERT INTO batch_allocations(id, product_id, batch_id, quantity, state, created_at)
        VALUES
          ('ba-v2-res', 'p1', 'b1', 5, 'reserved', 1),
          ('ba-v2-sold', 'p1', 'b1', 3, 'sold', 1);
      ''');
      raw.close();

      final migrationDb = AppDatabase(executor: NativeDatabase(file));
      await migrationDb.customSelect('SELECT 1').getSingle();

      final customerCols =
          await migrationDb.customSelect('PRAGMA table_info(customers);').get();
      final customerColNames =
          customerCols.map((r) => r.read<String>('name')).toSet();
      expect(customerColNames.contains('email'), isTrue);
      expect(customerColNames.contains('document'), isTrue);
      expect(customerColNames.contains('address'), isTrue);

      final reservationCols = await migrationDb
          .customSelect('PRAGMA table_info(reservations);')
          .get();
      final reservationColNames =
          reservationCols.map((r) => r.read<String>('name')).toSet();
      expect(reservationColNames.contains('deleted_at'), isTrue);

      final allocationCols = await migrationDb
          .customSelect('PRAGMA table_info(batch_allocations);')
          .get();
      final allocationColNames =
          allocationCols.map((r) => r.read<String>('name')).toSet();
      expect(allocationColNames.contains('quantity_reserved'), isTrue);
      expect(allocationColNames.contains('quantity_sold'), isTrue);

      final reservedRow = await migrationDb
          .customSelect(
            "SELECT quantity, quantity_reserved, quantity_sold FROM batch_allocations WHERE id = 'ba-v2-res'",
          )
          .getSingle();
      final soldRow = await migrationDb
          .customSelect(
            "SELECT quantity, quantity_reserved, quantity_sold FROM batch_allocations WHERE id = 'ba-v2-sold'",
          )
          .getSingle();

      expect(reservedRow.read<int>('quantity'), 5);
      expect(reservedRow.read<int>('quantity_reserved'), 5);
      expect(reservedRow.read<int>('quantity_sold'), 0);
      expect(soldRow.read<int>('quantity'), 3);
      expect(soldRow.read<int>('quantity_reserved'), 0);
      expect(soldRow.read<int>('quantity_sold'), 3);

      await migrationDb.close();
      if (file.existsSync()) {
        file.deleteSync();
      }
    });
  });
}
