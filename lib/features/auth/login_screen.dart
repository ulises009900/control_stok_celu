import 'package:control_stok_celu/data/sync/sync_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Pantalla de login obligatoria: se muestra siempre que no haya una sesión
/// activa (al abrir la app por primera vez, o después de cerrar sesión).
/// Reutiliza las mismas cuentas del servidor de sincronización (admin/jefe y
/// vendedores); una vez que el login se hace con éxito, queda "recordado"
/// en este dispositivo para poder volver a entrar sin conexión.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _serverController = TextEditingController();
  final _userController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = true;
  bool _submitting = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _prefillServerUrl();
  }

  Future<void> _prefillServerUrl() async {
    String? lastServerUrl;
    try {
      final store = ref.read(syncCredentialsStoreProvider);
      lastServerUrl = await store.loadLastServerUrl();
    } catch (_) {
      // Si el almacenamiento seguro falla (por ejemplo, en un entorno sin
      // soporte de plataforma), simplemente arrancamos con el campo vacío
      // en lugar de dejar la pantalla de login trabada cargando.
      lastServerUrl = null;
    }
    if (!mounted) return;
    setState(() {
      _serverController.text = lastServerUrl ?? '';
      _loading = false;
    });
  }

  @override
  void dispose() {
    _serverController.dispose();
    _userController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final serverUrl = _serverController.text.trim();
    final username = _userController.text.trim();
    final password = _passwordController.text;
    if (serverUrl.isEmpty || username.isEmpty || password.isEmpty) {
      setState(() => _error = 'Completá servidor, usuario y contraseña.');
      return;
    }
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      await ref.read(syncControllerProvider.notifier).login(
            serverUrl: serverUrl,
            username: username,
            password: password,
          );
      // Al guardar la sesión, el router redirige solo a Inicio.
    } catch (e) {
      setState(() {
        _error = e is AuthException ? e.message : 'No se pudo iniciar sesión: $e';
      });
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Icon(
                          Icons.storefront_outlined,
                          size: 64,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Control Stok Celu',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Iniciá sesión para continuar. Usá tu usuario y '
                          'contraseña del negocio (te los da el administrador).',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        TextField(
                          controller: _serverController,
                          keyboardType: TextInputType.url,
                          decoration: const InputDecoration(
                            labelText: 'URL del servidor',
                            hintText: 'http://192.168.0.10:4000',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _userController,
                          decoration: const InputDecoration(
                            labelText: 'Usuario',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          onSubmitted: (_) => _submitting ? null : _login(),
                          decoration: const InputDecoration(
                            labelText: 'Contraseña',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        if (_error != null) ...<Widget>[
                          const SizedBox(height: 12),
                          Text(
                            _error!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ],
                        const SizedBox(height: 20),
                        FilledButton.icon(
                          onPressed: _submitting ? null : _login,
                          icon: _submitting
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2),
                                )
                              : const Icon(Icons.login),
                          label: const Text('Entrar'),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
