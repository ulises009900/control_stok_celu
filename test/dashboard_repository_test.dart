import 'package:control_stok_celu/data/db/app_database.dart';
import 'package:control_stok_celu/data/repositories/drift_stock_repository.dart';
import 'package:control_stok_celu/domain/stock/stock_models.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  group('dashboard summaries', () {
    late AppDatabase database;
    late DriftStockRepository repository;

    setUp(() {
      database = AppDatabase(executor: NativeDatabase.memory());
      repository = DriftStockRepository(database);
    });

    tearDown(() async {
      await database.close();
    });

    test('builds real dashboard metrics from sales, expenses and stock',
        () async {
      final now = DateTime.utc(2026, 8, 15);

      await database.into(database.expenseCategories).insert(
            ExpenseCategoriesCompanion.insert(
              id: 'exp-cat-1',
              name: 'Servicios',
              isActive: const Value(true),
            ),
          );

      await database.into(database.products).insert(
            ProductsCompanion.insert(
              id: 'prod-1',
              internalCode: 'P001',
              name: 'Producto A',
              stockTotal: const Value(10),
              stockReserved: const Value(1),
              stockMin: const Value(3),
              costCents: const Value(5000),
              salePriceCents: const Value(10000),
              isActive: const Value(true),
              createdAt: now,
              updatedAt: now,
            ),
          );

      await database.into(database.products).insert(
            ProductsCompanion.insert(
              id: 'prod-2',
              internalCode: 'P002',
              name: 'Producto B',
              stockTotal: const Value(2),
              stockReserved: const Value(0),
              stockMin: const Value(5),
              costCents: const Value(4000),
              salePriceCents: const Value(8000),
              isActive: const Value(true),
              createdAt: now,
              updatedAt: now,
            ),
          );

      await database.into(database.customers).insert(
            CustomersCompanion.insert(
              id: 'cus-1',
              name: 'Cliente Uno',
              isActive: const Value(true),
              createdAt: now,
              updatedAt: now,
            ),
          );

      await database.into(database.suppliers).insert(
            SuppliersCompanion.insert(
              id: 'sup-1',
              name: 'Proveedor Uno',
              isActive: const Value(true),
              createdAt: now,
              updatedAt: now,
            ),
          );

      await database.into(database.reservations).insert(
            ReservationsCompanion.insert(
              id: 'res-1',
              customerId: const Value('cus-1'),
              status: const Value('reserved'),
              createdAt: now,
              updatedAt: now,
            ),
          );

      await database.into(database.expenses).insert(
            ExpensesCompanion.insert(
              id: 'exp-1',
              name: 'Internet',
              categoryId: const Value('exp-cat-1'),
              amountCents: 25000,
              isActive: const Value(true),
              occurredAt: now,
              createdAt: now,
              updatedAt: Value(now),
            ),
          );

      await database.into(database.sales).insert(
            SalesCompanion.insert(
              id: 'sale-1',
              customerId: const Value('cus-1'),
              status: const Value('sold'),
              subtotalCents: const Value(20000),
              taxCents: const Value(2000),
              discountCents: const Value(0),
              totalCents: const Value(22000),
              estimatedProfitCents: const Value(12000),
              createdAt: now,
              updatedAt: now,
              confirmedAt: Value(now),
            ),
          );

      await database.into(database.saleItems).insert(
            SaleItemsCompanion.insert(
              id: 'item-1',
              saleId: 'sale-1',
              productId: 'prod-1',
              quantity: 1,
              unitPriceCents: 12000,
              unitCostCents: 9000,
              discountCents: const Value(0),
              taxCents: const Value(0),
              lineTotalCents: 12000,
              lineProfitCents: const Value(3000),
            ),
          );

      await database.into(database.sales).insert(
            SalesCompanion.insert(
              id: 'sale-2',
              customerId: const Value('cus-1'),
              status: const Value('sold'),
              subtotalCents: const Value(10000),
              taxCents: const Value(1000),
              discountCents: const Value(0),
              totalCents: const Value(11000),
              estimatedProfitCents: const Value(2000),
              createdAt: now,
              updatedAt: now,
              confirmedAt: Value(now),
            ),
          );

      await database.into(database.saleItems).insert(
            SaleItemsCompanion.insert(
              id: 'item-2',
              saleId: 'sale-2',
              productId: 'prod-2',
              quantity: 1,
              unitPriceCents: 8000,
              unitCostCents: 6000,
              discountCents: const Value(0),
              taxCents: const Value(0),
              lineTotalCents: 8000,
              lineProfitCents: const Value(2000),
            ),
          );

      final summary = await repository.getDashboardSummary(
        const DashboardQuery(period: DashboardPeriod.thisMonth),
      );

      expect(summary.revenueCents, 33000);
      expect(summary.grossProfitCents, 5000);
      expect(summary.expensesCents, 25000);
      expect(summary.netProfitCents, -20000);
      expect(summary.salesCount, 2);
      expect(summary.averageTicketCents, 16500);
      expect(summary.activeProductsCount, 2);
      expect(summary.lowStockCount, 1);
      expect(summary.reservationsCount, 1);
      expect(summary.customersCount, 1);
      expect(summary.suppliersCount, 1);
      expect(summary.topProducts.first.label, 'Producto A');
      expect(summary.topExpenses.first.label, 'Servicios');
    });
  });
}
