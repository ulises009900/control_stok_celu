import 'package:control_stok_celu/domain/stock/stock_models.dart';
import 'package:control_stok_celu/features/statistics/dashboard_providers.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class StatisticsScreen extends ConsumerStatefulWidget {
  const StatisticsScreen({super.key});

  @override
  ConsumerState<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends ConsumerState<StatisticsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(dashboardStateProvider.notifier).load();
    });
  }

  Future<void> _pickCustomRange() async {
    final state = ref.read(dashboardStateProvider);
    final now = DateTime.now();
    final initialFrom = state.query.from ?? DateTime(now.year, now.month, 1);
    final from = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(now.year + 1, 12, 31),
      initialDate: initialFrom,
    );
    if (from == null || !mounted) {
      return;
    }

    final initialTo = state.query.to ?? now;
    final to = await showDatePicker(
      context: context,
      firstDate: from,
      lastDate: DateTime(now.year + 1, 12, 31),
      initialDate: initialTo.isBefore(from) ? from : initialTo,
    );
    if (to == null || !mounted) {
      return;
    }

    await ref.read(dashboardStateProvider.notifier).setCustomRange(
          from: DateTime.utc(from.year, from.month, from.day),
          to: DateTime.utc(to.year, to.month, to.day),
        );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dashboardStateProvider);
    final summary = state.summary;

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => ref.read(dashboardStateProvider.notifier).load(),
          child: state.isLoading && summary == null
              ? const Center(child: CircularProgressIndicator())
              : state.errorMessage != null && summary == null
                  ? ListView(
                      padding: const EdgeInsets.all(24),
                      children: <Widget>[
                        const SizedBox(height: 120),
                        Text(
                          state.errorMessage!,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        FilledButton(
                          onPressed: () {
                            ref.read(dashboardStateProvider.notifier).load();
                          },
                          child: const Text('Reintentar'),
                        ),
                      ],
                    )
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                      children: <Widget>[
                        _HeaderSection(
                          state: state,
                          onRefresh: () {
                            ref.read(dashboardStateProvider.notifier).load();
                          },
                          onCustomRange: _pickCustomRange,
                        ),
                        if (summary != null) ...<Widget>[
                          const SizedBox(height: 16),
                          _SummaryGrid(
                            summary: summary,
                            expensePeriodQuery: _dashboardToExpensePeriodQuery(
                              state.query.period,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _AlertSection(alerts: summary.alerts),
                          const SizedBox(height: 16),
                          _SectionCard(
                            title: 'Ventas y rentabilidad',
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                _InfoTable(
                                  rows: <_InfoRowData>[
                                    _InfoRowData('Cantidad de ventas',
                                        '${summary.sales.salesCount}'),
                                    _InfoRowData(
                                        'Facturación',
                                        _formatMoney(
                                            summary.sales.revenueCents)),
                                    _InfoRowData(
                                        'Ticket promedio',
                                        _formatMoney(
                                            summary.sales.averageTicketCents)),
                                    _InfoRowData('Unidades vendidas',
                                        '${summary.sales.unitsSold}'),
                                    _InfoRowData(
                                        'Descuentos',
                                        _formatMoney(
                                            summary.sales.discountCents)),
                                    _InfoRowData('IVA ventas',
                                        _formatMoney(summary.sales.taxCents)),
                                    _InfoRowData('Costo de productos',
                                        _formatMoney(summary.profit.costCents)),
                                    _InfoRowData(
                                        'Ganancia bruta',
                                        _formatMoney(
                                            summary.profit.grossProfitCents)),
                                    _InfoRowData(
                                        'Margen bruto',
                                        _formatPercent(
                                            summary.profit.grossMarginBps)),
                                    _InfoRowData(
                                        'Ganancia neta',
                                        _formatMoney(
                                            summary.profit.netProfitCents)),
                                    _InfoRowData(
                                        'Margen neto',
                                        _formatPercent(
                                            summary.profit.netMarginBps)),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                _LineChartCard(
                                  title: 'Ventas por período',
                                  emptyLabel: 'Sin ventas en el período.',
                                  points: summary.sales.trend,
                                  lineColor:
                                      Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(height: 12),
                                _LineChartCard(
                                  title: 'Ganancia por período',
                                  emptyLabel:
                                      'Sin ganancias registradas en el período.',
                                  points: summary.profit.trend,
                                  lineColor:
                                      Theme.of(context).colorScheme.tertiary,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          _SectionCard(
                            title: 'Gastos',
                            actionLabel: 'Abrir gastos',
                            onActionTap: () => context.push(
                              '/gastos?period=${_dashboardToExpensePeriodQuery(state.query.period)}',
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                _InfoTable(
                                  rows: <_InfoRowData>[
                                    _InfoRowData(
                                        'Total gastos',
                                        _formatMoney(summary
                                            .expenseStats.totalAmountCents)),
                                    _InfoRowData('Cantidad de gastos',
                                        '${summary.expenseStats.expenseCount}'),
                                    _InfoRowData(
                                        'Gasto promedio',
                                        _formatMoney(summary
                                            .expenseStats.averageAmountCents)),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                _LineChartCard(
                                  title: 'Gastos por período',
                                  emptyLabel: 'Sin gastos en el período.',
                                  points: summary.expenseStats.trend,
                                  lineColor:
                                      Theme.of(context).colorScheme.error,
                                ),
                                const SizedBox(height: 12),
                                _BarChartCard(
                                  title: 'Gastos por categoría',
                                  emptyLabel: 'Sin gastos por categoría.',
                                  items: summary.expenseStats.byCategory,
                                ),
                                const SizedBox(height: 12),
                                _BreakdownList(
                                  title: 'Gastos por proveedor',
                                  emptyLabel:
                                      'Sin proveedores asociados a gastos.',
                                  items: summary.expenseStats.bySupplier,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          _SectionCard(
                            title: 'Inventario y vencimientos',
                            actionLabel: 'Abrir inventario',
                            onActionTap: () => context.push('/stock'),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                _InfoTable(
                                  rows: <_InfoRowData>[
                                    _InfoRowData('Productos activos',
                                        '${summary.inventory.totalProducts}'),
                                    _InfoRowData('Sin stock',
                                        '${summary.inventory.noStockCount}'),
                                    _InfoRowData('Stock bajo',
                                        '${summary.inventory.lowStockCount}'),
                                    _InfoRowData('Sobre stock',
                                        '${summary.inventory.overStockCount}'),
                                    _InfoRowData('Reservadas',
                                        '${summary.inventory.reservedUnits} unidades'),
                                    _InfoRowData('Próximos a vencer',
                                        '${summary.inventory.nearExpiryCount}'),
                                    _InfoRowData('Vencen hoy',
                                        '${summary.inventory.dueTodayCount}'),
                                    _InfoRowData('Vencidos',
                                        '${summary.inventory.expiredCount}'),
                                    _InfoRowData(
                                        'Valor de inventario',
                                        _formatMoney(summary
                                            .inventory.inventoryValueCents)),
                                    _InfoRowData(
                                        'Capital inmovilizado',
                                        _formatMoney(summary
                                            .inventory.noMovementValueCents)),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: <Widget>[
                                    _ActionChip(
                                      label: 'Sin stock',
                                      onTap: () =>
                                          context.push('/stock?filter=noStock'),
                                    ),
                                    _ActionChip(
                                      label: 'Stock bajo',
                                      onTap: () => context
                                          .push('/stock?filter=lowStock'),
                                    ),
                                    _ActionChip(
                                      label: 'Próx. a vencer',
                                      onTap: () => context
                                          .push('/stock?filter=nearExpiry'),
                                    ),
                                    _ActionChip(
                                      label: 'Vencidos',
                                      onTap: () =>
                                          context.push('/stock?filter=expired'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          _SectionCard(
                            title: 'Reservas',
                            actionLabel: 'Abrir reservas',
                            onActionTap: () => context.push('/reservas'),
                            child: _InfoTable(
                              rows: <_InfoRowData>[
                                _InfoRowData('Reservas activas',
                                    '${summary.reservations.activeReservations}'),
                                _InfoRowData('Reservas pendientes',
                                    '${summary.reservations.pendingReservations}'),
                                _InfoRowData('Canceladas en período',
                                    '${summary.reservations.cancelledInPeriod}'),
                                _InfoRowData('Convertidas en venta',
                                    '${summary.reservations.convertedToSaleCount}'),
                                _InfoRowData('Unidades reservadas',
                                    '${summary.reservations.reservedUnits}'),
                                _InfoRowData(
                                    'Valor reservado',
                                    _formatMoney(summary
                                        .reservations.reservedValueCents)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          _ProductRankingSection(
                            summary: summary,
                            mode: state.productRankingMode,
                            onModeChanged: (mode) {
                              ref
                                  .read(dashboardStateProvider.notifier)
                                  .setProductRankingMode(mode);
                            },
                          ),
                          const SizedBox(height: 16),
                          _SectionCard(
                            title: 'Productos sin movimiento',
                            actionLabel: 'Abrir productos',
                            onActionTap: () => context.push('/productos'),
                            child: _ProductRankingList(
                              items: summary.stagnantProducts,
                              emptyLabel:
                                  'No hay productos inmovilizados en el período.',
                              showLastSale: true,
                              showInventoryValue: true,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _SectionCard(
                            title: 'Clientes',
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                _InfoTable(
                                  rows: <_InfoRowData>[
                                    _InfoRowData('Clientes activos',
                                        '${summary.customers.totalCustomers}'),
                                    _InfoRowData('Con compras',
                                        '${summary.customers.customersWithPurchases}'),
                                    _InfoRowData('Sin compras',
                                        '${summary.customers.customersWithoutPurchases}'),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                _CustomerRankingList(
                                    items: summary.customers.topCustomers),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          _SectionCard(
                            title: 'Proveedores',
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                _InfoTable(
                                  rows: <_InfoRowData>[
                                    _InfoRowData('Proveedores totales',
                                        '${summary.suppliers.totalSuppliers}'),
                                    _InfoRowData('Activos',
                                        '${summary.suppliers.activeSuppliers}'),
                                    _InfoRowData('Con gastos',
                                        '${summary.suppliers.suppliersWithExpenses}'),
                                    _InfoRowData('Unidades recibidas',
                                        '${summary.suppliers.receivedUnits}'),
                                    _InfoRowData(
                                        'Costo recibido',
                                        _formatMoney(summary
                                            .suppliers.receivedCostCents)),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                _SupplierRankingList(
                                    items: summary.suppliers.topSuppliers),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          _SectionCard(
                            title: 'Descuentos e IVA',
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                _InfoTable(
                                  rows: <_InfoRowData>[
                                    _InfoRowData('Operaciones con descuento',
                                        '${summary.discounts.discountedOperationsCount}'),
                                    _InfoRowData(
                                        'Monto total descontado',
                                        _formatMoney(summary
                                            .discounts.totalDiscountCents)),
                                    _InfoRowData(
                                        'Descuento promedio',
                                        _formatMoney(summary
                                            .discounts.averageDiscountCents)),
                                    _InfoRowData('IVA del período',
                                        _formatMoney(summary.taxCents)),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                _BreakdownList(
                                  title: 'Productos con mayor descuento',
                                  emptyLabel:
                                      'No hubo descuentos en el período.',
                                  items:
                                      summary.discounts.topDiscountedProducts,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          _SectionCard(
                            title: 'Ventas por categoría',
                            actionLabel: 'Abrir productos',
                            onActionTap: () => context.push('/productos'),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                _BarChartCard(
                                  title: 'Facturación por categoría',
                                  emptyLabel: 'Sin ventas por categoría.',
                                  items: summary.salesByCategory,
                                ),
                                const SizedBox(height: 12),
                                _BreakdownList(
                                  title: 'Top categorías',
                                  emptyLabel: 'Sin categorías con ventas.',
                                  items: summary.salesByCategory,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          _SectionCard(
                            title: 'Métricas no disponibles con datos reales',
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: summary.unavailableMetrics
                                  .map(
                                    (item) => Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: Text('• $item'),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ],
                      ],
                    ),
        ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection({
    required this.state,
    required this.onRefresh,
    required this.onCustomRange,
  });

  final DashboardViewState state;
  final VoidCallback onRefresh;
  final VoidCallback onCustomRange;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                'Dashboard del negocio',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            IconButton(
              onPressed: state.isLoading ? null : onRefresh,
              tooltip: 'Actualizar',
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          state.summary == null
              ? 'Período pendiente'
              : 'Período: ${state.summary!.period.label}',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: <Widget>[
            _PeriodChip(
                label: 'Hoy',
                selected: state.query.period == DashboardPeriod.today,
                onTap: () => _setPeriod(context, DashboardPeriod.today)),
            _PeriodChip(
                label: '7 días',
                selected: state.query.period == DashboardPeriod.last7Days,
                onTap: () => _setPeriod(context, DashboardPeriod.last7Days)),
            _PeriodChip(
                label: 'Este mes',
                selected: state.query.period == DashboardPeriod.thisMonth,
                onTap: () => _setPeriod(context, DashboardPeriod.thisMonth)),
            _PeriodChip(
                label: 'Mes anterior',
                selected: state.query.period == DashboardPeriod.previousMonth,
                onTap: () =>
                    _setPeriod(context, DashboardPeriod.previousMonth)),
            _PeriodChip(
                label: 'Este año',
                selected: state.query.period == DashboardPeriod.thisYear,
                onTap: () => _setPeriod(context, DashboardPeriod.thisYear)),
            ActionChip(
              label: Text(state.query.period == DashboardPeriod.custom
                  ? 'Personalizado'
                  : 'Elegir rango'),
              onPressed: onCustomRange,
            ),
          ],
        ),
      ],
    );
  }

  void _setPeriod(BuildContext context, DashboardPeriod period) {
    final ref = ProviderScope.containerOf(context);
    ref.read(dashboardStateProvider.notifier).setPeriod(period);
  }
}

class _PeriodChip extends StatelessWidget {
  const _PeriodChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
    );
  }
}

class _SummaryGrid extends StatelessWidget {
  const _SummaryGrid({
    required this.summary,
    required this.expensePeriodQuery,
  });

  final DashboardSummaryView summary;
  final String expensePeriodQuery;

  @override
  Widget build(BuildContext context) {
    final items = <_SummaryItemData>[
      _SummaryItemData('Ventas', '${summary.salesCount}', '/ventas'),
      _SummaryItemData(
          'Facturación', _formatMoney(summary.revenueCents), '/ventas'),
      _SummaryItemData('Costos', _formatMoney(summary.costCents), '/productos'),
      _SummaryItemData('Gastos', _formatMoney(summary.expensesCents),
          '/gastos?period=$expensePeriodQuery'),
      _SummaryItemData('Ganancia bruta', _formatMoney(summary.grossProfitCents),
          '/estadisticas'),
      _SummaryItemData('Ganancia neta', _formatMoney(summary.netProfitCents),
          '/estadisticas'),
      _SummaryItemData('IVA', _formatMoney(summary.taxCents), '/estadisticas'),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth >= 340
            ? (constraints.maxWidth - 10) / 2
            : constraints.maxWidth;
        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: items
              .map(
                (item) => SizedBox(
                  width: cardWidth,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: item.route == null
                            ? null
                            : () => context.push(item.route!),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(item.label,
                                style: Theme.of(context).textTheme.labelMedium),
                            const SizedBox(height: 8),
                            Text(item.value,
                                style: Theme.of(context).textTheme.titleLarge),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _SummaryItemData {
  const _SummaryItemData(this.label, this.value, [this.route]);

  final String label;
  final String value;
  final String? route;
}

class _AlertSection extends StatelessWidget {
  const _AlertSection({required this.alerts});

  final List<DashboardAlertItem> alerts;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Alertas importantes',
      child: alerts.isEmpty
          ? const Text('Sin alertas para el período seleccionado.')
          : Column(
              children: alerts
                  .map(
                    (alert) => Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Text(alert.title),
                        subtitle: Text(alert.subtitle),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => context.push(alert.route),
                      ),
                    ),
                  )
                  .toList(),
            ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.child,
    this.actionLabel,
    this.onActionTap,
  });

  final String title;
  final Widget child;
  final String? actionLabel;
  final VoidCallback? onActionTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                if (actionLabel != null && onActionTap != null)
                  TextButton(onPressed: onActionTap, child: Text(actionLabel!)),
              ],
            ),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }
}

class _InfoTable extends StatelessWidget {
  const _InfoTable({required this.rows});

  final List<_InfoRowData> rows;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: rows
          .map(
            (row) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(child: Text(row.label)),
                  const SizedBox(width: 12),
                  Text(
                    row.value,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _InfoRowData {
  const _InfoRowData(this.label, this.value);

  final String label;
  final String value;
}

class _LineChartCard extends StatelessWidget {
  const _LineChartCard({
    required this.title,
    required this.emptyLabel,
    required this.points,
    required this.lineColor,
  });

  final String title;
  final String emptyLabel;
  final List<DashboardSeriesPoint> points;
  final Color lineColor;

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) {
      return _ChartShell(title: title, child: Text(emptyLabel));
    }

    final spots = <FlSpot>[];
    var maxY = 0.0;
    for (var index = 0; index < points.length; index++) {
      final point = points[index];
      final y = point.amountCents.toDouble() / 100.0;
      if (y > maxY) {
        maxY = y;
      }
      spots.add(FlSpot(index.toDouble(), y));
    }

    return _ChartShell(
      title: title,
      child: SizedBox(
        height: 220,
        child: LineChart(
          LineChartData(
            minY: 0,
            maxY: maxY == 0 ? 1 : maxY * 1.2,
            gridData: const FlGridData(show: true),
            titlesData: FlTitlesData(
              topTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 42,
                  getTitlesWidget: (value, meta) =>
                      Text(_compactMoneyLabel(value)),
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 34,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index < 0 || index >= points.length) {
                      return const SizedBox.shrink();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        points[index].label,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    );
                  },
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            lineBarsData: <LineChartBarData>[
              LineChartBarData(
                spots: spots,
                isCurved: false,
                color: lineColor,
                barWidth: 3,
                dotData: const FlDotData(show: true),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BarChartCard extends StatelessWidget {
  const _BarChartCard({
    required this.title,
    required this.emptyLabel,
    required this.items,
  });

  final String title;
  final String emptyLabel;
  final List<DashboardBreakdownItem> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return _ChartShell(title: title, child: Text(emptyLabel));
    }

    var maxY = 0.0;
    for (final item in items) {
      final y = item.amountCents.toDouble() / 100.0;
      if (y > maxY) {
        maxY = y;
      }
    }

    return _ChartShell(
      title: title,
      child: SizedBox(
        height: 230,
        child: BarChart(
          BarChartData(
            minY: 0,
            maxY: maxY == 0 ? 1 : maxY * 1.2,
            gridData: const FlGridData(show: true),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              topTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 42,
                  getTitlesWidget: (value, meta) =>
                      Text(_compactMoneyLabel(value)),
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index < 0 || index >= items.length) {
                      return const SizedBox.shrink();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        _shortLabel(items[index].label),
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    );
                  },
                ),
              ),
            ),
            barGroups: items.asMap().entries.map((entry) {
              return BarChartGroupData(
                x: entry.key,
                barRods: <BarChartRodData>[
                  BarChartRodData(
                    toY: entry.value.amountCents.toDouble() / 100.0,
                    color: Theme.of(context).colorScheme.primary,
                    width: 18,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _ChartShell extends StatelessWidget {
  const _ChartShell({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withValues(alpha: 0.32),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _BreakdownList extends StatelessWidget {
  const _BreakdownList({
    required this.title,
    required this.emptyLabel,
    required this.items,
  });

  final String title;
  final String emptyLabel;
  final List<DashboardBreakdownItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        if (items.isEmpty)
          Text(emptyLabel)
        else
          ...items.map(
            (item) => ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: Text(item.label),
              subtitle: Text(
                  '${item.count} operaciones${item.quantity > 0 ? ' · ${item.quantity} unidades' : ''}'),
              trailing: Text(_formatMoney(item.amountCents)),
            ),
          ),
      ],
    );
  }
}

class _ProductRankingSection extends StatelessWidget {
  const _ProductRankingSection({
    required this.summary,
    required this.mode,
    required this.onModeChanged,
  });

  final DashboardSummaryView summary;
  final DashboardProductRankingMode mode;
  final ValueChanged<DashboardProductRankingMode> onModeChanged;

  @override
  Widget build(BuildContext context) {
    final List<DashboardProductRankingItem> items;
    switch (mode) {
      case DashboardProductRankingMode.units:
        items = summary.topProductsByUnits;
        break;
      case DashboardProductRankingMode.revenue:
        items = summary.topProductsByRevenue;
        break;
      case DashboardProductRankingMode.profit:
        items = summary.topProductsByProfit;
        break;
    }

    return _SectionCard(
      title: 'Ranking de productos',
      actionLabel: 'Abrir productos',
      onActionTap: () => context.push('/productos'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SegmentedButton<DashboardProductRankingMode>(
            segments: const <ButtonSegment<DashboardProductRankingMode>>[
              ButtonSegment<DashboardProductRankingMode>(
                value: DashboardProductRankingMode.units,
                label: Text('Unidades'),
              ),
              ButtonSegment<DashboardProductRankingMode>(
                value: DashboardProductRankingMode.revenue,
                label: Text('Facturación'),
              ),
              ButtonSegment<DashboardProductRankingMode>(
                value: DashboardProductRankingMode.profit,
                label: Text('Ganancia'),
              ),
            ],
            selected: <DashboardProductRankingMode>{mode},
            onSelectionChanged: (selection) => onModeChanged(selection.first),
          ),
          const SizedBox(height: 12),
          _BarChartCard(
            title: 'Top productos',
            emptyLabel: 'Sin ventas en el período.',
            items: items
                .map(
                  (item) => DashboardBreakdownItem(
                    id: item.productId,
                    label: item.label,
                    amountCents: mode == DashboardProductRankingMode.profit
                        ? item.profitCents
                        : item.revenueCents,
                    count: item.unitsSold,
                    quantity: item.unitsSold,
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 12),
          _ProductRankingList(
              items: items, emptyLabel: 'Sin productos vendidos.'),
          const SizedBox(height: 12),
          _SectionSubtitle('Menos vendidos'),
          _ProductRankingList(
            items: summary.leastSoldProducts,
            emptyLabel: 'Sin productos con ventas en el período.',
            showLastSale: true,
          ),
        ],
      ),
    );
  }
}

class _ProductRankingList extends StatelessWidget {
  const _ProductRankingList({
    required this.items,
    required this.emptyLabel,
    this.showLastSale = false,
    this.showInventoryValue = false,
  });

  final List<DashboardProductRankingItem> items;
  final String emptyLabel;
  final bool showLastSale;
  final bool showInventoryValue;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Text(emptyLabel);
    }

    return Column(
      children: items
          .map(
            (item) => ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: Text(item.label),
              subtitle: Text(
                'Unidades: ${item.unitsSold} · Facturación: ${_formatMoney(item.revenueCents)} · Ganancia: ${_formatMoney(item.profitCents)}'
                '${showLastSale ? ' · Última venta: ${item.lastSaleAt == null ? '-' : _formatDate(item.lastSaleAt!)}' : ''}'
                '${showInventoryValue ? ' · Stock: ${item.stockAvailable} · Valor stock: ${_formatMoney(item.inventoryValueCents)}' : ''}',
              ),
              trailing: Text(_formatMoney(item.revenueCents)),
              onTap: () => context.push('/productos/${item.productId}'),
            ),
          )
          .toList(),
    );
  }
}

class _CustomerRankingList extends StatelessWidget {
  const _CustomerRankingList({required this.items});

  final List<DashboardCustomerRankingItem> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Text('Sin clientes con compras en el período.');
    }

    return Column(
      children: items
          .map(
            (item) => ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: Text(item.label),
              subtitle: Text(
                  '${item.salesCount} operaciones · Ticket promedio ${_formatMoney(item.averageTicketCents)}'),
              trailing: Text(_formatMoney(item.revenueCents)),
            ),
          )
          .toList(),
    );
  }
}

class _SupplierRankingList extends StatelessWidget {
  const _SupplierRankingList({required this.items});

  final List<DashboardSupplierRankingItem> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Text('Sin proveedores con actividad en el período.');
    }

    return Column(
      children: items
          .map(
            (item) => ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: Text(item.label),
              subtitle: Text(
                'Recibido: ${item.receivedUnits} unidades · Gastos: ${item.expenseCount} · ${item.isActive ? 'Activo' : 'Inactivo'}',
              ),
              trailing: Text(_formatMoney(
                  item.receivedCostCents + item.expenseAmountCents)),
              onTap: () => context.push('/proveedores/${item.supplierId}'),
            ),
          )
          .toList(),
    );
  }
}

class _SectionSubtitle extends StatelessWidget {
  const _SectionSubtitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title, style: Theme.of(context).textTheme.titleSmall),
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(label),
      onPressed: onTap,
    );
  }
}

String _formatMoney(int cents) {
  final sign = cents < 0 ? '-' : '';
  final absolute = cents.abs();
  final major = absolute ~/ 100;
  final minor = (absolute % 100).toString().padLeft(2, '0');
  return '$sign\$$major.$minor';
}

String _formatPercent(int bps) {
  final sign = bps < 0 ? '-' : '';
  final absolute = bps.abs();
  final whole = absolute ~/ 100;
  final decimals = (absolute % 100).toString().padLeft(2, '0');
  return '$sign$whole.$decimals%';
}

String _compactMoneyLabel(double value) {
  if (value >= 1000000) {
    return '${(value / 1000000).toStringAsFixed(1)}M';
  }
  if (value >= 1000) {
    return '${(value / 1000).toStringAsFixed(1)}k';
  }
  return value.toStringAsFixed(0);
}

String _shortLabel(String value) {
  if (value.length <= 10) {
    return value;
  }
  return '${value.substring(0, 10)}…';
}

String _formatDate(DateTime value) {
  final local = value.toLocal();
  final day = local.day.toString().padLeft(2, '0');
  final month = local.month.toString().padLeft(2, '0');
  return '$day/$month/${local.year}';
}

String _dashboardToExpensePeriodQuery(DashboardPeriod period) {
  switch (period) {
    case DashboardPeriod.today:
      return 'today';
    case DashboardPeriod.last7Days:
    case DashboardPeriod.thisWeek:
      return 'thisWeek';
    case DashboardPeriod.previousMonth:
      return 'previousMonth';
    case DashboardPeriod.custom:
      return 'custom';
    case DashboardPeriod.thisYear:
    case DashboardPeriod.thisMonth:
      return 'thisMonth';
  }
}
