import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/services/http/auth_service.dart';
import '../models/book_model.dart';

class BooksService {
  final AuthService _authService = AuthService();

  Future<List<BookModel>> getBooks() async {
    final token = await _authService.getToken();

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

    final List books = data['content'];

    return books
        .map(
          (book) => BookModel.fromJson(book),
        )
        .toList();
  }
}