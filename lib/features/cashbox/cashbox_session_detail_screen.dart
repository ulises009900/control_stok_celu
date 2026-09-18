import 'package:control_stok_celu/domain/cashbox/cashbox_models.dart';
import 'package:control_stok_celu/features/cashbox/cashbox_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CashboxSessionDetailScreen extends ConsumerWidget {
  const CashboxSessionDetailScreen({required this.sessionId, super.key});

  final String sessionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(cashSessionDetailProvider(sessionId));
    return Scaffold(
      appBar: AppBar(
        leading: Navigator.canPop(context) ? const BackButton() : null,
        title: const Text('Turno de caja'),
      ),
      body: detailAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (detail) => _DetailBody(detail: detail),
      ),
    );
  }
}

class _DetailBody extends StatelessWidget {
  const _DetailBody({required this.detail});

  final CashSessionDetail detail;

  @override
  Widget build(BuildContext context) {
    final isOpen = detail.status == CashSessionStatus.open;
    final diff = detail.differenceCents;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(
                      isOpen ? Icons.lock_open : Icons.lock_outline,
                      color: isOpen ? Colors.green : null,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isOpen ? 'Turno abierto' : 'Turno cerrado',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Apertura: ${_formatDate(detail.openedAt)}'),
                if (detail.closedAt != null)
                  Text('Cierre: ${_formatDate(detail.closedAt!)}'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Arqueo', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                _Row('Apertura', detail.openingCents),
                _Row('Ventas en efectivo (${detail.salesCount})', detail.salesTotalCents),
                _Row('Ingresos manuales en efectivo', detail.manualIncomeCents),
                _Row('Egresos manuales en efectivo', -detail.manualExpenseCents),
                _Row('Gastos (${detail.expensesCount})',
                    -detail.expensesTotalCents),
                const Divider(),
                _Row('Efectivo esperado al cierre', detail.expectedClosingCents, bold: true),
                if (!isOpen) ...<Widget>[
                  _Row('Contado', detail.countedClosingCents ?? 0),
                  _Row(
                    diff != null && diff >= 0 ? 'Sobrante' : 'Faltante',
                    diff == null ? 0 : diff.abs(),
                    color: diff == null || diff == 0
                        ? null
                        : diff > 0
                            ? Colors.blue
                            : Colors.red,
                    bold: true,
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Cobros no incluidos en efectivo', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                _Row('Transferencias', detail.transferSalesCents),
                _Row('Tarjetas', detail.cardSalesCents),
                _Row('Cuenta corriente (pendiente)', detail.currentAccountSalesCents),
                const SizedBox(height: 6),
                const Text('Estos importes quedan registrados en ventas, pero no se comparan contra el efectivo contado.'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text('Movimientos de caja y ventas', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        if (detail.movements.isEmpty)
          const Text('No hay movimientos registrados.')
        else
          ...detail.movements.map(
            (movement) => Card(
              child: ListTile(
                leading: Icon(
                  movement.type == CashMovementType.income
                      ? Icons.add_circle_outline
                      : Icons.remove_circle_outline,
                  color: movement.type == CashMovementType.income
                      ? Colors.green
                      : Colors.red,
                ),
                title: Text(movement.description?.isNotEmpty == true
                    ? movement.description!
                    : (movement.type == CashMovementType.income
                        ? 'Ingreso'
                        : 'Egreso')),
                subtitle: Text(_formatDate(movement.createdAt)),
                trailing: Text(_formatMoney(movement.amountCents)),
              ),
            ),
          ),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.cents, {this.bold = false, this.color});

  final String label;
  final int cents;
  final bool bold;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(label),
          Text(
            _formatMoney(cents),
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              color: color,
            ),
          ),
        ],
      ),
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

String _formatDate(DateTime date) {
  final local = date.toLocal();
  final day = local.day.toString().padLeft(2, '0');
  final month = local.month.toString().padLeft(2, '0');
  final hour = local.hour.toString().padLeft(2, '0');
  final minute = local.minute.toString().padLeft(2, '0');
  return '$day/$month/${local.year} $hour:$minute';
}
