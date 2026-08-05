import 'package:control_stok_celu/data/providers/app_providers.dart';
import 'package:control_stok_celu/domain/stock/stock_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ReservationDetailScreen extends ConsumerStatefulWidget {
  const ReservationDetailScreen({required this.reservationId, super.key});

  final String reservationId;

  @override
  ConsumerState<ReservationDetailScreen> createState() =>
      _ReservationDetailScreenState();
}

class _ReservationDetailScreenState
    extends ConsumerState<ReservationDetailScreen> {
  late Future<ReservationDetailView> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<ReservationDetailView> _load() {
    return ref.read(getReservationDetailUseCaseProvider)(widget.reservationId);
  }

  Future<void> _reserveDraft() async {
    await ref.read(reserveDraftReservationUseCaseProvider)(
        widget.reservationId, DateTime.now().toUtc());
    if (!mounted) {
      return;
    }
    Navigator.of(context).pop(true);
  }

  Future<void> _cancelReservation() async {
    await ref.read(cancelReservationUseCaseProvider)(
        widget.reservationId, DateTime.now().toUtc());
    if (!mounted) {
      return;
    }
    Navigator.of(context).pop(true);
  }

  Future<void> _deleteReservation() async {
    await ref.read(deleteReservationUseCaseProvider)(
        widget.reservationId, DateTime.now().toUtc());
    if (!mounted) {
      return;
    }
    Navigator.of(context).pop(true);
  }

  Future<void> _confirmDraftSale() async {
    await ref.read(confirmDraftReservationSaleUseCaseProvider)(
      ConfirmSaleInput(
        saleId: widget.reservationId,
        reservationId: widget.reservationId,
        confirmedAt: DateTime.now().toUtc(),
      ),
    );
    if (!mounted) {
      return;
    }
    Navigator.of(context).pop(true);
  }

  Future<void> _confirmReservedSale() async {
    await ref.read(confirmReservationSaleUseCaseProvider)(
      ConfirmSaleInput(
        saleId: widget.reservationId,
        reservationId: widget.reservationId,
        confirmedAt: DateTime.now().toUtc(),
      ),
    );
    if (!mounted) {
      return;
    }
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de reserva')),
      body: FutureBuilder<ReservationDetailView>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return Center(
                child: Text(
                    'No pudimos cargar la reserva. ${snapshot.error ?? ''}'));
          }
          final detail = snapshot.data!;
          final reservation = detail.reservation;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              Text(reservation.customerName ?? 'Sin cliente',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              _Line(label: 'ID', value: reservation.id),
              _Line(label: 'Estado', value: reservation.status),
              _Line(label: 'Fecha', value: _formatDate(reservation.createdAt)),
              _Line(
                  label: 'Subtotal',
                  value: _formatMoney(reservation.subtotalCents)),
              _Line(label: 'IVA', value: _formatMoney(reservation.taxCents)),
              _Line(
                  label: 'Descuento',
                  value: _formatMoney(reservation.discountCents)),
              _Line(
                  label: 'Total', value: _formatMoney(reservation.totalCents)),
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
                      'Unitario: ${_formatMoney(line.unitPriceCents)} · IVA: ${line.taxRateBps / 100}% · Descuento: ${_formatMoney(line.discountCents)}',
                    ),
                    trailing: Text(_formatMoney(line.lineTotalCents +
                        ((line.lineTotalCents * line.taxRateBps) / 10000)
                            .round())),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (reservation.status == 'draft') ...<Widget>[
                FilledButton.icon(
                  onPressed: () => context
                      .push('/reservations/${reservation.id}/edit')
                      .then((value) {
                    if (value == true && mounted) {
                      setState(() => _future = _load());
                    }
                  }),
                  icon: const Icon(Icons.edit_outlined),
                  label: const Text('Editar draft'),
                ),
                const SizedBox(height: 8),
                FilledButton.tonalIcon(
                  onPressed: _reserveDraft,
                  icon: const Icon(Icons.bookmark_outline),
                  label: const Text('Reservar'),
                ),
                const SizedBox(height: 8),
                FilledButton.tonalIcon(
                  onPressed: _confirmDraftSale,
                  icon: const Icon(Icons.point_of_sale_outlined),
                  label: const Text('Convertir en venta'),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: _deleteReservation,
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Eliminar draft'),
                ),
              ],
              if (reservation.status == 'reserved') ...<Widget>[
                FilledButton.tonalIcon(
                  onPressed: _confirmReservedSale,
                  icon: const Icon(Icons.point_of_sale_outlined),
                  label: const Text('Confirmar venta'),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: _cancelReservation,
                  icon: const Icon(Icons.cancel_outlined),
                  label: const Text('Cancelar reserva'),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: _deleteReservation,
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Eliminar reserva'),
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
