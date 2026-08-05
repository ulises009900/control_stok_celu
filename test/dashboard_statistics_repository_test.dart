import 'dart:io';

import 'package:control_stok_celu/data/db/app_database.dart';
import 'package:control_stok_celu/data/repositories/drift_stock_repository.dart';
import 'package:control_stok_celu/domain/stock/stock_models.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  group('dashboard statistics repository', () {
    late AppDatabase database;
    late DriftStockRepository repository;

    setUp(() {
      database = AppDatabase(executor: NativeDatabase.memory());
      repository = DriftStockRepository(database);
    });

    tearDown(() async {
      await database.close();
    });

    Future<void> seedDashboardData(AppDatabase db) async {
      final now = DateTime.now().toUtc();
      final todayStart = DateTime.utc(now.year, now.month, now.day);
      final monthStart = DateTime.utc(now.year, now.month, 1);
      final previousMonthStart = now.month == 1
          ? DateTime.utc(now.year - 1, 12, 1)
          : DateTime.utc(now.year, now.month - 1, 1);
      final previousMonthSaleDate =
          previousMonthStart.add(const Duration(days: 3));
      final reservedCreatedAt = monthStart.add(const Duration(days: 1));
      final draftCreatedAt = monthStart.add(const Duration(days: 2));
      final cancelledAt = monthStart.add(const Duration(days: 2));
      final soldReservationConfirmedAt =
          monthStart.add(const Duration(days: 3));
      final saleOneAt = monthStart.add(const Duration(days: 1));
      final saleTwoAt = monthStart.add(const Duration(days: 2));

      await db.into(db.categories).insert(
            CategoriesCompanion.insert(
              id: 'cat-1',
              name: 'Bebidas',
              isActive: const Value(true),
              createdAt: now,
              updatedAt: now,
            ),
          );
      await db.into(db.categories).insert(
            CategoriesCompanion.insert(
              id: 'cat-2',
              name: 'Accesorios',
              isActive: const Value(true),
              createdAt: now,
              updatedAt: now,
            ),
          );

      await db.into(db.suppliers).insert(
            SuppliersCompanion.insert(
              id: 'sup-1',
              name: 'Proveedor Uno',
              isActive: const Value(true),
              createdAt: now,
              updatedAt: now,
            ),
          );
      await db.into(db.suppliers).insert(
            SuppliersCompanion.insert(
              id: 'sup-2',
              name: 'Proveedor Dos',
              isActive: const Value(true),
              createdAt: now,
              updatedAt: now,
            ),
          );

      await db.into(db.customers).insert(
            CustomersCompanion.insert(
              id: 'cus-1',
              name: 'Cliente Uno',
              isActive: const Value(true),
              createdAt: now,
              updatedAt: now,
            ),
          );
      await db.into(db.customers).insert(
            CustomersCompanion.insert(
              id: 'cus-2',
              name: 'Cliente Dos',
              isActive: const Value(true),
              createdAt: now,
              updatedAt: now,
            ),
          );

      await db.into(db.expenseCategories).insert(
            ExpenseCategoriesCompanion.insert(
              id: 'exp-cat-1',
              name: 'Servicios',
              isActive: const Value(true),
            ),
          );
      await db.into(db.expenseCategories).insert(
            ExpenseCategoriesCompanion.insert(
              id: 'exp-cat-2',
              name: 'Logística',
              isActive: const Value(true),
            ),
          );

      await db.into(db.products).insert(
            ProductsCompanion.insert(
              id: 'prod-1',
              internalCode: 'P001',
              name: 'Producto A',
              categoryId: const Value('cat-1'),
              stockTotal: const Value(10),
              stockReserved: const Value(2),
              stockMin: const Value(9),
              costCents: const Value(2500),
              salePriceCents: const Value(4500),
              isActive: const Value(true),
              createdAt: now,
              updatedAt: now,
            ),
          );
      await db.into(db.products).insert(
            ProductsCompanion.insert(
              id: 'prod-2',
              internalCode: 'P002',
              name: 'Producto B',
              categoryId: const Value('cat-1'),
              stockTotal: const Value(0),
              stockReserved: const Value(0),
              stockMin: const Value(2),
              costCents: const Value(3000),
              salePriceCents: const Value(6000),
              isActive: const Value(true),
              createdAt: now,
              updatedAt: now,
            ),
          );
      await db.into(db.products).insert(
            ProductsCompanion.insert(
              id: 'prod-3',
              internalCode: 'P003',
              name: 'Producto C',
              categoryId: const Value('cat-2'),
              stockTotal: const Value(5),
              stockReserved: const Value(0),
              stockMin: const Value(1),
              stockMax: const Value(4),
              costCents: const Value(1000),
              salePriceCents: const Value(2500),
              isActive: const Value(true),
              createdAt: now,
              updatedAt: now,
            ),
          );
      await db.into(db.products).insert(
            ProductsCompanion.insert(
              id: 'prod-4',
              internalCode: 'P004',
              name: 'Producto D',
              categoryId: const Value('cat-2'),
              stockTotal: const Value(2),
              stockReserved: const Value(1),
              stockMin: const Value(0),
              costCents: const Value(700),
              salePriceCents: const Value(1500),
              isActive: const Value(true),
              createdAt: now,
              updatedAt: now,
            ),
          );

      await db.into(db.productBatches).insert(
            ProductBatchesCompanion.insert(
              id: 'batch-1',
              productId: 'prod-1',
              supplierId: const Value('sup-1'),
              receivedAt: monthStart,
              expiresAt: Value(todayStart.add(const Duration(days: 5))),
              quantityTotal: 10,
              quantityReserved: const Value(2),
              unitCostCents: 2500,
              createdAt: now,
              updatedAt: now,
            ),
          );
      await db.into(db.productBatches).insert(
            ProductBatchesCompanion.insert(
              id: 'batch-3',
              productId: 'prod-3',
              supplierId: const Value('sup-2'),
              receivedAt: monthStart,
              expiresAt: Value(todayStart.subtract(const Duration(days: 1))),
              quantityTotal: 5,
              quantityReserved: const Value(0),
              unitCostCents: 1000,
              createdAt: now,
              updatedAt: now,
            ),
          );
      await db.into(db.productBatches).insert(
            ProductBatchesCompanion.insert(
              id: 'batch-4',
              productId: 'prod-4',
              supplierId: const Value('sup-1'),
              receivedAt: monthStart,
              expiresAt: Value(todayStart),
              quantityTotal: 2,
              quantityReserved: const Value(1),
              unitCostCents: 700,
              createdAt: now,
              updatedAt: now,
            ),
          );

      await db.into(db.reservations).insert(
            ReservationsCompanion.insert(
              id: 'res-1',
              customerId: const Value('cus-1'),
              status: const Value('reserved'),
              createdAt: reservedCreatedAt,
              updatedAt: reservedCreatedAt,
            ),
          );
      await db.into(db.reservationItems).insert(
            ReservationItemsCompanion.insert(
              id: 'res-item-1',
              reservationId: 'res-1',
              productId: 'prod-1',
              quantity: 2,
              unitPriceCents: const Value(4500),
              unitCostCents: const Value(2500),
              taxRateBps: const Value(2100),
              discountCents: const Value(0),
              lineTotalCents: const Value(9000),
            ),
          );

      await db.into(db.reservations).insert(
            ReservationsCompanion.insert(
              id: 'res-2',
              customerId: const Value('cus-2'),
              status: const Value('draft'),
              createdAt: draftCreatedAt,
              updatedAt: draftCreatedAt,
            ),
          );
      await db.into(db.reservationItems).insert(
            ReservationItemsCompanion.insert(
              id: 'res-item-2',
              reservationId: 'res-2',
              productId: 'prod-4',
              quantity: 1,
              unitPriceCents: const Value(1500),
              unitCostCents: const Value(700),
              taxRateBps: const Value(2100),
              discountCents: const Value(0),
              lineTotalCents: const Value(1500),
            ),
          );

      await db.into(db.reservations).insert(
            ReservationsCompanion.insert(
              id: 'res-3',
              customerId: const Value('cus-1'),
              status: const Value('cancelled'),
              createdAt: monthStart,
              updatedAt: cancelledAt,
              canceledAt: Value(cancelledAt),
            ),
          );

      await db.into(db.reservations).insert(
            ReservationsCompanion.insert(
              id: 'res-4',
              customerId: const Value('cus-1'),
              status: const Value('sold'),
              createdAt: monthStart,
              updatedAt: soldReservationConfirmedAt,
              confirmedAt: Value(soldReservationConfirmedAt),
            ),
          );

      await db.into(db.expenses).insert(
            ExpensesCompanion.insert(
              id: 'exp-1',
              name: 'Internet',
              categoryId: const Value('exp-cat-1'),
              amountCents: 3000,
              supplierId: const Value('sup-1'),
              isActive: const Value(true),
              occurredAt: saleOneAt,
              createdAt: saleOneAt,
              updatedAt: Value(saleOneAt),
            ),
          );
      await db.into(db.expenses).insert(
            ExpensesCompanion.insert(
              id: 'exp-2',
              name: 'Envíos',
              categoryId: const Value('exp-cat-2'),
              amountCents: 2000,
              supplierId: const Value('sup-1'),
              isActive: const Value(true),
              occurredAt: saleTwoAt,
              createdAt: saleTwoAt,
              updatedAt: Value(saleTwoAt),
            ),
          );

      await db.into(db.sales).insert(
            SalesCompanion.insert(
              id: 'sale-1',
              customerId: const Value('cus-1'),
              reservationId: const Value('res-4'),
              status: const Value('sold'),
              subtotalCents: const Value(7500),
              taxCents: const Value(1470),
              discountCents: const Value(500),
              totalCents: const Value(8970),
              estimatedProfitCents: const Value(2500),
              createdAt: saleOneAt,
              updatedAt: saleOneAt,
              confirmedAt: Value(saleOneAt),
            ),
          );
      await db.into(db.saleItems).insert(
            SaleItemsCompanion.insert(
              id: 'sale-item-1',
              saleId: 'sale-1',
              productId: 'prod-1',
              quantity: 2,
              unitPriceCents: 4000,
              unitCostCents: 2500,
              taxRateBps: const Value(2100),
              discountCents: const Value(500),
              taxCents: const Value(1470),
              lineTotalCents: 7500,
              lineProfitCents: const Value(2500),
            ),
          );

      await db.into(db.sales).insert(
            SalesCompanion.insert(
              id: 'sale-2',
              customerId: const Value('cus-1'),
              status: const Value('sold'),
              subtotalCents: const Value(6000),
              taxCents: const Value(1260),
              discountCents: const Value(0),
              totalCents: const Value(7260),
              estimatedProfitCents: const Value(3000),
              createdAt: saleTwoAt,
              updatedAt: saleTwoAt,
              confirmedAt: Value(saleTwoAt),
            ),
          );
      await db.into(db.saleItems).insert(
            SaleItemsCompanion.insert(
              id: 'sale-item-2',
              saleId: 'sale-2',
              productId: 'prod-2',
              quantity: 1,
              unitPriceCents: 6000,
              unitCostCents: 3000,
              taxRateBps: const Value(2100),
              discountCents: const Value(0),
              taxCents: const Value(1260),
              lineTotalCents: 6000,
              lineProfitCents: const Value(3000),
            ),
          );

      await db.into(db.sales).insert(
            SalesCompanion.insert(
              id: 'sale-old',
              customerId: const Value('cus-2'),
              status: const Value('sold'),
              subtotalCents: const Value(5000),
              taxCents: const Value(1050),
              discountCents: const Value(0),
              totalCents: const Value(6050),
              estimatedProfitCents: const Value(2000),
              createdAt: previousMonthSaleDate,
              updatedAt: previousMonthSaleDate,
              confirmedAt: Value(previousMonthSaleDate),
            ),
          );
      await db.into(db.saleItems).insert(
            SaleItemsCompanion.insert(
              id: 'sale-item-old',
              saleId: 'sale-old',
              productId: 'prod-3',
              quantity: 2,
              unitPriceCents: 2500,
              unitCostCents: 1500,
              taxRateBps: const Value(2100),
              discountCents: const Value(0),
              taxCents: const Value(1050),
              lineTotalCents: 5000,
              lineProfitCents: const Value(2000),
            ),
          );
    }

    test('computes real financial totals, rankings and margins', () async {
      await seedDashboardData(database);

      final summary = await repository.getDashboardSummary(
        const DashboardQuery(period: DashboardPeriod.thisMonth),
      );

      expect(summary.revenueCents, 16230);
      expect(summary.costCents, 8000);
      expect(summary.grossProfitCents, 5500);
      expect(summary.expensesCents, 5000);
      expect(summary.netProfitCents, 500);
      expect(summary.grossMarginBps, 3389);
      expect(summary.netMarginBps, 308);
      expect(summary.taxCents, 2730);
      expect(summary.discountCents, 500);
      expect(summary.salesCount, 2);
      expect(summary.averageTicketCents, 8115);
      expect(summary.unitsSold, 3);
      expect(summary.topProductsByUnits.first.productId, 'prod-1');
      expect(summary.topProductsByRevenue.first.productId, 'prod-1');
      expect(summary.topProductsByProfit.first.productId, 'prod-2');
      expect(summary.salesByCategory.first.label, 'Bebidas');
      expect(summary.expenseStats.byCategory.length, 2);
      expect(summary.expenseStats.bySupplier.first.label, 'Proveedor Uno');
      expect(summary.discounts.discountedOperationsCount, 1);
      expect(summary.discounts.totalDiscountCents, 500);
      expect(summary.discounts.averageDiscountCents, 500);
    });

    test('computes inventory, reservations, customers and suppliers stats',
        () async {
      await seedDashboardData(database);

      final summary = await repository.getDashboardSummary(
        const DashboardQuery(period: DashboardPeriod.thisMonth),
      );

      expect(summary.inventory.totalProducts, 4);
      expect(summary.inventory.noStockCount, 1);
      expect(summary.inventory.lowStockCount, 1);
      expect(summary.inventory.overStockCount, 1);
      expect(summary.inventory.nearExpiryCount, 1);
      expect(summary.inventory.dueTodayCount, 1);
      expect(summary.inventory.expiredCount, 1);
      expect(summary.inventory.reservedUnits, 3);
      expect(summary.inventory.inventoryValueCents, 25700);
      expect(summary.inventory.noMovementProductsCount, 2);
      expect(summary.inventory.noMovementValueCents, 5700);

      expect(summary.reservations.activeReservations, 1);
      expect(summary.reservations.pendingReservations, 1);
      expect(summary.reservations.cancelledInPeriod, 1);
      expect(summary.reservations.convertedToSaleCount, 1);
      expect(summary.reservations.reservedUnits, 2);
      expect(summary.reservations.reservedValueCents, 10890);

      expect(summary.customers.totalCustomers, 2);
      expect(summary.customers.customersWithPurchases, 1);
      expect(summary.customers.customersWithoutPurchases, 1);
      expect(summary.customers.topCustomers.first.customerId, 'cus-1');
      expect(summary.customers.topCustomers.first.revenueCents, 16230);

      expect(summary.suppliers.totalSuppliers, 2);
      expect(summary.suppliers.activeSuppliers, 2);
      expect(summary.suppliers.suppliersWithExpenses, 1);
      expect(summary.suppliers.receivedUnits, 17);
      expect(summary.suppliers.receivedCostCents, 31400);
      expect(summary.suppliers.topSuppliers.first.supplierId, 'sup-1');

      expect(summary.stagnantProducts.map((item) => item.productId),
          containsAll(<String>['prod-3', 'prod-4']));
      expect(summary.alerts.any((item) => item.key == 'low-stock'), isTrue);
      expect(summary.unavailableMetrics, isNotEmpty);
    });

    test('honors periods and avoids division by zero when there are no sales',
        () async {
      await seedDashboardData(database);
      final now = DateTime.now().toUtc();
      final futureFrom = DateTime.utc(now.year + 1, 1, 1);
      final futureTo = DateTime.utc(now.year + 1, 1, 31);

      final emptySummary = await repository.getDashboardSummary(
        DashboardQuery(
          period: DashboardPeriod.custom,
          from: futureFrom,
          to: futureTo,
        ),
      );

      expect(emptySummary.revenueCents, 0);
      expect(emptySummary.costCents, 0);
      expect(emptySummary.grossProfitCents, 0);
      expect(emptySummary.netProfitCents, 0);
      expect(emptySummary.salesCount, 0);
      expect(emptySummary.averageTicketCents, 0);
      expect(emptySummary.grossMarginBps, 0);
      expect(emptySummary.netMarginBps, 0);
      expect(emptySummary.sales.trend, isEmpty);
      expect(emptySummary.topProductsByUnits, isEmpty);

      final previousMonthSummary = await repository.getDashboardSummary(
        const DashboardQuery(period: DashboardPeriod.previousMonth),
      );
      expect(previousMonthSummary.salesCount, 1);
      expect(previousMonthSummary.revenueCents, 6050);
      expect(previousMonthSummary.costCents, 3000);
      expect(previousMonthSummary.grossProfitCents, 2000);
    });

    test('persists dashboard metrics after reopening sqlite file', () async {
      final file =
          File('${Directory.systemTemp.path}/dashboard_stats_persist.sqlite');
      if (file.existsSync()) {
        file.deleteSync();
      }

      var db = AppDatabase(executor: NativeDatabase(file));
      await seedDashboardData(db);
      await db.close();

      db = AppDatabase(executor: NativeDatabase(file));
      final reopenedRepository = DriftStockRepository(db);
      final summary = await reopenedRepository.getDashboardSummary(
        const DashboardQuery(period: DashboardPeriod.thisMonth),
      );

      expect(summary.revenueCents, 16230);
      expect(summary.expensesCents, 5000);
      expect(summary.inventory.totalProducts, 4);
      expect(summary.topProductsByRevenue.first.productId, 'prod-1');

      await db.close();
      if (file.existsSync()) {
        file.deleteSync();
      }
    });
  });
}
