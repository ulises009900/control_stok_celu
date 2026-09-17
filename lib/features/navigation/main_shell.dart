import 'package:control_stok_celu/domain/stock/stock_models.dart';
import 'package:control_stok_celu/features/inventory/inventory_screen.dart';
import 'package:control_stok_celu/features/statistics/statistics_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainShell extends ConsumerWidget {
  const MainShell({
    required this.index,
    this.inventoryFilter,
    this.inventorySearch,
    super.key,
  });

  final int index;
  final InventoryFilter? inventoryFilter;
  final String? inventorySearch;

  static const _items = <_NavItem>[
    _NavItem('Inicio', '/inicio', Icons.home_outlined),
    _NavItem('Stock', '/stock', Icons.inventory_2_outlined),
    _NavItem('Ventas', '/sales', Icons.point_of_sale_outlined),
    _NavItem('Reservas', '/reservations', Icons.bookmark_outline),
    _NavItem('Productos', '/productos', Icons.shopping_bag_outlined),
    _NavItem('Gastos', '/gastos', Icons.receipt_long_outlined, adminOnly: true),
    _NavItem('Estadísticas', '/estadisticas', Icons.bar_chart_outlined,
        adminOnly: true),
    _NavItem('Notas', '/notas', Icons.note_outlined),
    _NavItem('Tareas', '/tareas', Icons.checklist_outlined),
    _NavItem('Config.', '/configuracion', Icons.settings_outlined),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _NavItem item = _items[index];
    return Scaffold(
      appBar: AppBar(
        leading: Navigator.canPop(context) ? const BackButton() : null,
        title: Text(item.label),
      ),
      body: index == 1
          ? InventoryScreen(
              initialFilter: inventoryFilter,
              initialSearch: inventorySearch,
            )
          : index == 6
              ? const StatisticsScreen()
              : _PlaceholderPage(title: item.label),
    );
  }
}

class _PlaceholderPage extends StatelessWidget {
  const _PlaceholderPage({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text(
              'Pantalla base de Fase 1. La lógica de negocio y persistencia se implementa por capas.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem(this.label, this.route, this.icon, {this.adminOnly = false});

  final String label;
  final String route;
  final IconData icon;
  final bool adminOnly;
}
