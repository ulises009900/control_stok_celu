import 'package:control_stok_celu/data/db/app_database.dart';
import 'package:control_stok_celu/data/providers/app_providers.dart';
import 'package:control_stok_celu/data/repositories/drift_stock_repository.dart';
import 'package:control_stok_celu/domain/stock/stock_models.dart';
import 'package:control_stok_celu/features/inventory/inventory_providers.dart';
import 'package:control_stok_celu/features/inventory/inventory_screen.dart';
import 'package:control_stok_celu/features/products/product_detail_screen.dart';
import 'package:control_stok_celu/features/products/product_stock_movement_prep_screen.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  GoRouter buildRouter({String initialLocation = '/stock'}) {
    return GoRouter(
      initialLocation: initialLocation,
      routes: <GoRoute>[
        GoRoute(
          path: '/stock',
          builder: (context, state) => const InventoryScreen(),
        ),
        GoRoute(
          path: '/productos/:id',
          builder: (context, state) =>
              ProductDetailScreen(productId: state.pathParameters['id']!),
        ),
        GoRoute(
          path: '/productos/:id/movimiento',
          builder: (context, state) => ProductStockMovementPrepScreen(
            productId: state.pathParameters['id']!,
          ),
        ),
      ],
    );
  }

  Future<void> pumpInventoryApp(
    WidgetTester tester,
    AppDatabase db, {
    String initialLocation = '/stock',
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[appDatabaseProvider.overrideWithValue(db)],
        child: MaterialApp.router(
          routerConfig: buildRouter(initialLocation: initialLocation),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> seedInventoryData(DriftStockRepository repo) async {
    final now = DateTime.now().toUtc();
    final todayStart = DateTime.utc(now.year, now.month, now.day);

    await repo.createProductProfile(
      const ProductUpsertInput(
        id: 'ui-inv-a',
        name: 'Coca Cola 500',
        internalCode: 'COCA-500',
        stockMin: 5,
        stockMax: 12,
        barcode: '7791234567890',
      ),
    );
    await repo.receiveStock(
      ReceiveStockInput(
        batchId: 'ui-inv-a-b1',
        productId: 'ui-inv-a',
        quantity: 4,
        unitCostCents: 1000,
        receivedAt: now,
        expiresAt: todayStart.add(const Duration(days: 7)),
      ),
    );

    await repo.createProductProfile(
      const ProductUpsertInput(
        id: 'ui-inv-b',
        name: 'Coca Cola Zero',
        internalCode: 'COCA-ZERO',
        stockMin: 2,
      ),
    );
    await repo.receiveStock(
      ReceiveStockInput(
        batchId: 'ui-inv-b-b1',
        productId: 'ui-inv-b',
        quantity: 9,
        unitCostCents: 1000,
        receivedAt: now,
      ),
    );

    await repo.createProductProfile(
      const ProductUpsertInput(
        id: 'ui-inv-c',
        name: 'Agua Mineral',
        internalCode: 'AGUA-500',
      ),
    );

    await repo.createProductProfile(
      const ProductUpsertInput(
        id: 'ui-inv-d',
        name: 'Jugo Naranja',
        internalCode: 'JUGO-1L',
        stockMax: 3,
      ),
    );
    await repo.receiveStock(
      ReceiveStockInput(
        batchId: 'ui-inv-d-b1',
        productId: 'ui-inv-d',
        quantity: 6,
        unitCostCents: 1000,
        receivedAt: now,
      ),
    );
  }

  testWidgets('1. open inventory screen', (WidgetTester tester) async {
    final db = AppDatabase(executor: NativeDatabase.memory());

    await pumpInventoryApp(tester, db);

    expect(find.text('Inventario'), findsOneWidget);
    expect(find.text('Buscar producto'), findsOneWidget);

    await db.close();
  });

  testWidgets('2. show summary counters', (WidgetTester tester) async {
    final db = AppDatabase(executor: NativeDatabase.memory());
    final repo = DriftStockRepository(db);
    await seedInventoryData(repo);

    await pumpInventoryApp(tester, db);

    expect(find.text('Productos'), findsOneWidget);
    expect(find.text('Sin stock'), findsWidgets);
    expect(find.text('Stock bajo'), findsWidgets);
    expect(find.text('Sobre stock'), findsWidgets);

    await db.close();
  });

  testWidgets('3. show products list', (WidgetTester tester) async {
    final db = AppDatabase(executor: NativeDatabase.memory());
    final repo = DriftStockRepository(db);
    await seedInventoryData(repo);

    await pumpInventoryApp(tester, db);

    expect(find.text('Coca Cola 500'), findsOneWidget);
    expect(find.byType(ListTile), findsWidgets);

    await db.close();
  });

  testWidgets('4. search product', (WidgetTester tester) async {
    final db = AppDatabase(executor: NativeDatabase.memory());
    final repo = DriftStockRepository(db);
    await seedInventoryData(repo);

    await pumpInventoryApp(tester, db);

    await tester.enterText(find.byType(TextField).first, 'zero');
    await tester.pump(const Duration(milliseconds: 280));
    await tester.pumpAndSettle();

    expect(find.text('Coca Cola Zero'), findsOneWidget);
    expect(find.text('Coca Cola 500'), findsNothing);

    await db.close();
  });

  testWidgets('5. show no results state', (WidgetTester tester) async {
    final db = AppDatabase(executor: NativeDatabase.memory());
    final repo = DriftStockRepository(db);
    await seedInventoryData(repo);

    await pumpInventoryApp(tester, db);

    final context = tester.element(find.byType(InventoryScreen));
    await ProviderScope.containerOf(context)
        .read(inventoryStateProvider.notifier)
        .setFilter(InventoryFilter.expired);
    await tester.pumpAndSettle();

    expect(find.textContaining('No hay productos'), findsOneWidget);

    await db.close();
  });

  testWidgets('6. apply filter', (WidgetTester tester) async {
    final db = AppDatabase(executor: NativeDatabase.memory());
    final repo = DriftStockRepository(db);
    await seedInventoryData(repo);

    await pumpInventoryApp(tester, db);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Sin stock'));
    await tester.pumpAndSettle();

    expect(find.text('Agua Mineral'), findsOneWidget);
    expect(find.text('Coca Cola Zero'), findsNothing);

    await db.close();
  });

  testWidgets('7. combine search and filter', (WidgetTester tester) async {
    final db = AppDatabase(executor: NativeDatabase.memory());
    final repo = DriftStockRepository(db);
    await seedInventoryData(repo);

    await pumpInventoryApp(tester, db);

    await tester.enterText(find.byType(TextField).first, 'coca');
    await tester.pump(const Duration(milliseconds: 280));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ChoiceChip, 'Stock bajo'));
    await tester.pumpAndSettle();

    expect(find.text('Coca Cola 500'), findsOneWidget);
    expect(find.text('Coca Cola Zero'), findsNothing);

    await db.close();
  });

  testWidgets('8. sort inventory list', (WidgetTester tester) async {
    final db = AppDatabase(executor: NativeDatabase.memory());
    final repo = DriftStockRepository(db);
    await seedInventoryData(repo);

    await pumpInventoryApp(tester, db);

    await tester.tap(find.byIcon(Icons.arrow_upward_outlined));
    await tester.pumpAndSettle();

    expect(find.byType(ListTile), findsWidgets);

    await db.close();
  });

  testWidgets('9. open existing product detail from inventory',
      (WidgetTester tester) async {
    final db = AppDatabase(executor: NativeDatabase.memory());
    final repo = DriftStockRepository(db);
    await seedInventoryData(repo);

    await pumpInventoryApp(tester, db);

    await tester.tap(find.text('Coca Cola 500'));
    await tester.pumpAndSettle();

    expect(find.text('Detalle de producto'), findsOneWidget);

    await db.close();
  });

  testWidgets('10. show explicit stock state labels',
      (WidgetTester tester) async {
    final db = AppDatabase(executor: NativeDatabase.memory());
    final repo = DriftStockRepository(db);
    await seedInventoryData(repo);

    await pumpInventoryApp(tester, db);

    final context = tester.element(find.byType(InventoryScreen));
    await ProviderScope.containerOf(context)
        .read(inventoryStateProvider.notifier)
        .setFilter(InventoryFilter.overStock);
    await tester.pumpAndSettle();

    expect(find.textContaining('Stock: Sobre stock'), findsOneWidget);

    await db.close();
  });

  testWidgets(
      '11. register stock-in from movement screen and refresh inventory',
      (WidgetTester tester) async {
    final db = AppDatabase(executor: NativeDatabase.memory());
    final repo = DriftStockRepository(db);
    await seedInventoryData(repo);
    await repo.createSupplier(
      const SupplierUpsertInput(id: 'sup-ui-1', name: 'Proveedor UI 1'),
    );

    await pumpInventoryApp(tester, db);

    final context = tester.element(find.byType(InventoryScreen));
    GoRouter.of(context).push('/productos/ui-inv-a/movimiento');
    await tester.pumpAndSettle();

    expect(find.text('Movimiento de stock'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Cantidad *').first,
      '3',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Costo unitario (centavos) *'),
      '1300',
    );

    final confirmStockInButton =
        find.widgetWithText(FilledButton, 'Confirmar ingreso');
    await tester.ensureVisible(confirmStockInButton);
    await tester.pumpAndSettle();
    await tester.tap(confirmStockInButton);
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilledButton, 'Confirmar'));
    await tester.pumpAndSettle();

    final stock = await repo.getProductStock('ui-inv-a');
    expect(stock.stockTotal, 7);
    expect(stock.stockReserved, 0);

    await db.close();
  });

  testWidgets('12. adjustment requires reason', (WidgetTester tester) async {
    final db = AppDatabase(executor: NativeDatabase.memory());
    final repo = DriftStockRepository(db);
    await seedInventoryData(repo);

    await pumpInventoryApp(tester, db);

    final context = tester.element(find.byType(InventoryScreen));
    GoRouter.of(context).push('/productos/ui-inv-a/movimiento');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Ajuste'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Cantidad *').first,
      '2',
    );
    final confirmAdjustButton =
        find.widgetWithText(FilledButton, 'Confirmar ajuste');
    await tester.ensureVisible(confirmAdjustButton);
    await tester.pumpAndSettle();
    await tester.tap(confirmAdjustButton);
    await tester.pumpAndSettle();

    expect(find.text('El motivo del ajuste es obligatorio.'), findsOneWidget);

    await db.close();
  });

  testWidgets('13. register positive adjustment from movement screen',
      (WidgetTester tester) async {
    final db = AppDatabase(executor: NativeDatabase.memory());
    final repo = DriftStockRepository(db);
    await seedInventoryData(repo);

    await pumpInventoryApp(tester, db);

    final context = tester.element(find.byType(InventoryScreen));
    GoRouter.of(context).push('/productos/ui-inv-a/movimiento');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Ajuste'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Cantidad *').first,
      '2',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Motivo *'),
      'Conteo físico',
    );

    final confirmAdjustButton =
        find.widgetWithText(FilledButton, 'Confirmar ajuste');
    await tester.ensureVisible(confirmAdjustButton);
    await tester.pumpAndSettle();
    await tester.tap(confirmAdjustButton);
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilledButton, 'Confirmar'));
    await tester.pumpAndSettle();

    final stock = await repo.getProductStock('ui-inv-a');
    expect(stock.stockTotal, 6);
    expect(stock.stockReserved, 0);

    await db.close();
  });
}
