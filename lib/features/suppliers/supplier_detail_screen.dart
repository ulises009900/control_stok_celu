import 'package:control_stok_celu/data/providers/app_providers.dart';
import 'package:control_stok_celu/domain/stock/stock_models.dart';
import 'package:control_stok_celu/features/suppliers/suppliers_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SupplierDetailScreen extends ConsumerStatefulWidget {
  const SupplierDetailScreen({required this.supplierId, super.key});

  final String supplierId;

  @override
  ConsumerState<SupplierDetailScreen> createState() =>
      _SupplierDetailScreenState();
}

class _SupplierDetailScreenState extends ConsumerState<SupplierDetailScreen> {
  late Future<SupplierDetailView> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<SupplierDetailView> _load() {
    return ref.read(getSupplierDetailUseCaseProvider)(widget.supplierId);
  }

  Future<void> _toggleStatus(SupplierDetailView detail) async {
    final willDeactivate = detail.isActive;
    if (willDeactivate) {
      final confirmed = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('¿Desactivar proveedor?'),
                content: const Text(
                  'El proveedor seguirá apareciendo en el historial, pero no podrá utilizarse para nuevos ingresos.',
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancelar'),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Desactivar'),
                  ),
                ],
              );
            },
          ) ??
          false;
      if (!confirmed) {
        return;
      }
    }

    await ref.read(suppliersStateProvider.notifier).toggleActive(
          supplier: SupplierListItem(
            id: detail.id,
            name: detail.name,
            legalName: detail.legalName,
            cuit: detail.cuit,
            phone: detail.phone,
            email: detail.email,
            address: detail.address,
            notes: detail.notes,
            isActive: detail.isActive,
            productBatchCount: detail.incomeCount,
          ),
          isActive: !detail.isActive,
        );

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
        leading: Navigator.canPop(context) ? const BackButton() : null,
        title: const Text('Detalle proveedor'),
        actions: <Widget>[
          IconButton(
            tooltip: 'Editar',
            onPressed: () {
              context
                  .push('/proveedores/${widget.supplierId}/editar')
                  .then((_) {
                setState(() {
                  _future = _load();
                });
              });
            },
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),
      body: FutureBuilder<SupplierDetailView>(
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
                        'No pudimos cargar el proveedor. ${snapshot.error ?? ''}'),
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

          return ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              Text(detail.name, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              _line('Razón social', detail.legalName ?? '-'),
              _line('CUIT', detail.cuit ?? '-'),
              _line('Teléfono', detail.phone ?? '-'),
              _line('Email', detail.email ?? '-'),
              _line('Dirección', detail.address ?? '-'),
              _line('Estado', detail.isActive ? 'Activo' : 'Inactivo'),
              _line('Notas', detail.notes ?? '-'),
              const SizedBox(height: 16),
              Text('Resumen', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              _line('Ingresos asociados', '${detail.incomeCount}'),
              _line('Productos asociados', '${detail.associatedProductsCount}'),
              _line(
                'Último ingreso',
                detail.lastIncomeAt == null
                    ? '-'
                    : _formatDateTime(detail.lastIncomeAt!),
              ),
              const SizedBox(height: 16),
              FilledButton.tonalIcon(
                onPressed: () => _toggleStatus(detail),
                icon: Icon(detail.isActive
                    ? Icons.pause_circle_outline
                    : Icons.play_circle_outline),
                label: Text(
                  detail.isActive
                      ? 'Desactivar proveedor'
                      : 'Reactivar proveedor',
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _line(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text('$label: $value'),
    );
  }

  String _formatDateTime(DateTime value) {
    final local = value.toLocal();
    final d = local.day.toString().padLeft(2, '0');
    final m = local.month.toString().padLeft(2, '0');
    final y = local.year.toString();
    final h = local.hour.toString().padLeft(2, '0');
    final min = local.minute.toString().padLeft(2, '0');
    return '$d/$m/$y $h:$min';
  }
}
