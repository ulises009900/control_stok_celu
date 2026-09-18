import 'package:control_stok_celu/data/sync/sync_providers.dart';
import 'package:control_stok_celu/data/sync/sync_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<SyncResult?>>(
      syncControllerProvider,
      (previous, next) {
        final result = next.valueOrNull;
        if (result != null && (result.pulled > 0 || result.pushed > 0)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Datos actualizados: ${result.pulled} recibidos, ${result.pushed} enviados.'),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
    );
    final isAdmin = ref.watch(isAdminProvider);
    final items = <_HomeItem>[
      const _HomeItem('Stock', '/stock', Icons.inventory_2_outlined),
      const _HomeItem('Ventas', '/sales', Icons.point_of_sale_outlined),
      const _HomeItem('Caja', '/caja', Icons.account_balance_wallet_outlined),
      const _HomeItem('Reservas', '/reservations', Icons.bookmark_outline),
      const _HomeItem('Productos', '/productos', Icons.shopping_bag_outlined),
      const _HomeItem(
          'Proveedores', '/proveedores', Icons.local_shipping_outlined),
      const _HomeItem('Clientes', '/customers', Icons.people_outline),
      if (isAdmin)
        const _HomeItem('Empleados', '/empleados', Icons.badge_outlined),
      const _HomeItem('Gastos', '/gastos', Icons.receipt_long_outlined),
      if (isAdmin)
        const _HomeItem(
            'Estadísticas', '/estadisticas', Icons.bar_chart_outlined),
      if (isAdmin)
        const _HomeItem('Reportes', '/reports', Icons.summarize_outlined),
      const _HomeItem('Notas', '/notes', Icons.note_outlined),
      const _HomeItem('Tareas', '/tasks', Icons.checklist_outlined),
      const _HomeItem('Configuración', '/settings', Icons.settings_outlined),
    ];

    return Scaffold(
      appBar: AppBar(
        leading: Navigator.canPop(context) ? const BackButton() : null,
        title: const Text('Inicio'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.15,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Card(
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => context.push(item.route),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(item.icon, size: 32),
                    const SizedBox(height: 12),
                    Text(
                      item.label,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _HomeItem {
  const _HomeItem(this.label, this.route, this.icon);

  final String label;
  final String route;
  final IconData icon;
}
