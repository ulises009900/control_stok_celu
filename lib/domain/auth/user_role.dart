/// Rol de un usuario logueado en el dispositivo. Coincide con los roles
/// manejados por el servidor de sincronización (`admin`/`vendedor`).
enum UserRole { admin, vendedor }

UserRole userRoleFromString(String? value) {
  switch (value) {
    case 'admin':
      return UserRole.admin;
    case 'vendedor':
    default:
      return UserRole.vendedor;
  }
}

String userRoleToString(UserRole role) {
  switch (role) {
    case UserRole.admin:
      return 'admin';
    case UserRole.vendedor:
      return 'vendedor';
  }
}

extension UserRoleX on UserRole {
  bool get isAdmin => this == UserRole.admin;

  String get displayLabel {
    switch (this) {
      case UserRole.admin:
        return 'Administrador';
      case UserRole.vendedor:
        return 'Vendedor';
    }
  }
}
