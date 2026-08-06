import 'dart:convert';
import 'dart:io';

import 'package:control_stok_celu/core/errors/app_exception.dart';
import 'package:control_stok_celu/data/db/app_database.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;

const String kAppProductionVersion = '1.0.0+1';

class BackupExportResult {
  const BackupExportResult({
    required this.filePath,
    required this.fileName,
    required this.createdAt,
    required this.schemaVersion,
    required this.appVersion,
  });

  final String filePath;
  final String fileName;
  final DateTime createdAt;
  final int schemaVersion;
  final String appVersion;
}

class BackupValidationResult {
  const BackupValidationResult({
    required this.isValid,
    required this.message,
    this.schemaVersion,
    this.appVersion,
    this.createdAt,
  });

  final bool isValid;
  final String message;
  final int? schemaVersion;
  final String? appVersion;
  final DateTime? createdAt;
}

class RestoreResult {
  const RestoreResult({
    required this.safetyBackup,
    required this.validation,
  });

  final BackupExportResult safetyBackup;
  final BackupValidationResult validation;
}

class LocalBackupService {
  LocalBackupService({
    required Future<AppDatabase> Function() getDatabase,
    required Future<File> Function() resolvePrimaryDatabaseFile,
    required Future<void> Function() restartDatabase,
    required int currentSchemaVersion,
    required String appVersion,
  })  : _getDatabase = getDatabase,
        _resolvePrimaryDatabaseFile = resolvePrimaryDatabaseFile,
        _restartDatabase = restartDatabase,
        _currentSchemaVersion = currentSchemaVersion,
        _appVersion = appVersion;

  final Future<AppDatabase> Function() _getDatabase;
  final Future<File> Function() _resolvePrimaryDatabaseFile;
  final Future<void> Function() _restartDatabase;
  final int _currentSchemaVersion;
  final String _appVersion;

  Future<BackupExportResult> exportBackupToDirectory({
    required String directoryPath,
    String? fileName,
  }) async {
    final db = await _getDatabase();
    await _validateCurrentDatabase(db);

    final targetDirectory = Directory(directoryPath);
    if (!await targetDirectory.exists()) {
      await targetDirectory.create(recursive: true);
    }

    final createdAt = DateTime.now().toUtc();
    final backupFileName = fileName ?? _buildBackupFileName(createdAt);
    final targetPath = p.join(targetDirectory.path, backupFileName);
    await _createConsistentBackup(db, targetPath, createdAt);

    return BackupExportResult(
      filePath: targetPath,
      fileName: backupFileName,
      createdAt: createdAt,
      schemaVersion: _currentSchemaVersion,
      appVersion: _appVersion,
    );
  }

  Future<BackupValidationResult> validateBackupFile(String filePath) async {
    final prepared = await _prepareBackupFile(filePath);
    try {
      return BackupValidationResult(
        isValid: true,
        message: 'Backup válido.',
        schemaVersion: prepared.schemaVersion,
        appVersion: prepared.appVersion,
        createdAt: prepared.createdAt,
      );
    } finally {
      await prepared.dispose();
    }
  }

  Future<RestoreResult> restoreBackup(String filePath) async {
    final prepared = await _prepareBackupFile(filePath);
    BackupExportResult? safetyBackup;
    final targetDatabaseFile = await _resolvePrimaryDatabaseFile();
    final targetWal = File('${targetDatabaseFile.path}-wal');
    final targetShm = File('${targetDatabaseFile.path}-shm');

    try {
      final db = await _getDatabase();
      final safetyDirectory = await _resolveInternalBackupDirectory();
      safetyBackup = await exportBackupToDirectory(
        directoryPath: safetyDirectory.path,
        fileName: 'pre_restore_${_safeTimestamp(DateTime.now().toUtc())}.db',
      );

      await db.close();
      await _replaceDatabaseFile(
        sourceFile: File(prepared.workingPath),
        targetFile: targetDatabaseFile,
        targetWal: targetWal,
        targetShm: targetShm,
      );
      await _restartDatabase();
      final restoredDb = await _getDatabase();
      await _validateCurrentDatabase(restoredDb);

      return RestoreResult(
        safetyBackup: safetyBackup,
        validation: BackupValidationResult(
          isValid: true,
          message: 'Restauración completada.',
          schemaVersion: prepared.schemaVersion,
          appVersion: prepared.appVersion,
          createdAt: prepared.createdAt,
        ),
      );
    } catch (e) {
      if (safetyBackup != null) {
        try {
          final db = await _getDatabase();
          await db.close();
        } catch (_) {}
        try {
          await _replaceDatabaseFile(
            sourceFile: File(safetyBackup.filePath),
            targetFile: targetDatabaseFile,
            targetWal: targetWal,
            targetShm: targetShm,
          );
          await _restartDatabase();
        } catch (_) {}
      }
      throw AppException('No se pudo restaurar el backup. $e');
    } finally {
      await prepared.dispose();
    }
  }

  Future<void> _createConsistentBackup(
    AppDatabase db,
    String targetPath,
    DateTime createdAt,
  ) async {
    final targetFile = File(targetPath);
    if (await targetFile.exists()) {
      await targetFile.delete();
    }

    await db.customStatement('PRAGMA wal_checkpoint(FULL);');
    await db.customStatement("VACUUM INTO '${_escapeSqlitePath(targetPath)}';");

    final backupDb = AppDatabase(executor: NativeDatabase(targetFile));
    try {
      final metadata = <MapEntry<String, Object>>[
        MapEntry<String, Object>(
            'backup_created_at', createdAt.toIso8601String()),
        MapEntry<String, Object>(
            'backup_schema_version', _currentSchemaVersion),
        MapEntry<String, Object>('backup_app_version', _appVersion),
      ];
      for (final entry in metadata) {
        await backupDb.into(backupDb.settings).insertOnConflictUpdate(
              SettingsCompanion.insert(
                key: entry.key,
                valueJson: _encodeValue(entry.value),
                updatedAt: createdAt,
              ),
            );
      }
      await _validateCurrentDatabase(backupDb);
    } finally {
      await backupDb.close();
    }
  }

  Future<void> _validateCurrentDatabase(AppDatabase db) async {
    final integrityRows =
        await db.customSelect('PRAGMA integrity_check;').get();
    final integrityValue = integrityRows.isEmpty
        ? 'failed'
        : integrityRows.first.data.values.first.toString().toLowerCase();
    if (integrityValue != 'ok') {
      throw ValidationException('La base falló el integrity_check.');
    }

    final foreignKeyRows =
        await db.customSelect('PRAGMA foreign_key_check;').get();
    if (foreignKeyRows.isNotEmpty) {
      throw ValidationException(
          'La base tiene inconsistencias de foreign keys.');
    }
  }

  Future<_PreparedBackup> _prepareBackupFile(String filePath) async {
    final sourceFile = File(filePath);
    if (!await sourceFile.exists()) {
      throw ValidationException('El archivo de backup no existe.');
    }
    final size = await sourceFile.length();
    if (size <= 0) {
      throw ValidationException('El archivo de backup está vacío.');
    }

    final tempDirectory =
        await Directory.systemTemp.createTemp('control_stok_restore_');
    final workingPath = p.join(tempDirectory.path, 'working_backup.db');
    await sourceFile.copy(workingPath);

    final workingDb = AppDatabase(executor: NativeDatabase(File(workingPath)));
    try {
      await workingDb.customSelect('SELECT 1').getSingle();
      await _validateCurrentDatabase(workingDb);

      final settingsRows = await workingDb.customSelect(
        '''
        SELECT key, value_json
        FROM settings
        WHERE key IN ('backup_created_at', 'backup_schema_version', 'backup_app_version')
        ''',
      ).get();

      final values = <String, dynamic>{};
      for (final row in settingsRows) {
        values[row.read<String>('key')] = row.read<String>('value_json');
      }

      final schemaVersionRow =
          await workingDb.customSelect('PRAGMA user_version;').getSingle();
      final schemaValue =
          int.tryParse(schemaVersionRow.data.values.first.toString()) ??
              _currentSchemaVersion;
      final backupSchemaVersion =
          _decodeInt(values['backup_schema_version']) ?? schemaValue;
      final backupAppVersion = _decodeString(values['backup_app_version']);
      final backupCreatedAt = _decodeDate(values['backup_created_at']);

      if (backupSchemaVersion > _currentSchemaVersion) {
        throw ValidationException(
            'El backup pertenece a un esquema más nuevo e incompatible.');
      }

      return _PreparedBackup(
        workingPath: workingPath,
        tempDirectory: tempDirectory,
        schemaVersion: backupSchemaVersion,
        appVersion: backupAppVersion,
        createdAt: backupCreatedAt,
      );
    } catch (e) {
      await workingDb.close();
      await _safeDeleteDirectory(tempDirectory);
      if (e is AppException) {
        rethrow;
      }
      throw ValidationException(
          'El archivo no es un backup SQLite compatible. $e');
    } finally {
      if (await File(workingPath).exists()) {
        try {
          await workingDb.close();
        } catch (_) {}
      }
    }
  }

  Future<void> _replaceDatabaseFile({
    required File sourceFile,
    required File targetFile,
    required File targetWal,
    required File targetShm,
  }) async {
    if (await targetWal.exists()) {
      await targetWal.delete();
    }
    if (await targetShm.exists()) {
      await targetShm.delete();
    }
    if (await targetFile.exists()) {
      await targetFile.delete();
    }
    await sourceFile.copy(targetFile.path);
  }

  Future<Directory> _resolveInternalBackupDirectory() async {
    final databaseFile = await _resolvePrimaryDatabaseFile();
    final directory = Directory(p.join(databaseFile.parent.path, 'backups'));
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    return directory;
  }

  String _buildBackupFileName(DateTime createdAt) {
    return 'control_stok_celu_backup_${_safeTimestamp(createdAt)}.db';
  }

  String _safeTimestamp(DateTime value) {
    final local = value.toLocal();
    final year = local.year.toString().padLeft(4, '0');
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '$year-$month-${day}_$hour-$minute';
  }

  String _escapeSqlitePath(String value) => value.replaceAll("'", "''");

  String _encodeValue(Object value) {
    return jsonEncode(value);
  }

  int? _decodeInt(dynamic raw) {
    if (raw is String) {
      return int.tryParse(raw.replaceAll('"', ''));
    }
    return null;
  }

  String? _decodeString(dynamic raw) {
    if (raw is! String) {
      return null;
    }
    if (raw.startsWith('"') && raw.endsWith('"') && raw.length >= 2) {
      return raw.substring(1, raw.length - 1);
    }
    return raw;
  }

  DateTime? _decodeDate(dynamic raw) {
    final text = _decodeString(raw);
    if (text == null || text.isEmpty) {
      return null;
    }
    return DateTime.tryParse(text);
  }

  Future<void> _safeDeleteDirectory(Directory directory) async {
    if (await directory.exists()) {
      await directory.delete(recursive: true);
    }
  }
}

class _PreparedBackup {
  const _PreparedBackup({
    required this.workingPath,
    required this.tempDirectory,
    required this.schemaVersion,
    required this.appVersion,
    required this.createdAt,
  });

  final String workingPath;
  final Directory tempDirectory;
  final int schemaVersion;
  final String? appVersion;
  final DateTime? createdAt;

  Future<void> dispose() async {
    if (await tempDirectory.exists()) {
      await tempDirectory.delete(recursive: true);
    }
  }
}
