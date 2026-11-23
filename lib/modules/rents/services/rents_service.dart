import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/services/http/auth_service.dart';
import '../models/rent_model.dart';

class RentsService {
  Future<List<RentModel>> getRents() async {
    final token = await AuthService().getToken();

    final response = await http.get(
      Uri.parse('${AuthService.baseUrl}/rents'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Erro ao carregar aluguéis: ${response.statusCode}',
      );
    }

    final data = jsonDecode(response.body);

    final List<dynamic> content =
        data is Map ? (data['content'] ?? []) : data;

    return content
        .map(
          (item) => RentModel.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();
  }

  Future<void> createRent({
    required int userId,
    required int bookId,
  }) async {
    final token = await AuthService().getToken();

    final response = await http.post(
      Uri.parse('${AuthService.baseUrl}/rents'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'userId': userId,
        'bookId': bookId,
      }),
    );

    if (response.statusCode != 201) {
      String message =
          'Erro ao cadastrar aluguel: ${response.statusCode}';

      try {
        final data = jsonDecode(response.body);

        if (data is Map && data['message'] != null) {
          message = data['message'].toString();
        }
      } catch (_) {}

      throw Exception(message);
    }
  }

  Future<void> returnRent(int rentId) async {
    final token = await AuthService().getToken();

    final response = await http.patch(
      Uri.parse('${AuthService.baseUrl}/rents/$rentId/return'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      String message =
          'Erro ao devolver livro: ${response.statusCode}';

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