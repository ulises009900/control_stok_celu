import 'package:control_stok_celu/app/app.dart';
import 'package:control_stok_celu/data/backup/local_backup_service.dart'; // Ajusta la ruta según tu estructura
import 'package:control_stok_celu/data/providers/app_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: BackupLifecycleInitializer(
        child: StockApp(),
      ),
    ),
  );
}

/// Widget encargado de registrar el observador de copia de seguridad
class BackupLifecycleInitializer extends ConsumerStatefulWidget {
  const BackupLifecycleInitializer({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<BackupLifecycleInitializer> createState() =>
      _BackupLifecycleInitializerState();
}

class _BackupLifecycleInitializerState
    extends ConsumerState<BackupLifecycleInitializer> {
  AppLifecycleBackupObserver? _observer;

  @override
  void initState() {
    super.initState();
    // Inicialización del servicio de backup
    // Nota: Reemplaza 'localBackupServiceProvider' por el nombre real de tu Provider de LocalBackupService
    final backupService = ref.read(localBackupServiceProvider);

    _observer = AppLifecycleBackupObserver(backupService: backupService);
    _observer?.init();
  }

  @override
  void dispose() {
    _observer?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
