import 'dart:async';

import 'package:control_stok_celu/domain/stock/stock_models.dart';
import 'package:control_stok_celu/features/inventory/inventory_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class InventoryScreen extends ConsumerStatefulWidget {
  const InventoryScreen({
    this.initialFilter,
    this.initialSearch,
    super.key,
  });

  final InventoryFilter? initialFilter;
  final String? initialSearch;

  @override
  ConsumerState<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends ConsumerState<InventoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialSearch != null) {
        _searchController.text = widget.initialSearch!;
      }
      ref.read(inventoryStateProvider.notifier).applyRouteQuery(
            filter: widget.initialFilter,
            search: widget.initialSearch,
          );
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }
    final threshold = _scrollController.position.maxScrollExtent - 220;
    if (_scrollController.position.pixels >= threshold) {
      ref.read(inventoryStateProvider.notifier).loadMore();
    }
  }

  void _onSearchChanged(String value) {
    final notifier = ref.read(inventoryStateProvider.notifier);
    notifier.setSearching();

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () {
      notifier.setSearch(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(inventoryStateProvider);

    return Scaffold(
      appBar: AppBar(
        leading: Navigator.canPop(context) ? const BackButton() : null,
        title: const Text('Inventario'),
      ),
      body: Column(
        children: <Widget>[
          _InventorySummaryBar(summary: state.summary),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                labelText: 'Buscar producto',
                hintText: 'Nombre, codigo o codigo de barras',
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
          _InventoryFilters(state: state),
          _InventorySortBar(state: state),
          if (state.isSearching)
            const Padding(
              padding: EdgeInsets.only(top: 6),
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
          const SizedBox(height: 6),
          Expanded(child: _buildContent(state)),
        ],
      ),
    );
  }

  Widget _buildContent(InventoryState state) {
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
                  ref.read(inventoryStateProvider.notifier).loadInitial();
                },
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    if (state.items.isEmpty) {
      final isEmptyData =
          !state.hasSearch && state.query.filter == InventoryFilter.all;
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            isEmptyData
                ? 'No hay productos en el inventario.'
                : 'No hay productos que coincidan con este filtro.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(inventoryStateProvider.notifier).loadInitial(),
      child: ListView.separated(
        controller: _scrollController,
        padding: const EdgeInsets.only(bottom: 20),
        itemCount: state.items.length + (state.isLoadingMore ? 1 : 0),
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          if (index >= state.items.length) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          final item = state.items[index];
          return ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            title: Text(item.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                    '${item.internalCode} · ${item.categoryName ?? 'Sin categoria'}'),
                const SizedBox(height: 4),
                Text(
                  'Disponible: ${item.stockAvailable} · Total: ${item.stockTotal} · Reservado: ${item.stockReserved}',
                ),
                Text(
                    'Minimo: ${item.stockMin}${item.stockMax == null ? '' : ' · Maximo: ${item.stockMax}'}'),
                Text('Stock: ${_stockStateLabel(item.stockState)}'),
                Text(
                    'Vencimiento: ${_expiryLabel(item.expiryState, item.nextRelevantExpiry)}'),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: () async {
                      final changed = await context
                          .push<bool>('/productos/${item.id}/movimiento');
                      if (changed == true && mounted) {
                        await ref
                            .read(inventoryStateProvider.notifier)
                            .loadInitial();
                      }
                    },
                    icon: const Icon(Icons.swap_horiz_outlined),
                    label: const Text('Movimiento'),
                  ),
                ),
              ],
            ),
            trailing: Text(
              '${item.stockAvailable}',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            onTap: () => context.push('/productos/${item.id}'),
          );
        },
      ),
    );
  }

  String _stockStateLabel(InventoryStockState state) {
    switch (state) {
      case InventoryStockState.noStock:
        return 'Sin stock';
      case InventoryStockState.lowStock:
        return 'Stock bajo';
      case InventoryStockState.normal:
        return 'Normal';
      case InventoryStockState.overStock:
        return 'Sobre stock';
    }
  }

  String _expiryLabel(InventoryExpiryState state, DateTime? date) {
    if (state == InventoryExpiryState.noExpiry) {
      return 'Sin fecha';
    }
    final formatted = date == null ? '-' : _formatDate(date);
    switch (state) {
      case InventoryExpiryState.noExpiry:
        return 'Sin fecha';
      case InventoryExpiryState.normal:
        return 'Normal ($formatted)';
      case InventoryExpiryState.nearExpiry:
        return 'Proximo a vencer ($formatted)';
      case InventoryExpiryState.dueToday:
        return 'Vence hoy ($formatted)';
      case InventoryExpiryState.expired:
        return 'Vencido ($formatted)';
    }
  }

  String _formatDate(DateTime date) {
    final d = date.toLocal();
    final day = d.day.toString().padLeft(2, '0');
    final month = d.month.toString().padLeft(2, '0');
    return '$day/$month/${d.year}';
  }
}

class _InventorySummaryBar extends StatelessWidget {
  const _InventorySummaryBar({required this.summary});

  final InventorySummaryView? summary;

  @override
  Widget build(BuildContext context) {
    if (summary == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 2),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: <Widget>[
          _SummaryPill(label: 'Productos', value: summary!.totalProducts),
          _SummaryPill(label: 'Sin stock', value: summary!.noStockCount),
          _SummaryPill(label: 'Stock bajo', value: summary!.lowStockCount),
          _SummaryPill(
              label: 'Prox. a vencer', value: summary!.nearExpiryCount),
          _SummaryPill(label: 'Vencidos', value: summary!.expiredCount),
          _SummaryPill(label: 'Sobre stock', value: summary!.overStockCount),
        ],
      ),
    );
  }
}

class _SummaryPill extends StatelessWidget {
  const _SummaryPill({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(label),
          const SizedBox(width: 6),
          Text(
            '$value',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _InventoryFilters extends ConsumerWidget {
  const _InventoryFilters({required this.state});

  final InventoryState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: InventoryFilter.values.map((filter) {
          final selected = state.query.filter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(_label(filter)),
              selected: selected,
              onSelected: (_) {
                ref.read(inventoryStateProvider.notifier).setFilter(filter);
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  String _label(InventoryFilter filter) {
    switch (filter) {
      case InventoryFilter.all:
        return 'Todos';
      case InventoryFilter.noStock:
        return 'Sin stock';
      case InventoryFilter.lowStock:
        return 'Stock bajo';
      case InventoryFilter.normal:
        return 'Normal';
      case InventoryFilter.overStock:
        return 'Sobre stock';
      case InventoryFilter.nearExpiry:
        return 'Prox. a vencer';
      case InventoryFilter.expired:
        return 'Vencido';
    }
  }
}

class _InventorySortBar extends ConsumerWidget {
  const _InventorySortBar({required this.state});

  final InventoryState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 6),
      child: Row(
        children: <Widget>[
          Expanded(
            child: DropdownButtonFormField<InventorySortBy>(
              initialValue: state.query.sortBy,
              decoration: const InputDecoration(
                labelText: 'Ordenar por',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              items: const <DropdownMenuItem<InventorySortBy>>[
                DropdownMenuItem(
                  value: InventorySortBy.name,
                  child: Text('Nombre'),
                ),
                DropdownMenuItem(
                  value: InventorySortBy.stockAvailable,
                  child: Text('Stock disponible'),
                ),
                DropdownMenuItem(
                  value: InventorySortBy.stockReserved,
                  child: Text('Stock reservado'),
                ),
                DropdownMenuItem(
                  value: InventorySortBy.nextExpiry,
                  child: Text('Proximo vencimiento'),
                ),
                DropdownMenuItem(
                  value: InventorySortBy.updatedAt,
                  child: Text('Actualizacion'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  ref.read(inventoryStateProvider.notifier).setSort(value);
                }
              },
            ),
          ),
          const SizedBox(width: 8),
          IconButton.filledTonal(
            tooltip: state.query.descending ? 'Descendente' : 'Ascendente',
            onPressed: () {
              ref.read(inventoryStateProvider.notifier).toggleDescending();
            },
            icon: Icon(
              state.query.descending
                  ? Icons.arrow_downward_outlined
                  : Icons.arrow_upward_outlined,
            ),
          ),
        ],
      ),
    );
  }
}
