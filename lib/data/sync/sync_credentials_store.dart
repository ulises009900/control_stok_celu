import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SyncCredentials {
  const SyncCredentials({
    required this.serverUrl,
    required this.token,
    required this.username,
    required this.role,
    this.displayName,
  });

  final String serverUrl;
  final String token;
  final String username;
  final String role;
  final String? displayName;

  SyncCredentials copyWith({String? token}) => SyncCredentials(
        serverUrl: serverUrl,
        token: token ?? this.token,
        username: username,
        role: role,
        displayName: displayName,
      );
}

/// Tiempo máximo que esperamos al almacenamiento seguro antes de asumir que
/// no va a responder (por ejemplo, en un entorno de test sin implementación
/// de plataforma, o un dispositivo con el plugin roto). Evita que la
/// pantalla de login/splash quede trabada con el spinner girando para
/// siempre.
const Duration _secureStorageTimeout = Duration(seconds: 5);

/// Persiste la sesión de sincronización (URL del servidor, token JWT y
/// datos del usuario logueado) en almacenamiento seguro del dispositivo.
class SyncCredentialsStore {
  SyncCredentialsStore([FlutterSecureStorage? storage])
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const _keyServerUrl = 'sync_server_url';
  static const _keyToken = 'sync_token';
  static const _keyUsername = 'sync_username';
  static const _keyRole = 'sync_role';
  static const _keyDisplayName = 'sync_display_name';

  Future<String?> loadLastServerUrl() async {
    return _storage.read(key: _keyServerUrl).timeout(
          _secureStorageTimeout,
          onTimeout: () => null,
        );
  }

  Future<SyncCredentials?> load() async {
    final Map<String, String> values = await _storage.readAll().timeout(
          _secureStorageTimeout,
          onTimeout: () => const <String, String>{},
        );
    final serverUrl = values[_keyServerUrl];
    final token = values[_keyToken];
    final username = values[_keyUsername];
    final role = values[_keyRole];
    if (serverUrl == null || token == null || username == null || role == null) {
      return null;
    }
    return SyncCredentials(
      serverUrl: serverUrl,
      token: token,
      username: username,
      role: role,
      displayName: values[_keyDisplayName],
    );
  }

  Future<void> save(SyncCredentials credentials) async {
    await _storage
        .write(key: _keyServerUrl, value: credentials.serverUrl)
        .timeout(_secureStorageTimeout);
    await _storage
        .write(key: _keyToken, value: credentials.token)
        .timeout(_secureStorageTimeout);
    await _storage
        .write(key: _keyUsername, value: credentials.username)
        .timeout(_secureStorageTimeout);
    await _storage
        .write(key: _keyRole, value: credentials.role)
        .timeout(_secureStorageTimeout);
    if (credentials.displayName != null) {
      await _storage
          .write(key: _keyDisplayName, value: credentials.displayName!)
          .timeout(_secureStorageTimeout);
    } else {
      await _storage.delete(key: _keyDisplayName).timeout(_secureStorageTimeout);
    }
  }

  Future<void> clear({bool keepServerUrl = true}) async {
    if (!keepServerUrl) {
      await _storage.delete(key: _keyServerUrl).timeout(_secureStorageTimeout);
    }
    await _storage.delete(key: _keyToken).timeout(_secureStorageTimeout);
    await _storage.delete(key: _keyUsername).timeout(_secureStorageTimeout);
    await _storage.delete(key: _keyRole).timeout(_secureStorageTimeout);
    await _storage
        .delete(key: _keyDisplayName)
        .timeout(_secureStorageTimeout);
  }
}
