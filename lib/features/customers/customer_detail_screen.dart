import 'package:control_stok_celu/data/providers/app_providers.dart';
import 'package:control_stok_celu/data/sync/sync_providers.dart';
import 'package:control_stok_celu/domain/stock/stock_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CustomerDetailScreen extends ConsumerStatefulWidget {
  const CustomerDetailScreen({required this.customerId, super.key});

  final String customerId;

  @override
  ConsumerState<CustomerDetailScreen> createState() =>
      _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends ConsumerState<CustomerDetailScreen> {
  late Future<CustomerDetailView> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<CustomerDetailView> _load() {
    return ref.read(getCustomerDetailUseCaseProvider)(widget.customerId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Navigator.canPop(context) ? const BackButton() : null,
        title: const Text('Detalle cliente'),
        actions: <Widget>[
          if (ref.watch(isAdminProvider)) IconButton(
            onPressed: () => context
                .push('/customers/${widget.customerId}/edit')
                .then((value) {
              if (value == true && mounted) {
                setState(() => _future = _load());
              }
            }),
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),
      body: FutureBuilder<CustomerDetailView>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return Center(
                child: Text(
                    'No pudimos cargar el cliente. ${snapshot.error ?? ''}'));
          }
          final detail = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              Text(detail.customer.name,
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              _Line(label: 'Teléfono', value: detail.customer.phone ?? '-'),
              _Line(label: 'Email', value: detail.customer.email ?? '-'),
              _Line(label: 'Documento', value: detail.customer.document ?? '-'),
              _Line(label: 'Dirección', value: detail.customer.address ?? '-'),
              _Line(label: 'Notas', value: detail.customer.notes ?? '-'),
              _Line(
                  label: 'Estado',
                  value: detail.customer.isActive ? 'Activo' : 'Inactivo'),
              const SizedBox(height: 16),
              _Line(label: 'Ventas', value: '${detail.salesCount}'),
              _Line(label: 'Reservas', value: '${detail.reservationsCount}'),
              _Line(
                  label: 'Facturación',
                  value: _formatMoney(detail.revenueCents)),
              _Line(
                  label: 'Ticket promedio',
                  value: _formatMoney(detail.averageTicketCents)),
              _Line(
                  label: 'Saldo cuenta corriente',
                  value: _formatMoney(detail.currentAccountBalanceCents)),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.account_balance_wallet_outlined),
                  title: const Text('Cuenta corriente'),
                  subtitle: Text(detail.currentAccountBalanceCents == 0
                      ? 'Sin saldo pendiente.'
                      : 'Saldo pendiente: ${_formatMoney(detail.currentAccountBalanceCents)}'),
                ),
              ),
              const SizedBox(height: 16),
              Text('Historial', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              if (detail.history.isEmpty)
                const Text('Sin historial para este cliente.')
              else
                ...detail.history.map(
                  (item) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('${item.referenceType} · ${item.status}'),
                    subtitle: Text(_formatDate(item.createdAt)),
                    trailing: Text(_formatMoney(item.amountCents)),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text('$label: $value'),
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

String _formatDate(DateTime value) {
  final local = value.toLocal();
  final day = local.day.toString().padLeft(2, '0');
  final month = local.month.toString().padLeft(2, '0');
  return '$day/$month/${local.year}';
}
