
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/services/http/auth_service.dart';
import '../models/book_model.dart';

class BooksService {
  final AuthService _authService = AuthService();

  Future<List<BookModel>> getBooks() async {
    final token = await _authService.getToken();

    if (token == null) {
      throw Exception('Usuário não autenticado.');
    }

    final response = await http.get(
      Uri.parse('${AuthService.baseUrl}/books'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao carregar livros.');
    }

    final data = jsonDecode(response.body);

    final List<dynamic> content = data['content'] ?? [];

    return content
        .map(
          (json) => BookModel.fromJson(
            Map<String, dynamic>.from(json),
          ),
        )
        .toList();
  }

  Future<void> createBook({
    required String title,
    required String isbn,
    required String genre,
    required int numberPages,
    required int quantity,
    required int publisherId,
  }) async {
    final token = await _authService.getToken();

    if (token == null) {
      throw Exception('Usuário não autenticado.');
    }

    final response = await http.post(
      Uri.parse('${AuthService.baseUrl}/books'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'title': title,
        'isbn': isbn,
        'genre': genre,
        'numberPages': numberPages,
        'quantity': quantity,
        'publisherId': publisherId,
      }),
    );

    if (response.statusCode != 201) {
      String message = 'Erro ao cadastrar livro.';

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
