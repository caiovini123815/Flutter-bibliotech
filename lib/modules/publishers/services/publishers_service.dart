import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/services/http/auth_service.dart';
import '../models/publisher_model.dart';

class PublishersService {
  Future<List<PublisherModel>> getPublishers() async {
    final token = await AuthService().getToken();

    final response = await http.get(
      Uri.parse('${AuthService.baseUrl}/publishers'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Erro ao carregar editoras: ${response.statusCode}',
      );
    }

    final data = jsonDecode(response.body);

    final List<dynamic> content =
        data is Map ? (data['content'] ?? []) : data;

    return content
        .map(
          (item) => PublisherModel.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();
  }

  Future<void> createPublisher({
    required String namePublisher,
    required String cnpj,
    required String email,
    required String phonePublisher,
    required String website,
  }) async {
    final token = await AuthService().getToken();

    final response = await http.post(
      Uri.parse('${AuthService.baseUrl}/publishers'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'namePublisher': namePublisher,
        'cnpj': cnpj,
        'email': email,
        'phonePublisher': phonePublisher,
        'website': website,
      }),
    );

    if (response.statusCode != 201) {
      String message =
          'Erro ao cadastrar editora: ${response.statusCode}';

      try {
        final data = jsonDecode(response.body);

        if (data is Map && data['message'] != null) {
          message = data['message'].toString();
        }
      } catch (_) {}

      throw Exception(message);
    }
  }
}