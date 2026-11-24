
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'http://10.0.2.2:8080';

  static const FlutterSecureStorage _storage =
      FlutterSecureStorage();

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http
        .post(
          Uri.parse('$baseUrl/login'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'email': email,
            'password': password,
          }),
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception('Falha na autenticação.');
    }

    final data =
        jsonDecode(response.body) as Map<String, dynamic>;

    final token = data['token'] as String;
    final id = data['id'];

    final parts = token.split('.');

    if (parts.length != 3) {
      throw Exception('Token JWT inválido.');
    }

    final payload = jsonDecode(
      utf8.decode(
        base64Url.decode(
          base64Url.normalize(parts[1]),
        ),
      ),
    ) as Map<String, dynamic>;

    final isAdmin = payload['isAdmin'] == true;

    await _storage.write(
      key: 'access_token',
      value: token,
    );

    await _storage.write(
      key: 'user_id',
      value: id.toString(),
    );

    await _storage.write(
      key: 'is_admin',
      value: isAdmin.toString(),
    );

    return {
      'id': id,
      'token': token,
      'isAdmin': isAdmin,
    };
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'access_token');
  }

  Future<int?> getUserId() async {
    final id = await _storage.read(key: 'user_id');
    return id == null ? null : int.tryParse(id);
  }

  Future<bool> getIsAdmin() async {
    final value = await _storage.read(key: 'is_admin');
    return value == 'true';
  }

  Future<void> logout() async {
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'user_id');
    await _storage.delete(key: 'is_admin');
  }
}
