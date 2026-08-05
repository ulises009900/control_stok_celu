class AppException implements Exception {
  AppException(this.message);

  final String message;

  @override
  String toString() => message;
}

class ValidationException extends AppException {
  ValidationException(super.message);
}

class NotFoundException extends AppException {
  NotFoundException(super.message);
}

class ConflictException extends AppException {
  ConflictException(super.message);
}
