import 'package:control_stok_celu/data/providers/app_providers.dart';
import 'package:control_stok_celu/domain/stock/stock_models.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DashboardPeriod _period = DashboardPeriod.thisMonth;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _generateReport() async {
    final reportText = await _buildReportText();
    if (!mounted) {
      return;
    }
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Reporte generado'),
          content: SingleChildScrollView(child: Text(reportText)),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  Future<String> _buildReportText() async {
    final periodLabel = switch (_period) {
      DashboardPeriod.today => 'Hoy',
      DashboardPeriod.last7Days => 'Últimos 7 días',
      DashboardPeriod.thisMonth => 'Este mes',
      DashboardPeriod.previousMonth => 'Mes anterior',
      DashboardPeriod.thisYear => 'Este año',
      DashboardPeriod.thisWeek => 'Esta semana',
      DashboardPeriod.custom => 'Personalizado',
    };

    switch (_tabController.index) {
      case 0:
        final snapshot = await ref.read(getDashboardSummaryUseCaseProvider)(
          DashboardQuery(period: _period),
        );
        return '''Reporte de ventas
Período: $periodLabel
Cantidad: ${snapshot.salesCount}
Facturación: ${_money(snapshot.revenueCents)}
IVA: ${_money(snapshot.taxCents)}
Costos: ${_money(snapshot.costCents)}
Ganancia: ${_money(snapshot.netProfitCents)}''';
      case 1:
        final expensePeriod = _period == DashboardPeriod.today
            ? ExpensePeriod.today
            : _period == DashboardPeriod.previousMonth
                ? ExpensePeriod.previousMonth
                : _period == DashboardPeriod.last7Days
                    ? ExpensePeriod.thisWeek
                    : ExpensePeriod.thisMonth;
        final snapshot = await ref.read(getExpenseSummaryUseCaseProvider)(
          ExpenseQuery(period: expensePeriod),
        );
        return '''Reporte de gastos
Período: $periodLabel
Cantidad: ${snapshot.count}
Total: ${_money(snapshot.totalAmountCents)}''';
      case 2:
        final snapshot = await ref.read(getInventorySummaryUseCaseProvider)(
          const InventoryQuery(),
        );
        return '''Reporte de inventario
Período: $periodLabel
Productos: ${snapshot.totalProducts}
Sin stock: ${snapshot.noStockCount}
Stock bajo: ${snapshot.lowStockCount}
Próximos a vencer: ${snapshot.nearExpiryCount}
Vencidos: ${snapshot.expiredCount}
Sobre stock: ${snapshot.overStockCount}''';
      default:
        return '''Reporte general
Período: $periodLabel
Se generó desde la vista activa del módulo.''';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reportes operativos'),
        actions: <Widget>[
          IconButton(
            tooltip: 'Generar reporte',
            onPressed: _generateReport,
            icon: const Icon(Icons.print_outlined),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const <Widget>[
            Tab(text: 'Ventas'),
            Tab(text: 'Gastos'),
            Tab(text: 'Inventario'),
            Tab(text: 'Lotes'),
            Tab(text: 'Movimientos'),
            Tab(text: 'Reservas'),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12),
            child: DropdownButtonFormField<DashboardPeriod>(
              initialValue: _period,
              decoration: const InputDecoration(labelText: 'Período'),
              items: const <DropdownMenuItem<DashboardPeriod>>[
                DropdownMenuItem(
                    value: DashboardPeriod.today, child: Text('Hoy')),
                DropdownMenuItem(
                    value: DashboardPeriod.last7Days,
                    child: Text('Últimos 7 días')),
                DropdownMenuItem(
                    value: DashboardPeriod.thisMonth, child: Text('Este mes')),
                DropdownMenuItem(
                    value: DashboardPeriod.previousMonth,
                    child: Text('Mes anterior')),
                DropdownMenuItem(
                    value: DashboardPeriod.thisYear, child: Text('Este año')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _period = value);
                }
              },
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                _SalesReport(period: _period),
                _ExpensesReport(period: _period),
                _InventoryReport(),
                _BatchesReport(),
                _MovementsReport(),
                _ReservationsReport(period: _period),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SalesReport extends ConsumerWidget {
  const _SalesReport({required this.period});

  final DashboardPeriod period;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<DashboardSummaryView>(
      future: ref.read(getDashboardSummaryUseCaseProvider)(
          DashboardQuery(period: period)),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final data = snapshot.data!;
        return ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            _row('Cantidad', '${data.salesCount}'),
            _row('Facturación', _money(data.revenueCents)),
            _row('IVA', _money(data.taxCents)),
            _row('Descuentos', _money(data.discountCents)),
            _row('Costos', _money(data.costCents)),
            _row('Ganancia', _money(data.netProfitCents)),
          ],
        );
      },
    );
  }
}

class _ExpensesReport extends ConsumerWidget {
  const _ExpensesReport({required this.period});

  final DashboardPeriod period;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensePeriod = period == DashboardPeriod.today
        ? ExpensePeriod.today
        : period == DashboardPeriod.previousMonth
            ? ExpensePeriod.previousMonth
            : period == DashboardPeriod.last7Days
                ? ExpensePeriod.thisWeek
                : ExpensePeriod.thisMonth;
    return FutureBuilder<ExpenseSummaryView>(
      future: ref.read(getExpenseSummaryUseCaseProvider)(
          ExpenseQuery(period: expensePeriod)),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final data = snapshot.data!;
        return ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            _row('Cantidad', '${data.count}'),
            _row('Total gastos', _money(data.totalAmountCents)),
          ],
        );
      },
    );
  }
}

class _InventoryReport extends ConsumerWidget {
  const _InventoryReport();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<InventorySummaryView>(
      future:
          ref.read(getInventorySummaryUseCaseProvider)(const InventoryQuery()),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final data = snapshot.data!;
        return ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            _row('Productos', '${data.totalProducts}'),
            _row('Sin stock', '${data.noStockCount}'),
            _row('Stock bajo', '${data.lowStockCount}'),
            _row('Próximos a vencer', '${data.nearExpiryCount}'),
            _row('Vencidos', '${data.expiredCount}'),
            _row('Sobre stock', '${data.overStockCount}'),
          ],
        );
      },
    );
  }
}

class _BatchesReport extends ConsumerWidget {
  const _BatchesReport();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.read(appDatabaseProvider);
    return FutureBuilder<List<QueryRow>>(
      future: db.customSelect(
        '''
        SELECT b.id, p.name AS product_name, s.name AS supplier_name,
               b.quantity_total, b.quantity_reserved, b.unit_cost_cents, b.received_at, b.expires_at
        FROM product_batches b
        JOIN products p ON p.id = b.product_id
        LEFT JOIN suppliers s ON s.id = b.supplier_id
        ORDER BY b.received_at DESC
        LIMIT 100
        ''',
      ).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final rows = snapshot.data!;
        if (rows.isEmpty) {
          return const Center(child: Text('No hay lotes.'));
        }
        return ListView.builder(
          itemCount: rows.length,
          itemBuilder: (context, index) {
            final row = rows[index];
            return ListTile(
              title: Text(row.read<String>('product_name')),
              subtitle: Text(
                  '${row.readNullable<String>('supplier_name') ?? 'Sin proveedor'} · ${row.read<int>('quantity_total')} uds'),
              trailing: Text(_money(row.read<int>('unit_cost_cents'))),
            );
          },
        );
      },
    );
  }
}

class _MovementsReport extends ConsumerWidget {
  const _MovementsReport();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.read(appDatabaseProvider);
    return FutureBuilder<List<QueryRow>>(
      future: db.customSelect(
        '''
        SELECT m.id, p.name AS product_name, m.movement_type, m.quantity, m.created_at, m.reference_id
        FROM stock_movements m
        JOIN products p ON p.id = m.product_id
        ORDER BY m.created_at DESC
        LIMIT 100
        ''',
      ).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final rows = snapshot.data!;
        if (rows.isEmpty) {
          return const Center(child: Text('No hay movimientos.'));
        }
        return ListView.builder(
          itemCount: rows.length,
          itemBuilder: (context, index) {
            final row = rows[index];
            return ListTile(
              title: Text(row.read<String>('product_name')),
              subtitle: Text(
                  '${row.read<String>('movement_type')} · ${row.read<int>('quantity')}'),
              trailing: Text(row.readNullable<String>('reference_id') ?? '-'),
            );
          },
        );
      },
    );
  }
}

class _ReservationsReport extends ConsumerWidget {
  const _ReservationsReport({required this.period});

  final DashboardPeriod period;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<List<ReservationListItem>>(
      future: ref.read(listReservationsUseCaseProvider)(
          ReservationQuery(period: period)),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final rows = snapshot.data!;
        if (rows.isEmpty) {
          return const Center(child: Text('No hay reservas.'));
        }
        return ListView.builder(
          itemCount: rows.length,
          itemBuilder: (context, index) {
            final row = rows[index];
            return ListTile(
              title: Text(row.customerName ?? 'Sin cliente'),
              subtitle: Text('${row.status} · ${row.unitsCount} unidades'),
              trailing: Text(_money(row.totalCents)),
            );
          },
        );
      },
    );
  }
}

Widget _row(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: <Widget>[
        Expanded(child: Text(label)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
      ],
    ),
  );
}

String _money(int cents) {
  final sign = cents < 0 ? '-' : '';
  final absolute = cents.abs();
  final major = absolute ~/ 100;
  final minor = (absolute % 100).toString().padLeft(2, '0');
  return '$sign\$$major.$minor';
}
