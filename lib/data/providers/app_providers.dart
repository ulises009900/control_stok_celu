import 'dart:convert';
import 'dart:io';

import 'package:control_stok_celu/data/backup/local_backup_service.dart';
import 'package:control_stok_celu/data/db/app_database.dart';
import 'package:control_stok_celu/data/repositories/drift_stock_repository.dart';
import 'package:control_stok_celu/domain/stock/stock_models.dart';
import 'package:control_stok_celu/domain/stock/stock_repository.dart';
import 'package:control_stok_celu/domain/stock/stock_use_cases.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

final appSessionRevisionProvider = StateProvider<int>((ref) => 0);

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  ref.watch(appSessionRevisionProvider);
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

/// Identificador estable de este dispositivo/instalación, usado para
/// distinguir cajas y filas sincronizadas por dispositivo. Se genera una
/// vez y se persiste en la tabla `settings`.
final deviceIdProvider = FutureProvider<String>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  const key = 'device_id';
  final existing =
      await (db.select(db.settings)..where((t) => t.key.equals(key)))
          .getSingleOrNull();
  if (existing != null) {
    return jsonDecode(existing.valueJson) as String;
  }
  final newId = const Uuid().v4();
  await db.into(db.settings).insertOnConflictUpdate(
        SettingsCompanion.insert(
          key: key,
          valueJson: jsonEncode(newId),
          updatedAt: DateTime.now().toUtc(),
        ),
      );
  return newId;
});

class AppDatabaseLifecycle {
  AppDatabaseLifecycle(this._ref);

  final Ref _ref;

  Future<void> restart() async {
    final db = _ref.read(appDatabaseProvider);
    await db.close();
    _ref.invalidate(appDatabaseProvider);
    _ref.invalidate(stockRepositoryProvider);
    _ref.read(appSessionRevisionProvider.notifier).state++;
  }
}

final appDatabaseLifecycleProvider = Provider<AppDatabaseLifecycle>((ref) {
  return AppDatabaseLifecycle(ref);
});

final localBackupServiceProvider = Provider<LocalBackupService>((ref) {
  return LocalBackupService(
    getDatabase: () async => ref.read(appDatabaseProvider),
    resolvePrimaryDatabaseFile: resolveAppDatabaseFile,
    restartDatabase: () => ref.read(appDatabaseLifecycleProvider).restart(),
    currentSchemaVersion: AppDatabase.currentSchemaVersion,
    appVersion: kAppProductionVersion,
  );
});

class StockBackupCoordinator {
  StockBackupCoordinator(this._backupService);

  final LocalBackupService _backupService;

  Future<void> createBackupInBacaps() async {
    final docsDirectory = await getApplicationDocumentsDirectory();
    final backupDirectory = Directory(p.join(docsDirectory.path, 'bacaps'));
    await _backupService.exportBackupToDirectory(
      directoryPath: backupDirectory.path,
    );
  }
}

final stockBackupCoordinatorProvider = Provider<StockBackupCoordinator>((ref) {
  return StockBackupCoordinator(ref.read(localBackupServiceProvider));
});

final stockRepositoryProvider = Provider<StockRepository>((ref) {
  return DriftStockRepository(ref.watch(appDatabaseProvider));
});

final createProductUseCaseProvider = Provider<CreateProductUseCase>((ref) {
  return CreateProductUseCase(ref.watch(stockRepositoryProvider));
});

final createProductProfileUseCaseProvider =
    Provider<CreateProductProfileUseCase>((ref) {
  return CreateProductProfileUseCase(ref.watch(stockRepositoryProvider));
});

final updateProductProfileUseCaseProvider =
    Provider<UpdateProductProfileUseCase>((ref) {
  return UpdateProductProfileUseCase(ref.watch(stockRepositoryProvider));
});

final setProductActiveUseCaseProvider =
    Provider<SetProductActiveUseCase>((ref) {
  return SetProductActiveUseCase(ref.watch(stockRepositoryProvider));
});

final logicalDeleteProductUseCaseProvider =
    Provider<LogicalDeleteProductUseCase>((ref) {
  return LogicalDeleteProductUseCase(ref.watch(stockRepositoryProvider));
});

final listProductsUseCaseProvider = Provider<ListProductsUseCase>((ref) {
  return ListProductsUseCase(ref.watch(stockRepositoryProvider));
});

final getInventorySummaryUseCaseProvider =
    Provider<GetInventorySummaryUseCase>((ref) {
  return GetInventorySummaryUseCase(ref.watch(stockRepositoryProvider));
});

final listInventoryUseCaseProvider = Provider<ListInventoryUseCase>((ref) {
  return ListInventoryUseCase(ref.watch(stockRepositoryProvider));
});

final getProductDetailUseCaseProvider =
    Provider<GetProductDetailUseCase>((ref) {
  return GetProductDetailUseCase(ref.watch(stockRepositoryProvider));
});

final createCategoryUseCaseProvider = Provider<CreateCategoryUseCase>((ref) {
  return CreateCategoryUseCase(ref.watch(stockRepositoryProvider));
});

final updateCategoryUseCaseProvider = Provider<UpdateCategoryUseCase>((ref) {
  return UpdateCategoryUseCase(ref.watch(stockRepositoryProvider));
});

final setCategoryActiveUseCaseProvider =
    Provider<SetCategoryActiveUseCase>((ref) {
  return SetCategoryActiveUseCase(ref.watch(stockRepositoryProvider));
});

final listCategoriesUseCaseProvider = Provider<ListCategoriesUseCase>((ref) {
  return ListCategoriesUseCase(ref.watch(stockRepositoryProvider));
});

final createSupplierUseCaseProvider = Provider<CreateSupplierUseCase>((ref) {
  return CreateSupplierUseCase(ref.watch(stockRepositoryProvider));
});

final updateSupplierUseCaseProvider = Provider<UpdateSupplierUseCase>((ref) {
  return UpdateSupplierUseCase(ref.watch(stockRepositoryProvider));
});

final setSupplierActiveUseCaseProvider =
    Provider<SetSupplierActiveUseCase>((ref) {
  return SetSupplierActiveUseCase(ref.watch(stockRepositoryProvider));
});

final listSuppliersUseCaseProvider = Provider<ListSuppliersUseCase>((ref) {
  return ListSuppliersUseCase(ref.watch(stockRepositoryProvider));
});

final getSupplierDetailUseCaseProvider =
    Provider<GetSupplierDetailUseCase>((ref) {
  return GetSupplierDetailUseCase(ref.watch(stockRepositoryProvider));
});

final createCustomerUseCaseProvider = Provider<CreateCustomerUseCase>((ref) {
  return CreateCustomerUseCase(ref.watch(stockRepositoryProvider));
});

final updateCustomerUseCaseProvider = Provider<UpdateCustomerUseCase>((ref) {
  return UpdateCustomerUseCase(ref.watch(stockRepositoryProvider));
});

final setCustomerActiveUseCaseProvider =
    Provider<SetCustomerActiveUseCase>((ref) {
  return SetCustomerActiveUseCase(ref.watch(stockRepositoryProvider));
});

final listCustomersUseCaseProvider = Provider<ListCustomersUseCase>((ref) {
  return ListCustomersUseCase(ref.watch(stockRepositoryProvider));
});

final createReservationDraftUseCaseProvider =
    Provider<CreateReservationDraftUseCase>((ref) {
  return CreateReservationDraftUseCase(ref.watch(stockRepositoryProvider));
});

final saveReservationDraftUseCaseProvider =
    Provider<SaveReservationDraftUseCase>((ref) {
  return SaveReservationDraftUseCase(ref.watch(stockRepositoryProvider));
});

final saveSaleDraftUseCaseProvider = Provider<SaveSaleDraftUseCase>((ref) {
  return SaveSaleDraftUseCase(ref.watch(stockRepositoryProvider));
});

final deleteSaleDraftUseCaseProvider = Provider<DeleteSaleDraftUseCase>((ref) {
  return DeleteSaleDraftUseCase(ref.watch(stockRepositoryProvider));
});

final reserveSaleDraftUseCaseProvider =
    Provider<Future<void> Function(String, DateTime)>((ref) {
  final useCase = ReserveSaleDraftUseCase(ref.watch(stockRepositoryProvider));
  final backup = ref.read(stockBackupCoordinatorProvider);
  return (saleId, reservedAt) async {
    await backup.createBackupInBacaps();
    await useCase(saleId, reservedAt);
  };
});

final confirmSaleDraftUseCaseProvider =
    Provider<Future<void> Function(String, DateTime)>((ref) {
  final useCase = ConfirmSaleDraftUseCase(ref.watch(stockRepositoryProvider));
  final backup = ref.read(stockBackupCoordinatorProvider);
  return (saleId, confirmedAt) async {
    await backup.createBackupInBacaps();
    await useCase(saleId, confirmedAt);
  };
});

final listSalesUseCaseProvider = Provider<ListSalesUseCase>((ref) {
  return ListSalesUseCase(ref.watch(stockRepositoryProvider));
});

final getSaleDetailUseCaseProvider = Provider<GetSaleDetailUseCase>((ref) {
  return GetSaleDetailUseCase(ref.watch(stockRepositoryProvider));
});

final listReservationsUseCaseProvider =
    Provider<ListReservationsUseCase>((ref) {
  return ListReservationsUseCase(ref.watch(stockRepositoryProvider));
});

final getReservationDetailUseCaseProvider =
    Provider<GetReservationDetailUseCase>((ref) {
  return GetReservationDetailUseCase(ref.watch(stockRepositoryProvider));
});

final getCustomerDetailUseCaseProvider =
    Provider<GetCustomerDetailUseCase>((ref) {
  return GetCustomerDetailUseCase(ref.watch(stockRepositoryProvider));
});

final reserveDraftReservationUseCaseProvider =
    Provider<Future<void> Function(String, DateTime)>((ref) {
  final useCase =
      ReserveDraftReservationUseCase(ref.watch(stockRepositoryProvider));
  final backup = ref.read(stockBackupCoordinatorProvider);
  return (reservationId, reservedAt) async {
    await backup.createBackupInBacaps();
    await useCase(reservationId, reservedAt);
  };
});

final deleteReservationUseCaseProvider =
    Provider<Future<void> Function(String, DateTime)>((ref) {
  final useCase = DeleteReservationUseCase(ref.watch(stockRepositoryProvider));
  final backup = ref.read(stockBackupCoordinatorProvider);
  return (reservationId, deletedAt) async {
    await backup.createBackupInBacaps();
    await useCase(reservationId, deletedAt);
  };
});

final confirmDraftReservationSaleUseCaseProvider =
    Provider<Future<void> Function(ConfirmSaleInput)>((ref) {
  final useCase =
      ConfirmDraftReservationSaleUseCase(ref.watch(stockRepositoryProvider));
  final backup = ref.read(stockBackupCoordinatorProvider);
  return (input) async {
    await backup.createBackupInBacaps();
    await useCase(input);
  };
});

final receiveStockUseCaseProvider =
    Provider<Future<void> Function(ReceiveStockInput)>((ref) {
  final useCase = ReceiveStockUseCase(ref.watch(stockRepositoryProvider));
  final backup = ref.read(stockBackupCoordinatorProvider);
  return (input) async {
    await backup.createBackupInBacaps();
    await useCase(input);
  };
});

final adjustStockUseCaseProvider =
    Provider<Future<void> Function(StockAdjustmentInput)>((ref) {
  final useCase = AdjustStockUseCase(ref.watch(stockRepositoryProvider));
  final backup = ref.read(stockBackupCoordinatorProvider);
  return (input) async {
    await backup.createBackupInBacaps();
    await useCase(input);
  };
});

final createReservationUseCaseProvider =
    Provider<Future<void> Function(CreateReservationInput)>((ref) {
  final useCase = CreateReservationUseCase(ref.watch(stockRepositoryProvider));
  final backup = ref.read(stockBackupCoordinatorProvider);
  return (input) async {
    await backup.createBackupInBacaps();
    await useCase(input);
  };
});

final cancelReservationUseCaseProvider =
    Provider<Future<void> Function(String, DateTime)>((ref) {
  final useCase = CancelReservationUseCase(ref.watch(stockRepositoryProvider));
  final backup = ref.read(stockBackupCoordinatorProvider);
  return (reservationId, canceledAt) async {
    await backup.createBackupInBacaps();
    await useCase(reservationId, canceledAt);
  };
});

final confirmReservationSaleUseCaseProvider =
    Provider<Future<void> Function(ConfirmSaleInput)>((ref) {
  final useCase =
      ConfirmReservationSaleUseCase(ref.watch(stockRepositoryProvider));
  final backup = ref.read(stockBackupCoordinatorProvider);
  return (input) async {
    await backup.createBackupInBacaps();
    await useCase(input);
  };
});

final createDirectSaleUseCaseProvider =
    Provider<Future<void> Function(CreateDirectSaleInput)>((ref) {
  final useCase = CreateDirectSaleUseCase(ref.watch(stockRepositoryProvider));
  final backup = ref.read(stockBackupCoordinatorProvider);
  return (input) async {
    await backup.createBackupInBacaps();
    await useCase(input);
  };
});

final createReturnUseCaseProvider =
    Provider<Future<void> Function(CreateReturnInput)>((ref) {
  final useCase = CreateReturnUseCase(ref.watch(stockRepositoryProvider));
  final backup = ref.read(stockBackupCoordinatorProvider);
  return (input) async {
    await backup.createBackupInBacaps();
    await useCase(input);
  };
});

final createExpenseCategoryUseCaseProvider =
    Provider<CreateExpenseCategoryUseCase>((ref) {
  return CreateExpenseCategoryUseCase(ref.watch(stockRepositoryProvider));
});

final updateExpenseCategoryUseCaseProvider =
    Provider<UpdateExpenseCategoryUseCase>((ref) {
  return UpdateExpenseCategoryUseCase(ref.watch(stockRepositoryProvider));
});

final setExpenseCategoryActiveUseCaseProvider =
    Provider<SetExpenseCategoryActiveUseCase>((ref) {
  return SetExpenseCategoryActiveUseCase(ref.watch(stockRepositoryProvider));
});

final listExpenseCategoriesUseCaseProvider =
    Provider<ListExpenseCategoriesUseCase>((ref) {
  return ListExpenseCategoriesUseCase(ref.watch(stockRepositoryProvider));
});

final createExpenseUseCaseProvider = Provider<CreateExpenseUseCase>((ref) {
  return CreateExpenseUseCase(ref.watch(stockRepositoryProvider));
});

final updateExpenseUseCaseProvider = Provider<UpdateExpenseUseCase>((ref) {
  return UpdateExpenseUseCase(ref.watch(stockRepositoryProvider));
});

final logicalDeleteExpenseUseCaseProvider =
    Provider<LogicalDeleteExpenseUseCase>((ref) {
  return LogicalDeleteExpenseUseCase(ref.watch(stockRepositoryProvider));
});

final listExpensesUseCaseProvider = Provider<ListExpensesUseCase>((ref) {
  return ListExpensesUseCase(ref.watch(stockRepositoryProvider));
});

final getExpenseDetailUseCaseProvider =
    Provider<GetExpenseDetailUseCase>((ref) {
  return GetExpenseDetailUseCase(ref.watch(stockRepositoryProvider));
});

final getExpenseSummaryUseCaseProvider =
    Provider<GetExpenseSummaryUseCase>((ref) {
  return GetExpenseSummaryUseCase(ref.watch(stockRepositoryProvider));
});

final getDashboardSummaryUseCaseProvider =
    Provider<GetDashboardSummaryUseCase>((ref) {
  return GetDashboardSummaryUseCase(ref.watch(stockRepositoryProvider));
});
