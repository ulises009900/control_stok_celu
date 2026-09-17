import 'package:control_stok_celu/data/auth/password_hasher.dart';
import 'package:control_stok_celu/data/db/app_database.dart';
import 'package:control_stok_celu/domain/auth/user_role.dart';
import 'package:drift/drift.dart';

class CachedAccountMatch {
  const CachedAccountMatch({
    required this.username,
    required this.role,
    this.displayName,
  });

  final String username;
  final UserRole role;
  final String? displayName;
}

/// Guarda una copia local (hash, nunca la contraseña en texto plano) de cada
/// cuenta que inició sesión con éxito contra el servidor al menos una vez.
/// Permite que ese mismo usuario vuelva a loguearse en este dispositivo sin
/// conexión, comparando contra el hash guardado.
class LocalAccountStore {
  LocalAccountStore(this._db);

  final AppDatabase _db;

  Future<void> rememberSuccessfulLogin({
    required String username,
    required String serverUrl,
    required String password,
    required UserRole role,
    String? displayName,
  }) async {
    final salt = PasswordHasher.generateSalt();
    final hash = PasswordHasher.hash(password, salt);
    await _db.into(_db.cachedAccounts).insertOnConflictUpdate(
          CachedAccountsCompanion.insert(
            username: username,
            serverUrl: serverUrl,
            passwordSalt: salt,
            passwordHash: hash,
            role: userRoleToString(role),
            displayName: Value(displayName),
            updatedAt: DateTime.now().toUtc(),
          ),
        );
  }

  /// Verifica usuario/contraseña contra la última copia local guardada para
  /// ese usuario. Devuelve `null` si no hay cuenta guardada o la contraseña
  /// no coincide.
  Future<CachedAccountMatch?> verify({
    required String username,
    required String password,
  }) async {
    final row = await (_db.select(_db.cachedAccounts)
          ..where((t) => t.username.equals(username)))
        .getSingleOrNull();
    if (row == null) {
      return null;
    }
    if (!PasswordHasher.verify(password, row.passwordSalt, row.passwordHash)) {
      return null;
    }
    return CachedAccountMatch(
      username: row.username,
      role: userRoleFromString(row.role),
      displayName: row.displayName,
    );
  }
}
