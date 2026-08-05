import 'dart:io';

import 'package:control_stok_celu/data/db/app_database.dart';
import 'package:control_stok_celu/data/repositories/drift_stock_repository.dart';
import 'package:control_stok_celu/domain/stock/stock_models.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  group('Inventory repository phase 3 block 3', () {
    late AppDatabase database;
    late DriftStockRepository repository;
    late DateTime todayStart;

    setUp(() {
      database = AppDatabase(executor: NativeDatabase.memory());
      repository = DriftStockRepository(database);
      final now = DateTime.now().toUtc();
      todayStart = DateTime.utc(now.year, now.month, now.day);
    });

    tearDown(() async {
      await database.close();
    });

    Future<void> createProduct({
      required String id,
      required String name,
      required String code,
      int stockMin = 0,
      int? stockMax,
      String? barcode,
    }) async {
      await repository.createProductProfile(
        ProductUpsertInput(
          id: id,
          name: name,
          internalCode: code,
          stockMin: stockMin,
          stockMax: stockMax,
          barcode: barcode,
        ),
      );
    }

    Future<void> receive({
      required String batchId,
      required String productId,
      required int quantity,
      DateTime? expiresAt,
    }) async {
      await repository.receiveStock(
        ReceiveStockInput(
          batchId: batchId,
          productId: productId,
          quantity: quantity,
          unitCostCents: 1000,
          receivedAt: todayStart,
          expiresAt: expiresAt,
        ),
      );
    }

    test('1. get inventory summary with real counters', () async {
      await createProduct(
        id: 'inv-sum-no',
        name: 'Sin Stock',
        code: 'INV-SUM-0',
      );
      await createProduct(
        id: 'inv-sum-low',
        name: 'Bajo',
        code: 'INV-SUM-1',
        stockMin: 5,
      );
      await receive(
        batchId: 'inv-sum-low-b',
        productId: 'inv-sum-low',
        quantity: 3,
        expiresAt: todayStart.add(const Duration(days: 10)),
      );

      final summary =
          await repository.getInventorySummary(const InventoryQuery());

      expect(summary.totalProducts, 2);
      expect(summary.noStockCount, 1);
      expect(summary.lowStockCount, 1);
      expect(summary.nearExpiryCount, 1);
      expect(summary.expiredCount, 0);
    });

    test('2. classify product with no stock', () async {
      await createProduct(id: 'inv-no', name: 'No Stock', code: 'INV-NO');

      final rows = await repository.listInventory(const InventoryQuery());
      final item = rows.firstWhere((r) => r.id == 'inv-no');

      expect(item.stockAvailable, 0);
      expect(item.stockState, InventoryStockState.noStock);
    });

    test('3. classify low stock product', () async {
      await createProduct(
        id: 'inv-low',
        name: 'Low',
        code: 'INV-LOW',
        stockMin: 6,
      );
      await receive(batchId: 'inv-low-b', productId: 'inv-low', quantity: 4);

      final rows = await repository.listInventory(const InventoryQuery());
      final item = rows.firstWhere((r) => r.id == 'inv-low');

      expect(item.stockState, InventoryStockState.lowStock);
      expect(item.stockAvailable, 4);
    });

    test('4. classify normal stock product', () async {
      await createProduct(
        id: 'inv-normal',
        name: 'Normal',
        code: 'INV-NORMAL',
        stockMin: 3,
      );
      await receive(
          batchId: 'inv-normal-b', productId: 'inv-normal', quantity: 9);

      final rows = await repository.listInventory(const InventoryQuery());
      final item = rows.firstWhere((r) => r.id == 'inv-normal');

      expect(item.stockState, InventoryStockState.normal);
    });

    test('5. classify over stock product', () async {
      await createProduct(
        id: 'inv-over',
        name: 'Over',
        code: 'INV-OVER',
        stockMin: 2,
        stockMax: 5,
      );
      await receive(batchId: 'inv-over-b', productId: 'inv-over', quantity: 7);

      final rows = await repository.listInventory(const InventoryQuery());
      final item = rows.firstWhere((r) => r.id == 'inv-over');

      expect(item.stockState, InventoryStockState.overStock);
    });

    test('6. classify near expiry product', () async {
      await createProduct(
        id: 'inv-near',
        name: 'Near',
        code: 'INV-NEAR',
      );
      await receive(
        batchId: 'inv-near-b',
        productId: 'inv-near',
        quantity: 2,
        expiresAt: todayStart.add(const Duration(days: 8)),
      );

      final rows = await repository.listInventory(const InventoryQuery());
      final item = rows.firstWhere((r) => r.id == 'inv-near');

      expect(item.expiryState, InventoryExpiryState.nearExpiry);
    });

    test('7. classify product due today', () async {
      await createProduct(
        id: 'inv-today',
        name: 'Today',
        code: 'INV-TODAY',
      );
      await receive(
        batchId: 'inv-today-b',
        productId: 'inv-today',
        quantity: 2,
        expiresAt: todayStart.add(const Duration(hours: 12)),
      );

      final rows = await repository.listInventory(const InventoryQuery());
      final item = rows.firstWhere((r) => r.id == 'inv-today');

      expect(item.expiryState, InventoryExpiryState.dueToday);
    });

    test('8. classify expired product', () async {
      await createProduct(
        id: 'inv-exp',
        name: 'Expired',
        code: 'INV-EXP',
      );
      await receive(
        batchId: 'inv-exp-b',
        productId: 'inv-exp',
        quantity: 2,
        expiresAt: todayStart.subtract(const Duration(days: 1)),
      );

      final rows = await repository.listInventory(const InventoryQuery());
      final item = rows.firstWhere((r) => r.id == 'inv-exp');

      expect(item.expiryState, InventoryExpiryState.expired);
    });

    test('9. reserved stock is discounted from available stock', () async {
      await createProduct(
        id: 'inv-res',
        name: 'Reserved',
        code: 'INV-RES',
      );
      await receive(batchId: 'inv-res-b', productId: 'inv-res', quantity: 10);

      await repository.createReservation(
        CreateReservationInput(
          reservationId: 'inv-reservation-1',
          createdAt: todayStart,
          lines: const <ReservationLineInput>[
            ReservationLineInput(
              itemId: 'inv-res-item',
              productId: 'inv-res',
              quantity: 4,
              unitPriceCents: 1200,
              taxRateBps: 0,
              discountCents: 0,
            ),
          ],
        ),
      );

      final rows = await repository.listInventory(const InventoryQuery());
      final item = rows.firstWhere((r) => r.id == 'inv-res');

      expect(item.stockTotal, 10);
      expect(item.stockReserved, 4);
      expect(item.stockAvailable, 6);
    });

    test('10. inventory search by name, code and barcode', () async {
      await createProduct(
        id: 'inv-src',
        name: 'Coca Cola 500',
        code: 'COCA-500',
        barcode: '7790123456789',
      );

      final byName = await repository.listInventory(
        const InventoryQuery(search: 'coca cola'),
      );
      final byCode = await repository.listInventory(
        const InventoryQuery(search: 'COCA-500'),
      );
      final byBarcode = await repository.listInventory(
        const InventoryQuery(search: '7790123456789'),
      );

      expect(byName.any((r) => r.id == 'inv-src'), isTrue);
      expect(byCode.any((r) => r.id == 'inv-src'), isTrue);
      expect(byBarcode.any((r) => r.id == 'inv-src'), isTrue);
    });

    test('11. filter low stock', () async {
      await createProduct(
        id: 'inv-f-low',
        name: 'Filtro Bajo',
        code: 'INV-F-LOW',
        stockMin: 5,
      );
      await createProduct(
        id: 'inv-f-normal',
        name: 'Filtro Normal',
        code: 'INV-F-NORMAL',
        stockMin: 2,
      );
      await receive(
          batchId: 'inv-f-low-b', productId: 'inv-f-low', quantity: 2);
      await receive(
          batchId: 'inv-f-normal-b', productId: 'inv-f-normal', quantity: 9);

      final rows = await repository.listInventory(
          const InventoryQuery(filter: InventoryFilter.lowStock));

      expect(rows.map((r) => r.id), contains('inv-f-low'));
      expect(rows.map((r) => r.id), isNot(contains('inv-f-normal')));
    });

    test('12. filter no stock', () async {
      await createProduct(id: 'inv-f-no', name: 'Filtro No', code: 'INV-F-NO');
      await createProduct(
          id: 'inv-f-no-2', name: 'Filtro Tiene', code: 'INV-F-NO-2');
      await receive(
          batchId: 'inv-f-no-b', productId: 'inv-f-no-2', quantity: 1);

      final rows = await repository
          .listInventory(const InventoryQuery(filter: InventoryFilter.noStock));

      expect(rows.map((r) => r.id), contains('inv-f-no'));
      expect(rows.map((r) => r.id), isNot(contains('inv-f-no-2')));
    });

    test('13. filter expired', () async {
      await createProduct(id: 'inv-f-exp', name: 'Exp', code: 'INV-F-EXP');
      await createProduct(id: 'inv-f-ok', name: 'Ok', code: 'INV-F-OK');
      await receive(
        batchId: 'inv-f-exp-b',
        productId: 'inv-f-exp',
        quantity: 1,
        expiresAt: todayStart.subtract(const Duration(days: 2)),
      );
      await receive(
        batchId: 'inv-f-ok-b',
        productId: 'inv-f-ok',
        quantity: 1,
        expiresAt: todayStart.add(const Duration(days: 40)),
      );

      final rows = await repository
          .listInventory(const InventoryQuery(filter: InventoryFilter.expired));

      expect(rows.map((r) => r.id), contains('inv-f-exp'));
      expect(rows.map((r) => r.id), isNot(contains('inv-f-ok')));
    });

    test('14. filter near expiry', () async {
      await createProduct(id: 'inv-f-near', name: 'Near', code: 'INV-F-NEAR');
      await createProduct(id: 'inv-f-far', name: 'Far', code: 'INV-F-FAR');
      await receive(
        batchId: 'inv-f-near-b',
        productId: 'inv-f-near',
        quantity: 1,
        expiresAt: todayStart.add(const Duration(days: 5)),
      );
      await receive(
        batchId: 'inv-f-far-b',
        productId: 'inv-f-far',
        quantity: 1,
        expiresAt: todayStart.add(const Duration(days: 70)),
      );

      final rows = await repository.listInventory(
          const InventoryQuery(filter: InventoryFilter.nearExpiry));

      expect(rows.map((r) => r.id), contains('inv-f-near'));
      expect(rows.map((r) => r.id), isNot(contains('inv-f-far')));
    });

    test('15. filter over stock', () async {
      await createProduct(
        id: 'inv-f-over',
        name: 'Over',
        code: 'INV-F-OVER',
        stockMax: 4,
      );
      await createProduct(
        id: 'inv-f-over-no',
        name: 'Not Over',
        code: 'INV-F-OVER-NO',
        stockMax: 10,
      );
      await receive(
          batchId: 'inv-f-over-b', productId: 'inv-f-over', quantity: 8);
      await receive(
          batchId: 'inv-f-over-no-b', productId: 'inv-f-over-no', quantity: 3);

      final rows = await repository.listInventory(
          const InventoryQuery(filter: InventoryFilter.overStock));

      expect(rows.map((r) => r.id), contains('inv-f-over'));
      expect(rows.map((r) => r.id), isNot(contains('inv-f-over-no')));
    });

    test('16. combine search and filter', () async {
      await createProduct(
        id: 'inv-coca-low',
        name: 'Coca Chica',
        code: 'COCA-LOW',
        stockMin: 5,
      );
      await createProduct(
        id: 'inv-coca-ok',
        name: 'Coca Grande',
        code: 'COCA-OK',
        stockMin: 2,
      );
      await createProduct(
        id: 'inv-agua-low',
        name: 'Agua Chica',
        code: 'AGUA-LOW',
        stockMin: 5,
      );
      await receive(
          batchId: 'inv-coca-low-b', productId: 'inv-coca-low', quantity: 2);
      await receive(
          batchId: 'inv-coca-ok-b', productId: 'inv-coca-ok', quantity: 8);
      await receive(
          batchId: 'inv-agua-low-b', productId: 'inv-agua-low', quantity: 1);

      final rows = await repository.listInventory(
        const InventoryQuery(
          search: 'coca',
          filter: InventoryFilter.lowStock,
        ),
      );

      expect(rows.length, 1);
      expect(rows.first.id, 'inv-coca-low');
    });

    test('17. sort by available stock', () async {
      await createProduct(id: 'inv-sort-a', name: 'A', code: 'INV-S-A');
      await createProduct(id: 'inv-sort-b', name: 'B', code: 'INV-S-B');
      await receive(
          batchId: 'inv-sort-a-b', productId: 'inv-sort-a', quantity: 2);
      await receive(
          batchId: 'inv-sort-b-b', productId: 'inv-sort-b', quantity: 7);

      final rows = await repository.listInventory(
        const InventoryQuery(
          sortBy: InventorySortBy.stockAvailable,
          descending: true,
        ),
      );

      final ids = rows.map((r) => r.id).toList();
      expect(ids.indexOf('inv-sort-b') < ids.indexOf('inv-sort-a'), isTrue);
    });

    test('18. sort by next expiry (closest first)', () async {
      await createProduct(id: 'inv-sort-exp-a', name: 'A', code: 'INV-E-A');
      await createProduct(id: 'inv-sort-exp-b', name: 'B', code: 'INV-E-B');
      await receive(
        batchId: 'inv-sort-exp-a-b',
        productId: 'inv-sort-exp-a',
        quantity: 1,
        expiresAt: todayStart.add(const Duration(days: 12)),
      );
      await receive(
        batchId: 'inv-sort-exp-b-b',
        productId: 'inv-sort-exp-b',
        quantity: 1,
        expiresAt: todayStart.add(const Duration(days: 3)),
      );

      final rows = await repository.listInventory(
        const InventoryQuery(
          sortBy: InventorySortBy.nextExpiry,
        ),
      );

      final ids = rows.map((r) => r.id).toList();
      expect(ids.indexOf('inv-sort-exp-b') < ids.indexOf('inv-sort-exp-a'),
          isTrue);
    });

    test('19. inventory persists after reopen database', () async {
      final file =
          File('${Directory.systemTemp.path}/phase3_inventory_persist.sqlite');
      if (file.existsSync()) {
        file.deleteSync();
      }

      var db = AppDatabase(executor: NativeDatabase(file));
      var repo = DriftStockRepository(db);
      await repo.createProductProfile(
        const ProductUpsertInput(
          id: 'inv-persist',
          name: 'Persistente Inv',
          internalCode: 'INV-PERSIST',
        ),
      );
      await repo.receiveStock(
        ReceiveStockInput(
          batchId: 'inv-persist-batch',
          productId: 'inv-persist',
          quantity: 5,
          unitCostCents: 1200,
          receivedAt: DateTime.now().toUtc(),
        ),
      );
      await db.close();

      db = AppDatabase(executor: NativeDatabase(file));
      repo = DriftStockRepository(db);

      final rows = await repo.listInventory(
        const InventoryQuery(search: 'persistente'),
      );
      final summary = await repo.getInventorySummary(const InventoryQuery());

      expect(rows.any((r) => r.id == 'inv-persist'), isTrue);
      expect(summary.totalProducts, 1);

      await db.close();
      if (file.existsSync()) {
        file.deleteSync();
      }
    });
  });
}
