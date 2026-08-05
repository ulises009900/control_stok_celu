import 'dart:async';

import 'package:control_stok_celu/domain/stock/stock_models.dart';
import 'package:control_stok_celu/features/suppliers/suppliers_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SuppliersScreen extends ConsumerStatefulWidget {
  const SuppliersScreen({super.key});

  @override
  ConsumerState<SuppliersScreen> createState() => _SuppliersScreenState();
}

class _SuppliersScreenState extends ConsumerState<SuppliersScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(suppliersStateProvider.notifier).loadSuppliers();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    final notifier = ref.read(suppliersStateProvider.notifier);
    notifier.setSearchQuery(value);
    notifier.setSearching();

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () {
      notifier.loadSuppliers();
    });
  }

  Future<void> _confirmToggle(SupplierListItem supplier) async {
    final notifier = ref.read(suppliersStateProvider.notifier);

    if (supplier.isActive) {
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

    await notifier.toggleActive(
      supplier: supplier,
      isActive: !supplier.isActive,
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<SuppliersState>(suppliersStateProvider, (previous, next) {
      if (!mounted) {
        return;
      }
      if (next.successMessage != null &&
          next.successMessage != previous?.successMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.successMessage!)),
        );
        ref.read(suppliersStateProvider.notifier).clearFeedback();
      }
      if (next.errorMessage != null &&
          next.errorMessage != previous?.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage!)),
        );
      }
    });

    final state = ref.watch(suppliersStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Proveedores'),
        actions: <Widget>[
          IconButton(
            tooltip: 'Nuevo proveedor',
            onPressed: () {
              context.push('/proveedores/nuevo').then((saved) {
                if (saved == true) {
                  ref.read(suppliersStateProvider.notifier).loadSuppliers();
                }
              });
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                labelText: 'Buscar proveedor',
                hintText: 'Nombre, razón social, CUIT, teléfono o email',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isEmpty
                    ? null
                    : IconButton(
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged('');
                          setState(() {});
                        },
                        icon: const Icon(Icons.close),
                      ),
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SegmentedButton<SupplierStatusFilter>(
              segments: const <ButtonSegment<SupplierStatusFilter>>[
                ButtonSegment<SupplierStatusFilter>(
                  value: SupplierStatusFilter.active,
                  label: Text('Activos'),
                ),
                ButtonSegment<SupplierStatusFilter>(
                  value: SupplierStatusFilter.inactive,
                  label: Text('Inactivos'),
                ),
                ButtonSegment<SupplierStatusFilter>(
                  value: SupplierStatusFilter.all,
                  label: Text('Todos'),
                ),
              ],
              selected: <SupplierStatusFilter>{state.statusFilter},
              onSelectionChanged: (selection) {
                ref
                    .read(suppliersStateProvider.notifier)
                    .setFilter(selection.first);
              },
            ),
          ),
          if (state.isSearching)
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 8),
                  Text('Buscando...'),
                ],
              ),
            ),
          const SizedBox(height: 8),
          Expanded(child: _buildContent(state)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push('/proveedores/nuevo').then((saved) {
            if (saved == true) {
              ref.read(suppliersStateProvider.notifier).loadSuppliers();
            }
          });
        },
        icon: const Icon(Icons.add),
        label: const Text('Nuevo'),
      ),
    );
  }

  Widget _buildContent(SuppliersState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.errorMessage != null && state.items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(state.errorMessage!, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () {
                  ref.read(suppliersStateProvider.notifier).loadSuppliers();
                },
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    if (state.items.isEmpty) {
      if (state.hasSearch) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'No encontramos proveedores con esa búsqueda.',
              textAlign: TextAlign.center,
            ),
          ),
        );
      }
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'No hay proveedores para mostrar.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () =>
          ref.read(suppliersStateProvider.notifier).loadSuppliers(),
      child: ListView.separated(
        padding: const EdgeInsets.only(bottom: 16),
        itemCount: state.items.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final supplier = state.items[index];
          return ListTile(
            title: Text(supplier.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  [
                    if (supplier.legalName != null &&
                        supplier.legalName!.isNotEmpty)
                      supplier.legalName!,
                    if (supplier.cuit != null && supplier.cuit!.isNotEmpty)
                      supplier.cuit!,
                  ].join(' · ').isEmpty
                      ? 'Sin razón social ni CUIT'
                      : [
                          if (supplier.legalName != null &&
                              supplier.legalName!.isNotEmpty)
                            supplier.legalName!,
                          if (supplier.cuit != null &&
                              supplier.cuit!.isNotEmpty)
                            supplier.cuit!,
                        ].join(' · '),
                ),
                Text(
                  [
                    if (supplier.phone != null && supplier.phone!.isNotEmpty)
                      supplier.phone!,
                    if (supplier.email != null && supplier.email!.isNotEmpty)
                      supplier.email!,
                  ].join(' · ').isEmpty
                      ? 'Sin teléfono ni email'
                      : [
                          if (supplier.phone != null &&
                              supplier.phone!.isNotEmpty)
                            supplier.phone!,
                          if (supplier.email != null &&
                              supplier.email!.isNotEmpty)
                            supplier.email!,
                        ].join(' · '),
                ),
                Text(
                  '${supplier.isActive ? 'Activo' : 'Inactivo'} · ${supplier.productBatchCount} ingreso${supplier.productBatchCount == 1 ? '' : 's'}',
                ),
              ],
            ),
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  context
                      .push('/proveedores/${supplier.id}/editar')
                      .then((saved) {
                    if (saved == true) {
                      ref.read(suppliersStateProvider.notifier).loadSuppliers();
                    }
                  });
                  return;
                }
                if (value == 'toggle') {
                  _confirmToggle(supplier);
                }
              },
              itemBuilder: (context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'edit',
                  child: Text('Editar'),
                ),
                PopupMenuItem<String>(
                  value: 'toggle',
                  child: Text(supplier.isActive ? 'Desactivar' : 'Reactivar'),
                ),
              ],
            ),
            onTap: () => context.push('/proveedores/${supplier.id}'),
          );
        },
      ),
    );
  }
}
