import 'package:control_stok_celu/data/db/app_database.dart';
import 'package:control_stok_celu/data/providers/app_providers.dart';
import 'package:control_stok_celu/data/repositories/drift_stock_repository.dart';
import 'package:control_stok_celu/domain/stock/stock_models.dart';
import 'package:control_stok_celu/features/suppliers/supplier_detail_screen.dart';
import 'package:control_stok_celu/features/suppliers/supplier_form_screen.dart';
import 'package:control_stok_celu/features/suppliers/suppliers_screen.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  GoRouter buildRouter() {
    return GoRouter(
      initialLocation: '/proveedores',
      routes: <GoRoute>[
        GoRoute(
          path: '/proveedores',
          builder: (context, state) => const SuppliersScreen(),
        ),
        GoRoute(
          path: '/proveedores/nuevo',
          builder: (context, state) =>
              const SupplierFormScreen(supplierId: null),
        ),
        GoRoute(
          path: '/proveedores/:id',
          builder: (context, state) =>
              SupplierDetailScreen(supplierId: state.pathParameters['id']!),
        ),
        GoRoute(
          path: '/proveedores/:id/editar',
          builder: (context, state) =>
              SupplierFormScreen(supplierId: state.pathParameters['id']!),
        ),
      ],
    );
  }

  Future<void> pumpSuppliersApp(
    WidgetTester tester,
    AppDatabase db,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[appDatabaseProvider.overrideWithValue(db)],
        child: MaterialApp.router(routerConfig: buildRouter()),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('open suppliers screen', (WidgetTester tester) async {
    final db = AppDatabase(executor: NativeDatabase.memory());
    await pumpSuppliersApp(tester, db);

    expect(find.text('Proveedores'), findsOneWidget);
    expect(find.text('Buscar proveedor'), findsOneWidget);

    await db.close();
  });

  testWidgets('suppliers search works with debounce',
      (WidgetTester tester) async {
    final db = AppDatabase(executor: NativeDatabase.memory());
    final repo = DriftStockRepository(db);
    await repo.createSupplier(
      const SupplierUpsertInput(
        id: 'sup-search',
        name: 'Proveedor Search',
      ),
    );

    await pumpSuppliersApp(tester, db);

    await tester.enterText(find.byType(TextField), 'search');
    await tester.pump(const Duration(milliseconds: 280));
    await tester.pumpAndSettle();

    expect(find.text('Proveedor Search'), findsOneWidget);

    await db.close();
  });

  testWidgets('create supplier from form', (WidgetTester tester) async {
    final db = AppDatabase(executor: NativeDatabase.memory());
    await pumpSuppliersApp(tester, db);

    await tester.tap(find.byTooltip('Nuevo proveedor'));
    await tester.pumpAndSettle();

    await tester.enterText(
        find.widgetWithText(TextFormField, 'Nombre *'), 'Proveedor Nuevo UI');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'CUIT'), '30-44444444-4');
    await tester.tap(find.widgetWithText(FilledButton, 'Guardar proveedor'));
    await tester.pumpAndSettle();

    expect(find.text('Proveedor Nuevo UI'), findsOneWidget);

    await db.close();
  });

  testWidgets('edit supplier from detail', (WidgetTester tester) async {
    final db = AppDatabase(executor: NativeDatabase.memory());
    final repo = DriftStockRepository(db);
    await repo.createSupplier(
      const SupplierUpsertInput(
        id: 'sup-edit-ui',
        name: 'Proveedor Editar',
      ),
    );

    await pumpSuppliersApp(tester, db);

    await tester.tap(find.text('Proveedor Editar'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Editar'));
    await tester.pumpAndSettle();

    await tester.enterText(
        find.widgetWithText(TextFormField, 'Nombre *'), 'Proveedor Editado UI');
    await tester.tap(find.widgetWithText(FilledButton, 'Guardar proveedor'));
    await tester.pumpAndSettle();

    expect(find.text('Proveedor Editado UI'), findsOneWidget);

    await db.close();
  });

  testWidgets('deactivate supplier with confirmation',
      (WidgetTester tester) async {
    final db = AppDatabase(executor: NativeDatabase.memory());
    final repo = DriftStockRepository(db);
    await repo.createSupplier(
      const SupplierUpsertInput(
        id: 'sup-deactivate-ui',
        name: 'Proveedor Desactivar',
      ),
    );

    await pumpSuppliersApp(tester, db);

    await tester.tap(find.byType(PopupMenuButton<String>).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Desactivar').last);
    await tester.pumpAndSettle();

    expect(find.text('¿Desactivar proveedor?'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Desactivar'));
    await tester.pumpAndSettle();

    final inactive =
        await repo.listSuppliers(includeInactive: true, search: 'desactivar');
    expect(inactive.isNotEmpty, isTrue);
    expect(inactive.first.isActive, isFalse);

    await db.close();
  });

  testWidgets('reactivate supplier from inactive list',
      (WidgetTester tester) async {
    final db = AppDatabase(executor: NativeDatabase.memory());
    final repo = DriftStockRepository(db);
    await repo.createSupplier(
      const SupplierUpsertInput(
        id: 'sup-reactivate-ui',
        name: 'Proveedor Reactivar',
        isActive: false,
      ),
    );

    await pumpSuppliersApp(tester, db);

    await tester.tap(find.text('Inactivos'));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(PopupMenuButton<String>).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Reactivar').last);
    await tester.pumpAndSettle();

    final active =
        await repo.listSuppliers(includeInactive: false, search: 'reactivar');
    expect(active.any((s) => s.id == 'sup-reactivate-ui'), isTrue);

    await db.close();
  });

  testWidgets('filter active and inactive suppliers',
      (WidgetTester tester) async {
    final db = AppDatabase(executor: NativeDatabase.memory());
    final repo = DriftStockRepository(db);

    await repo.createSupplier(
      const SupplierUpsertInput(
        id: 'sup-active-only',
        name: 'Proveedor Activo UI',
      ),
    );
    await repo.createSupplier(
      const SupplierUpsertInput(
        id: 'sup-inactive-only',
        name: 'Proveedor Inactivo UI',
        isActive: false,
      ),
    );

    await pumpSuppliersApp(tester, db);

    expect(find.text('Proveedor Activo UI'), findsOneWidget);
    expect(find.text('Proveedor Inactivo UI'), findsNothing);

    await tester.tap(find.text('Inactivos'));
    await tester.pumpAndSettle();

    expect(find.text('Proveedor Inactivo UI'), findsOneWidget);
    expect(find.text('Proveedor Activo UI'), findsNothing);

    await tester.tap(find.text('Todos'));
    await tester.pumpAndSettle();

    expect(find.text('Proveedor Inactivo UI'), findsOneWidget);
    expect(find.text('Proveedor Activo UI'), findsOneWidget);

    await db.close();
  });

  testWidgets('duplicate cuit shows inline validation',
      (WidgetTester tester) async {
    final db = AppDatabase(executor: NativeDatabase.memory());
    final repo = DriftStockRepository(db);

    await repo.createSupplier(
      const SupplierUpsertInput(
        id: 'sup-cuit-base',
        name: 'Proveedor Base CUIT',
        cuit: '30-55555555-5',
      ),
    );

    await pumpSuppliersApp(tester, db);

    await tester.tap(find.byTooltip('Nuevo proveedor'));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextFormField, 'Nombre *'),
        'Proveedor Duplicado CUIT');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'CUIT'), '30-55555555-5');
    await tester.tap(find.widgetWithText(FilledButton, 'Guardar proveedor'));
    await tester.pumpAndSettle();

    expect(find.text('Ya existe un proveedor con ese CUIT.'), findsOneWidget);

    await db.close();
  });

  testWidgets('suppliers no results state', (WidgetTester tester) async {
    final db = AppDatabase(executor: NativeDatabase.memory());
    final repo = DriftStockRepository(db);

    await repo.createSupplier(
      const SupplierUpsertInput(
        id: 'sup-no-results',
        name: 'Proveedor Visible',
      ),
    );

    await pumpSuppliersApp(tester, db);

    await tester.enterText(find.byType(TextField), 'no-coincide');
    await tester.pump(const Duration(milliseconds: 280));
    await tester.pumpAndSettle();

    expect(find.text('No encontramos proveedores con esa búsqueda.'),
        findsOneWidget);

    await db.close();
  });

  testWidgets('suppliers empty state', (WidgetTester tester) async {
    final db = AppDatabase(executor: NativeDatabase.memory());
    await pumpSuppliersApp(tester, db);

    expect(find.text('No hay proveedores para mostrar.'), findsOneWidget);

    await db.close();
  });
}
