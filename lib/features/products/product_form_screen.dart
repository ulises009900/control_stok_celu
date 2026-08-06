import 'package:control_stok_celu/data/providers/app_providers.dart';
import 'package:control_stok_celu/core/commercial/percentage_utils.dart';
import 'package:control_stok_celu/core/errors/app_exception.dart';
import 'package:control_stok_celu/domain/stock/stock_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductFormScreen extends ConsumerStatefulWidget {
  const ProductFormScreen({required this.productId, super.key});

  final String? productId;

  bool get isEdit => productId != null;

  @override
  ConsumerState<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends ConsumerState<ProductFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _internalCodeController = TextEditingController();
  final TextEditingController _barcodeController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _subcategoryController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _characteristicsController =
      TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  final TextEditingController _unitController =
      TextEditingController(text: 'unit');
  final TextEditingController _unitsPerPackController =
      TextEditingController(text: '1');
  final TextEditingController _stockMinController =
      TextEditingController(text: '0');
  final TextEditingController _stockMaxController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _costController =
      TextEditingController(text: '0.00');
  final TextEditingController _salePriceController =
      TextEditingController(text: '0.00');
  final TextEditingController _taxController = TextEditingController(text: '0');
  final TextEditingController _discountController =
      TextEditingController(text: '0');
  final TextEditingController _supplierController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  String? _categoryId;
  bool _offer = false;
  bool _clearance = false;
  bool _active = true;
  bool _loading = true;
  bool _saving = false;
  String? _loadWarning;
  List<CategoryListItem> _categories = <CategoryListItem>[];
  String? _internalCodeInlineError;
  String? _barcodeInlineError;
  String? _categoryInlineError;
  bool _dirty = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _internalCodeController.dispose();
    _barcodeController.dispose();
    _brandController.dispose();
    _subcategoryController.dispose();
    _descriptionController.dispose();
    _characteristicsController.dispose();
    _detailsController.dispose();
    _unitController.dispose();
    _unitsPerPackController.dispose();
    _stockMinController.dispose();
    _stockMaxController.dispose();
    _locationController.dispose();
    _costController.dispose();
    _salePriceController.dispose();
    _taxController.dispose();
    _discountController.dispose();
    _supplierController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _loadWarning = null;
    });

    try {
      _categories =
          await ref.read(listCategoriesUseCaseProvider)(includeInactive: false);
      if (widget.isEdit) {
        final detail =
            await ref.read(getProductDetailUseCaseProvider)(widget.productId!);
        _nameController.text = detail.product.name;
        _internalCodeController.text = detail.product.internalCode;
        _barcodeController.text = detail.product.barcode ?? '';
        _brandController.text = detail.product.brand ?? '';
        _categoryId = detail.product.categoryId;
        _subcategoryController.text = detail.product.subcategory ?? '';
        _descriptionController.text = detail.description ?? '';
        _characteristicsController.text = detail.characteristics ?? '';
        _detailsController.text = detail.details ?? '';
        _unitController.text = detail.unit;
        _unitsPerPackController.text = detail.unitsPerPack.toString();
        _stockMinController.text = detail.product.stockMin.toString();
        _stockMaxController.text = detail.stockMax?.toString() ?? '';
        _locationController.text = detail.location ?? '';
        _costController.text = _formatMoneyInput(detail.product.costCents);
        _salePriceController.text =
            _formatMoneyInput(detail.product.salePriceCents);
        _taxController.text = bpsToPercentText(detail.taxRateBps);
        _discountController.text = detail.defaultDiscountBps.toString();
        _supplierController.text = detail.supplierId ?? '';
        _notesController.text = detail.notes ?? '';
        _active = detail.product.isActive;
        _offer = detail.product.isOffer;
        _clearance = detail.product.isClearance;
        _dirty = false;
      }
    } catch (e) {
      _loadWarning = 'No pudimos cargar algunas opciones: $e';
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      setState(() {});
      return;
    }
    setState(() {
      _saving = true;
    });

    final input = ProductUpsertInput(
      id: widget.productId ?? 'prd_${DateTime.now().microsecondsSinceEpoch}',
      name: _nameController.text.trim(),
      internalCode: _internalCodeController.text.trim(),
      barcode: _readOptional(_barcodeController),
      brand: _readOptional(_brandController),
      categoryId: _categoryId,
      subcategory: _readOptional(_subcategoryController),
      description: _readOptional(_descriptionController),
      characteristics: _readOptional(_characteristicsController),
      details: _readOptional(_detailsController),
      unit: _unitController.text.trim().isEmpty
          ? 'unit'
          : _unitController.text.trim(),
      unitsPerPack: int.tryParse(_unitsPerPackController.text.trim()) ?? 1,
      stockMin: int.tryParse(_stockMinController.text.trim()) ?? 0,
      stockMax: int.tryParse(_stockMaxController.text.trim()),
      location: _readOptional(_locationController),
      costCents: _parseMoneyToCents(_costController.text.trim()),
      salePriceCents: _parseMoneyToCents(_salePriceController.text.trim()),
      taxRateBps: percentToBps(_taxController.text.trim()),
      defaultDiscountBps: int.tryParse(_discountController.text.trim()) ?? 0,
      isOffer: _offer,
      isClearance: _clearance,
      supplierId: _readOptional(_supplierController),
      notes: _readOptional(_notesController),
      isActive: _active,
    );

    try {
      if (widget.isEdit) {
        await ref.read(updateProductProfileUseCaseProvider)(input);
      } else {
        await ref.read(createProductProfileUseCaseProvider)(input);
      }
      if (!mounted) {
        return;
      }
      _dirty = false;
      Navigator.of(context).pop(true);
    } catch (e) {
      if (e is AppException && _handleInlineBusinessError(e.message)) {
        _formKey.currentState?.validate();
        return;
      }
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo guardar. $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
            title: Text(widget.isEdit ? 'Editar producto' : 'Nuevo producto')),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      if (_loadWarning != null) ...<Widget>[
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.orange.shade200),
                          ),
                          child: Text(_loadWarning!),
                        ),
                        const SizedBox(height: 12),
                      ],
                      _sectionTitle('Identificación'),
                      TextFormField(
                        controller: _nameController,
                        onChanged: (_) => setState(() => _dirty = true),
                        decoration:
                            const InputDecoration(labelText: 'Nombre *'),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                                ? 'El nombre es obligatorio'
                                : null,
                      ),
                      TextFormField(
                        controller: _internalCodeController,
                        onChanged: (_) {
                          setState(() {
                            _dirty = true;
                            if (_internalCodeInlineError != null) {
                              _internalCodeInlineError = null;
                            }
                          });
                        },
                        decoration: const InputDecoration(
                            labelText: 'Código interno *'),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                                ? 'El código es obligatorio'
                                : _internalCodeInlineError,
                      ),
                      TextFormField(
                        controller: _barcodeController,
                        onChanged: (_) {
                          setState(() {
                            _dirty = true;
                            if (_barcodeInlineError != null) {
                              _barcodeInlineError = null;
                            }
                          });
                        },
                        decoration: const InputDecoration(
                            labelText: 'Código de barras'),
                        validator: (_) => _barcodeInlineError,
                      ),
                      TextFormField(
                        controller: _brandController,
                        onChanged: (_) => setState(() => _dirty = true),
                        decoration: const InputDecoration(labelText: 'Marca'),
                      ),
                      const SizedBox(height: 16),
                      _sectionTitle('Clasificación'),
                      DropdownButtonFormField<String?>(
                        initialValue: _categoryId,
                        items: <DropdownMenuItem<String?>>[
                          const DropdownMenuItem<String?>(
                              value: null, child: Text('Sin categoría')),
                          ..._categories.map(
                            (category) => DropdownMenuItem<String?>(
                              value: category.id,
                              child: Text(category.name),
                            ),
                          ),
                        ],
                        onChanged: (value) => setState(() {
                          _categoryId = value;
                          _categoryInlineError = null;
                          _dirty = true;
                        }),
                        decoration: InputDecoration(
                          labelText: 'Categoría',
                          errorText: _categoryInlineError,
                        ),
                      ),
                      TextFormField(
                        controller: _subcategoryController,
                        decoration:
                            const InputDecoration(labelText: 'Subcategoría'),
                      ),
                      const SizedBox(height: 16),
                      _sectionTitle('Información'),
                      TextFormField(
                        controller: _descriptionController,
                        decoration:
                            const InputDecoration(labelText: 'Descripción'),
                        minLines: 2,
                        maxLines: 4,
                      ),
                      TextFormField(
                        controller: _characteristicsController,
                        decoration:
                            const InputDecoration(labelText: 'Características'),
                      ),
                      TextFormField(
                        controller: _detailsController,
                        decoration:
                            const InputDecoration(labelText: 'Detalles'),
                      ),
                      TextFormField(
                        controller: _unitController,
                        decoration: const InputDecoration(labelText: 'Unidad'),
                      ),
                      TextFormField(
                        controller: _unitsPerPackController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            labelText: 'Unidades por pack'),
                        validator: (value) {
                          final parsed = int.tryParse(value ?? '');
                          if (parsed == null || parsed <= 0) {
                            return 'Debe ser mayor a 0';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _sectionTitle('Inventario'),
                      const Text(
                          'El stock se gestiona por movimientos. No se edita directo acá.'),
                      TextFormField(
                        controller: _stockMinController,
                        keyboardType: TextInputType.number,
                        decoration:
                            const InputDecoration(labelText: 'Stock mínimo'),
                        validator: _validateNonNegativeInt,
                      ),
                      TextFormField(
                        controller: _stockMaxController,
                        keyboardType: TextInputType.number,
                        decoration:
                            const InputDecoration(labelText: 'Stock máximo'),
                        validator: _validateStockMax,
                      ),
                      TextFormField(
                        controller: _locationController,
                        decoration:
                            const InputDecoration(labelText: 'Ubicación'),
                      ),
                      const SizedBox(height: 16),
                      _sectionTitle('Precio y comercial'),
                      TextFormField(
                        controller: _costController,
                        onChanged: (_) => setState(() {}),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration:
                            const InputDecoration(labelText: 'Costo total'),
                        validator: _validateNonNegativeMoney,
                      ),
                      TextFormField(
                        controller: _salePriceController,
                        onChanged: (_) => setState(() {}),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration:
                            const InputDecoration(labelText: 'Precio de venta'),
                        validator: _validateSalePrice,
                      ),
                      TextFormField(
                        controller: _taxController,
                        onChanged: (_) => setState(() => _dirty = true),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: const InputDecoration(labelText: 'IVA (%)'),
                        validator: _validateTax,
                      ),
                      TextFormField(
                        controller: _discountController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            labelText: 'Descuento predeterminado (bps)'),
                        validator: _validateNonNegativeInt,
                      ),
                      SwitchListTile(
                        value: _offer,
                        onChanged: (value) => setState(() => _offer = value),
                        title: const Text('En oferta'),
                      ),
                      SwitchListTile(
                        value: _clearance,
                        onChanged: (value) =>
                            setState(() => _clearance = value),
                        title: const Text('En liquidación'),
                      ),
                      const SizedBox(height: 16),
                      _sectionTitle('Otros'),
                      TextFormField(
                        controller: _supplierController,
                        decoration:
                            const InputDecoration(labelText: 'Proveedor (id)'),
                      ),
                      TextFormField(
                        controller: _notesController,
                        onChanged: (_) => setState(() => _dirty = true),
                        decoration: const InputDecoration(labelText: 'Notas'),
                        minLines: 2,
                        maxLines: 4,
                      ),
                      SwitchListTile(
                        value: _active,
                        onChanged: (value) => setState(() {
                          _active = value;
                          _dirty = true;
                        }),
                        title: const Text('Producto activo'),
                      ),
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        onPressed: _saving ? null : _save,
                        icon: _saving
                            ? const SizedBox(
                                height: 16,
                                width: 16,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.save_outlined),
                        label:
                            Text(_saving ? 'Guardando...' : 'Guardar producto'),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
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

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title, style: Theme.of(context).textTheme.titleMedium),
    );
  }

  String? _readOptional(TextEditingController controller) {
    final value = controller.text.trim();
    return value.isEmpty ? null : value;
  }

  String? _validateNonNegativeInt(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return 'Este campo es obligatorio';
    }
    final parsed = int.tryParse(text);
    if (parsed == null) {
      return 'Debe ser un número válido';
    }
    if (parsed < 0) {
      return 'No puede ser negativo';
    }
    return null;
  }

  String? _validateNonNegativeMoney(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return 'Este campo es obligatorio';
    }
    final normalized = text.replaceAll(',', '.');
    final parsed = double.tryParse(normalized);
    if (parsed == null) {
      return 'Introduce un costo válido.';
    }
    if (parsed < 0) {
      return 'Introduce un costo válido.';
    }
    return null;
  }

  String? _validateSalePrice(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return 'Introduce un precio válido.';
    }
    final normalized = text.replaceAll(',', '.');
    final parsed = double.tryParse(normalized);
    if (parsed == null || parsed < 0) {
      return 'Introduce un precio válido.';
    }
    return null;
  }

  String? _validateTax(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return 'Introduce un porcentaje de IVA válido.';
    }
    final parsed = parsePercentage(text);
    if (parsed == null || parsed < 0 || parsed > 100) {
      return 'Introduce un porcentaje de IVA válido.';
    }
    return null;
  }

  bool _handleInlineBusinessError(String message) {
    final normalized = message.toLowerCase();
    bool handled = false;
    setState(() {
      _internalCodeInlineError = null;
      _barcodeInlineError = null;
      _categoryInlineError = null;

      if (normalized.contains('código interno')) {
        _internalCodeInlineError = 'Este código ya está utilizado.';
        handled = true;
      }
      if (normalized.contains('código de barras')) {
        _barcodeInlineError = 'Este código de barras ya está utilizado.';
        handled = true;
      }
      if (normalized.contains('categoría') && normalized.contains('inactiva')) {
        _categoryInlineError = 'La categoría seleccionada está inactiva.';
        handled = true;
      }
      if (normalized.contains('categoría seleccionada no existe')) {
        _categoryInlineError = 'La categoría seleccionada no es válida.';
        handled = true;
      }
    });
    return handled;
  }

  String? _validateStockMax(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return null;
    }
    final parsed = int.tryParse(text);
    if (parsed == null) {
      return 'Debe ser un número válido';
    }
    final minValue = int.tryParse(_stockMinController.text.trim()) ?? 0;
    if (parsed < minValue) {
      return 'Debe ser mayor o igual al stock mínimo';
    }
    return null;
  }

  int _parseMoneyToCents(String raw) {
    if (raw.isEmpty) {
      return 0;
    }
    final normalized = raw.replaceAll(',', '.');
    final parsed = double.tryParse(normalized);
    if (parsed == null) {
      return 0;
    }
    return (parsed * 100).round();
  }

  String _formatMoneyInput(int cents) {
    final major = cents ~/ 100;
    final minor = (cents.abs() % 100).toString().padLeft(2, '0');
    return '$major.$minor';
  }
}
