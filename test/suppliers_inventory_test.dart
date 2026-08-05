import 'package:control_stok_celu/core/errors/app_exception.dart';
import 'package:control_stok_celu/data/db/app_database.dart';
import 'package:control_stok_celu/data/repositories/drift_stock_repository.dart';
import 'package:control_stok_celu/domain/stock/stock_models.dart';
import 'package:drift/drift.dart' hide isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:io';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  group('Suppliers and inventory phase 3', () {
    late AppDatabase database;
    late DriftStockRepository repository;

    setUp(() {
      database = AppDatabase(executor: NativeDatabase.memory());
      repository = DriftStockRepository(database);
    });

    tearDown(() async {
      await database.close();
    });

    test('create, search, edit and deactivate supplier', () async {
      await repository.createSupplier(
        const SupplierUpsertInput(
          id: 'sup-1',
          name: 'Proveedor Uno',
          legalName: 'Proveedor Uno SA',
          cuit: '30-12345678-9',
          phone: '1122334455',
          email: 'uno@proveedor.com',
          address: 'Calle 123',
          notes: 'Preferente',
        ),
      );

      final foundByName = await repository.listSuppliers(search: 'proveedor');
      expect(foundByName, isNotEmpty);
      expect(foundByName.first.id, 'sup-1');

      await repository.updateSupplier(
        const SupplierUpsertInput(
          id: 'sup-1',
          name: 'Proveedor Uno Editado',
          legalName: 'Proveedor Uno SA',
          cuit: '30-12345678-9',
          isActive: true,
        ),
      );
      final foundEdited = await repository.listSuppliers(search: 'editado');
      expect(foundEdited.any((s) => s.id == 'sup-1'), isTrue);

      await repository.setSupplierActive('sup-1', false);
      final inactive = await repository.listSuppliers(includeInactive: true);
      final row = inactive.firstWhere((s) => s.id == 'sup-1');
      expect(row.isActive, isFalse);

      await repository.setSupplierActive('sup-1', true);
      final active = await repository.listSuppliers(includeInactive: false);
      expect(active.any((supplier) => supplier.id == 'sup-1'), isTrue);
    });

    test('search supplier by phone and email', () async {
      await repository.createSupplier(
        const SupplierUpsertInput(
          id: 'sup-contact',
          name: 'Proveedor Contacto',
          phone: '1133445566',
          email: 'contacto@proveedor.com',
        ),
      );

      final byPhone = await repository.listSuppliers(search: '3344');
      expect(byPhone.any((s) => s.id == 'sup-contact'), isTrue);

      final byEmail = await repository.listSuppliers(search: 'contacto@');
      expect(byEmail.any((s) => s.id == 'sup-contact'), isTrue);
    });

    test('reject duplicate supplier cuit', () async {
      await repository.createSupplier(
        const SupplierUpsertInput(
          id: 'sup-a',
          name: 'Proveedor A',
          cuit: '30-99999999-1',
        ),
      );

      await expectLater(
        () => repository.createSupplier(
          const SupplierUpsertInput(
            id: 'sup-b',
            name: 'Proveedor B',
            cuit: '30-99999999-1',
          ),
        ),
        throwsA(isA<ConflictException>()),
      );
    });

    test('associate supplier to received batch', () async {
      await repository.createSupplier(
        const SupplierUpsertInput(
          id: 'sup-batch',
          name: 'Proveedor Lotes',
        ),
      );
      await repository.createProductProfile(
        const ProductUpsertInput(
          id: 'prod-batch-sup',
          name: 'Producto Lote',
          internalCode: 'PROD-LOT',
        ),
      );

      await repository.receiveStock(
        ReceiveStockInput(
          batchId: 'batch-sup-1',
          productId: 'prod-batch-sup',
          quantity: 10,
          unitCostCents: 1500,
          supplierId: 'sup-batch',
          receivedAt: DateTime.utc(2026, 8, 3),
        ),
      );

      final batch = await (database.select(database.productBatches)
            ..where((t) => t.id.equals('batch-sup-1')))
          .getSingle();
      expect(batch.supplierId, 'sup-batch');

      final suppliers = await repository.listSuppliers(search: 'lotes');
      expect(suppliers.first.productBatchCount, 1);
    });

    test('reject receive stock when supplier is inactive and rollback',
        () async {
      await repository.createSupplier(
        const SupplierUpsertInput(
          id: 'sup-inactive',
          name: 'Proveedor Inactivo',
          isActive: false,
        ),
      );
      await repository.createProductProfile(
        const ProductUpsertInput(
          id: 'prod-inactive-supplier',
          name: 'Producto Ingreso',
          internalCode: 'PROD-IN-SUP',
        ),
      );

      await expectLater(
        () => repository.receiveStock(
          ReceiveStockInput(
            batchId: 'batch-inactive-supplier',
            productId: 'prod-inactive-supplier',
            quantity: 10,
            unitCostCents: 2200,
            supplierId: 'sup-inactive',
            receivedAt: DateTime.utc(2026, 8, 3),
          ),
        ),
        throwsA(isA<ConflictException>()),
      );

      final stock = await repository.getProductStock('prod-inactive-supplier');
      expect(stock.stockTotal, 0);

      final batches = await (database.select(database.productBatches)
            ..where((t) => t.productId.equals('prod-inactive-supplier')))
          .get();
      expect(batches, isEmpty);
    });

    test('supplier update keeps historical batch association', () async {
      await repository.createSupplier(
        const SupplierUpsertInput(
          id: 'sup-history',
          name: 'Proveedor Historia',
          cuit: '30-22222222-2',
        ),
      );
      await repository.createProductProfile(
        const ProductUpsertInput(
          id: 'prod-history',
          name: 'Producto Historia',
          internalCode: 'PROD-HIST',
        ),
      );

      await repository.receiveStock(
        ReceiveStockInput(
          batchId: 'batch-history-1',
          productId: 'prod-history',
          quantity: 6,
          unitCostCents: 500,
          supplierId: 'sup-history',
          receivedAt: DateTime.utc(2026, 8, 3),
        ),
      );

      await repository.updateSupplier(
        const SupplierUpsertInput(
          id: 'sup-history',
          name: 'Proveedor Historia Editado',
          cuit: '30-22222222-2',
          isActive: true,
        ),
      );

      final batch = await (database.select(database.productBatches)
            ..where((t) => t.id.equals('batch-history-1')))
          .getSingle();
      expect(batch.supplierId, 'sup-history');

      final detail = await repository.getSupplierDetail('sup-history');
      expect(detail.incomeCount, 1);
      expect(detail.associatedProductsCount, 1);
      expect(detail.lastIncomeAt, isNotNull);
    });

    test('supplier data persists after reopen', () async {
      final file =
          File('${Directory.systemTemp.path}/phase3_supplier_persist.sqlite');
      if (file.existsSync()) {
        file.deleteSync();
      }

      var db = AppDatabase(executor: NativeDatabase(file));
      var repo = DriftStockRepository(db);
      await repo.createSupplier(
        const SupplierUpsertInput(
          id: 'sup-persist',
          name: 'Proveedor Persistente',
          cuit: '30-33333333-3',
        ),
      );
      await db.close();

      db = AppDatabase(executor: NativeDatabase(file));
      repo = DriftStockRepository(db);
      final suppliers = await repo.listSuppliers(search: 'persistente');
      expect(suppliers.any((s) => s.id == 'sup-persist'), isTrue);
      await db.close();

      if (file.existsSync()) {
        file.deleteSync();
      }
    });
  });
}
