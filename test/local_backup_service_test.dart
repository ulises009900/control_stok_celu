import 'dart:io';

import 'package:control_stok_celu/core/errors/app_exception.dart';
import 'package:control_stok_celu/data/backup/local_backup_service.dart';
import 'package:control_stok_celu/data/db/app_database.dart';
import 'package:control_stok_celu/data/repositories/drift_stock_repository.dart';
import 'package:control_stok_celu/domain/stock/stock_models.dart';
import 'package:drift/drift.dart' hide isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  group('local backup service', () {
    late Directory tempDir;
    late File dbFile;
    late AppDatabase database;
    late DriftStockRepository repository;
    late LocalBackupService service;

    Future<void> seedData() async {
      final now = DateTime.now().toUtc();
      await repository.createCategory(
        const CategoryUpsertInput(id: 'cat-backup', name: 'General'),
      );
      await repository.createSupplier(
        const SupplierUpsertInput(id: 'sup-backup', name: 'Proveedor'),
      );
      await repository.createCustomer(
        const CustomerUpsertInput(id: 'cus-backup', name: 'Cliente'),
      );
      await repository.createProductProfile(
        const ProductUpsertInput(
          id: 'prod-backup',
          name: 'Producto Backup',
          internalCode: 'BACKUP-1',
          categoryId: 'cat-backup',
          costCents: 1000,
          salePriceCents: 2000,
        ),
      );
      await repository.receiveStock(
        ReceiveStockInput(
          batchId: 'batch-backup',
          productId: 'prod-backup',
          quantity: 10,
          unitCostCents: 1000,
          supplierId: 'sup-backup',
          receivedAt: now,
        ),
      );
      await repository.createReservation(
        CreateReservationInput(
          reservationId: 'res-backup',
          createdAt: now,
          customerId: 'cus-backup',
          lines: const <ReservationLineInput>[
            ReservationLineInput(
              itemId: 'res-line-backup',
              productId: 'prod-backup',
              quantity: 2,
              unitPriceCents: 2000,
              taxRateBps: 2100,
              discountCents: 0,
            ),
          ],
        ),
      );
      await repository.confirmReservationSale(
        ConfirmSaleInput(
          saleId: 'sale-backup',
          reservationId: 'res-backup',
          confirmedAt: now.add(const Duration(minutes: 1)),
        ),
      );
      await repository.createExpenseCategory(
        const ExpenseCategoryUpsertInput(
            id: 'exp-cat-backup', name: 'Servicios'),
      );
      await repository.createExpense(
        const ExpenseUpsertInput(
          id: 'exp-backup',
          description: 'Internet',
          categoryId: 'exp-cat-backup',
          amountCents: 500,
          occurredAt: '2026-08-04',
          supplierId: 'sup-backup',
        ),
      );
      await database.into(database.notes).insert(
            NotesCompanion.insert(
              id: 'note-backup',
              title: 'Nota',
              content: 'Contenido',
              createdAt: now,
              updatedAt: now,
            ),
          );
      await database.into(database.reminders).insert(
            RemindersCompanion.insert(
              id: 'rem-backup',
              title: 'Recordar',
              dueAt: now,
            ),
          );
      await database.into(database.checklists).insert(
            ChecklistsCompanion.insert(
              id: 'check-backup',
              title: 'Checklist',
              createdAt: now,
              updatedAt: now,
            ),
          );
      await database.into(database.checklistItems).insert(
            ChecklistItemsCompanion.insert(
              id: 'check-item-backup',
              checklistId: 'check-backup',
              textValue: 'Paso',
            ),
          );
    }

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('backup_service_test_');
      dbFile = File('${tempDir.path}${Platform.pathSeparator}main.sqlite');
      database = AppDatabase(executor: NativeDatabase(dbFile));
      repository = DriftStockRepository(database);
      service = LocalBackupService(
        getDatabase: () async => database,
        resolvePrimaryDatabaseFile: () async => dbFile,
        restartDatabase: () async {
          await database.close();
          database = AppDatabase(executor: NativeDatabase(dbFile));
          repository = DriftStockRepository(database);
        },
        currentSchemaVersion: AppDatabase.currentSchemaVersion,
        appVersion: kAppProductionVersion,
      );
    });

    tearDown(() async {
      await database.close();
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('creates backup file with metadata and valid data', () async {
      await seedData();
      final backupDir =
          Directory('${tempDir.path}${Platform.pathSeparator}exports');
      final export =
          await service.exportBackupToDirectory(directoryPath: backupDir.path);

      expect(File(export.filePath).existsSync(), isTrue);
      final validation = await service.validateBackupFile(export.filePath);
      expect(validation.isValid, isTrue);
      expect(validation.schemaVersion, AppDatabase.currentSchemaVersion);
      expect(validation.appVersion, kAppProductionVersion);

      final backupDb =
          AppDatabase(executor: NativeDatabase(File(export.filePath)));
      final backupRepo = DriftStockRepository(backupDb);
      final stock = await backupRepo.getProductStock('prod-backup');
      expect(stock.stockTotal, 8);
      expect((await backupDb.select(backupDb.notes).get()).length, 1);
      await backupDb.close();
    });

    test('restores original data and creates safety backup first', () async {
      await seedData();
      final backupDir =
          Directory('${tempDir.path}${Platform.pathSeparator}exports');
      final export =
          await service.exportBackupToDirectory(directoryPath: backupDir.path);

      await repository.createProductProfile(
        const ProductUpsertInput(
          id: 'prod-extra',
          name: 'Extra',
          internalCode: 'EXTRA-1',
        ),
      );
      await (database.delete(database.notes)
            ..where((t) => t.id.equals('note-backup')))
          .go();

      final restore = await service.restoreBackup(export.filePath);
      expect(File(restore.safetyBackup.filePath).existsSync(), isTrue);

      final stock = await repository.getProductStock('prod-backup');
      expect(stock.stockTotal, 8);
      expect(
          await repository.listProducts(const ProductQuery(
              search: 'extra', status: ProductStatusFilter.all)),
          isEmpty);
      expect((await database.select(database.notes).get()).length, 1);
    });

    test('invalid restore files are rejected and current database stays intact',
        () async {
      await seedData();
      final invalid =
          File('${tempDir.path}${Platform.pathSeparator}invalid.db');
      await invalid.writeAsString('not a sqlite database');

      await expectLater(
        () => service.validateBackupFile(invalid.path),
        throwsA(isA<AppException>()),
      );
      await expectLater(
        () => service.restoreBackup(invalid.path),
        throwsA(isA<AppException>()),
      );

      expect(await repository.getCustomerDetail('cus-backup'), isNotNull);
      expect((await database.select(database.notes).get()).length, 1);
    });

    test('rejects incompatible backup metadata', () async {
      await seedData();
      final backupDir =
          Directory('${tempDir.path}${Platform.pathSeparator}exports');
      final export =
          await service.exportBackupToDirectory(directoryPath: backupDir.path);

      final backupDb =
          AppDatabase(executor: NativeDatabase(File(export.filePath)));
      await backupDb.into(backupDb.settings).insertOnConflictUpdate(
            SettingsCompanion.insert(
              key: 'backup_schema_version',
              valueJson: '999',
              updatedAt: DateTime.now().toUtc(),
            ),
          );
      await backupDb.close();

      await expectLater(
        () => service.validateBackupFile(export.filePath),
        throwsA(isA<AppException>()),
      );
    });

    test('backup with wal preserves stock, sales, reservations and audit data',
        () async {
      await seedData();
      final backupDir =
          Directory('${tempDir.path}${Platform.pathSeparator}exports');
      final export =
          await service.exportBackupToDirectory(directoryPath: backupDir.path);

      final backupDb =
          AppDatabase(executor: NativeDatabase(File(export.filePath)));
      final stock =
          await DriftStockRepository(backupDb).getProductStock('prod-backup');
      expect(stock.stockTotal, 8);
      expect(stock.stockReserved, 0);
      expect((await backupDb.select(backupDb.sales).get()).length, 1);
      expect((await backupDb.select(backupDb.reservations).get()).length, 1);
      expect((await backupDb.select(backupDb.stockMovements).get()).isNotEmpty,
          isTrue);
      expect(
          (await backupDb.select(backupDb.auditLogs).get()).isNotEmpty, isTrue);
      await backupDb.close();
    });
  });
}
