import 'dart:io';

import 'package:control_stok_celu/core/errors/app_exception.dart';
import 'package:control_stok_celu/data/db/app_database.dart';
import 'package:control_stok_celu/data/repositories/drift_stock_repository.dart';
import 'package:control_stok_celu/domain/stock/stock_models.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  group('Product and category repository', () {
    late AppDatabase database;
    late DriftStockRepository repository;

    setUp(() {
      database = AppDatabase(executor: NativeDatabase.memory());
      repository = DriftStockRepository(database);
    });

    tearDown(() async {
      await database.close();
    });

    test(
        'create category and create product with search by code and partial name',
        () async {
      await repository.createCategory(
        const CategoryUpsertInput(
          id: 'cat-1',
          name: 'Bebidas',
        ),
      );

      await repository.createProductProfile(
        const ProductUpsertInput(
          id: 'prod-1',
          name: 'Agua Mineral 500ml',
          internalCode: 'AGUA-500',
          categoryId: 'cat-1',
          salePriceCents: 250000,
          costCents: 120000,
        ),
      );

      final byCode = await repository.listProducts(
        const ProductQuery(search: 'AGUA-500', status: ProductStatusFilter.all),
      );
      expect(byCode, isNotEmpty);
      expect(byCode.first.id, 'prod-1');

      final byName = await repository.listProducts(
        const ProductQuery(search: 'mineral', status: ProductStatusFilter.all),
      );
      expect(byName, isNotEmpty);
      expect(byName.first.name, contains('Agua'));

      final byMissing = await repository.listProducts(
        const ProductQuery(
            search: 'no-existe-xyz', status: ProductStatusFilter.all),
      );
      expect(byMissing, isEmpty);
    });

    test('search by barcode exact and accent-insensitive name', () async {
      await repository.createProductProfile(
        const ProductUpsertInput(
          id: 'prod-barcode',
          name: 'Cámara Frontal HD',
          internalCode: 'CAM-001',
          barcode: '7791234567890',
          brand: 'MarcaX',
        ),
      );

      final byBarcode = await repository.listProducts(
        const ProductQuery(
            search: '7791234567890', status: ProductStatusFilter.all),
      );
      expect(byBarcode, isNotEmpty);
      expect(byBarcode.first.id, 'prod-barcode');

      final byAccentless = await repository.listProducts(
        const ProductQuery(
            search: 'camara frontal', status: ProductStatusFilter.all),
      );
      expect(byAccentless.any((p) => p.id == 'prod-barcode'), isTrue);
    });

    test('reject duplicate internal code and duplicate barcode', () async {
      await repository.createProductProfile(
        const ProductUpsertInput(
          id: 'prod-a',
          name: 'Producto A',
          internalCode: 'P-A',
          barcode: '123',
        ),
      );

      await expectLater(
        () => repository.createProductProfile(
          const ProductUpsertInput(
            id: 'prod-b',
            name: 'Producto B',
            internalCode: 'P-A',
          ),
        ),
        throwsA(isA<ConflictException>()),
      );

      await expectLater(
        () => repository.createProductProfile(
          const ProductUpsertInput(
            id: 'prod-c',
            name: 'Producto C',
            internalCode: 'P-C',
            barcode: '123',
          ),
        ),
        throwsA(isA<ConflictException>()),
      );
    });

    test('deactivate and reactivate product', () async {
      await repository.createProductProfile(
        const ProductUpsertInput(
          id: 'prod-active',
          name: 'Producto Activo',
          internalCode: 'P-ON',
        ),
      );

      await repository.setProductActive('prod-active', false);
      final inactive = await repository.listProducts(
        const ProductQuery(status: ProductStatusFilter.inactive),
      );
      expect(inactive.any((p) => p.id == 'prod-active'), isTrue);

      await repository.setProductActive('prod-active', true);
      final active = await repository.listProducts(
        const ProductQuery(status: ProductStatusFilter.active),
      );
      expect(active.any((p) => p.id == 'prod-active'), isTrue);
    });

    test('inactive product cannot be reserved or sold', () async {
      await repository.createProductProfile(
        const ProductUpsertInput(
          id: 'prod-inactive-rules',
          name: 'Producto Inactivo',
          internalCode: 'P-INACT',
        ),
      );
      await repository.receiveStock(
        ReceiveStockInput(
          batchId: 'batch-inactive-rules',
          productId: 'prod-inactive-rules',
          quantity: 15,
          unitCostCents: 2000,
          receivedAt: DateTime.utc(2026, 8, 2),
        ),
      );
      await repository.setProductActive('prod-inactive-rules', false);

      await expectLater(
        () => repository.createReservation(
          CreateReservationInput(
            reservationId: 'res-inactive-rules',
            createdAt: DateTime.utc(2026, 8, 3),
            lines: const <ReservationLineInput>[
              ReservationLineInput(
                itemId: 'res-item-inactive-rules',
                productId: 'prod-inactive-rules',
                quantity: 1,
                unitPriceCents: 3000,
                taxRateBps: 2100,
                discountCents: 0,
              ),
            ],
          ),
        ),
        throwsA(isA<ConflictException>()),
      );

      await expectLater(
        () => repository.createDirectSale(
          CreateDirectSaleInput(
            saleId: 'sale-inactive-rules',
            createdAt: DateTime.utc(2026, 8, 3),
            lines: const <DirectSaleLineInput>[
              DirectSaleLineInput(
                itemId: 'sale-item-inactive-rules',
                productId: 'prod-inactive-rules',
                quantity: 1,
                unitPriceCents: 3000,
                taxRateBps: 2100,
                discountCents: 0,
              ),
            ],
          ),
        ),
        throwsA(isA<ConflictException>()),
      );
    });

    test('edit product keeps stock movements untouched', () async {
      await repository.createProductProfile(
        const ProductUpsertInput(
          id: 'prod-h',
          name: 'Producto Historial',
          internalCode: 'P-H',
        ),
      );
      await repository.receiveStock(
        ReceiveStockInput(
          batchId: 'batch-h',
          productId: 'prod-h',
          quantity: 20,
          unitCostCents: 5000,
          receivedAt: DateTime.utc(2026, 8, 1),
        ),
      );

      final movementCountBefore =
          (await (database.select(database.stockMovements)
                    ..where((t) => t.productId.equals('prod-h')))
                  .get())
              .length;

      await repository.updateProductProfile(
        const ProductUpsertInput(
          id: 'prod-h',
          name: 'Producto Historial Editado',
          internalCode: 'P-H',
          salePriceCents: 9000,
          costCents: 6000,
        ),
      );

      final movementCountAfter =
          (await (database.select(database.stockMovements)
                    ..where((t) => t.productId.equals('prod-h')))
                  .get())
              .length;
      expect(movementCountAfter, movementCountBefore);
    });

    test('create, edit and deactivate category with product count', () async {
      await repository.createCategory(
        const CategoryUpsertInput(id: 'cat-a', name: 'Accesorios'),
      );
      await repository.createCategory(
        const CategoryUpsertInput(
            id: 'cat-b', name: 'Fundas', parentId: 'cat-a'),
      );

      await repository.createProductProfile(
        const ProductUpsertInput(
          id: 'prod-cat',
          name: 'Funda TPU',
          internalCode: 'FUNDA-1',
          categoryId: 'cat-b',
        ),
      );

      await repository.updateCategory(
        const CategoryUpsertInput(
            id: 'cat-b', name: 'Fundas Premium', parentId: 'cat-a'),
      );
      await repository.setCategoryActive('cat-b', false);

      final categories = await repository.listCategories(search: 'fundas');
      expect(categories, isNotEmpty);
      expect(categories.first.productCount, 1);
      expect(categories.first.isActive, isFalse);
    });

    test('product persistence after reopen', () async {
      final file =
          File('${Directory.systemTemp.path}/phase2_product_persist.sqlite');
      if (file.existsSync()) {
        file.deleteSync();
      }

      var db = AppDatabase(executor: NativeDatabase(file));
      var repo = DriftStockRepository(db);
      await repo.createProductProfile(
        const ProductUpsertInput(
          id: 'prod-persist',
          name: 'Producto Persistencia',
          internalCode: 'P-PERSIST',
        ),
      );
      await db.close();

      db = AppDatabase(executor: NativeDatabase(file));
      repo = DriftStockRepository(db);
      final items = await repo.listProducts(
        const ProductQuery(search: 'persist', status: ProductStatusFilter.all),
      );
      expect(items.any((p) => p.id == 'prod-persist'), isTrue);
      await db.close();
      if (file.existsSync()) {
        file.deleteSync();
      }
    });

    test(
        'logical delete deactivates product and keeps it queryable as inactive',
        () async {
      await repository.createProductProfile(
        const ProductUpsertInput(
          id: 'prod-logical-delete',
          name: 'Producto Eliminacion Logica',
          internalCode: 'P-DEL-LOG',
        ),
      );

      await repository.logicalDeleteProduct('prod-logical-delete');

      final inactive = await repository.listProducts(
        const ProductQuery(status: ProductStatusFilter.inactive),
      );
      expect(inactive.any((p) => p.id == 'prod-logical-delete'), isTrue);
    });
  });
}
