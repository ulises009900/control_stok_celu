import 'dart:convert';

import 'package:control_stok_celu/data/db/app_database.dart';
import 'package:control_stok_celu/data/providers/app_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _currencyController = TextEditingController();
  final TextEditingController _defaultTaxController = TextEditingController();
  final TextEditingController _nearExpiryDaysController =
      TextEditingController();
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _currencyController.dispose();
    _defaultTaxController.dispose();
    _nearExpiryDaysController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final db = ref.read(appDatabaseProvider);
    final rows = await db.select(db.settings).get();
    final values = <String, dynamic>{};
    for (final row in rows) {
      values[row.key] = jsonDecode(row.valueJson);
    }
    _businessNameController.text =
        values['business_name'] as String? ?? 'Control Stok Celu';
    _currencyController.text = values['currency_symbol'] as String? ?? '\$';
    _defaultTaxController.text =
        (values['default_tax_bps'] as int? ?? 2100).toString();
    _nearExpiryDaysController.text =
        (values['near_expiry_days'] as int? ?? 30).toString();
    if (mounted) {
      setState(() => _loading = false);
    }
  }

  Future<void> _save() async {
    final db = ref.read(appDatabaseProvider);
    setState(() => _saving = true);
    final now = DateTime.now().toUtc();
    final entries = <MapEntry<String, Object>>[
      MapEntry<String, Object>(
          'business_name', _businessNameController.text.trim()),
      MapEntry<String, Object>(
          'currency_symbol',
          _currencyController.text.trim().isEmpty
              ? '\$'
              : _currencyController.text.trim()),
      MapEntry<String, Object>('default_tax_bps',
          int.tryParse(_defaultTaxController.text.trim()) ?? 2100),
      MapEntry<String, Object>('near_expiry_days',
          int.tryParse(_nearExpiryDaysController.text.trim()) ?? 30),
    ];
    for (final entry in entries) {
      await db.into(db.settings).insertOnConflictUpdate(
            SettingsCompanion.insert(
              key: entry.key,
              valueJson: jsonEncode(entry.value),
              updatedAt: now,
            ),
          );
    }
    if (mounted) {
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Configuración guardada.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: <Widget>[
                TextField(
                  controller: _businessNameController,
                  decoration:
                      const InputDecoration(labelText: 'Nombre del negocio'),
                ),
                TextField(
                  controller: _currencyController,
                  decoration:
                      const InputDecoration(labelText: 'Símbolo de moneda'),
                ),
                TextField(
                  controller: _defaultTaxController,
                  keyboardType: TextInputType.number,
                  decoration:
                      const InputDecoration(labelText: 'IVA por defecto (bps)'),
                ),
                TextField(
                  controller: _nearExpiryDaysController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      labelText: 'Días para próximo vencimiento'),
                ),
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
                  label: const Text('Guardar configuración'),
                ),
              ],
            ),
    );
  }
}
