import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

/// Hash local de contraseñas (salted SHA-256) usado únicamente para poder
/// verificar el login sin conexión en ESTE dispositivo, después de que la
/// cuenta ya se validó al menos una vez contra el servidor. No reemplaza ni
/// se compara nunca con el hash real (bcrypt) que guarda el servidor.
class PasswordHasher {
  static const int _saltLength = 16;

  static String generateSalt() {
    final random = Random.secure();
    final bytes = List<int>.generate(_saltLength, (_) => random.nextInt(256));
    return base64Url.encode(bytes);
  }

  static String hash(String password, String salt) {
    final bytes = utf8.encode('$salt:$password');
    return sha256.convert(bytes).toString();
  }

  static bool verify(String password, String salt, String expectedHash) {
    return hash(password, salt) == expectedHash;
  }
}
