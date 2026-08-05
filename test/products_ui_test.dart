import 'package:control_stok_celu/data/db/app_database.dart';
import 'package:control_stok_celu/data/providers/app_providers.dart';
import 'package:control_stok_celu/data/repositories/drift_stock_repository.dart';
import 'package:control_stok_celu/domain/stock/stock_models.dart';
import 'package:control_stok_celu/features/categories/categories_screen.dart';
import 'package:control_stok_celu/features/products/product_detail_screen.dart';
import 'package:control_stok_celu/features/products/product_form_screen.dart';
import 'package:control_stok_celu/features/products/product_stock_movement_prep_screen.dart';
import 'package:control_stok_celu/features/products/products_screen.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  testWidgets('products screen renders search and filters',
      (WidgetTester tester) async {
    final db = AppDatabase(executor: NativeDatabase.memory());
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[appDatabaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: ProductsScreen()),
      ),
    );

    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Productos'), findsWidgets);
    expect(find.byIcon(Icons.search), findsWidgets);
    expect(find.text('Filtros'), findsOneWidget);

    await db.close();
  });

  testWidgets('search product and show no-results state',
      (WidgetTester tester) async {
    final db = AppDatabase(executor: NativeDatabase.memory());
    final repo = DriftStockRepository(db);
    await repo.createProductProfile(
      const ProductUpsertInput(
        id: 'prd-search-1',
        name: 'Samsung A15',
        internalCode: 'SAM-A15',
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[appDatabaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: ProductsScreen()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'samsung');
    await tester.pump(const Duration(milliseconds: 350));
    await tester.pumpAndSettle();
    expect(find.text('Samsung A15'), findsOneWidget);

    await tester.enterText(
        find.byType(TextField).first, 'producto inexistente');
    await tester.pump(const Duration(milliseconds: 350));
    await tester.pumpAndSettle();
    expect(find.text('No encontramos productos con esa búsqueda.'),
        findsOneWidget);

    await db.close();
  });

  testWidgets('open product detail from products list',
      (WidgetTester tester) async {
    final db = AppDatabase(executor: NativeDatabase.memory());
    final repo = DriftStockRepository(db);
    await repo.createProductProfile(
      const ProductUpsertInput(
        id: 'prd-nav-1',
        name: 'Motorola G84',
        internalCode: 'MOTO-G84',
      ),
    );

    final router = GoRouter(
      initialLocation: '/productos',
      routes: <GoRoute>[
        GoRoute(
          path: '/productos',
          builder: (context, state) => const ProductsScreen(),
        ),
        GoRoute(
          path: '/productos/:id',
          builder: (context, state) =>
              ProductDetailScreen(productId: state.pathParameters['id']!),
        ),
        GoRoute(
          path: '/productos/:id/editar',
          builder: (context, state) =>
              ProductFormScreen(productId: state.pathParameters['id']!),
        ),
        GoRoute(
          path: '/productos/nuevo',
          builder: (context, state) => const ProductFormScreen(productId: null),
        ),
        GoRoute(
          path: '/productos/:id/movimiento',
          builder: (context, state) => ProductStockMovementPrepScreen(
            productId: state.pathParameters['id']!,
          ),
        ),
        GoRoute(
          path: '/categorias',
          builder: (context, state) => const CategoriesScreen(),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[appDatabaseProvider.overrideWithValue(db)],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Motorola G84'));
    await tester.pumpAndSettle();
    expect(find.text('Detalle de producto'), findsOneWidget);

    await db.close();
  });

  testWidgets('product form shows validation error for required name',
      (WidgetTester tester) async {
    final db = AppDatabase(executor: NativeDatabase.memory());
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[appDatabaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: ProductFormScreen(productId: null)),
      ),
    );

    await tester.pump(const Duration(milliseconds: 300));
    final saveButton = find.widgetWithText(FilledButton, 'Guardar producto');
    await tester.scrollUntilVisible(saveButton, 200,
        scrollable: find.byType(Scrollable).first);
    await tester.ensureVisible(saveButton);
    await tester.pumpAndSettle();
    expect(saveButton, findsOneWidget);
    await tester.tap(saveButton);
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(ProductFormScreen), findsOneWidget);
    expect(find.text('El nombre es obligatorio'), findsOneWidget);

    await db.close();
  });

  testWidgets('edit product and save modification',
      (WidgetTester tester) async {
    final db = AppDatabase(executor: NativeDatabase.memory());
    final repo = DriftStockRepository(db);
    await repo.createProductProfile(
      const ProductUpsertInput(
        id: 'prd-edit-1',
        name: 'Producto Original',
        internalCode: 'PRD-EDIT-1',
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[appDatabaseProvider.overrideWithValue(db)],
        child:
            const MaterialApp(home: ProductFormScreen(productId: 'prd-edit-1')),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
        find.widgetWithText(TextFormField, 'Nombre *'), 'Producto Editado');
    final saveButton = find.widgetWithText(FilledButton, 'Guardar producto');
    await tester.scrollUntilVisible(saveButton, 200,
        scrollable: find.byType(Scrollable).first);
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    final edited = await repo.listProducts(
      const ProductQuery(
          search: 'producto editado', status: ProductStatusFilter.all),
    );
    expect(edited.any((p) => p.id == 'prd-edit-1'), isTrue);

    await db.close();
  });

  testWidgets('deactivate and reactivate from product detail',
      (WidgetTester tester) async {
    final db = AppDatabase(executor: NativeDatabase.memory());
    final repo = DriftStockRepository(db);
    await repo.createProductProfile(
      const ProductUpsertInput(
        id: 'prd-active-1',
        name: 'Producto Activacion',
        internalCode: 'PRD-ACT-1',
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[appDatabaseProvider.overrideWithValue(db)],
        child: const MaterialApp(
            home: ProductDetailScreen(productId: 'prd-active-1')),
      ),
    );
    await tester.pumpAndSettle();

    final deactivateButton = find.text('Desactivar producto');
    await tester.scrollUntilVisible(deactivateButton, 220,
        scrollable: find.byType(Scrollable).first);
    await tester.tap(deactivateButton);
    await tester.pumpAndSettle();
    var inactive = await repo.listProducts(
      const ProductQuery(status: ProductStatusFilter.inactive),
    );
    expect(inactive.any((p) => p.id == 'prd-active-1'), isTrue);

    final reactivateButton = find.text('Reactivar producto');
    await tester.scrollUntilVisible(reactivateButton, 220,
        scrollable: find.byType(Scrollable).first);
    await tester.tap(reactivateButton);
    await tester.pumpAndSettle();
    final active = await repo.listProducts(
      const ProductQuery(status: ProductStatusFilter.active),
    );
    expect(active.any((p) => p.id == 'prd-active-1'), isTrue);

    await db.close();
  });

  testWidgets('inline error for duplicate internal code',
      (WidgetTester tester) async {
    final db = AppDatabase(executor: NativeDatabase.memory());
    final repo = DriftStockRepository(db);
    await repo.createProductProfile(
      const ProductUpsertInput(
        id: 'prd-dup-code-base',
        name: 'Producto Base',
        internalCode: 'COD-DUP',
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[appDatabaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: ProductFormScreen(productId: null)),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
        find.widgetWithText(TextFormField, 'Nombre *'), 'Nuevo Producto');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Código interno *'), 'COD-DUP');
    final saveButton = find.widgetWithText(FilledButton, 'Guardar producto');
    await tester.scrollUntilVisible(saveButton, 200,
        scrollable: find.byType(Scrollable).first);
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    expect(find.text('Este código ya está utilizado.'), findsOneWidget);

    await db.close();
  });

  testWidgets('inline error for duplicate barcode',
      (WidgetTester tester) async {
    final db = AppDatabase(executor: NativeDatabase.memory());
    final repo = DriftStockRepository(db);
    await repo.createProductProfile(
      const ProductUpsertInput(
        id: 'prd-dup-bar-base',
        name: 'Producto Base B',
        internalCode: 'COD-BAR-1',
        barcode: '7790001112223',
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[appDatabaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: ProductFormScreen(productId: null)),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
        find.widgetWithText(TextFormField, 'Nombre *'), 'Nuevo Producto B');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Código interno *'), 'COD-BAR-2');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Código de barras'),
        '7790001112223');
    final saveButton = find.widgetWithText(FilledButton, 'Guardar producto');
    await tester.scrollUntilVisible(saveButton, 200,
        scrollable: find.byType(Scrollable).first);
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    expect(
        find.text('Este código de barras ya está utilizado.'), findsOneWidget);

    await db.close();
  });

  testWidgets('categories screen renders list and search input',
      (WidgetTester tester) async {
    final db = AppDatabase(executor: NativeDatabase.memory());
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[appDatabaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: CategoriesScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Categorías'), findsOneWidget);
    expect(find.text('Buscar categoría'), findsOneWidget);
    expect(find.text('No hay categorías para mostrar.'), findsOneWidget);

    await db.close();
  });

  testWidgets('products search button focuses the search field',
      (WidgetTester tester) async {
    final db = AppDatabase(executor: NativeDatabase.memory());
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[appDatabaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: ProductsScreen()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Buscar'));
    await tester.pump();

    final focused = FocusManager.instance.primaryFocus;
    expect(focused != null, isTrue);
    expect(focused!.hasPrimaryFocus, isTrue);

    await db.close();
  });

  testWidgets('categories search supports clearing text',
      (WidgetTester tester) async {
    final db = AppDatabase(executor: NativeDatabase.memory());
    final repo = DriftStockRepository(db);
    await repo.createCategory(
      const CategoryUpsertInput(id: 'cat-ui-base', name: 'Bebidas'),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[appDatabaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: CategoriesScreen()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'bebi');
    await tester.pump();

    expect(find.byIcon(Icons.close), findsOneWidget);
    await tester.tap(find.byIcon(Icons.close));
    await tester.pump();

    final searchField = tester.widget<TextField>(find.byType(TextField).first);
    expect(searchField.controller!.text, isEmpty);

    await db.close();
  });

  testWidgets('search, create, edit and deactivate category',
      (WidgetTester tester) async {
    final db = AppDatabase(executor: NativeDatabase.memory());
    final repo = DriftStockRepository(db);
    await repo.createCategory(
      const CategoryUpsertInput(id: 'cat-ui-base', name: 'Bebidas'),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[appDatabaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: CategoriesScreen()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'bebi');
    await tester.pump(const Duration(milliseconds: 350));
    await tester.pumpAndSettle();
    expect(find.text('Bebidas'), findsOneWidget);

    await tester.tap(find.byTooltip('Agregar categoría'));
    await tester.pumpAndSettle();
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Nombre *').last, 'Accesorios');
    await tester.tap(find.widgetWithText(FilledButton, 'Guardar').last);
    await tester.pumpAndSettle();

    final created = await repo.listCategories(search: 'accesorios');
    expect(created.any((c) => c.name == 'Accesorios'), isTrue);

    await tester.tap(find.byType(PopupMenuButton<String>).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Editar').last);
    await tester.pumpAndSettle();
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Nombre *').last, 'Bebidas Premium');
    await tester.tap(find.widgetWithText(FilledButton, 'Guardar').last);
    await tester.pumpAndSettle();

    final edited = await repo.listCategories(search: 'premium');
    expect(edited.any((c) => c.name == 'Bebidas Premium'), isTrue);

    await tester.tap(find.byType(PopupMenuButton<String>).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Desactivar').last);
    await tester.pumpAndSettle();

    final inactive = await repo.listCategories(search: 'premium');
    expect(inactive.isNotEmpty, isTrue);
    expect(inactive.first.isActive, isFalse);

    await db.close();
  });
}
