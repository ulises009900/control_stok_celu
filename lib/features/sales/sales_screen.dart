import 'dart:async';

import 'package:control_stok_celu/data/providers/app_providers.dart';
import 'package:control_stok_celu/domain/stock/stock_models.dart';
import 'package:control_stok_celu/features/sales/sales_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SalesScreen extends ConsumerStatefulWidget {
  const SalesScreen({super.key});

  @override
  ConsumerState<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends ConsumerState<SalesScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(salesStateProvider.notifier).load();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    final notifier = ref.read(salesStateProvider.notifier);
    notifier.setSearching();
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () {
      notifier.setSearch(value);
    });
  }

  Future<void> _openFilters() async {
    final customers =
        await ref.read(listCustomersUseCaseProvider)(includeInactive: true);
    if (!mounted) {
      return;
    }
    final state = ref.read(salesStateProvider);
    SaleStatusFilter status = state.query.status;
    String? customerId = state.query.customerId;
    DashboardPeriod period = state.query.period;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  DropdownButtonFormField<SaleStatusFilter>(
                    initialValue: status,
                    decoration: const InputDecoration(labelText: 'Estado'),
                    items: const <DropdownMenuItem<SaleStatusFilter>>[
                      DropdownMenuItem(
                          value: SaleStatusFilter.all, child: Text('Todos')),
                      DropdownMenuItem(
                          value: SaleStatusFilter.draft, child: Text('Draft')),
                      DropdownMenuItem(
                          value: SaleStatusFilter.sold, child: Text('Sold')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setModalState(() => status = value);
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String?>(
                    initialValue: customerId,
                    decoration: const InputDecoration(labelText: 'Cliente'),
                    items: <DropdownMenuItem<String?>>[
                      const DropdownMenuItem<String?>(
                          value: null, child: Text('Todos')),
                      ...customers.map(
                        (customer) => DropdownMenuItem<String?>(
                          value: customer.id,
                          child: Text(customer.name),
                        ),
                      ),
                    ],
                    onChanged: (value) =>
                        setModalState(() => customerId = value),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<DashboardPeriod>(
                    initialValue: period,
                    decoration: const InputDecoration(labelText: 'Período'),
                    items: const <DropdownMenuItem<DashboardPeriod>>[
                      DropdownMenuItem(
                          value: DashboardPeriod.today, child: Text('Hoy')),
                      DropdownMenuItem(
                          value: DashboardPeriod.last7Days,
                          child: Text('Últimos 7 días')),
                      DropdownMenuItem(
                          value: DashboardPeriod.thisMonth,
                          child: Text('Este mes')),
                      DropdownMenuItem(
                          value: DashboardPeriod.previousMonth,
                          child: Text('Mes anterior')),
                      DropdownMenuItem(
                          value: DashboardPeriod.thisYear,
                          child: Text('Este año')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setModalState(() => period = value);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      final notifier = ref.read(salesStateProvider.notifier);
                      await notifier.setCustomer(customerId);
                      await notifier.setStatus(status);
                      await notifier.setPeriod(period);
                    },
                    child: const Text('Aplicar'),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(salesStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ventas'),
        actions: <Widget>[
          IconButton(
            tooltip: 'Filtros',
            onPressed: _openFilters,
            icon: const Icon(Icons.tune),
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
                labelText: 'Buscar venta',
                hintText: 'Cliente o ID',
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
          if (state.isSearching)
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
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
          Expanded(child: _buildContent(state)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/sales/new').then((value) {
          if (value == true) {
            ref.read(salesStateProvider.notifier).load();
          }
        }),
        icon: const Icon(Icons.add),
        label: const Text('Nueva venta'),
      ),
    );
  }

  Widget _buildContent(SalesState state) {
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
                onPressed: () => ref.read(salesStateProvider.notifier).load(),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }
    if (state.items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            (state.query.search ?? '').trim().isEmpty
                ? 'No hay ventas para mostrar.'
                : 'No encontramos ventas con esa búsqueda.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(salesStateProvider.notifier).load(),
      child: ListView.separated(
        itemCount: state.items.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final sale = state.items[index];
          return ListTile(
            title: Text(sale.customerName ?? 'Sin cliente'),
            subtitle: Text(
              '${sale.id} · ${sale.status} · ${_formatDate(sale.confirmedAt ?? sale.createdAt)}\n'
              '${sale.productCount} productos · ${sale.unitsCount} unidades',
            ),
            trailing: Text(_formatMoney(sale.totalCents)),
            onTap: () => context.push('/sales/${sale.id}').then((value) {
              if (value == true) {
                ref.read(salesStateProvider.notifier).load();
              }
            }),
          );
        },
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
  return '$day/$month/${local.year}';
}
