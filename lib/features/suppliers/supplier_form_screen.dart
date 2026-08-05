import 'package:control_stok_celu/core/errors/app_exception.dart';
import 'package:control_stok_celu/data/providers/app_providers.dart';
import 'package:control_stok_celu/domain/stock/stock_models.dart';
import 'package:control_stok_celu/features/suppliers/suppliers_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SupplierFormScreen extends ConsumerStatefulWidget {
  const SupplierFormScreen({required this.supplierId, super.key});

  final String? supplierId;

  bool get isEdit => supplierId != null;

  @override
  ConsumerState<SupplierFormScreen> createState() => _SupplierFormScreenState();
}

class _SupplierFormScreenState extends ConsumerState<SupplierFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _legalNameController = TextEditingController();
  final TextEditingController _cuitController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  bool _isActive = true;
  bool _loading = false;
  bool _saving = false;

  String? _nameInlineBusinessError;
  String? _cuitInlineBusinessError;

  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      _load();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _legalNameController.dispose();
    _cuitController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
    });
    try {
      final detail =
          await ref.read(getSupplierDetailUseCaseProvider)(widget.supplierId!);
      _nameController.text = detail.name;
      _legalNameController.text = detail.legalName ?? '';
      _cuitController.text = detail.cuit ?? '';
      _phoneController.text = detail.phone ?? '';
      _emailController.text = detail.email ?? '';
      _addressController.text = detail.address ?? '';
      _notesController.text = detail.notes ?? '';
      _isActive = detail.isActive;
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No pudimos cargar proveedor. $e')),
      );
      Navigator.of(context).pop();
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
      return;
    }
    setState(() {
      _saving = true;
      _nameInlineBusinessError = null;
      _cuitInlineBusinessError = null;
    });

    final input = SupplierUpsertInput(
      id: widget.supplierId ?? 'sup_${DateTime.now().microsecondsSinceEpoch}',
      name: _nameController.text.trim(),
      legalName: _optional(_legalNameController),
      cuit: _optional(_cuitController),
      phone: _optional(_phoneController),
      email: _optional(_emailController),
      address: _optional(_addressController),
      notes: _optional(_notesController),
      isActive: _isActive,
    );

    try {
      final notifier = ref.read(suppliersStateProvider.notifier);
      if (widget.isEdit) {
        await notifier.updateSupplier(input);
      } else {
        await notifier.createSupplier(input);
      }

      if (!mounted) {
        return;
      }
      Navigator.of(context).pop(true);
    } on AppException catch (e) {
      if (_mapInlineError(e.message)) {
        _formKey.currentState?.validate();
      } else {
        if (!mounted) {
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_friendlyBusinessMessage(e.message))),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  bool _mapInlineError(String message) {
    final normalized = message.toLowerCase();
    var handled = false;
    setState(() {
      if (normalized.contains('requiere nombre')) {
        _nameInlineBusinessError = 'El nombre es obligatorio.';
        handled = true;
      }
      if (normalized.contains('cuit')) {
        _cuitInlineBusinessError = 'Ya existe un proveedor con ese CUIT.';
        handled = true;
      }
    });
    return handled;
  }

  String _friendlyBusinessMessage(String message) {
    if (message.toLowerCase().contains('cuit')) {
      return 'Ya existe un proveedor con ese CUIT.';
    }
    if (message.toLowerCase().contains('nombre')) {
      return 'Revisa el nombre del proveedor.';
    }
    return message;
  }

  String? _optional(TextEditingController controller) {
    final value = controller.text.trim();
    return value.isEmpty ? null : value;
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El nombre es obligatorio.';
    }
    return _nameInlineBusinessError;
  }

  String? _validateEmail(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return null;
    }
    const pattern = r'^[^@\s]+@[^@\s]+\.[^@\s]+$';
    if (!RegExp(pattern).hasMatch(text)) {
      return 'El email no tiene un formato válido.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEdit ? 'Editar proveedor' : 'Nuevo proveedor'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    TextFormField(
                      controller: _nameController,
                      onChanged: (_) {
                        if (_nameInlineBusinessError != null) {
                          setState(() {
                            _nameInlineBusinessError = null;
                          });
                        }
                      },
                      decoration: const InputDecoration(labelText: 'Nombre *'),
                      validator: _validateName,
                    ),
                    TextFormField(
                      controller: _legalNameController,
                      decoration:
                          const InputDecoration(labelText: 'Razón social'),
                    ),
                    TextFormField(
                      controller: _cuitController,
                      onChanged: (_) {
                        if (_cuitInlineBusinessError != null) {
                          setState(() {
                            _cuitInlineBusinessError = null;
                          });
                        }
                      },
                      decoration: const InputDecoration(labelText: 'CUIT'),
                      validator: (_) => _cuitInlineBusinessError,
                    ),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(labelText: 'Teléfono'),
                    ),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: _validateEmail,
                    ),
                    TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(labelText: 'Dirección'),
                    ),
                    TextFormField(
                      controller: _notesController,
                      minLines: 2,
                      maxLines: 4,
                      decoration: const InputDecoration(labelText: 'Notas'),
                    ),
                    SwitchListTile(
                      value: _isActive,
                      onChanged: (value) {
                        setState(() {
                          _isActive = value;
                        });
                      },
                      title: const Text('Proveedor activo'),
                    ),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: _saving ? null : _save,
                      icon: _saving
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.save_outlined),
                      label:
                          Text(_saving ? 'Guardando...' : 'Guardar proveedor'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
