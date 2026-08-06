import 'dart:async';

import 'package:control_stok_celu/core/errors/app_exception.dart';
import 'package:control_stok_celu/data/providers/app_providers.dart';
import 'package:control_stok_celu/domain/stock/stock_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpensesScreen extends ConsumerStatefulWidget {
  const ExpensesScreen({
    this.initialPeriod = ExpensePeriod.thisMonth,
    super.key,
  });

  final ExpensePeriod initialPeriod;

  @override
  ConsumerState<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends ConsumerState<ExpensesScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  List<ExpenseListItem> _items = <ExpenseListItem>[];
  bool _loading = true;
  bool _saving = false;
  String? _error;
  late ExpensePeriod _period;
  String? _categoryId;
  String? _supplierId;

  @override
  void initState() {
    super.initState();
    _period = widget.initialPeriod;
    unawaited(_load(reset: true));
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String _) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () {
      unawaited(_load(reset: true));
    });
  }

  Future<void> _load({required bool reset}) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final query = ExpenseQuery(
        search: _searchController.text.trim().isEmpty
            ? null
            : _searchController.text.trim(),
        period: _period,
        categoryId: _categoryId,
        supplierId: _supplierId,
      );
      final items = await ref.read(listExpensesUseCaseProvider)(query);
      setState(() {
        _items = items;
      });
    } catch (e) {
      setState(() {
        _error = 'No pudimos cargar gastos. $e';
      });
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _openForm({ExpenseListItem? current}) async {
    final formKey = GlobalKey<FormState>();
    final descriptionController =
        TextEditingController(text: current?.description ?? '');
    final amountController = TextEditingController(
        text: current == null ? '' : '${current.amountCents.abs() / 100}');
    final notesController = TextEditingController(text: current?.notes ?? '');
    final occurredAtController = TextEditingController(
        text: current == null
            ? DateTime.now().toIso8601String().split('T').first
            : current.occurredAt.toIso8601String().split('T').first);
    String? categoryId;
    String? supplierId;
    String entryType =
        current != null && current.amountCents < 0 ? 'income' : 'expense';
    final categories = await ref.read(listExpenseCategoriesUseCaseProvider)(
        includeInactive: false);
    final suppliers =
        await ref.read(listSuppliersUseCaseProvider)(includeInactive: false);

    if (!mounted) {
      return;
    }

    final defaultCategoryId = categories
        .where((item) => item.name.toLowerCase() == 'sin categoría')
        .map((item) => item.id)
        .firstOrNull;
    categoryId ??= current?.categoryId ?? defaultCategoryId;

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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        current == null ? 'Nuevo gasto' : 'Editar gasto',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: descriptionController,
                        decoration:
                            const InputDecoration(labelText: 'Descripción *'),
                        validator: (value) =>
                            (value == null || value.trim().isEmpty)
                                ? 'La descripción es obligatoria.'
                                : null,
                      ),
                      DropdownButtonFormField<String>(
                        initialValue: categoryId ?? current?.categoryId,
                        decoration:
                            const InputDecoration(labelText: 'Categoría *'),
                        items: categories
                            .map((item) => DropdownMenuItem<String>(
                                value: item.id, child: Text(item.name)))
                            .toList(),
                        onChanged: (value) =>
                            setModalState(() => categoryId = value),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Seleccione una categoría.'
                            : null,
                      ),
                      DropdownButtonFormField<String>(
                        initialValue: entryType,
                        decoration: const InputDecoration(labelText: 'Tipo'),
                        items: const <DropdownMenuItem<String>>[
                          DropdownMenuItem<String>(
                              value: 'expense', child: Text('Gasto')),
                          DropdownMenuItem<String>(
                              value: 'income', child: Text('Ingreso')),
                        ],
                        onChanged: (value) =>
                            setModalState(() => entryType = value ?? 'expense'),
                      ),
                      TextFormField(
                        controller: amountController,
                        decoration:
                            const InputDecoration(labelText: 'Importe *'),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'El importe es obligatorio.';
                          }
                          final parsed =
                              double.tryParse(value.replaceAll(',', '.'));
                          if (parsed == null || parsed <= 0) {
                            return 'El importe debe ser mayor a cero.';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: occurredAtController,
                        decoration: const InputDecoration(labelText: 'Fecha *'),
                        validator: (value) =>
                            (value == null || value.trim().isEmpty)
                                ? 'La fecha es obligatoria.'
                                : null,
                      ),
                      DropdownButtonFormField<String?>(
                        initialValue: supplierId,
                        decoration:
                            const InputDecoration(labelText: 'Proveedor'),
                        items: <DropdownMenuItem<String?>>[
                          const DropdownMenuItem<String?>(
                              value: null, child: Text('Sin proveedor')),
                          ...suppliers.map((item) => DropdownMenuItem<String?>(
                              value: item.id, child: Text(item.name))),
                        ],
                        onChanged: (value) =>
                            setModalState(() => supplierId = value),
                      ),
                      TextFormField(
                        controller: notesController,
                        decoration: const InputDecoration(labelText: 'Nota'),
                        minLines: 2,
                        maxLines: 4,
                      ),
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        onPressed: () async {
                          final navigator = Navigator.of(context);
                          final messenger = ScaffoldMessenger.of(context);
                          if (!formKey.currentState!.validate()) {
                            return;
                          }
                          setState(() => _saving = true);
                          try {
                            final amountCents = ((double.parse(amountController
                                        .text
                                        .replaceAll(',', '.')) *
                                    100)
                                .round());
                            final signedAmountCents = entryType == 'income'
                                ? -amountCents
                                : amountCents;
                            final input = ExpenseUpsertInput(
                              id: current?.id ??
                                  'exp_${DateTime.now().microsecondsSinceEpoch}',
                              description: descriptionController.text.trim(),
                              categoryId:
                                  categoryId ?? current?.categoryId ?? '',
                              amountCents: signedAmountCents,
                              occurredAt: occurredAtController.text.trim(),
                              supplierId: supplierId,
                              notes: notesController.text.trim().isEmpty
                                  ? null
                                  : notesController.text.trim(),
                            );
                            if (current == null) {
                              await ref
                                  .read(createExpenseUseCaseProvider)(input);
                            } else {
                              await ref
                                  .read(updateExpenseUseCaseProvider)(input);
                            }
                            if (!mounted) {
                              return;
                            }
                            navigator.pop();
                            await _load(reset: true);
                          } catch (e) {
                            if (!mounted) {
                              return;
                            }
                            messenger.showSnackBar(
                              SnackBar(
                                  content: Text(e is AppException
                                      ? e.message
                                      : 'No se pudo guardar el gasto.')),
                            );
                          } finally {
                            if (mounted) {
                              setState(() => _saving = false);
                            }
                          }
                        },
                        icon: _saving
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2))
                            : const Icon(Icons.save_outlined),
                        label: Text(_saving ? 'Guardando...' : 'Guardar gasto'),
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

  Future<void> _delete(ExpenseListItem item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar gasto'),
        content: const Text('¿Desea eliminar lógicamente este gasto?'),
        actions: <Widget>[
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar')),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Eliminar')),
        ],
      ),
    );
    if (confirmed != true) {
      return;
    }
    await ref.read(logicalDeleteExpenseUseCaseProvider)(item.id);
    if (!mounted) {
      return;
    }
    await _load(reset: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Navigator.canPop(context) ? const BackButton() : null,
        title: const Text('Gastos'),
        actions: <Widget>[
          IconButton(
            tooltip: 'Nuevo gasto',
            onPressed: () => _openForm(),
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
              decoration: const InputDecoration(
                labelText: 'Buscar gasto',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          FutureBuilder<ExpenseSummaryView>(
            future: ref.read(getExpenseSummaryUseCaseProvider)(ExpenseQuery(
                period: _period,
                categoryId: _categoryId,
                supplierId: _supplierId)),
            builder: (context, snapshot) {
              final summary = snapshot.data;
              if (summary == null) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .surfaceContainerHighest
                        .withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child:
                              _summaryTile('Total', summary.totalAmountCents)),
                      Expanded(child: _summaryTile('Cantidad', summary.count)),
                    ],
                  ),
                ),
              );
            },
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(child: Text(_error!))
                    : _items.isEmpty
                        ? const Center(
                            child: Text('No hay gastos para mostrar.'))
                        : ListView.separated(
                            itemCount: _items.length,
                            separatorBuilder: (_, __) =>
                                const Divider(height: 1),
                            itemBuilder: (context, index) {
                              final item = _items[index];
                              return ListTile(
                                title: Text(item.description),
                                subtitle: Text(
                                    '${item.categoryName} · ${item.amountCents < 0 ? 'Ingreso' : 'Gasto'} · ${_formatMoney(item.amountCents.abs())}'),
                                trailing: PopupMenuButton<String>(
                                  onSelected: (value) {
                                    if (value == 'edit') {
                                      _openForm(current: item);
                                    } else if (value == 'delete') {
                                      _delete(item);
                                    }
                                  },
                                  itemBuilder: (context) =>
                                      const <PopupMenuEntry<String>>[
                                    PopupMenuItem<String>(
                                        value: 'edit', child: Text('Editar')),
                                    PopupMenuItem<String>(
                                        value: 'delete',
                                        child: Text('Eliminar')),
                                  ],
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
        label: const Text('Nuevo'),
      ),
    );
  }

  Widget _summaryTile(String label, int value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: 4),
        Text(label == 'Total' ? _formatMoney(value) : value.toString()),
      ],
    );
  }

  String _formatMoney(int cents) {
    final dollars = cents / 100;
    return '\$${dollars.toStringAsFixed(2)}';
  }
}
