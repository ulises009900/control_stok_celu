import 'package:control_stok_celu/core/commercial/percentage_utils.dart';
import 'package:control_stok_celu/data/providers/app_providers.dart';
import 'package:control_stok_celu/domain/stock/stock_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SaleDetailScreen extends ConsumerStatefulWidget {
  const SaleDetailScreen({required this.saleId, super.key});

  final String saleId;

  @override
  ConsumerState<SaleDetailScreen> createState() => _SaleDetailScreenState();
}

class _SaleDetailScreenState extends ConsumerState<SaleDetailScreen> {
  late Future<SaleDetailView> _future;
  bool _processingAction = false;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<SaleDetailView> _load() {
    return ref.read(getSaleDetailUseCaseProvider)(widget.saleId);
  }

  Future<void> _confirmDraftSale() async {
    await _runAction(() async {
      await ref.read(confirmSaleDraftUseCaseProvider)(
          widget.saleId, DateTime.now().toUtc());
      if (!mounted) {
        return;
      }
      Navigator.of(context).pop(true);
    });
  }

  Future<void> _reserveDraftSale() async {
    await _runAction(() async {
      await ref.read(reserveSaleDraftUseCaseProvider)(
          widget.saleId, DateTime.now().toUtc());
      if (!mounted) {
        return;
      }
      Navigator.of(context).pop(true);
    });
  }

  Future<void> _deleteDraft() async {
    await _runAction(() async {
      await ref.read(deleteSaleDraftUseCaseProvider)(widget.saleId);
      if (!mounted) {
        return;
      }
      Navigator.of(context).pop(true);
    });
  }

  Future<void> _runAction(Future<void> Function() action) async {
    if (_processingAction) {
      return;
    }
    setState(() => _processingAction = true);
    try {
      await action();
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo completar la operación. $e')),
      );
      setState(() => _future = _load());
    } finally {
      if (mounted) {
        setState(() => _processingAction = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de venta')),
      body: FutureBuilder<SaleDetailView>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return Center(
                child: Text(
                    'No pudimos cargar la venta. ${snapshot.error ?? ''}'));
          }
          final detail = snapshot.data!;
          final sale = detail.sale;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              Text(sale.customerName ?? 'Sin cliente',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              _Line(label: 'ID', value: sale.id),
              _Line(label: 'Estado', value: sale.status),
              _Line(
                  label: 'Fecha',
                  value: _formatDate(sale.confirmedAt ?? sale.createdAt)),
              _Line(label: 'Subtotal', value: _formatMoney(sale.subtotalCents)),
              _Line(label: 'IVA', value: _formatMoney(sale.taxCents)),
              _Line(
                  label: 'Descuento', value: _formatMoney(sale.discountCents)),
              _Line(label: 'Total', value: _formatMoney(sale.totalCents)),
              _Line(label: 'Ganancia', value: _formatMoney(sale.profitCents)),
              if ((detail.notes ?? '').trim().isNotEmpty)
                _Line(label: 'Notas', value: detail.notes!),
              const SizedBox(height: 12),
              Text('Productos', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              ...detail.lines.map(
                (line) => Card(
                  child: ListTile(
                    title: Text(line.productName),
                    subtitle: Text(
                      '${line.productCode} · Cantidad: ${line.quantity}\n'
                      'Unitario: ${_formatMoney(line.unitPriceCents)} · IVA: ${bpsToPercentText(line.taxRateBps)}% · Descuento: ${_formatMoney(line.discountCents)}',
                    ),
                    trailing:
                        Text(_formatMoney(line.lineTotalCents + line.taxCents)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (sale.status == 'draft') ...<Widget>[
                FilledButton.icon(
                  onPressed: () =>
                      context.push('/sales/${sale.id}/edit').then((value) {
                    if (value == true && mounted) {
                      setState(() => _future = _load());
                    }
                  }),
                  icon: const Icon(Icons.edit_outlined),
                  label: const Text('Editar draft'),
                ),
                const SizedBox(height: 8),
                FilledButton.tonalIcon(
                  onPressed: _processingAction ? null : _reserveDraftSale,
                  icon: const Icon(Icons.bookmark_outline),
                  label: const Text('Reservar'),
                ),
                const SizedBox(height: 8),
                FilledButton.tonalIcon(
                  onPressed: _processingAction ? null : _confirmDraftSale,
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Confirmar venta'),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: _processingAction ? null : _deleteDraft,
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Eliminar draft'),
                ),
              ],
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
