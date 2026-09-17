import 'dart:convert';

import 'package:http/http.dart' as http;

class SyncApiException implements Exception {
  SyncApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

class SyncLoginResult {
  const SyncLoginResult({
    required this.token,
    required this.username,
    required this.role,
    this.displayName,
  });

  final String token;
  final String username;
  final String role;
  final String? displayName;
}

class SyncPullResult {
  const SyncPullResult({
    required this.rows,
    required this.nextSince,
    required this.hasMore,
  });

  final List<Map<String, dynamic>> rows;
  final String nextSince;
  final bool hasMore;
}

class AppUser {
  const AppUser({
    required this.id,
    required this.username,
    required this.displayName,
    required this.role,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as String,
      username: json['username'] as String,
      displayName:
          json['display_name'] as String? ?? json['username'] as String,
      role: json['role'] as String,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'] as String)
          : null,
    );
  }

  final String id;
  final String username;
  final String displayName;
  final String role;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
}

/// Cliente HTTP delgado para hablar con la API central de sincronización.
/// No conoce nada de Drift/SQLite: solo hace requests y traduce errores.
class SyncApiClient {
  SyncApiClient({
    required String serverUrl,
    required this.deviceId,
    this.token,
  }) : baseUrl = serverUrl.endsWith('/')
            ? serverUrl.substring(0, serverUrl.length - 1)
            : serverUrl;

  final String baseUrl;
  final String deviceId;
  String? token;

  Map<String, String> get _headers => <String, String>{
        'Content-Type': 'application/json',
        'X-Device-Id': deviceId,
        if (token != null) 'Authorization': 'Bearer $token',
      };

  Future<SyncLoginResult> login(String username, String password) async {
    final uri = Uri.parse('$baseUrl/auth/login');
    final response = await http.post(
      uri,
      headers: const <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );
    _checkOk(response);
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final user = data['user'] as Map<String, dynamic>;
    token = data['token'] as String;
    return SyncLoginResult(
      token: token!,
      username: user['username'] as String,
      role: user['role'] as String,
      displayName: user['displayName'] as String?,
    );
  }

  Future<SyncPullResult> pull(String table, {required String since}) async {
    final uri = Uri.parse('$baseUrl/sync/$table/pull')
        .replace(queryParameters: <String, String>{'since': since});
    final response = await http.get(uri, headers: _headers);
    _checkOk(response);
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return SyncPullResult(
      rows: (data['rows'] as List<dynamic>).cast<Map<String, dynamic>>(),
      nextSince: data['nextSince'] as String,
      hasMore: data['hasMore'] as bool? ?? false,
    );
  }

  Future<int> push(String table, List<Map<String, dynamic>> rows) async {
    final uri = Uri.parse('$baseUrl/sync/$table/push');
    final response = await http.post(
      uri,
      headers: _headers,
      body: jsonEncode(<String, dynamic>{'rows': rows}),
    );
    _checkOk(response);
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return data['applied'] as int? ?? 0;
  }

  Future<List<AppUser>> getUsers() async {
    final uri = Uri.parse('$baseUrl/users');
    final response = await http.get(uri, headers: _headers);
    _checkOk(response);
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final list = data['users'] as List<dynamic>? ?? <dynamic>[];
    return list
        .map((e) => AppUser.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<AppUser> createUser({
    required String username,
    required String password,
    required String role,
    String? displayName,
  }) async {
    final uri = Uri.parse('$baseUrl/users');
    final response = await http.post(
      uri,
      headers: _headers,
      body: jsonEncode(<String, dynamic>{
        'username': username,
        'password': password,
        'role': role,
        if (displayName != null && displayName.isNotEmpty)
          'displayName': displayName,
      }),
    );
    _checkOk(response);
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return AppUser.fromJson(data['user'] as Map<String, dynamic>);
  }

  Future<AppUser> updateUser({
    required String id,
    String? displayName,
    String? role,
    bool? isActive,
    String? password,
  }) async {
    final uri = Uri.parse('$baseUrl/users/$id');
    final response = await http.put(
      uri,
      headers: _headers,
      body: jsonEncode(<String, dynamic>{
        if (displayName != null) 'displayName': displayName,
        if (role != null) 'role': role,
        if (isActive != null) 'is_active': isActive,
        if (password != null && password.isNotEmpty) 'password': password,
      }),
    );
    _checkOk(response);
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return AppUser.fromJson(data['user'] as Map<String, dynamic>);
  }

  Future<void> deleteUser(String id) async {
    final uri = Uri.parse('$baseUrl/users/$id');
    final response = await http.delete(uri, headers: _headers);
    _checkOk(response);
  }

  void _checkOk(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw SyncApiException(_extractError(response),
          statusCode: response.statusCode);
    }
  }

  String _extractError(http.Response response) {
    try {
      final data = jsonDecode(response.body);
      if (data is Map && data['error'] != null) {
        return data['error'] as String;
      }
    } catch (_) {
      // Ignorar: el cuerpo no era JSON, se usa el mensaje genérico.
    }
    return 'Error de sincronización (código ${response.statusCode}).';
  }
}
