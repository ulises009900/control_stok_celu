import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const items = <_HomeItem>[
      _HomeItem('Stock', '/stock', Icons.inventory_2_outlined),
      _HomeItem('Ventas', '/sales', Icons.point_of_sale_outlined),
      _HomeItem('Reservas', '/reservations', Icons.bookmark_outline),
      _HomeItem('Productos', '/productos', Icons.shopping_bag_outlined),
      _HomeItem('Proveedores', '/proveedores', Icons.local_shipping_outlined),
      _HomeItem('Clientes', '/customers', Icons.people_outline),
      _HomeItem('Gastos', '/gastos', Icons.receipt_long_outlined),
      _HomeItem('Estadísticas', '/estadisticas', Icons.bar_chart_outlined),
      _HomeItem('Reportes', '/reports', Icons.summarize_outlined),
      _HomeItem('Notas', '/notes', Icons.note_outlined),
      _HomeItem('Tareas', '/tasks', Icons.checklist_outlined),
      _HomeItem('Configuración', '/settings', Icons.settings_outlined),
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
