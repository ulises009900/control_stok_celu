import 'dart:async';

import 'package:control_stok_celu/data/providers/app_providers.dart';
import 'package:control_stok_celu/domain/stock/stock_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CustomersScreen extends ConsumerStatefulWidget {
  const CustomersScreen({super.key});

  @override
  ConsumerState<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends ConsumerState<CustomersScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  bool _loading = true;
  String? _error;
  List<CustomerListItem> _items = <CustomerListItem>[];
  bool _includeInactive = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final items = await ref.read(listCustomersUseCaseProvider)(
        search: _searchController.text.trim().isEmpty
            ? null
            : _searchController.text.trim(),
        includeInactive: _includeInactive,
      );
      setState(() => _items = items);
    } catch (e) {
      setState(() => _error = 'No pudimos cargar clientes. $e');
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  void _onSearchChanged(String _) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), _load);
  }

  Future<void> _toggle(CustomerListItem item) async {
    await ref.read(setCustomerActiveUseCaseProvider)(item.id, !item.isActive);
    if (!mounted) {
      return;
    }
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clientes')),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                labelText: 'Buscar cliente',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isEmpty
                    ? null
                    : IconButton(
                        onPressed: () {
                          _searchController.clear();
                          _load();
                          setState(() {});
                        },
                        icon: const Icon(Icons.close),
                      ),
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          SwitchListTile(
            value: _includeInactive,
            onChanged: (value) {
              setState(() => _includeInactive = value);
              _load();
            },
            title: const Text('Incluir inactivos'),
          ),
          Expanded(child: _buildContent()),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/customers/new').then((value) {
          if (value == true) {
            _load();
          }
        }),
        icon: const Icon(Icons.add),
        label: const Text('Nuevo cliente'),
      ),
    );
  }

  Widget _buildContent() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(child: Text(_error!));
    }
    if (_items.isEmpty) {
      return const Center(child: Text('No hay clientes para mostrar.'));
    }
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.separated(
        itemCount: _items.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final item = _items[index];
          return ListTile(
            title: Text(item.name),
            subtitle: Text(
              [
                if ((item.phone ?? '').isNotEmpty) item.phone!,
                if ((item.email ?? '').isNotEmpty) item.email!,
                if ((item.document ?? '').isNotEmpty) item.document!,
                item.isActive ? 'Activo' : 'Inactivo',
              ].join(' · '),
            ),
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  context.push('/customers/${item.id}/edit').then((saved) {
                    if (saved == true) {
                      _load();
                    }
                  });
                } else {
                  _toggle(item);
                }
              },
              itemBuilder: (context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'edit',
                  child: Text('Editar'),
                ),
                PopupMenuItem<String>(
                  value: 'toggle',
                  child: Text(item.isActive ? 'Desactivar' : 'Reactivar'),
                ),
              ],
            ),
            onTap: () => context.push('/customers/${item.id}'),
          );
        },
      ),
    );
  }
}
