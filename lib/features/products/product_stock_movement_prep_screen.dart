import 'package:control_stok_celu/data/providers/app_providers.dart';
import 'package:control_stok_celu/core/errors/app_exception.dart';
import 'package:control_stok_celu/domain/stock/stock_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

enum _MovementFormType { stockIn, adjustment }

class ProductStockMovementPrepScreen extends ConsumerStatefulWidget {
  const ProductStockMovementPrepScreen({required this.productId, super.key});

  final String productId;

  @override
  ConsumerState<ProductStockMovementPrepScreen> createState() =>
      _ProductStockMovementPrepScreenState();
}

class _ProductStockMovementPrepScreenState
    extends ConsumerState<ProductStockMovementPrepScreen> {
  static const Uuid _uuid = Uuid();

  final GlobalKey<FormState> _stockInFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _adjustFormKey = GlobalKey<FormState>();

  final TextEditingController _stockInQuantityController =
      TextEditingController(text: '1');
  final TextEditingController _stockInUnitCostController =
      TextEditingController();
  final TextEditingController _stockInBatchCodeController =
      TextEditingController();
  final TextEditingController _stockInNotesController = TextEditingController();

  final TextEditingController _adjustQuantityController =
      TextEditingController(text: '1');
  final TextEditingController _adjustReasonController = TextEditingController();
  final TextEditingController _adjustNotesController = TextEditingController();

  ProductDetailView? _detail;
  List<SupplierListItem> _suppliers = const <SupplierListItem>[];
  bool _isLoading = true;
  bool _isSubmitting = false;
  String? _error;

  _MovementFormType _movementType = _MovementFormType.stockIn;
  String? _selectedSupplierId;
  DateTime? _selectedExpiryDate;
  bool _isNegativeAdjustment = false;
  String? _selectedBatchId;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _stockInQuantityController.dispose();
    _stockInUnitCostController.dispose();
    _stockInBatchCodeController.dispose();
    _stockInNotesController.dispose();
    _adjustQuantityController.dispose();
    _adjustReasonController.dispose();
    _adjustNotesController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final detailFuture =
          ref.read(getProductDetailUseCaseProvider)(widget.productId);
      final suppliersFuture =
          ref.read(listSuppliersUseCaseProvider)(includeInactive: false);
      final results = await Future.wait<Object>(
        <Future<Object>>[detailFuture, suppliersFuture],
      );
      final detail = results[0] as ProductDetailView;
      final suppliers = results[1] as List<SupplierListItem>;
      if (!mounted) {
        return;
      }
      setState(() {
        _detail = detail;
        _suppliers = suppliers;
        _selectedSupplierId = suppliers.isNotEmpty ? suppliers.first.id : null;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }
      setState(() {
        _error = 'No pudimos cargar la información del movimiento. $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _pickExpiryDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 10),
      initialDate: _selectedExpiryDate ?? now,
    );
    if (picked == null || !mounted) {
      return;
    }
    setState(() {
      _selectedExpiryDate = DateTime.utc(picked.year, picked.month, picked.day);
    });
  }

  String? _validatePositiveInt(String? raw, String label) {
    final value = int.tryParse((raw ?? '').trim());
    if (value == null || value <= 0) {
      return '$label debe ser mayor a cero.';
    }
    return null;
  }

  Future<void> _submitStockIn() async {
    final form = _stockInFormKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }
    final detail = _detail;
    if (detail == null) {
      return;
    }

    final quantity = int.parse(_stockInQuantityController.text.trim());
    final unitCostRaw = _stockInUnitCostController.text.trim();
    final unitCost =
        unitCostRaw.isEmpty ? detail.product.costCents : int.parse(unitCostRaw);
    final batchCode = _stockInBatchCodeController.text.trim();
    final notes = _stockInNotesController.text.trim();
    final supplierName = _suppliers
        .where((supplier) => supplier.id == _selectedSupplierId)
        .map((supplier) => supplier.name)
        .firstOrNull;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmar ingreso'),
          content: Text(
            'Producto: ${detail.product.name}\n'
            'Cantidad: $quantity\n'
            'Costo unitario: $unitCost${unitCostRaw.isEmpty ? ' (se conserva el costo anterior)' : ''}\n'
            'Proveedor: ${supplierName ?? 'Sin proveedor'}\n'
            'Lote: ${batchCode.isEmpty ? 'Generado automáticamente' : batchCode}\n'
            'Vencimiento: ${_selectedExpiryDate == null ? 'Sin fecha' : _formatDate(_selectedExpiryDate!)}',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final now = DateTime.now().toUtc();
      final batchId = _uuid.v4();
      await ref.read(receiveStockUseCaseProvider)(
        ReceiveStockInput(
          batchId: batchId,
          productId: widget.productId,
          quantity: quantity,
          unitCostCents: unitCost,
          receivedAt: now,
          batchCode: batchCode.isEmpty ? null : batchCode,
          supplierId: _selectedSupplierId,
          expiresAt: _selectedExpiryDate,
          notes: notes.isEmpty ? null : notes,
        ),
      );
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingreso de stock registrado.')),
      );
      Navigator.of(context).pop(true);
    } on AppException catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No pudimos registrar el ingreso. $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  Future<void> _submitAdjustment() async {
    final form = _adjustFormKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }
    final detail = _detail;
    if (detail == null) {
      return;
    }

    final quantity = int.parse(_adjustQuantityController.text.trim());
    final delta = _isNegativeAdjustment ? -quantity : quantity;
    final reason = _adjustReasonController.text.trim();
    final notes = _adjustNotesController.text.trim();
    final selectedBatch = detail.batches
        .where((batch) => batch.id == _selectedBatchId)
        .cast<ProductBatchView?>()
        .firstOrNull;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmar ajuste'),
          content: Text(
            'Producto: ${detail.product.name}\n'
            'Tipo: ${delta > 0 ? 'Ajuste positivo' : 'Ajuste negativo'}\n'
            'Cantidad: ${delta.abs()}\n'
            'Lote: ${selectedBatch?.batchCode ?? selectedBatch?.id ?? 'Sin lote'}\n'
            'Motivo: $reason',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await ref.read(adjustStockUseCaseProvider)(
        StockAdjustmentInput(
          adjustmentId: _uuid.v4(),
          productId: widget.productId,
          batchId: _selectedBatchId,
          deltaQuantity: delta,
          createdAt: DateTime.now().toUtc(),
          reason: reason,
          observations: notes.isEmpty ? null : notes,
        ),
      );
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ajuste de stock registrado.')),
      );
      Navigator.of(context).pop(true);
    } on AppException catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No pudimos registrar el ajuste. $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          leading: Navigator.canPop(context) ? const BackButton() : null,
          title: const Text('Movimiento de stock'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null || _detail == null) {
      return Scaffold(
        appBar: AppBar(
          leading: Navigator.canPop(context) ? const BackButton() : null,
          title: const Text('Movimiento de stock'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(_error ?? 'No pudimos cargar la pantalla.'),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: _load,
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final detail = _detail!;
    final batchOptions =
        detail.batches.where((batch) => batch.quantityAvailable > 0).toList();

    return Scaffold(
      appBar: AppBar(
        leading: Navigator.canPop(context) ? const BackButton() : null,
        title: const Text('Movimiento de stock'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(detail.product.name,
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 6),
                  Text('Código: ${detail.product.internalCode}'),
                  Text('Stock total: ${detail.product.stockTotal}'),
                  Text('Stock reservado: ${detail.product.stockReserved}'),
                  Text('Stock disponible: ${detail.product.stockAvailable}'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          SegmentedButton<_MovementFormType>(
            segments: const <ButtonSegment<_MovementFormType>>[
              ButtonSegment<_MovementFormType>(
                value: _MovementFormType.stockIn,
                icon: Icon(Icons.add_box_outlined),
                label: Text('Ingreso'),
              ),
              ButtonSegment<_MovementFormType>(
                value: _MovementFormType.adjustment,
                icon: Icon(Icons.tune_outlined),
                label: Text('Ajuste'),
              ),
            ],
            selected: <_MovementFormType>{_movementType},
            onSelectionChanged: _isSubmitting
                ? null
                : (selection) {
                    setState(() {
                      _movementType = selection.first;
                    });
                  },
          ),
          const SizedBox(height: 16),
          if (_movementType == _MovementFormType.stockIn)
            Form(
              key: _stockInFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    controller: _stockInQuantityController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Cantidad *'),
                    validator: (value) =>
                        _validatePositiveInt(value, 'Cantidad'),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _stockInUnitCostController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Costo unitario (centavos, opcional)',
                    ),
                    validator: (value) {
                      final text = (value ?? '').trim();
                      if (text.isEmpty) {
                        return null;
                      }
                      return _validatePositiveInt(text, 'Costo unitario');
                    },
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String?>(
                    initialValue: _selectedSupplierId,
                    decoration: const InputDecoration(labelText: 'Proveedor'),
                    items: <DropdownMenuItem<String?>>[
                      const DropdownMenuItem<String?>(
                        value: null,
                        child: Text('Sin proveedor'),
                      ),
                      ..._suppliers.map(
                        (supplier) => DropdownMenuItem<String?>(
                          value: supplier.id,
                          child: Text(supplier.name),
                        ),
                      ),
                    ],
                    onChanged: _isSubmitting
                        ? null
                        : (value) {
                            setState(() {
                              _selectedSupplierId = value;
                            });
                          },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _stockInBatchCodeController,
                    decoration: const InputDecoration(
                      labelText: 'Código de lote (opcional)',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          _selectedExpiryDate == null
                              ? 'Vencimiento: sin fecha'
                              : 'Vencimiento: ${_formatDate(_selectedExpiryDate!)}',
                        ),
                      ),
                      TextButton(
                        onPressed: _isSubmitting ? null : _pickExpiryDate,
                        child: const Text('Elegir fecha'),
                      ),
                      if (_selectedExpiryDate != null)
                        IconButton(
                          onPressed: _isSubmitting
                              ? null
                              : () {
                                  setState(() {
                                    _selectedExpiryDate = null;
                                  });
                                },
                          icon: const Icon(Icons.close),
                        ),
                    ],
                  ),
                  TextFormField(
                    controller: _stockInNotesController,
                    decoration: const InputDecoration(labelText: 'Notas'),
                    minLines: 2,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _isSubmitting ? null : _submitStockIn,
                      icon: _isSubmitting
                          ? const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.check),
                      label: const Text('Confirmar ingreso'),
                    ),
                  ),
                ],
              ),
            )
          else
            Form(
              key: _adjustFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Ajuste negativo'),
                    subtitle: const Text(
                        'Si está activo, reduce stock. Si no, incrementa stock.'),
                    value: _isNegativeAdjustment,
                    onChanged: _isSubmitting
                        ? null
                        : (value) {
                            setState(() {
                              _isNegativeAdjustment = value;
                              if (!value) {
                                _selectedBatchId = null;
                              }
                            });
                          },
                  ),
                  TextFormField(
                    controller: _adjustQuantityController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Cantidad *'),
                    validator: (value) {
                      final error = _validatePositiveInt(value, 'Cantidad');
                      if (error != null) {
                        return error;
                      }
                      if (_isNegativeAdjustment && _selectedBatchId == null) {
                        return 'Para ajuste negativo debes seleccionar un lote.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String?>(
                    initialValue: _selectedBatchId,
                    decoration: const InputDecoration(
                      labelText: 'Lote (requerido en ajuste negativo)',
                    ),
                    items: <DropdownMenuItem<String?>>[
                      const DropdownMenuItem<String?>(
                        value: null,
                        child: Text('Sin lote'),
                      ),
                      ...batchOptions.map(
                        (batch) => DropdownMenuItem<String?>(
                          value: batch.id,
                          child: Text(
                            '${batch.batchCode ?? batch.id} · disp. ${batch.quantityAvailable}',
                          ),
                        ),
                      ),
                    ],
                    onChanged: _isSubmitting
                        ? null
                        : (value) {
                            setState(() {
                              _selectedBatchId = value;
                            });
                          },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _adjustReasonController,
                    decoration: const InputDecoration(labelText: 'Motivo *'),
                    validator: (value) {
                      if ((value ?? '').trim().isEmpty) {
                        return 'El motivo del ajuste es obligatorio.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _adjustNotesController,
                    decoration:
                        const InputDecoration(labelText: 'Observaciones'),
                    minLines: 2,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _isSubmitting ? null : _submitAdjustment,
                      icon: _isSubmitting
                          ? const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.check),
                      label: const Text('Confirmar ajuste'),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final local = date.toLocal();
    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');
    return '$day/$month/${local.year}';
  }
}
