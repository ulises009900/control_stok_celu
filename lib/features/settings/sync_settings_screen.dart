import 'package:control_stok_celu/core/errors/app_exception.dart';
import 'package:control_stok_celu/data/sync/sync_api_client.dart';
import 'package:control_stok_celu/data/sync/sync_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SyncSettingsScreen extends ConsumerStatefulWidget {
  const SyncSettingsScreen({super.key});

  @override
  ConsumerState<SyncSettingsScreen> createState() => _SyncSettingsScreenState();
}

class _SyncSettingsScreenState extends ConsumerState<SyncSettingsScreen> {
  final _serverController = TextEditingController();
  final _userController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loggingIn = false;

  @override
  void dispose() {
    _serverController.dispose();
    _userController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_serverController.text.trim().isEmpty ||
        _userController.text.trim().isEmpty ||
        _passwordController.text.isEmpty) {
      _showMessage('Completá servidor, usuario y contraseña.');
      return;
    }
    setState(() => _loggingIn = true);
    try {
      await ref.read(syncControllerProvider.notifier).login(
            serverUrl: _serverController.text.trim(),
            username: _userController.text.trim(),
            password: _passwordController.text,
          );
      _passwordController.clear();
      if (mounted) {
        _showMessage('Conectado correctamente.');
      }
    } catch (e) {
      _showMessage(e is SyncApiException ? e.message : 'No se pudo conectar: $e');
    } finally {
      if (mounted) {
        setState(() => _loggingIn = false);
      }
    }
  }

  Future<void> _logout() async {
    await ref.read(syncControllerProvider.notifier).logout();
  }

  Future<void> _syncNow() async {
    await ref.read(syncControllerProvider.notifier).syncNow();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final credentialsAsync = ref.watch(syncCredentialsProvider);
    final syncState = ref.watch(syncControllerProvider);

    return Scaffold(
      appBar: AppBar(
        leading: Navigator.canPop(context) ? const BackButton() : null,
        title: const Text('Sincronización'),
      ),
      body: credentialsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (credentials) {
          if (credentials == null) {
            return _buildLoginForm();
          }
          return _buildConnectedView(credentials, syncState);
        },
      ),
    );
  }

  Widget _buildLoginForm() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        const Text(
          'Conectá este dispositivo al servidor central para sincronizar '
          'ventas, gastos, stock y caja con los demás teléfonos.',
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _serverController,
          keyboardType: TextInputType.url,
          decoration: const InputDecoration(
            labelText: 'URL del servidor',
            hintText: 'http://192.168.0.10:4000',
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _userController,
          decoration: const InputDecoration(labelText: 'Usuario'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: const InputDecoration(labelText: 'Contraseña'),
        ),
        const SizedBox(height: 20),
        FilledButton.icon(
          onPressed: _loggingIn ? null : _login,
          icon: _loggingIn
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.link),
          label: const Text('Conectar'),
        ),
      ],
    );
  }

  Widget _buildConnectedView(
    dynamic credentials,
    AsyncValue<dynamic> syncState,
  ) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    const Icon(Icons.cloud_done_outlined, color: Colors.green),
                    const SizedBox(width: 8),
                    Text(
                      'Conectado',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Servidor: ${credentials.serverUrl}'),
                Text(
                  'Usuario: ${credentials.displayName ?? credentials.username} '
                  '(${credentials.role == 'admin' ? 'Jefe' : 'Vendedor'})',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: syncState.isLoading ? null : _syncNow,
          icon: syncState.isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.sync),
          label: const Text('Sincronizar ahora'),
        ),
        const SizedBox(height: 12),
        syncState.when(
          data: (result) => result == null
              ? const SizedBox.shrink()
              : Text(
                  'Última sincronización: ${result.pushed} enviados, '
                  '${result.pulled} recibidos.',
                ),
          loading: () => const SizedBox.shrink(),
          error: (error, _) => Text(
            'Error al sincronizar: '
            '${error is AppException ? error.message : error}',
            style: const TextStyle(color: Colors.red),
          ),
        ),
        const SizedBox(height: 24),
        OutlinedButton.icon(
          onPressed: _logout,
          icon: const Icon(Icons.logout),
          label: const Text('Desconectar este dispositivo'),
        ),
      ],
    );
  }
}
