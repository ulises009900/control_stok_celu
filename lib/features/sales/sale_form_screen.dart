import 'dart:async';

import 'package:control_stok_celu/core/commercial/percentage_utils.dart';
import 'package:control_stok_celu/data/providers/app_providers.dart';
import 'package:control_stok_celu/data/sync/sync_providers.dart';
import 'package:control_stok_celu/domain/stock/stock_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
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
  String _paymentMethod = 'cash';
  List<CustomerListItem> _customers = <CustomerListItem>[];
  final List<_EditableSaleLine> _lines = <_EditableSaleLine>[];
  DateTime _createdAt = DateTime.now().toUtc();
  bool _dirty = false;

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
        _paymentMethod = detail.sale.paymentMethod;
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
                discountRateBps:
                    _discountCentsToRateBps(line.discountCents, line),
              ),
            ),
          );
        _dirty = false;
      }
    } catch (e) {
      _error = 'No pudimos cargar la venta. $e';
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _pickCustomer() async {
    final searchController = TextEditingController();
    final selected = await showModalBottomSheet<CustomerListItem>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final query = searchController.text.trim().toLowerCase();
            final filtered = query.isEmpty
                ? _customers
                : _customers.where((customer) {
                    return customer.name.toLowerCase().contains(query) ||
                        (customer.phone?.toLowerCase().contains(query) ??
                            false) ||
                        (customer.document?.toLowerCase().contains(query) ??
                            false);
                  }).toList();
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
                    Text('Seleccionar cliente',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 12),
                    TextField(
                      controller: searchController,
                      onChanged: (_) => setModalState(() {}),
                      decoration: const InputDecoration(
                        labelText: 'Buscar por nombre, teléfono o documento',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: filtered.isEmpty
                          ? const Center(child: Text('Sin resultados'))
                          : ListView.builder(
                              itemCount: filtered.length,
                              itemBuilder: (context, index) {
                                final customer = filtered[index];
                                return ListTile(
                                  title: Text(customer.name),
                                  subtitle: Text(
                                    <String>[
                                      if (customer.phone != null &&
                                          customer.phone!.isNotEmpty)
                                        customer.phone!,
                                      if (customer.document != null &&
                                          customer.document!.isNotEmpty)
                                        customer.document!,
                                    ].join(' · '),
                                  ),
                                  onTap: () =>
                                      Navigator.of(context).pop(customer),
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
    searchController.dispose();
    if (selected == null || !mounted) {
      return;
    }
    setState(() {
      _customerId = selected.id;
      _dirty = true;
    });
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
    final searchController = TextEditingController();

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

            Future<void> scanBarcode() async {
              final scanned = await _scanBarcodeWithCamera();
              if (scanned == null || scanned.isEmpty) {
                return;
              }
              searchController.text = scanned;
              await reload(scanned);
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
                      controller: searchController,
                      onChanged: (value) => unawaited(reload(value)),
                      decoration: InputDecoration(
                        labelText:
                            'Buscar por nombre, código o código de barras',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: IconButton(
                          tooltip: 'Escanear código de barras',
                          icon: const Icon(Icons.qr_code_scanner_outlined),
                          onPressed: () => unawaited(scanBarcode()),
                        ),
                        border: const OutlineInputBorder(),
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
                                final available = product.stockAvailable;
                                final canAdd = available > 0;
                                return ListTile(
                                  title: Text(product.name),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(product.internalCode),
                                      Text(
                                        canAdd
                                            ? 'Stock disponible: $available'
                                            : 'Sin stock disponible',
                                        style: TextStyle(
                                          color: canAdd
                                              ? Colors.green.shade700
                                              : Colors.red.shade700,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  trailing: Text(
                                      _formatMoney(product.salePriceCents)),
                                  onTap: canAdd
                                      ? () {
                                          selected = product;
                                          Navigator.of(context).pop();
                                        }
                                      : null,
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
    searchController.dispose();

    if (selected == null || !mounted) {
      return;
    }
    final detail =
        await ref.read(getProductDetailUseCaseProvider)(selected!.id);

    setState(() {
      final existingIndex =
          _lines.indexWhere((line) => line.productId == selected!.id);

      if (existingIndex >= 0) {
        final currentQty = _lines[existingIndex].quantity;
        // Validar que no se supere el stock disponible si se agrega una unidad más desde la lista
        if (currentQty + 1 > selected!.stockAvailable) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'No puedes agregar más unidades. Stock disponible: ${selected!.stockAvailable}',
              ),
            ),
          );
          return;
        }
        _lines[existingIndex] = _lines[existingIndex].copyWith(
          quantity: currentQty + 1,
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
            discountRateBps: 0,
          ),
        );
      }
      _dirty = true;
    });
  }

  /// Escanea un código de barras con la cámara y devuelve el valor leído (o
  /// `null` si se cancela).
  Future<String?> _scanBarcodeWithCamera() async {
    final controller = MobileScannerController(
      formats: const <BarcodeFormat>[
        BarcodeFormat.ean13,
        BarcodeFormat.ean8,
        BarcodeFormat.code128,
        BarcodeFormat.code39,
        BarcodeFormat.upcA,
        BarcodeFormat.upcE,
        BarcodeFormat.qrCode
      ],
    );
    var handled = false;

    final scannedValue = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: SizedBox(
            height: MediaQuery.of(sheetContext).size.height * 0.72,
            child: Column(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 12),
                  child: Text(
                    'Apunta la cámara al código de barras.',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Expanded(
                  child: MobileScanner(
                    controller: controller,
                    onDetect: (capture) {
                      if (handled) {
                        return;
                      }
                      final raw = capture.barcodes
                          .map((barcode) => barcode.rawValue?.trim() ?? '')
                          .firstWhere(
                            (value) => value.isNotEmpty,
                            orElse: () => '',
                          );
                      if (raw.isEmpty) {
                        return;
                      }
                      handled = true;
                      Navigator.of(sheetContext).pop(raw);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextButton.icon(
                    onPressed: () => Navigator.of(sheetContext).pop(),
                    icon: const Icon(Icons.close),
                    label: const Text('Cancelar'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    await controller.dispose();
    return scannedValue;
  }

  Future<void> _editLine(_EditableSaleLine line) async {
    final quantityController = TextEditingController(text: '${line.quantity}');

    final discountController = TextEditingController(
      text: bpsToPercentText(line.discountRateBps),
    );

    // Obtener el detalle actual del producto.
    final productDetail =
        await ref.read(getProductDetailUseCaseProvider)(line.productId);

    // ProductDetailView contiene el ProductSummaryItem en "product".
    //
    // stockAvailable ya es:
    // stockTotal - stockReserved
    final stockAvailable = productDetail.product.stockAvailable;

    // Como estamos editando una venta que ya tiene esta cantidad,
    // devolvemos temporalmente esas unidades al disponible.
    //
    // Ejemplo:
    // stockTotal = 10
    // stockReserved = 2
    // stockAvailable = 8
    // cantidad actual de la venta = 3
    //
    // Podemos editar esta línea hasta 11 porque las 3 unidades
    // actuales ya pertenecen a esta venta.
    final available = stockAvailable + line.quantity;

    if (!mounted) {
      quantityController.dispose();
      discountController.dispose();
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                line.productName,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              Text(
                'Stock disponible: $stockAvailable',
                style: TextStyle(
                  color: stockAvailable > 0
                      ? Colors.green.shade700
                      : Colors.red.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Cantidad',
                  helperText: 'Máximo permitido para esta venta: $available',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: discountController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Descuento (%)',
                ),
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () {
                  final quantity =
                      int.tryParse(quantityController.text.trim()) ?? 1;

                  final discountRateBps =
                      percentToBps(discountController.text.trim());

                  if (quantity < 1) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'La cantidad debe ser como mínimo 1.',
                        ),
                      ),
                    );
                    return;
                  }

                  if (quantity > available) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'No puedes vender más de $available unidades.',
                        ),
                      ),
                    );
                    return;
                  }

                  setState(() {
                    final index = _lines.indexWhere(
                      (item) => item.itemId == line.itemId,
                    );

                    if (index >= 0) {
                      _lines[index] = _lines[index].copyWith(
                        quantity: quantity,
                        discountRateBps: discountRateBps.clamp(0, 10000),
                      );

                      _dirty = true;
                    }
                  });

                  Navigator.of(context).pop();
                },
                child: const Text('Guardar línea'),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );

    quantityController.dispose();
    discountController.dispose();
  }

  Future<void> _save({bool confirm = false}) async {
    if (_lines.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Agrega al menos un producto.')),
      );
      return;
    }
    setState(() => _saving = true);
    try {
      final credentials = await ref.read(syncCredentialsProvider.future);
      final saleId = widget.saleId ?? _uuid.v4();
      await ref.read(saveSaleDraftUseCaseProvider)(
        SaleDraftUpsertInput(
          saleId: saleId,
          createdAt: _createdAt,
          customerId: _customerId,
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
          paymentMethod: _paymentMethod,
          sellerId: credentials?.username,
          sellerName: credentials?.displayName ?? credentials?.username,
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
      if (confirm) {
        await ref.read(confirmSaleDraftUseCaseProvider)(saleId, DateTime.now().toUtc());
      }
      await ref.read(syncControllerProvider.notifier).syncNow(silent: true);
      if (!mounted) {
        return;
      }
      _dirty = false;
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
        appBar: AppBar(
            leading: Navigator.canPop(context) ? const BackButton() : null,
            title: Text(widget.isEdit ? 'Editar venta' : 'Nueva venta')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (_error != null) {
      return Scaffold(
        appBar: AppBar(
            leading: Navigator.canPop(context) ? const BackButton() : null,
            title: Text(widget.isEdit ? 'Editar venta' : 'Nueva venta')),
        body: Center(child: Text(_error!)),
      );
    }

    final subtotal =
        _lines.fold<int>(0, (sum, line) => sum + line.subtotalCents);
    final tax = _lines.fold<int>(0, (sum, line) => sum + line.taxCents);
    final total = subtotal + tax;
    final cost = _lines.fold<int>(0, (sum, line) => sum + line.totalCostCents);
    final profit = total - cost;

    return PopScope(
        canPop: !_dirty,
        onPopInvokedWithResult: (didPop, _) async {
          if (didPop || !_dirty) {
            return;
          }
          final navigator = Navigator.of(context);
          final discard = await _confirmDiscardChanges();
          if (!mounted || !discard) {
            return;
          }
          navigator.pop();
        },
        child: Scaffold(
          appBar: AppBar(
              leading: Navigator.canPop(context) ? const BackButton() : null,
              title: Text(widget.isEdit ? 'Editar venta' : 'Nueva venta')),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              _CustomerPickerField(
                customers: _customers,
                selectedCustomerId: _customerId,
                onPick: _pickCustomer,
                onClear: () => setState(() {
                  _customerId = null;
                  _dirty = true;
                }),
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
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '${line.productCode} · Cantidad: ${line.quantity} · IVA: ${bpsToPercentText(line.taxRateBps)}%\n'
                            'Unitario: ${_formatMoney(line.unitPriceCents)} · Descuento: ${bpsToPercentText(line.discountRateBps)}% · Total: ${_formatMoney(line.totalCents)}',
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Total a cobrar: ${_formatMoney(line.totalCents)}',
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'edit') {
                            _editLine(line);
                          } else if (value == 'remove') {
                            setState(() {
                              _lines.removeWhere(
                                  (item) => item.itemId == line.itemId);
                              _dirty = true;
                            });
                          }
                        },
                        itemBuilder: (context) =>
                            const <PopupMenuEntry<String>>[
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
              DropdownButtonFormField<String>(
                initialValue: _paymentMethod,
                decoration: const InputDecoration(labelText: 'Medio de pago', border: OutlineInputBorder()),
                items: const <DropdownMenuItem<String>>[
                  DropdownMenuItem(value: 'cash', child: Text('Efectivo')),
                  DropdownMenuItem(value: 'transfer', child: Text('Transferencia')),
                  DropdownMenuItem(value: 'card', child: Text('Tarjeta')),
                  DropdownMenuItem(value: 'current_account', child: Text('Cuenta corriente')),
                ],
                onChanged: (value) => setState(() {
                  _paymentMethod = value ?? 'cash';
                  _dirty = true;
                }),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _notesController,
                onChanged: (_) => setState(() => _dirty = true),
                minLines: 2,
                maxLines: 4,
                decoration: const InputDecoration(labelText: 'Notas'),
              ),
              const SizedBox(height: 16),
              _SummaryRow(label: 'Subtotal', value: _formatMoney(subtotal)),
              _SummaryRow(
                  label: 'Descuento',
                  value: _formatMoney(_lines.fold<int>(
                      0, (sum, line) => sum + line.discountCents))),
              _SummaryRow(label: 'IVA', value: _formatMoney(tax)),
              _SummaryRow(
                label: 'Total a cobrar',
                value: _formatMoney(total),
                highlight: true,
              ),
              if (ref.watch(isAdminProvider)) ...<Widget>[
                _SummaryRow(
                  label: 'Costo total',
                  value: _formatMoney(cost),
                ),
                _SummaryRow(label: 'Ganancia', value: _formatMoney(profit)),
              ],
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
              const SizedBox(height: 8),
              FilledButton.icon(
                onPressed: _saving ? null : () => _save(confirm: true),
                icon: const Icon(Icons.point_of_sale_outlined),
                label: const Text('Cobrar y confirmar venta'),
              ),
            ],
          ),
        ));
  }

  Future<bool> _confirmDiscardChanges() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Salir sin guardar'),
          content: const Text(
            'Hay cambios sin guardar. ¿Deseas salir y descartarlos?',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Salir'),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }
}

class _CustomerPickerField extends StatelessWidget {
  const _CustomerPickerField({
    required this.customers,
    required this.selectedCustomerId,
    required this.onPick,
    required this.onClear,
  });

  final List<CustomerListItem> customers;
  final String? selectedCustomerId;
  final VoidCallback onPick;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final selected = selectedCustomerId == null
        ? null
        : customers
            .where((customer) => customer.id == selectedCustomerId)
            .firstOrNull;
    return InkWell(
      onTap: onPick,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Cliente',
          border: const OutlineInputBorder(),
          suffixIcon: selected == null
              ? const Icon(Icons.search)
              : IconButton(
                  tooltip: 'Quitar cliente',
                  icon: const Icon(Icons.close),
                  onPressed: onClear,
                ),
        ),
        child: Text(selected?.name ?? 'Sin cliente · Tocá para buscar'),
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
    required this.discountRateBps,
  });

  final String itemId;
  final String productId;
  final String productName;
  final String productCode;
  final int quantity;
  final int unitPriceCents;
  final int unitCostCents;
  final int taxRateBps;
  final int discountRateBps;

  int get grossSubtotalCents => unitPriceCents * quantity;
  int get discountCents =>
      ((grossSubtotalCents * discountRateBps) / 10000).round();
  int get subtotalCents => grossSubtotalCents - discountCents;
  int get taxCents => ((subtotalCents * taxRateBps) / 10000).round();
  int get totalCents => subtotalCents + taxCents;
  int get totalCostCents => unitCostCents * quantity;

  _EditableSaleLine copyWith({
    int? quantity,
    int? discountRateBps,
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
      discountRateBps: discountRateBps ?? this.discountRateBps,
    );
  }
}

int _discountCentsToRateBps(int discountCents, SaleLineView line) {
  final gross = line.unitPriceCents * line.quantity;
  if (gross <= 0 || discountCents <= 0) {
    return 0;
  }
  final bps = ((discountCents * 10000) / gross).round();
  return bps.clamp(0, 10000);
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final accentColor = highlight ? Colors.green.shade700 : null;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              label,
              style: highlight
                  ? TextStyle(
                      color: accentColor,
                      fontWeight: FontWeight.w700,
                    )
                  : null,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: accentColor,
            ),
          ),
        ],
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
