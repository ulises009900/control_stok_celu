import 'package:control_stok_celu/data/providers/app_providers.dart';
import 'package:control_stok_celu/domain/stock/stock_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class CustomerFormScreen extends ConsumerStatefulWidget {
  const CustomerFormScreen({required this.customerId, super.key});

  final String? customerId;

  bool get isEdit => customerId != null;

  @override
  ConsumerState<CustomerFormScreen> createState() => _CustomerFormScreenState();
}

class _CustomerFormScreenState extends ConsumerState<CustomerFormScreen> {
  static const Uuid _uuid = Uuid();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _documentController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  bool _active = true;
  bool _loading = false;
  bool _saving = false;

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
    _phoneController.dispose();
    _emailController.dispose();
    _documentController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final detail =
          await ref.read(getCustomerDetailUseCaseProvider)(widget.customerId!);
      _nameController.text = detail.customer.name;
      _phoneController.text = detail.customer.phone ?? '';
      _emailController.text = detail.customer.email ?? '';
      _documentController.text = detail.customer.document ?? '';
      _addressController.text = detail.customer.address ?? '';
      _notesController.text = detail.customer.notes ?? '';
      _active = detail.customer.isActive;
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() => _saving = true);
    try {
      final input = CustomerUpsertInput(
        id: widget.customerId ?? _uuid.v4(),
        name: _nameController.text.trim(),
        phone: _optional(_phoneController),
        email: _optional(_emailController),
        document: _optional(_documentController),
        address: _optional(_addressController),
        notes: _optional(_notesController),
        isActive: _active,
      );
      if (widget.isEdit) {
        await ref.read(updateCustomerUseCaseProvider)(input);
      } else {
        await ref.read(createCustomerUseCaseProvider)(input);
      }
      if (!mounted) {
        return;
      }
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo guardar el cliente. $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  String? _optional(TextEditingController controller) {
    final value = controller.text.trim();
    return value.isEmpty ? null : value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: Navigator.canPop(context) ? const BackButton() : null,
          title: Text(widget.isEdit ? 'Editar cliente' : 'Nuevo cliente')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: <Widget>[
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Nombre *'),
                    validator: (value) =>
                        (value == null || value.trim().isEmpty)
                            ? 'El nombre es obligatorio.'
                            : null,
                  ),
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(labelText: 'Teléfono'),
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  TextFormField(
                    controller: _documentController,
                    decoration: const InputDecoration(labelText: 'Documento'),
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
                    value: _active,
                    onChanged: (value) => setState(() => _active = value),
                    title: const Text('Cliente activo'),
                  ),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: _saving ? null : _save,
                    icon: _saving
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.save_outlined),
                    label: const Text('Guardar cliente'),
                  ),
                ],
              ),
            ),
    );
  }
}
