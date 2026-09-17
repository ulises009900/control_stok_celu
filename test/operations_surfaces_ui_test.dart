import 'package:control_stok_celu/data/db/app_database.dart';
import 'package:control_stok_celu/data/providers/app_providers.dart';
import 'package:control_stok_celu/data/sync/sync_providers.dart';
import 'package:control_stok_celu/features/customers/customer_detail_screen.dart';
import 'package:control_stok_celu/features/customers/customer_form_screen.dart';
import 'package:control_stok_celu/features/customers/customers_screen.dart';
import 'package:control_stok_celu/features/navigation/home_screen.dart';
import 'package:control_stok_celu/features/notes/notes_screen.dart';
import 'package:control_stok_celu/features/reports/reports_screen.dart';
import 'package:control_stok_celu/features/reservations/reservation_detail_screen.dart';
import 'package:control_stok_celu/features/reservations/reservation_form_screen.dart';
import 'package:control_stok_celu/features/reservations/reservations_screen.dart';
import 'package:control_stok_celu/features/sales/sale_detail_screen.dart';
import 'package:control_stok_celu/features/sales/sale_form_screen.dart';
import 'package:control_stok_celu/features/sales/sales_screen.dart';
import 'package:control_stok_celu/features/settings/settings_screen.dart';
import 'package:control_stok_celu/features/tasks/tasks_screen.dart';
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
      initialLocation: '/inicio',
      routes: <GoRoute>[
        GoRoute(
            path: '/inicio', builder: (context, state) => const HomeScreen()),
        GoRoute(
            path: '/sales', builder: (context, state) => const SalesScreen()),
        GoRoute(
            path: '/sales/new',
            builder: (context, state) => const SaleFormScreen(saleId: null)),
        GoRoute(
            path: '/sales/:id',
            builder: (context, state) =>
                SaleDetailScreen(saleId: state.pathParameters['id']!)),
        GoRoute(
            path: '/sales/:id/edit',
            builder: (context, state) =>
                SaleFormScreen(saleId: state.pathParameters['id']!)),
        GoRoute(
            path: '/reservations',
            builder: (context, state) => const ReservationsScreen()),
        GoRoute(
            path: '/reservations/new',
            builder: (context, state) =>
                const ReservationFormScreen(reservationId: null)),
        GoRoute(
            path: '/reservations/:id',
            builder: (context, state) => ReservationDetailScreen(
                reservationId: state.pathParameters['id']!)),
        GoRoute(
            path: '/reservations/:id/edit',
            builder: (context, state) => ReservationFormScreen(
                reservationId: state.pathParameters['id']!)),
        GoRoute(
            path: '/customers',
            builder: (context, state) => const CustomersScreen()),
        GoRoute(
            path: '/customers/new',
            builder: (context, state) =>
                const CustomerFormScreen(customerId: null)),
        GoRoute(
            path: '/customers/:id',
            builder: (context, state) =>
                CustomerDetailScreen(customerId: state.pathParameters['id']!)),
        GoRoute(
            path: '/customers/:id/edit',
            builder: (context, state) =>
                CustomerFormScreen(customerId: state.pathParameters['id']!)),
        GoRoute(
            path: '/notes', builder: (context, state) => const NotesScreen()),
        GoRoute(
            path: '/tasks', builder: (context, state) => const TasksScreen()),
        GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsScreen()),
        GoRoute(
            path: '/reports',
            builder: (context, state) => const ReportsScreen()),
      ],
    );
  }

  Future<void> pumpApp(WidgetTester tester, AppDatabase db) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          appDatabaseProvider.overrideWithValue(db),
          // Estas pruebas ejercitan pantallas/acciones de administrador
          // (edición de productos/clientes, reportes, etc.); simulamos ese
          // rol y evitamos tocar el almacenamiento seguro real.
          isAdminProvider.overrideWithValue(true),
        ],
        child: MaterialApp.router(routerConfig: buildRouter()),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('home screen opens real operational surfaces',
      (WidgetTester tester) async {
    final db = AppDatabase(executor: NativeDatabase.memory());
    await pumpApp(tester, db);

    expect(find.text('Inicio'), findsOneWidget);
    expect(find.text('Ventas'), findsWidgets);

    GoRouter.of(tester.element(find.byType(HomeScreen))).go('/sales');
    await tester.pumpAndSettle();
    expect(find.text('Nueva venta'), findsOneWidget);

    GoRouter.of(tester.element(find.byType(SalesScreen))).go('/inicio');
    await tester.pumpAndSettle();
    GoRouter.of(tester.element(find.byType(HomeScreen))).go('/reservations');
    await tester.pumpAndSettle();
    expect(find.text('Nueva reserva'), findsOneWidget);

    await db.close();
  });

  testWidgets('sale form shows highlighted total cost summary',
      (WidgetTester tester) async {
    final db = AppDatabase(executor: NativeDatabase.memory());
    await pumpApp(tester, db);

    GoRouter.of(tester.element(find.byType(HomeScreen))).go('/sales/new');
    await tester.pumpAndSettle();

    expect(find.text('Costo total'), findsOneWidget);

    await db.close();
  });

  testWidgets('notes, tasks, settings and reports render',
      (WidgetTester tester) async {
    final db = AppDatabase(executor: NativeDatabase.memory());
    await pumpApp(tester, db);

    GoRouter.of(tester.element(find.byType(HomeScreen))).go('/notes');
    await tester.pumpAndSettle();
    expect(find.text('Notas'), findsOneWidget);

    GoRouter.of(tester.element(find.byType(NotesScreen))).go('/tasks');
    await tester.pumpAndSettle();
    expect(find.text('Recordatorios'), findsOneWidget);
    expect(find.text('Checklist'), findsOneWidget);

    GoRouter.of(tester.element(find.byType(TasksScreen))).go('/settings');
    await tester.pumpAndSettle();
    expect(find.text('Configuración'), findsOneWidget);

    GoRouter.of(tester.element(find.byType(SettingsScreen))).go('/reports');
    await tester.pumpAndSettle();
    expect(find.text('Reportes operativos'), findsOneWidget);

    await db.close();
  });
}
