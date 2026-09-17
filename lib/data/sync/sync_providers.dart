import 'dart:async';

import 'package:control_stok_celu/data/auth/local_account_store.dart';
import 'package:control_stok_celu/data/providers/app_providers.dart';
import 'package:control_stok_celu/data/sync/sync_api_client.dart';
import 'package:control_stok_celu/data/sync/sync_credentials_store.dart';
import 'package:control_stok_celu/data/sync/sync_engine.dart';
import 'package:control_stok_celu/domain/auth/user_role.dart';
import 'package:control_stok_celu/features/cashbox/cashbox_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Intervalo entre sincronizaciones automáticas en segundo plano. Además de
/// este disparador periódico, la app sincroniza al iniciar sesión y al
/// volver a primer plano (ver [AppLifecycleSyncObserver]).
/// Polling corto: permite que jefe y vendedores vean una venta/caja nueva casi
/// de inmediato sin mantener un websocket abierto en segundo plano.
const Duration kAutoSyncInterval = Duration(seconds: 10);

final syncCredentialsStoreProvider = Provider<SyncCredentialsStore>((ref) {
  return SyncCredentialsStore();
});

final localAccountStoreProvider = Provider<LocalAccountStore>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return LocalAccountStore(db);
});

/// Credenciales de sincronización guardadas (URL del servidor + token +
/// usuario), o `null` si todavía no se configuró/inició sesión.
final syncCredentialsProvider = FutureProvider<SyncCredentials?>((ref) async {
  final store = ref.watch(syncCredentialsStoreProvider);
  return store.load();
});

/// Proveedor de cliente API autenticado si hay credenciales y token válidos.
final authenticatedSyncApiClientProvider =
    FutureProvider<SyncApiClient?>((ref) async {
  final credentials = await ref.watch(syncCredentialsProvider.future);
  if (credentials == null || credentials.token.isEmpty) {
    return null;
  }
  final deviceId = await ref.watch(deviceIdProvider.future);
  return SyncApiClient(
    serverUrl: credentials.serverUrl,
    deviceId: deviceId,
    token: credentials.token,
  );
});

/// Rol del usuario actualmente logueado en este dispositivo, o `null` si
/// todavía no hay sesión activa. Base de todo el control de acceso por rol.
final currentUserRoleProvider = Provider<UserRole?>((ref) {
  final credentials = ref.watch(syncCredentialsProvider).valueOrNull;
  if (credentials == null) {
    return null;
  }
  return userRoleFromString(credentials.role);
});

final isAdminProvider = Provider<bool>((ref) {
  return ref.watch(currentUserRoleProvider)?.isAdmin ?? false;
});

class AuthException implements Exception {
  AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Controla el login/logout de la app (obligatorio al abrir, hasta que se
/// cierre sesión manualmente) y la ejecución manual/automática de
/// sincronizaciones. El estado expone el resultado (o error) de la última
/// sincronización disparada.
class SyncController extends StateNotifier<AsyncValue<SyncResult?>> {
  SyncController(this._ref) : super(const AsyncValue.data(null)) {
    _scheduleAutoSync();
  }

  final Ref _ref;
  Timer? _autoSyncTimer;
  bool _syncInFlight = false;

  void _scheduleAutoSync() {
    _autoSyncTimer?.cancel();
    _autoSyncTimer = Timer.periodic(kAutoSyncInterval, (_) {
      unawaited(_autoSyncSilently());
    });
  }

  /// Sincroniza en segundo plano sin bloquear la UI ni mostrar errores
  /// intrusivos: si falla (sin conexión, etc.) simplemente se reintenta en
  /// el próximo ciclo.
  Future<void> _autoSyncSilently() async {
    if (_syncInFlight) {
      return;
    }
    final credentials = await _ref.read(syncCredentialsProvider.future);
    if (credentials == null || credentials.token.isEmpty) {
      return;
    }
    await syncNow(silent: true);
  }

  @override
  void dispose() {
    _autoSyncTimer?.cancel();
    super.dispose();
  }

  /// Intenta iniciar sesión contra el servidor. Si no hay conexión (o el
  /// servidor no responde), intenta validar con la copia local guardada de
  /// un login previo exitoso en este mismo dispositivo. Si el servidor
  /// responde explícitamente que el usuario/contraseña son incorrectos, no
  /// se hace fallback: se informa el error tal cual.
  Future<void> login({
    required String serverUrl,
    required String username,
    required String password,
  }) async {
    final deviceId = await _ref.read(deviceIdProvider.future);
    final client = SyncApiClient(serverUrl: serverUrl, deviceId: deviceId);
    final localAccounts = _ref.read(localAccountStoreProvider);
    final store = _ref.read(syncCredentialsStoreProvider);

    SyncLoginResult? online;
    try {
      online = await client.login(username, password);
    } on SyncApiException catch (e) {
      // El servidor respondió (no es un problema de red): las credenciales
      // son incorrectas o la cuenta está inactiva. No hacemos fallback.
      throw AuthException(e.message);
    } catch (_) {
      // Error de red (sin conexión, servidor inalcanzable, timeout, etc.):
      // intentamos con la copia local antes de rendirnos.
      online = null;
    }

    if (online != null) {
      await localAccounts.rememberSuccessfulLogin(
        username: online.username,
        serverUrl: serverUrl,
        password: password,
        role: userRoleFromString(online.role),
        displayName: online.displayName,
      );
      await store.save(
        SyncCredentials(
          serverUrl: serverUrl,
          token: online.token,
          username: online.username,
          role: online.role,
          displayName: online.displayName,
        ),
      );
    } else {
      final cached = await localAccounts.verify(
        username: username,
        password: password,
      );
      if (cached == null) {
        throw AuthException(
          'No hay conexión con el servidor y no encontramos una cuenta '
          'guardada en este dispositivo con ese usuario y contraseña. '
          'Conectate a internet para el primer inicio de sesión.',
        );
      }
      await store.save(
        SyncCredentials(
          serverUrl: serverUrl,
          token: '',
          username: cached.username,
          role: userRoleToString(cached.role),
          displayName: cached.displayName,
        ),
      );
    }
    _ref.invalidate(syncCredentialsProvider);
  }

  Future<void> logout() async {
    final store = _ref.read(syncCredentialsStoreProvider);
    await store.clear();
    _ref.invalidate(syncCredentialsProvider);
  }

  /// Ejecuta una sincronización. Cuando [silent] es `true` (disparada de
  /// forma automática) no reemplaza un resultado previo exitoso con el
  /// estado de "cargando" para no interrumpir la UI, y absorbe errores de
  /// red silenciosamente en vez de dejarlos en [state].
  Future<void> syncNow({bool silent = false}) async {
    if (_syncInFlight) {
      return;
    }
    _syncInFlight = true;
    if (!silent) {
      state = const AsyncValue.loading();
    }
    try {
      final credentials = await _ref.read(syncCredentialsProvider.future);
      if (credentials == null) {
        throw StateError('Primero iniciá sesión con el servidor.');
      }
      if (credentials.token.isEmpty) {
        throw StateError(
          'Iniciaste sesión sin conexión: conectate a internet y volvé a '
          'iniciar sesión para poder sincronizar.',
        );
      }
      final deviceId = await _ref.read(deviceIdProvider.future);
      final client = SyncApiClient(
        serverUrl: credentials.serverUrl,
        deviceId: deviceId,
        token: credentials.token,
      );
      final db = _ref.read(appDatabaseProvider);
      final engine = SyncEngine(db: db, client: client);
      final result = await engine.syncAll();
      state = AsyncValue.data(result);
      // Refresca las pantallas reactivas de caja; el resto de las pantallas
      // (ventas, gastos, productos, etc.) recargan solas al volver a
      // visitarlas, siguiendo el patrón ya usado en el resto de la app.
      _ref.invalidate(currentOpenCashSessionProvider);
      _ref.invalidate(cashSessionHistoryProvider);
    } catch (e, st) {
      if (!silent) {
        state = AsyncValue.error(e, st);
      }
    } finally {
      _syncInFlight = false;
    }
  }
}

final syncControllerProvider =
    StateNotifierProvider<SyncController, AsyncValue<SyncResult?>>((ref) {
  return SyncController(ref);
});
