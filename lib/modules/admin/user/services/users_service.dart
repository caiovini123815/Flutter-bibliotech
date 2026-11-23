
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/services/http/auth_service.dart';
import '../models/user_model.dart';

class UsersService {
  Future<Map<String, String>> _headers() async {
    final token = await AuthService().getToken();

    if (token == null) {
      throw Exception('Usuário não autenticado.');
    }

    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  Future<List<UserModel>> getUsers({
    int page = 0,
    int size = 100,
  }) async {
    final response = await http.get(
      Uri.parse('${AuthService.baseUrl}/users').replace(
        queryParameters: {
          'page': page.toString(),
          'size': size.toString(),
        },
      ),
      headers: await _headers(),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Erro ao carregar usuários: ${response.statusCode} - ${response.body}',
      );
    }

    final data = jsonDecode(response.body);

    final List<dynamic> content =
        data is Map ? (data['content'] ?? []) : data;

    return content
        .map(
          (item) => UserModel.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();
  }

  Future<UserModel> createUser({
    required String nameFull,
    required String email,
    required String cpf,
    required String phone,
    required String birthDate,
    required String address,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('${AuthService.baseUrl}/users'),
      headers: await _headers(),
      body: jsonEncode({
        'nameFull': nameFull,
        'email': email,
        'cpf': cpf,
        'phone': phone,
        'birthDate': birthDate,
        'address': address,
        'password': password,
      }),
    );

    if (response.statusCode != 201 &&
        response.statusCode != 200) {
      throw Exception(
        'Erro ao cadastrar usuário: ${response.statusCode} - ${response.body}',
      );
    }

    return UserModel.fromJson(
      Map<String, dynamic>.from(jsonDecode(response.body)),
    );
  }

  Future<UserModel> disableUser(int id) async {
    final response = await http.patch(
      Uri.parse('${AuthService.baseUrl}/users/$id/disable'),
      headers: await _headers(),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Erro ao desativar usuário: ${response.statusCode} - ${response.body}',
      );
    }

    return UserModel.fromJson(
      Map<String, dynamic>.from(jsonDecode(response.body)),
    );
  }

  Future<UserModel> enableUser(int id) async {
    final response = await http.patch(
      Uri.parse('${AuthService.baseUrl}/users/$id/enable'),
      headers: await _headers(),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Erro ao ativar usuário: ${response.statusCode} - ${response.body}',
      );
    }

    return UserModel.fromJson(
      Map<String, dynamic>.from(jsonDecode(response.body)),
    );
  }
}
