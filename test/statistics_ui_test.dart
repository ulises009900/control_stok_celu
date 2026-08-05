import 'package:control_stok_celu/data/db/app_database.dart';
import 'package:control_stok_celu/data/providers/app_providers.dart';
import 'package:control_stok_celu/domain/stock/stock_models.dart';
import 'package:control_stok_celu/features/expenses/expenses_screen.dart';
import 'package:control_stok_celu/features/inventory/inventory_screen.dart';
import 'package:control_stok_celu/features/statistics/statistics_screen.dart';
import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  Future<void> seedDashboardUiData(AppDatabase db) async {
    final now = DateTime.now().toUtc();
    final todayStart = DateTime.utc(now.year, now.month, now.day);
    final monthStart = DateTime.utc(now.year, now.month, 1);

    await db.into(db.categories).insert(
          CategoriesCompanion.insert(
            id: 'cat-ui-1',
            name: 'Bebidas',
            isActive: const Value(true),
            createdAt: now,
            updatedAt: now,
          ),
        );
    await db.into(db.suppliers).insert(
          SuppliersCompanion.insert(
            id: 'sup-ui-1',
            name: 'Proveedor UI',
            isActive: const Value(true),
            createdAt: now,
            updatedAt: now,
          ),
        );
    await db.into(db.customers).insert(
          CustomersCompanion.insert(
            id: 'cus-ui-1',
            name: 'Cliente UI',
            isActive: const Value(true),
            createdAt: now,
            updatedAt: now,
          ),
        );
    await db.into(db.expenseCategories).insert(
          ExpenseCategoriesCompanion.insert(
            id: 'exp-cat-ui',
            name: 'Servicios',
            isActive: const Value(true),
          ),
        );
    await db.into(db.products).insert(
          ProductsCompanion.insert(
            id: 'prod-ui-1',
            internalCode: 'P-UI-1',
            name: 'Producto Dashboard',
            categoryId: const Value('cat-ui-1'),
            stockTotal: const Value(4),
            stockReserved: const Value(0),
            stockMin: const Value(6),
            costCents: const Value(1000),
            salePriceCents: const Value(2000),
            isActive: const Value(true),
            createdAt: now,
            updatedAt: now,
          ),
        );
    await db.into(db.products).insert(
          ProductsCompanion.insert(
            id: 'prod-ui-2',
            internalCode: 'P-UI-2',
            name: 'Producto Sin Stock',
            categoryId: const Value('cat-ui-1'),
            stockTotal: const Value(0),
            stockReserved: const Value(0),
            stockMin: const Value(1),
            costCents: const Value(1000),
            salePriceCents: const Value(3000),
            isActive: const Value(true),
            createdAt: now,
            updatedAt: now,
          ),
        );
    await db.into(db.productBatches).insert(
          ProductBatchesCompanion.insert(
            id: 'batch-ui-1',
            productId: 'prod-ui-1',
            supplierId: const Value('sup-ui-1'),
            receivedAt: monthStart,
            expiresAt: Value(todayStart.add(const Duration(days: 2))),
            quantityTotal: 4,
            quantityReserved: const Value(0),
            unitCostCents: 1000,
            createdAt: now,
            updatedAt: now,
          ),
        );
    await db.into(db.expenses).insert(
          ExpensesCompanion.insert(
            id: 'exp-ui-1',
            name: 'Internet',
            categoryId: const Value('exp-cat-ui'),
            amountCents: 2200,
            supplierId: const Value('sup-ui-1'),
            isActive: const Value(true),
            occurredAt: monthStart.add(const Duration(days: 1)),
            createdAt: now,
            updatedAt: Value(now),
          ),
        );
    await db.into(db.reservations).insert(
          ReservationsCompanion.insert(
            id: 'res-ui-1',
            customerId: const Value('cus-ui-1'),
            status: const Value('reserved'),
            createdAt: monthStart.add(const Duration(days: 1)),
            updatedAt: monthStart.add(const Duration(days: 1)),
          ),
        );
    await db.into(db.reservationItems).insert(
          ReservationItemsCompanion.insert(
            id: 'res-item-ui-1',
            reservationId: 'res-ui-1',
            productId: 'prod-ui-1',
            quantity: 1,
            unitPriceCents: const Value(2000),
            unitCostCents: const Value(1000),
            taxRateBps: const Value(2100),
            discountCents: const Value(0),
            lineTotalCents: const Value(2000),
          ),
        );
    await db.into(db.sales).insert(
          SalesCompanion.insert(
            id: 'sale-ui-1',
            customerId: const Value('cus-ui-1'),
            status: const Value('sold'),
            subtotalCents: const Value(2000),
            taxCents: const Value(420),
            discountCents: const Value(100),
            totalCents: const Value(2420),
            estimatedProfitCents: const Value(1000),
            createdAt: monthStart.add(const Duration(days: 1)),
            updatedAt: monthStart.add(const Duration(days: 1)),
            confirmedAt: Value(monthStart.add(const Duration(days: 1))),
          ),
        );
    await db.into(db.saleItems).insert(
          SaleItemsCompanion.insert(
            id: 'sale-item-ui-1',
            saleId: 'sale-ui-1',
            productId: 'prod-ui-1',
            quantity: 1,
            unitPriceCents: 2100,
            unitCostCents: 1000,
            taxRateBps: const Value(2100),
            discountCents: const Value(100),
            taxCents: const Value(420),
            lineTotalCents: 2000,
            lineProfitCents: const Value(1000),
          ),
        );
  }

  GoRouter buildRouter() {
    return GoRouter(
      initialLocation: '/estadisticas',
      routes: <GoRoute>[
        GoRoute(
          path: '/estadisticas',
          builder: (context, state) => const StatisticsScreen(),
        ),
        GoRoute(
          path: '/stock',
          builder: (context, state) => InventoryScreen(
            initialFilter: state.uri.queryParameters['filter'] == 'noStock'
                ? InventoryFilter.noStock
                : state.uri.queryParameters['filter'] == 'lowStock'
                    ? InventoryFilter.lowStock
                    : state.uri.queryParameters['filter'] == 'nearExpiry'
                        ? InventoryFilter.nearExpiry
                        : null,
          ),
        ),
        GoRoute(
          path: '/gastos',
          builder: (context, state) => const ExpensesScreen(),
        ),
        GoRoute(
          path: '/ventas',
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('Ventas')),
          ),
        ),
        GoRoute(
          path: '/reservas',
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('Reservas')),
          ),
        ),
        GoRoute(
          path: '/productos',
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('Productos')),
          ),
        ),
        GoRoute(
          path: '/productos/:id',
          builder: (context, state) => Scaffold(
            body: Center(child: Text('Producto ${state.pathParameters['id']}')),
          ),
        ),
        GoRoute(
          path: '/proveedores/:id',
          builder: (context, state) => Scaffold(
            body:
                Center(child: Text('Proveedor ${state.pathParameters['id']}')),
          ),
        ),
      ],
    );
  }

  Future<void> pumpDashboardApp(
    WidgetTester tester,
    AppDatabase db, {
    List<Override> extraOverrides = const <Override>[],
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          appDatabaseProvider.overrideWithValue(db),
          ...extraOverrides,
        ],
        child: MaterialApp.router(routerConfig: buildRouter()),
      ),
    );
  }

  testWidgets('opens dashboard and renders summary and charts',
      (WidgetTester tester) async {
    final db = AppDatabase(executor: NativeDatabase.memory());
    await seedDashboardUiData(db);

    await pumpDashboardApp(tester, db);
    await tester.pumpAndSettle();

    expect(find.text('Dashboard del negocio'), findsOneWidget);
    expect(find.text('Facturación'), findsWidgets);
    await tester.scrollUntilVisible(
      find.text('Ventas por período'),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Ventas por período'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Facturación por categoría'),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Facturación por categoría'), findsOneWidget);

    await db.close();
  });

  testWidgets('changes period from dashboard chips',
      (WidgetTester tester) async {
    final db = AppDatabase(executor: NativeDatabase.memory());
    await seedDashboardUiData(db);

    await pumpDashboardApp(tester, db);
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ChoiceChip, '7 días'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Período:'), findsOneWidget);
    expect(find.text('7 días'), findsOneWidget);

    await db.close();
  });

  testWidgets('shows empty-state content when there is no data',
      (WidgetTester tester) async {
    final db = AppDatabase(executor: NativeDatabase.memory());

    await pumpDashboardApp(tester, db);
    await tester.pumpAndSettle();

    expect(find.text('Dashboard del negocio'), findsOneWidget);
    expect(find.text('\$0.00'), findsWidgets);

    await db.close();
  });

  testWidgets('opens inventory and expenses from dashboard actions',
      (WidgetTester tester) async {
    final db = AppDatabase(executor: NativeDatabase.memory());
    await seedDashboardUiData(db);

    await pumpDashboardApp(tester, db);
    await tester.pumpAndSettle();

    final openExpenses = find.text('Abrir gastos');
    await tester.scrollUntilVisible(
      openExpenses,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(openExpenses);
    await tester.pumpAndSettle();
    expect(find.text('Gastos'), findsOneWidget);

    GoRouter.of(tester.element(find.byType(ExpensesScreen)))
        .go('/estadisticas');
    await tester.pumpAndSettle();

    final noStockAlert = find.textContaining('productos sin stock');
    await tester.scrollUntilVisible(
      noStockAlert,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(noStockAlert);
    await tester.pumpAndSettle();
    expect(find.text('Inventario'), findsOneWidget);
    expect(find.text('Producto Sin Stock'), findsOneWidget);

    await db.close();
  });

  testWidgets('refreshes after adding a new expense without restarting',
      (WidgetTester tester) async {
    final db = AppDatabase(executor: NativeDatabase.memory());
    await seedDashboardUiData(db);

    await pumpDashboardApp(tester, db);
    await tester.pumpAndSettle();

    expect(find.text('\$22.00'), findsOneWidget);

    await db.into(db.expenses).insert(
          ExpensesCompanion.insert(
            id: 'exp-ui-2',
            name: 'Electricidad',
            categoryId: const Value('exp-cat-ui'),
            amountCents: 1800,
            supplierId: const Value('sup-ui-1'),
            isActive: const Value(true),
            occurredAt: DateTime.now().toUtc(),
            createdAt: DateTime.now().toUtc(),
            updatedAt: Value(DateTime.now().toUtc()),
          ),
        );

    await tester.tap(find.byTooltip('Actualizar'));
    await tester.pumpAndSettle();

    expect(find.text('\$40.00'), findsOneWidget);

    await db.close();
  });

  testWidgets('renders correctly on a small screen without overflow',
      (WidgetTester tester) async {
    final db = AppDatabase(executor: NativeDatabase.memory());
    await seedDashboardUiData(db);

    await tester.binding.setSurfaceSize(const Size(320, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await pumpDashboardApp(tester, db);
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Dashboard del negocio'), findsOneWidget);

    await db.close();
  });
}
