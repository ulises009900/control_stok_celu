import 'package:control_stok_celu/data/providers/app_providers.dart';
import 'package:control_stok_celu/domain/stock/stock_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  const ProductDetailScreen({required this.productId, super.key});

  final String productId;

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  late Future<ProductDetailView> _future;
  final TextEditingController _batchSearchController = TextEditingController();
  String _batchQuery = '';

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  @override
  void dispose() {
    _batchSearchController.dispose();
    super.dispose();
  }

  Future<ProductDetailView> _load() {
    return ref.read(getProductDetailUseCaseProvider)(widget.productId);
  }

  Future<void> _toggleActive(ProductDetailView detail) async {
    await ref.read(setProductActiveUseCaseProvider)(
        detail.product.id, !detail.product.isActive);
    if (!mounted) {
      return;
    }
    setState(() {
      _future = _load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de producto'),
        actions: <Widget>[
          IconButton(
            tooltip: 'Editar',
            onPressed: () =>
                context.push('/productos/${widget.productId}/editar').then((_) {
              setState(() {
                _future = _load();
              });
            }),
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),
      body: FutureBuilder<ProductDetailView>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                        'No pudimos cargar el detalle. ${snapshot.error ?? ''}'),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: () {
                        setState(() {
                          _future = _load();
                        });
                      },
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            );
          }

          final detail = snapshot.data!;
          final margin = detail.product.salePriceCents == 0
              ? 0
              : (detail.estimatedProfitCents / detail.product.salePriceCents) *
                  100;
          final batchQuery = _batchQuery.trim().toLowerCase();
          final sortedBatches = List<ProductBatchView>.from(detail.batches)
            ..sort((a, b) {
              final aDays = _daysUntil(a.expiresAt);
              final bDays = _daysUntil(b.expiresAt);
              if (aDays == null && bDays == null) {
                return b.receivedAt.compareTo(a.receivedAt);
              }
              if (aDays == null) {
                return 1;
              }
              if (bDays == null) {
                return -1;
              }
              return aDays.compareTo(bDays);
            });
          final visibleBatches = sortedBatches.where((batch) {
            if (batchQuery.isEmpty) {
              return true;
            }
            return (batch.batchCode ?? batch.id)
                .toLowerCase()
                .contains(batchQuery);
          }).toList();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              _sectionTitle(context, 'Identificación'),
              Text(detail.product.name,
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              _readOnlyLine('Código', detail.product.internalCode),
              _readOnlyLine('Código de barras', detail.product.barcode ?? '-'),
              _readOnlyLine('Marca', detail.product.brand ?? '-'),
              _readOnlyLine('Categoría', detail.categoryName ?? '-'),
              _readOnlyLine('Subcategoría', detail.product.subcategory ?? '-'),
              _readOnlyLine(
                  'Estado', detail.product.isActive ? 'Activo' : 'Inactivo'),
              if (detail.description != null &&
                  detail.description!.trim().isNotEmpty)
                _readOnlyLine('Descripción', detail.description!),
              if (detail.characteristics != null &&
                  detail.characteristics!.trim().isNotEmpty)
                _readOnlyLine('Características', detail.characteristics!),
              const SizedBox(height: 16),
              _sectionTitle(context, 'Stock'),
              _readOnlyLine('Stock total', '${detail.product.stockTotal}'),
              _readOnlyLine(
                  'Stock reservado', '${detail.product.stockReserved}'),
              _readOnlyLine(
                  'Stock disponible', '${detail.product.stockAvailable}'),
              const SizedBox(height: 16),
              _sectionTitle(context, 'Precios'),
              _readOnlyLine('Costo', _formatMoney(detail.product.costCents)),
              _readOnlyLine('Precio de venta',
                  _formatMoney(detail.product.salePriceCents)),
              _readOnlyLine(
                  'IVA', '${(detail.taxRateBps / 100).toStringAsFixed(2)}%'),
              _readOnlyLine('Descuento',
                  '${(detail.defaultDiscountBps / 100).toStringAsFixed(2)}%'),
              _readOnlyLine(
                  'Ganancia', _formatMoney(detail.estimatedProfitCents)),
              _readOnlyLine('Margen', '${margin.toStringAsFixed(2)}%'),
              const SizedBox(height: 16),
              _sectionTitle(context, 'Lotes'),
              TextField(
                controller: _batchSearchController,
                onChanged: (value) => setState(() => _batchQuery = value),
                decoration: const InputDecoration(
                  labelText: 'Buscar lote',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              const SizedBox(height: 8),
              if (visibleBatches.isEmpty)
                const Text('No hay lotes cargados.')
              else
                ...visibleBatches.map(
                  (batch) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(batch.batchCode ?? batch.id),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                            'Ingreso: ${_formatDate(batch.receivedAt)} · ${_formatTime(batch.receivedAt)}'),
                        Text('Cantidad original: ${batch.quantityTotal}'),
                        Text(
                            'Disponible: ${batch.quantityAvailable} · Reservada: ${batch.quantityReserved}'),
                        Text(
                            'Costo unitario: ${_formatMoney(batch.unitCostCents)}'),
                        Text(
                          batch.expiresAt == null
                              ? 'Vencimiento: Sin fecha'
                              : 'Vencimiento: ${_formatDate(batch.expiresAt!)} (${_expiryLabel(_daysUntil(batch.expiresAt))})',
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              _sectionTitle(context, 'Historial de movimientos'),
              if (detail.movements.isEmpty)
                const Text('No hay movimientos para este producto.')
              else
                ...detail.movements.map(
                  (movement) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(_movementLabel(movement.movementType)),
                    subtitle: Text(
                      '${_formatDate(movement.createdAt)} · ${_formatTime(movement.createdAt)}\n'
                      'Cantidad: ${movement.quantity} · Stock: ${movement.stockBefore} -> ${movement.stockAfter}'
                      '${movement.batchId == null ? '' : '\nLote: ${movement.batchId}'}'
                      '${movement.reason == null || movement.reason!.trim().isEmpty ? '' : '\nDetalle: ${movement.reason}'}',
                    ),
                  ),
                ),
              const SizedBox(height: 24),
              FilledButton.tonalIcon(
                onPressed: () => _toggleActive(detail),
                icon: Icon(detail.product.isActive
                    ? Icons.pause_circle_outline
                    : Icons.play_circle_outline),
                label: Text(detail.product.isActive
                    ? 'Desactivar producto'
                    : 'Reactivar producto'),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () async {
                  final changed = await context
                      .push<bool>('/productos/${widget.productId}/movimiento');
                  if (changed == true && mounted) {
                    setState(() {
                      _future = _load();
                    });
                  }
                },
                icon: const Icon(Icons.swap_horiz),
                label: const Text('Agregar movimiento'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    return Text(title, style: Theme.of(context).textTheme.titleMedium);
  }

  Widget _readOnlyLine(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text('$label: $value'),
    );
  }

  int? _daysUntil(DateTime? value) {
    if (value == null) {
      return null;
    }
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetLocal = value.toLocal();
    final targetDay =
        DateTime(targetLocal.year, targetLocal.month, targetLocal.day);
    return targetDay.difference(today).inDays;
  }

  String _expiryLabel(int? days) {
    if (days == null) {
      return 'Sin vencimiento';
    }
    if (days < 0) {
      final overdue = days.abs();
      return 'Vencido hace $overdue día${overdue == 1 ? '' : 's'}';
    }
    if (days == 0) {
      return 'Vence hoy';
    }
    if (days <= 30) {
      return 'Próximo a vencer ($days día${days == 1 ? '' : 's'})';
    }
    return 'Normal (vence en $days días)';
  }

  String _movementLabel(String type) {
    switch (type) {
      case 'stock_in':
        return 'Ingreso';
      case 'reservation_create':
        return 'Reserva';
      case 'reservation_cancel':
        return 'Cancelación de reserva';
      case 'sale_confirm':
      case 'sale_direct':
        return 'Venta';
      case 'return_in':
        return 'Devolución';
      case 'stock_adjustment':
        return 'Ajuste';
      default:
        return type;
    }
  }

  String _formatDate(DateTime value) {
    final local = value.toLocal();
    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');
    final year = local.year.toString();
    return '$day/$month/$year';
  }

  String _formatTime(DateTime value) {
    final local = value.toLocal();
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _formatMoney(int cents) {
    final abs = cents.abs();
    final major = abs ~/ 100;
    final minor = (abs % 100).toString().padLeft(2, '0');
    final prefix = cents < 0 ? '-' : '';
    return '$prefix\$$major.$minor';
  }
}
