import 'dart:async';

import 'package:control_stok_celu/data/providers/app_providers.dart';
import 'package:control_stok_celu/domain/stock/stock_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpenseCategoryScreen extends ConsumerStatefulWidget {
  const ExpenseCategoryScreen({super.key});

  @override
  ConsumerState<ExpenseCategoryScreen> createState() =>
      _ExpenseCategoryScreenState();
}

class _ExpenseCategoryScreenState extends ConsumerState<ExpenseCategoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<ExpenseCategoryListItem> _items = <ExpenseCategoryListItem>[];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final items = await ref.read(listExpenseCategoriesUseCaseProvider)(
        search: _searchController.text.trim().isEmpty
            ? null
            : _searchController.text.trim(),
        includeInactive: true,
      );
      setState(() => _items = items);
    } catch (e) {
      setState(() => _error = 'No pudimos cargar categorías.');
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _openForm({ExpenseCategoryListItem? current}) async {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: current?.name ?? '');
    bool isActive = current?.isActive ?? true;

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
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(current == null ? 'Nueva categoría' : 'Editar categoría',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 12),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Nombre *'),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'El nombre es obligatorio.'
                      : null,
                ),
                SwitchListTile(
                    value: isActive,
                    onChanged: (value) => setState(() => isActive = value),
                    title: const Text('Activa')),
                const SizedBox(height: 8),
                FilledButton(
                  onPressed: () async {
                    if (!formKey.currentState!.validate()) {
                      return;
                    }
                    final input = ExpenseCategoryUpsertInput(
                      id: current?.id ??
                          'exp-cat_${DateTime.now().microsecondsSinceEpoch}',
                      name: nameController.text.trim(),
                      isActive: isActive,
                    );
                    if (current == null) {
                      await ref
                          .read(createExpenseCategoryUseCaseProvider)(input);
                    } else {
                      await ref
                          .read(updateExpenseCategoryUseCaseProvider)(input);
                    }
                    if (!mounted) {
                      return;
                    }
                    if (!context.mounted) {
                      return;
                    }
                    Navigator.of(context).pop();
                    await _load();
                  },
                  child: const Text('Guardar'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Categorías de gastos')),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => _load(),
              decoration: const InputDecoration(
                  labelText: 'Buscar categoría', border: OutlineInputBorder()),
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(child: Text(_error!))
                    : _items.isEmpty
                        ? const Center(
                            child: Text('No hay categorías para mostrar.'))
                        : ListView.separated(
                            itemCount: _items.length,
                            separatorBuilder: (_, __) =>
                                const Divider(height: 1),
                            itemBuilder: (context, index) {
                              final item = _items[index];
                              return ListTile(
                                title: Text(item.name),
                                subtitle:
                                    Text(item.isActive ? 'Activa' : 'Inactiva'),
                                trailing: IconButton(
                                  icon: const Icon(Icons.edit_outlined),
                                  onPressed: () => _openForm(current: item),
                                ),
                              );
                            },
                          ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(),
        icon: const Icon(Icons.add),
        label: const Text('Nueva'),
      ),
    );
  }
}
