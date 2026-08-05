import 'dart:async';

import 'package:control_stok_celu/data/providers/app_providers.dart';
import 'package:control_stok_celu/domain/stock/stock_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class SaleFormScreen extends ConsumerStatefulWidget {
  const SaleFormScreen({required this.saleId, super.key});

  final String? saleId;

  bool get isEdit => saleId != null;

  @override
  ConsumerState<SaleFormScreen> createState() => _SaleFormScreenState();
}

class _SaleFormScreenState extends ConsumerState<SaleFormScreen> {
  static const Uuid _uuid = Uuid();

  final TextEditingController _notesController = TextEditingController();
  bool _loading = true;
  bool _saving = false;
  String? _error;
  String? _customerId;
  List<CustomerListItem> _customers = <CustomerListItem>[];
  final List<_EditableSaleLine> _lines = <_EditableSaleLine>[];
  DateTime _createdAt = DateTime.now().toUtc();

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      _customers =
          await ref.read(listCustomersUseCaseProvider)(includeInactive: true);
      if (widget.isEdit) {
        final detail =
            await ref.read(getSaleDetailUseCaseProvider)(widget.saleId!);
        _customerId = detail.sale.customerId;
        _notesController.text = detail.notes ?? '';
        _createdAt = detail.sale.createdAt;
        _lines
          ..clear()
          ..addAll(
            detail.lines.map(
              (line) => _EditableSaleLine(
                itemId: line.id,
                productId: line.productId,
                productName: line.productName,
                productCode: line.productCode,
                quantity: line.quantity,
                unitPriceCents: line.unitPriceCents,
                unitCostCents: line.unitCostCents,
                taxRateBps: line.taxRateBps,
                discountCents: line.discountCents,
              ),
            ),
          );
      }
    } catch (e) {
      _error = 'No pudimos cargar la venta. $e';
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _pickProduct() async {
    ProductSummaryItem? selected;
    List<ProductSummaryItem> products =
        await ref.read(listProductsUseCaseProvider)(
      const ProductQuery(status: ProductStatusFilter.active),
    );
    if (!mounted) {
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            Future<void> reload(String value) async {
              products = await ref.read(listProductsUseCaseProvider)(
                ProductQuery(
                  search: value.trim().isEmpty ? null : value.trim(),
                  status: ProductStatusFilter.active,
                ),
              );
              if (mounted) {
                setModalState(() {});
              }
            }

            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SizedBox(
                height: 460,
                child: Column(
                  children: <Widget>[
                    TextField(
                      onChanged: (value) => unawaited(reload(value)),
                      decoration: const InputDecoration(
                        labelText: 'Buscar producto',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: products.isEmpty
                          ? const Center(child: Text('Sin resultados'))
                          : ListView.builder(
                              itemCount: products.length,
                              itemBuilder: (context, index) {
                                final product = products[index];
                                return ListTile(
                                  title: Text(product.name),
                                  subtitle: Text(product.internalCode),
                                  trailing: Text(
                                      _formatMoney(product.salePriceCents)),
                                  onTap: () {
                                    selected = product;
                                    Navigator.of(context).pop();
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (selected == null || !mounted) {
      return;
    }
    final detail =
        await ref.read(getProductDetailUseCaseProvider)(selected!.id);
    setState(() {
      final existingIndex =
          _lines.indexWhere((line) => line.productId == selected!.id);
      if (existingIndex >= 0) {
        _lines[existingIndex] = _lines[existingIndex].copyWith(
          quantity: _lines[existingIndex].quantity + 1,
        );
      } else {
        _lines.add(
          _EditableSaleLine(
            itemId: _uuid.v4(),
            productId: selected!.id,
            productName: selected!.name,
            productCode: selected!.internalCode,
            quantity: 1,
            unitPriceCents: selected!.salePriceCents,
            unitCostCents: selected!.costCents,
            taxRateBps: detail.taxRateBps,
            discountCents: 0,
          ),
        );
      }
    });
  }

  Future<void> _editLine(_EditableSaleLine line) async {
    final quantityController = TextEditingController(text: '${line.quantity}');
    final discountController =
        TextEditingController(text: '${line.discountCents / 100}');
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(line.productName,
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Cantidad'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: discountController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Descuento'),
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () {
                  final quantity =
                      int.tryParse(quantityController.text.trim()) ?? 1;
                  final discount = _parseMoney(discountController.text.trim());
                  setState(() {
                    final index =
                        _lines.indexWhere((item) => item.itemId == line.itemId);
                    if (index >= 0) {
                      _lines[index] = _lines[index].copyWith(
                        quantity: quantity < 1 ? 1 : quantity,
                        discountCents: discount < 0 ? 0 : discount,
                      );
                    }
                  });
                  Navigator.of(context).pop();
                },
                child: const Text('Guardar línea'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _save() async {
    if (_lines.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Agrega al menos un producto.')),
      );
      return;
    }
    setState(() => _saving = true);
    try {
      await ref.read(saveSaleDraftUseCaseProvider)(
        SaleDraftUpsertInput(
          saleId: widget.saleId ?? _uuid.v4(),
          createdAt: _createdAt,
          customerId: _customerId,
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
          lines: _lines
              .map(
                (line) => SaleLineDraftInput(
                  itemId: line.itemId,
                  productId: line.productId,
                  quantity: line.quantity,
                  unitPriceCents: line.unitPriceCents,
                  taxRateBps: line.taxRateBps,
                  discountCents: line.discountCents,
                ),
              )
              .toList(),
        ),
      );
      if (!mounted) {
        return;
      }
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo guardar la venta. $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar:
            AppBar(title: Text(widget.isEdit ? 'Editar venta' : 'Nueva venta')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (_error != null) {
      return Scaffold(
        appBar:
            AppBar(title: Text(widget.isEdit ? 'Editar venta' : 'Nueva venta')),
        body: Center(child: Text(_error!)),
      );
    }

    final subtotal =
        _lines.fold<int>(0, (sum, line) => sum + line.subtotalCents);
    final tax = _lines.fold<int>(0, (sum, line) => sum + line.taxCents);
    final total = subtotal + tax;
    final cost = _lines.fold<int>(0, (sum, line) => sum + line.totalCostCents);
    final profit = total - cost;

    return Scaffold(
      appBar:
          AppBar(title: Text(widget.isEdit ? 'Editar venta' : 'Nueva venta')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          DropdownButtonFormField<String?>(
            initialValue: _customerId,
            decoration: const InputDecoration(labelText: 'Cliente'),
            items: <DropdownMenuItem<String?>>[
              const DropdownMenuItem<String?>(
                  value: null, child: Text('Sin cliente')),
              ..._customers.map(
                (customer) => DropdownMenuItem<String?>(
                  value: customer.id,
                  child: Text(customer.name),
                ),
              ),
            ],
            onChanged: (value) => setState(() => _customerId = value),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _pickProduct,
            icon: const Icon(Icons.add),
            label: const Text('Agregar producto'),
          ),
          const SizedBox(height: 12),
          if (_lines.isEmpty)
            const Text('No hay productos en la venta.')
          else
            ..._lines.map(
              (line) => Card(
                child: ListTile(
                  title: Text(line.productName),
                  subtitle: Text(
                    '${line.productCode} · Cantidad: ${line.quantity} · IVA: ${line.taxRateBps / 100}%\n'
                    'Unitario: ${_formatMoney(line.unitPriceCents)} · Descuento: ${_formatMoney(line.discountCents)} · Total: ${_formatMoney(line.totalCents)}',
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        _editLine(line);
                      } else if (value == 'remove') {
                        setState(() {
                          _lines.removeWhere(
                              (item) => item.itemId == line.itemId);
                        });
                      }
                    },
                    itemBuilder: (context) => const <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                          value: 'edit', child: Text('Editar')),
                      PopupMenuItem<String>(
                          value: 'remove', child: Text('Quitar')),
                    ],
                  ),
                ),
              ),
            ),
          const SizedBox(height: 12),
          TextField(
            controller: _notesController,
            minLines: 2,
            maxLines: 4,
            decoration: const InputDecoration(labelText: 'Notas'),
          ),
          const SizedBox(height: 16),
          _SummaryRow(label: 'Subtotal', value: _formatMoney(subtotal)),
          _SummaryRow(label: 'IVA', value: _formatMoney(tax)),
          _SummaryRow(label: 'Total', value: _formatMoney(total)),
          _SummaryRow(label: 'Costo', value: _formatMoney(cost)),
          _SummaryRow(label: 'Ganancia', value: _formatMoney(profit)),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _saving ? null : _save,
            icon: _saving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.save_outlined),
            label: const Text('Guardar draft'),
          ),
        ],
      ),
    );
  }
}

class _EditableSaleLine {
  const _EditableSaleLine({
    required this.itemId,
    required this.productId,
    required this.productName,
    required this.productCode,
    required this.quantity,
    required this.unitPriceCents,
    required this.unitCostCents,
    required this.taxRateBps,
    required this.discountCents,
  });

  final String itemId;
  final String productId;
  final String productName;
  final String productCode;
  final int quantity;
  final int unitPriceCents;
  final int unitCostCents;
  final int taxRateBps;
  final int discountCents;

  int get subtotalCents => (unitPriceCents * quantity) - discountCents;
  int get taxCents => ((subtotalCents * taxRateBps) / 10000).round();
  int get totalCents => subtotalCents + taxCents;
  int get totalCostCents => unitCostCents * quantity;

  _EditableSaleLine copyWith({
    int? quantity,
    int? discountCents,
  }) {
    return _EditableSaleLine(
      itemId: itemId,
      productId: productId,
      productName: productName,
      productCode: productCode,
      quantity: quantity ?? this.quantity,
      unitPriceCents: unitPriceCents,
      unitCostCents: unitCostCents,
      taxRateBps: taxRateBps,
      discountCents: discountCents ?? this.discountCents,
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: <Widget>[
          Expanded(child: Text(label)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

int _parseMoney(String raw) {
  if (raw.trim().isEmpty) {
    return 0;
  }
  final parsed = double.tryParse(raw.replaceAll(',', '.')) ?? 0;
  return (parsed * 100).round();
}

String _formatMoney(int cents) {
  final sign = cents < 0 ? '-' : '';
  final absolute = cents.abs();
  final major = absolute ~/ 100;
  final minor = (absolute % 100).toString().padLeft(2, '0');
  return '$sign\$$major.$minor';
}
