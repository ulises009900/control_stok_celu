import 'dart:async';

import 'package:control_stok_celu/data/providers/app_providers.dart';
import 'package:control_stok_celu/domain/stock/stock_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoriesScreen extends ConsumerStatefulWidget {
  const CategoriesScreen({super.key});

  @override
  ConsumerState<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  Timer? _debounce;
  bool _loading = true;
  String? _error;
  List<CategoryListItem> _items = <CategoryListItem>[];

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _searchController.clear();
    _onSearchChanged('');
  }

  void _onSearchChanged(String _) {
    setState(() {});
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () {
      _load();
    });
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await ref.read(listCategoriesUseCaseProvider)(
        search: _searchController.text.trim().isEmpty
            ? null
            : _searchController.text.trim(),
        includeInactive: true,
      );
      setState(() {
        _items = data;
      });
    } catch (e) {
      setState(() {
        _error = 'No pudimos cargar categorías. $e';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _openForm({CategoryListItem? current}) async {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: current?.name ?? '');
    String? parentId = current?.parentId;
    bool isActive = current?.isActive ?? true;

    final categories =
        await ref.read(listCategoriesUseCaseProvider)(includeInactive: true);
    if (!mounted) {
      return;
    }

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
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                          current == null
                              ? 'Nueva categoría'
                              : 'Editar categoría',
                          style: Theme.of(context).textTheme.titleMedium),
                      TextFormField(
                        controller: nameController,
                        decoration:
                            const InputDecoration(labelText: 'Nombre *'),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                                ? 'El nombre es obligatorio'
                                : null,
                      ),
                      DropdownButtonFormField<String?>(
                        initialValue: parentId,
                        decoration:
                            const InputDecoration(labelText: 'Categoría padre'),
                        items: <DropdownMenuItem<String?>>[
                          const DropdownMenuItem<String?>(
                              value: null, child: Text('Sin padre')),
                          ...categories
                              .where((item) =>
                                  current == null || item.id != current.id)
                              .map(
                                (item) => DropdownMenuItem<String?>(
                                  value: item.id,
                                  child: Text(item.name),
                                ),
                              ),
                        ],
                        onChanged: (value) =>
                            setModalState(() => parentId = value),
                      ),
                      SwitchListTile(
                        value: isActive,
                        onChanged: (value) =>
                            setModalState(() => isActive = value),
                        title: const Text('Activa'),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancelar'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: FilledButton(
                              onPressed: () async {
                                if (!formKey.currentState!.validate()) {
                                  return;
                                }
                                final input = CategoryUpsertInput(
                                  id: current?.id ??
                                      'cat_${DateTime.now().microsecondsSinceEpoch}',
                                  name: nameController.text.trim(),
                                  parentId: parentId,
                                  isActive: isActive,
                                );
                                if (current == null) {
                                  await ref.read(createCategoryUseCaseProvider)(
                                      input);
                                } else {
                                  await ref.read(updateCategoryUseCaseProvider)(
                                      input);
                                }
                                if (!mounted) {
                                  return;
                                }
                                Navigator.of(this.context).pop();
                                _load();
                              },
                              child: const Text('Guardar'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _toggle(CategoryListItem item) async {
    await ref.read(setCategoryActiveUseCaseProvider)(item.id, !item.isActive);
    if (!mounted) {
      return;
    }
    _load();
  }

  CategoryListItem? _findCategoryById(String id) {
    for (final item in _items) {
      if (item.id == id) {
        return item;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Navigator.canPop(context) ? const BackButton() : null,
        title: const Text('Categorías'),
        actions: <Widget>[
          IconButton(
            onPressed: () => _openForm(),
            icon: const Icon(Icons.add),
            tooltip: 'Agregar categoría',
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                labelText: 'Buscar categoría',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isEmpty
                    ? null
                    : IconButton(
                        onPressed: _clearSearch,
                        icon: const Icon(Icons.close),
                      ),
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(child: Text(_error!))
                    : _items.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Text(
                                _searchController.text.trim().isEmpty
                                    ? 'No hay categorías para mostrar.'
                                    : 'No encontramos categorías con esa búsqueda.',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.only(bottom: 16),
                            itemCount: _items.length,
                            separatorBuilder: (_, __) =>
                                const Divider(height: 1),
                            itemBuilder: (context, index) {
                              final item = _items[index];
                              final parent = item.parentId == null
                                  ? null
                                  : _findCategoryById(item.parentId!);
                              return ListTile(
                                title: Text(item.name),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      '${item.productCount} producto${item.productCount == 1 ? '' : 's'} · ${item.isActive ? 'Activa' : 'Inactiva'}',
                                    ),
                                    if (item.parentId != null)
                                      Text(
                                          parent == null
                                              ? 'Subcategoría'
                                              : 'Subcategoría de ${parent.name}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall),
                                  ],
                                ),
                                trailing: PopupMenuButton<String>(
                                  onSelected: (value) {
                                    if (value == 'edit') {
                                      _openForm(current: item);
                                    } else {
                                      _toggle(item);
                                    }
                                  },
                                  itemBuilder: (context) =>
                                      <PopupMenuEntry<String>>[
                                    const PopupMenuItem<String>(
                                        value: 'edit', child: Text('Editar')),
                                    PopupMenuItem<String>(
                                      value: 'toggle',
                                      child: Text(item.isActive
                                          ? 'Desactivar'
                                          : 'Reactivar'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}
