import 'dart:async';

import 'package:control_stok_celu/data/providers/app_providers.dart';
import 'package:control_stok_celu/data/sync/sync_providers.dart';
import 'package:control_stok_celu/domain/stock/stock_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProductsScreen extends ConsumerStatefulWidget {
  const ProductsScreen({super.key});

  @override
  ConsumerState<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  Timer? _debounce;
  List<ProductSummaryItem> _items = <ProductSummaryItem>[];
  bool _loading = true;
  bool _loadingMore = false;
  bool _hasMore = true;
  String? _error;
  bool _searching = false;

  ProductStatusFilter _status = ProductStatusFilter.active;
  ProductStockFilter _stock = ProductStockFilter.all;
  ProductSortBy _sortBy = ProductSortBy.name;
  bool _descending = false;
  String? _categoryId;
  String? _subcategory;
  bool _offerOnly = false;
  bool _clearanceOnly = false;
  bool _nearExpiryOnly = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    unawaited(_load(reset: true));
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _searchFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _load({required bool reset}) async {
    if (_loadingMore || (!_hasMore && !reset)) {
      return;
    }

    if (reset) {
      setState(() {
        _loading = true;
        _error = null;
        _hasMore = true;
      });
    } else {
      setState(() {
        _loadingMore = true;
      });
    }

    try {
      final useCase = ref.read(listProductsUseCaseProvider);
      final currentItems = reset
          ? <ProductSummaryItem>[]
          : List<ProductSummaryItem>.from(_items);
      final result = await useCase(
        ProductQuery(
          search: _searchController.text.trim().isEmpty
              ? null
              : _searchController.text.trim(),
          categoryId: _categoryId,
          subcategory: _subcategory,
          status: _status,
          stock: _stock,
          onlyOffer: _offerOnly ? true : null,
          onlyClearance: _clearanceOnly ? true : null,
          nearExpiryDays: _nearExpiryOnly ? 30 : null,
          sortBy: _sortBy,
          descending: _descending,
          limit: 40,
          offset: currentItems.length,
        ),
      );

      setState(() {
        _items = <ProductSummaryItem>[...currentItems, ...result];
        _hasMore = result.length == 40;
        _error = null;
      });
    } catch (e) {
      setState(() {
        _error = 'No pudimos cargar productos. $e';
      });
    } finally {
      setState(() {
        _loading = false;
        _loadingMore = false;
        _searching = false;
      });
    }
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }
    final threshold = _scrollController.position.maxScrollExtent - 280;
    if (_scrollController.position.pixels >= threshold) {
      unawaited(_load(reset: false));
    }
  }

  void _onSearchChanged(String _) {
    setState(() {
      _searching = true;
    });
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () {
      unawaited(_load(reset: true));
    });
  }

  Future<void> _setActive(ProductSummaryItem item, bool isActive) async {
    await ref.read(setProductActiveUseCaseProvider)(item.id, isActive);
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text(isActive ? 'Producto reactivado.' : 'Producto desactivado.'),
      ),
    );
    await _load(reset: true);
  }

  Future<void> _logicalDelete(ProductSummaryItem item) async {
    await ref.read(logicalDeleteProductUseCaseProvider)(item.id);
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Producto eliminado lógicamente.')),
    );
    await _load(reset: true);
  }

  Future<void> _openFilters() async {
    final categories =
        await ref.read(listCategoriesUseCaseProvider)(includeInactive: false);
    if (!mounted) {
      return;
    }

    ProductStatusFilter status = _status;
    ProductStockFilter stock = _stock;
    ProductSortBy sortBy = _sortBy;
    bool descending = _descending;
    String? categoryId = _categoryId;
    String? subcategory = _subcategory;
    bool offerOnly = _offerOnly;
    bool clearanceOnly = _clearanceOnly;
    bool nearExpiryOnly = _nearExpiryOnly;

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
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text('Filtros y orden',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<ProductStatusFilter>(
                      initialValue: status,
                      decoration: const InputDecoration(labelText: 'Estado'),
                      items: const <DropdownMenuItem<ProductStatusFilter>>[
                        DropdownMenuItem(
                            value: ProductStatusFilter.active,
                            child: Text('Activos')),
                        DropdownMenuItem(
                            value: ProductStatusFilter.inactive,
                            child: Text('Inactivos')),
                        DropdownMenuItem(
                            value: ProductStatusFilter.all,
                            child: Text('Todos')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setModalState(() => status = value);
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<ProductStockFilter>(
                      initialValue: stock,
                      decoration: const InputDecoration(labelText: 'Stock'),
                      items: const <DropdownMenuItem<ProductStockFilter>>[
                        DropdownMenuItem(
                            value: ProductStockFilter.all,
                            child: Text('Todos')),
                        DropdownMenuItem(
                            value: ProductStockFilter.lowStock,
                            child: Text('Stock bajo')),
                        DropdownMenuItem(
                            value: ProductStockFilter.noStock,
                            child: Text('Sin stock')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setModalState(() => stock = value);
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String?>(
                      initialValue: categoryId,
                      decoration: const InputDecoration(labelText: 'Categoría'),
                      items: <DropdownMenuItem<String?>>[
                        const DropdownMenuItem<String?>(
                            value: null, child: Text('Todas')),
                        ...categories.map(
                          (category) => DropdownMenuItem<String?>(
                            value: category.id,
                            child: Text(category.name),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        setModalState(() => categoryId = value);
                      },
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      initialValue: subcategory,
                      decoration:
                          const InputDecoration(labelText: 'Subcategoría'),
                      onChanged: (value) {
                        setModalState(() => subcategory =
                            value.trim().isEmpty ? null : value.trim());
                      },
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<ProductSortBy>(
                      initialValue: sortBy,
                      decoration:
                          const InputDecoration(labelText: 'Ordenar por'),
                      items: const <DropdownMenuItem<ProductSortBy>>[
                        DropdownMenuItem(
                            value: ProductSortBy.name, child: Text('Nombre')),
                        DropdownMenuItem(
                            value: ProductSortBy.code, child: Text('Código')),
                        DropdownMenuItem(
                            value: ProductSortBy.stock, child: Text('Stock')),
                        DropdownMenuItem(
                            value: ProductSortBy.price, child: Text('Precio')),
                        DropdownMenuItem(
                            value: ProductSortBy.createdAt,
                            child: Text('Fecha creación')),
                        DropdownMenuItem(
                            value: ProductSortBy.updatedAt,
                            child: Text('Fecha modificación')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setModalState(() => sortBy = value);
                        }
                      },
                    ),
                    SwitchListTile(
                      value: descending,
                      title: const Text('Descendente'),
                      onChanged: (value) =>
                          setModalState(() => descending = value),
                    ),
                    SwitchListTile(
                      value: offerOnly,
                      title: const Text('Solo en oferta'),
                      onChanged: (value) =>
                          setModalState(() => offerOnly = value),
                    ),
                    SwitchListTile(
                      value: clearanceOnly,
                      title: const Text('Solo en liquidación'),
                      onChanged: (value) =>
                          setModalState(() => clearanceOnly = value),
                    ),
                    SwitchListTile(
                      value: nearExpiryOnly,
                      title: const Text('Próximo a vencer (30 días)'),
                      onChanged: (value) =>
                          setModalState(() => nearExpiryOnly = value),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Cancelar'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: FilledButton(
                            onPressed: () {
                              setState(() {
                                _status = status;
                                _stock = stock;
                                _sortBy = sortBy;
                                _descending = descending;
                                _categoryId = categoryId;
                                _subcategory = subcategory;
                                _offerOnly = offerOnly;
                                _clearanceOnly = clearanceOnly;
                                _nearExpiryOnly = nearExpiryOnly;
                              });
                              Navigator.pop(context);
                              unawaited(_load(reset: true));
                            },
                            child: const Text('Aplicar'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = ref.watch(isAdminProvider);
    return Scaffold(
      appBar: AppBar(
        leading: Navigator.canPop(context) ? const BackButton() : null,
        title: const Text('Productos'),
        actions: <Widget>[
          IconButton(
            tooltip: 'Buscar',
            onPressed: () {
              FocusScope.of(context).requestFocus(_searchFocusNode);
            },
            icon: const Icon(Icons.search),
          ),
          if (isAdmin)
            IconButton(
              tooltip: 'Categorías',
              onPressed: () => context.push('/categorias'),
              icon: const Icon(Icons.category_outlined),
            ),
          if (isAdmin)
            IconButton(
              tooltip: 'Proveedores',
              onPressed: () => context.push('/proveedores'),
              icon: const Icon(Icons.local_shipping_outlined),
            ),
          if (isAdmin)
            IconButton(
              tooltip: 'Agregar producto',
              onPressed: () => context
                  .push('/productos/nuevo')
                  .then((_) => _load(reset: true)),
              icon: const Icon(Icons.add),
            ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Buscar por código, nombre, marca o descripción',
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
            child: Row(
              children: <Widget>[
                FilledButton.tonalIcon(
                  onPressed: _openFilters,
                  icon: const Icon(Icons.tune),
                  label: const Text('Filtros'),
                ),
                const SizedBox(width: 8),
                if (_categoryId != null ||
                    _subcategory != null ||
                    _offerOnly ||
                    _clearanceOnly ||
                    _nearExpiryOnly)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _categoryId = null;
                        _subcategory = null;
                        _offerOnly = false;
                        _clearanceOnly = false;
                        _nearExpiryOnly = false;
                        _status = ProductStatusFilter.active;
                        _stock = ProductStockFilter.all;
                      });
                      unawaited(_load(reset: true));
                    },
                    child: const Text('Limpiar'),
                  ),
              ],
            ),
          ),
          if (_searching)
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 4, 16, 0),
              child: Row(
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
          Expanded(child: _buildContent(isAdmin)),
        ],
      ),
      floatingActionButton: isAdmin
          ? FloatingActionButton.extended(
              onPressed: () => context
                  .push('/productos/nuevo')
                  .then((_) => _load(reset: true)),
              icon: const Icon(Icons.add),
              label: const Text('Nuevo'),
            )
          : null,
    );
  }

  Widget _buildContent(bool isAdmin) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(_error!, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              FilledButton(
                  onPressed: () => _load(reset: true),
                  child: const Text('Reintentar')),
            ],
          ),
        ),
      );
    }
    if (_items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            _searchController.text.trim().isEmpty
                ? 'Todavía no hay productos cargados.'
                : 'No encontramos productos con esa búsqueda.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return ListView.separated(
      controller: _scrollController,
      itemCount: _items.length + (_loadingMore ? 1 : 0),
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        if (index >= _items.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final item = _items[index];
        return ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          title: Text(item.name, maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                  'Código: ${item.internalCode}${item.brand == null ? '' : ' · ${item.brand}'}'),
              const SizedBox(height: 4),
              Text(
                'Disponible: ${item.stockAvailable} · Reservado: ${item.stockReserved} · Precio: ${_formatMoney(item.salePriceCents)}',
              ),
              if (item.hasLowStock)
                Text(
                  'Alerta: stock bajo',
                  style: TextStyle(
                      color: Colors.orange.shade800,
                      fontWeight: FontWeight.w600),
                ),
              if (item.hasNearExpiry)
                Text(
                  'Próximo a vencer',
                  style: TextStyle(
                      color: Colors.red.shade700, fontWeight: FontWeight.w600),
                ),
            ],
          ),
          trailing: isAdmin
              ? PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      context
                          .push('/productos/${item.id}/editar')
                          .then((_) => _load(reset: true));
                    } else if (value == 'deactivate') {
                      unawaited(_setActive(item, false));
                    } else if (value == 'activate') {
                      unawaited(_setActive(item, true));
                    } else if (value == 'delete') {
                      unawaited(_logicalDelete(item));
                    }
                  },
                  itemBuilder: (context) => <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                        value: 'edit', child: Text('Editar')),
                    PopupMenuItem<String>(
                      value: item.isActive ? 'deactivate' : 'activate',
                      child: Text(item.isActive ? 'Desactivar' : 'Reactivar'),
                    ),
                    const PopupMenuItem<String>(
                        value: 'delete', child: Text('Eliminar lógico')),
                  ],
                )
              : null,
          onTap: () => context
              .push('/productos/${item.id}')
              .then((_) => _load(reset: true)),
        );
      },
    );
  }

  String _formatMoney(int cents) {
    final abs = cents.abs();
    final major = abs ~/ 100;
    final minor = (abs % 100).toString().padLeft(2, '0');
    final prefix = cents < 0 ? '-' : '';
    return '$prefix\$$major.$minor';
  }
}
