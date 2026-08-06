import 'dart:convert';

import 'package:control_stok_celu/data/db/app_database.dart';
import 'package:control_stok_celu/data/providers/app_providers.dart';
import 'package:file_picker/file_picker.dart';
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
  String? _backupStatus;

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

  Future<void> _exportBackup() async {
    final directoryPath = await FilePicker.platform.getDirectoryPath(
      dialogTitle: 'Elegir carpeta para backup',
    );
    if (directoryPath == null) {
      return;
    }
    final service = ref.read(localBackupServiceProvider);
    try {
      final backup = await service.exportBackupToDirectory(
        directoryPath: directoryPath,
      );
      if (!mounted) {
        return;
      }
      setState(() => _backupStatus = backup.filePath);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Backup guardado en ${backup.filePath}')),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo exportar el backup. $e')),
      );
    }
  }

  Future<void> _restoreBackup() async {
    final result = await FilePicker.platform.pickFiles(
      dialogTitle: 'Seleccionar backup',
      type: FileType.custom,
      allowedExtensions: <String>['db', 'sqlite'],
    );
    final path = result?.files.single.path;
    if (path == null) {
      return;
    }
    final service = ref.read(localBackupServiceProvider);
    try {
      final validation = await service.validateBackupFile(path);
      if (!mounted) {
        return;
      }
      final confirmed = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Restaurar backup'),
                content: Text(
                  'Schema: ${validation.schemaVersion ?? 'desconocido'}\n'
                  'App: ${validation.appVersion ?? 'desconocida'}\n'
                  'Fecha: ${validation.createdAt?.toLocal() ?? '-'}\n\n'
                  'Antes de restaurar se creará una copia de seguridad de la base actual. ¿Continuar?',
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancelar'),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Restaurar'),
                  ),
                ],
              );
            },
          ) ??
          false;
      if (!confirmed) {
        return;
      }
      final restore = await service.restoreBackup(path);
      if (!mounted) {
        return;
      }
      setState(() => _backupStatus = restore.safetyBackup.filePath);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Restauración completada. Backup de seguridad: ${restore.safetyBackup.filePath}',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo restaurar el backup. $e')),
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
                Text(
                  'Backup local',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: _exportBackup,
                  icon: const Icon(Icons.download_outlined),
                  label: const Text('Exportar copia local'),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: _restoreBackup,
                  icon: const Icon(Icons.upload_file_outlined),
                  label: const Text('Restaurar copia local'),
                ),
                if ((_backupStatus ?? '').isNotEmpty) ...<Widget>[
                  const SizedBox(height: 8),
                  Text(
                    _backupStatus!,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
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
                  label: const Text('Guardar configuración'),
                ),
              ],
            ),
    );
  }
}
