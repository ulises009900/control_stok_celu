import 'package:control_stok_celu/features/navigation/main_shell.dart';
import 'package:control_stok_celu/features/categories/categories_screen.dart';
import 'package:control_stok_celu/features/customers/customer_detail_screen.dart';
import 'package:control_stok_celu/features/customers/customer_form_screen.dart';
import 'package:control_stok_celu/features/customers/customers_screen.dart';
import 'package:control_stok_celu/features/expenses/expense_category_screen.dart';
import 'package:control_stok_celu/features/expenses/expenses_screen.dart';
import 'package:control_stok_celu/features/navigation/home_screen.dart';
import 'package:control_stok_celu/features/notes/notes_screen.dart';
import 'package:control_stok_celu/features/products/product_detail_screen.dart';
import 'package:control_stok_celu/features/products/product_form_screen.dart';
import 'package:control_stok_celu/features/products/product_stock_movement_prep_screen.dart';
import 'package:control_stok_celu/features/products/products_screen.dart';
import 'package:control_stok_celu/features/reports/reports_screen.dart';
import 'package:control_stok_celu/features/reservations/reservation_detail_screen.dart';
import 'package:control_stok_celu/features/reservations/reservation_form_screen.dart';
import 'package:control_stok_celu/features/reservations/reservations_screen.dart';
import 'package:control_stok_celu/features/sales/sale_detail_screen.dart';
import 'package:control_stok_celu/features/sales/sale_form_screen.dart';
import 'package:control_stok_celu/features/sales/sales_screen.dart';
import 'package:control_stok_celu/features/settings/settings_screen.dart';
import 'package:control_stok_celu/features/suppliers/supplier_detail_screen.dart';
import 'package:control_stok_celu/features/suppliers/supplier_form_screen.dart';
import 'package:control_stok_celu/features/suppliers/suppliers_screen.dart';
import 'package:control_stok_celu/features/tasks/tasks_screen.dart';
import 'package:control_stok_celu/domain/stock/stock_models.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/inicio',
  routes: <GoRoute>[
    GoRoute(path: '/inicio', builder: (context, state) => const HomeScreen()),
    GoRoute(
        path: '/stock',
        builder: (context, state) => MainShell(
              index: 1,
              inventoryFilter: _inventoryFilterFromQuery(
                state.uri.queryParameters['filter'],
              ),
              inventorySearch: state.uri.queryParameters['search'],
            )),
    GoRoute(path: '/ventas', redirect: (context, state) => '/sales'),
    GoRoute(path: '/reservas', redirect: (context, state) => '/reservations'),
    GoRoute(path: '/sales', builder: (context, state) => const SalesScreen()),
    GoRoute(
      path: '/sales/new',
      builder: (context, state) => const SaleFormScreen(saleId: null),
    ),
    GoRoute(
      path: '/sales/:id',
      builder: (context, state) =>
          SaleDetailScreen(saleId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/sales/:id/edit',
      builder: (context, state) =>
          SaleFormScreen(saleId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/reservations',
      builder: (context, state) => const ReservationsScreen(),
    ),
    GoRoute(
      path: '/reservations/new',
      builder: (context, state) =>
          const ReservationFormScreen(reservationId: null),
    ),
    GoRoute(
      path: '/reservations/:id',
      builder: (context, state) =>
          ReservationDetailScreen(reservationId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/reservations/:id/edit',
      builder: (context, state) =>
          ReservationFormScreen(reservationId: state.pathParameters['id']!),
    ),
    GoRoute(
        path: '/productos',
        builder: (context, state) => const ProductsScreen()),
    GoRoute(
      path: '/productos/nuevo',
      builder: (context, state) => const ProductFormScreen(productId: null),
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
      path: '/productos/:id/movimiento',
      builder: (context, state) => ProductStockMovementPrepScreen(
          productId: state.pathParameters['id']!),
    ),
    GoRoute(
        path: '/categorias',
        builder: (context, state) => const CategoriesScreen()),
    GoRoute(
        path: '/customers',
        builder: (context, state) => const CustomersScreen()),
    GoRoute(
      path: '/customers/new',
      builder: (context, state) => const CustomerFormScreen(customerId: null),
    ),
    GoRoute(
      path: '/customers/:id',
      builder: (context, state) =>
          CustomerDetailScreen(customerId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/customers/:id/edit',
      builder: (context, state) =>
          CustomerFormScreen(customerId: state.pathParameters['id']!),
    ),
    GoRoute(
        path: '/proveedores',
        builder: (context, state) => const SuppliersScreen()),
    GoRoute(
      path: '/proveedores/nuevo',
      builder: (context, state) => const SupplierFormScreen(supplierId: null),
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
    GoRoute(
        path: '/gastos',
        builder: (context, state) => ExpensesScreen(
              initialPeriod: _expensePeriodFromQuery(
                state.uri.queryParameters['period'],
              ),
            )),
    GoRoute(
        path: '/gastos/categorias',
        builder: (context, state) => const ExpenseCategoryScreen()),
    GoRoute(
        path: '/estadisticas',
        builder: (context, state) => const MainShell(index: 6)),
    GoRoute(path: '/notas', redirect: (context, state) => '/notes'),
    GoRoute(path: '/tareas', redirect: (context, state) => '/tasks'),
    GoRoute(path: '/configuracion', redirect: (context, state) => '/settings'),
    GoRoute(path: '/notes', builder: (context, state) => const NotesScreen()),
    GoRoute(path: '/tasks', builder: (context, state) => const TasksScreen()),
    GoRoute(
        path: '/settings', builder: (context, state) => const SettingsScreen()),
    GoRoute(
        path: '/reports', builder: (context, state) => const ReportsScreen()),
  ],
);

InventoryFilter? _inventoryFilterFromQuery(String? value) {
  switch (value) {
    case 'noStock':
      return InventoryFilter.noStock;
    case 'lowStock':
      return InventoryFilter.lowStock;
    case 'normal':
      return InventoryFilter.normal;
    case 'overStock':
      return InventoryFilter.overStock;
    case 'nearExpiry':
      return InventoryFilter.nearExpiry;
    case 'expired':
      return InventoryFilter.expired;
    default:
      return null;
  }
}

ExpensePeriod _expensePeriodFromQuery(String? value) {
  switch (value) {
    case 'today':
      return ExpensePeriod.today;
    case 'thisWeek':
      return ExpensePeriod.thisWeek;
    case 'previousMonth':
      return ExpensePeriod.previousMonth;
    case 'custom':
      return ExpensePeriod.custom;
    case 'thisMonth':
    default:
      return ExpensePeriod.thisMonth;
  }
}
