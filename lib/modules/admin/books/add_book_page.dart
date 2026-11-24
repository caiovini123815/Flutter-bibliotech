
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../core/services/http/auth_service.dart';
import 'services/books_service.dart';

class AddBookPage extends StatefulWidget {
  const AddBookPage({super.key});

  @override
  State<AddBookPage> createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  static const Color primaryColor = Color(0xFF420F0F);
  static const Color cardColor = Color(0xFF6B302C);

  final BooksService _service = BooksService();

  final _titleController = TextEditingController();
  final _isbnController = TextEditingController();
  final _genreController = TextEditingController();
  final _pagesController = TextEditingController();
  final _quantityController = TextEditingController();

  List<Map<String, dynamic>> _publishers = [];

  int? _publisherId;
  bool _loadingPublishers = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadPublishers();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _isbnController.dispose();
    _genreController.dispose();
    _pagesController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _loadPublishers() async {
    try {
      final token = await AuthService().getToken();

      final response = await http.get(
        Uri.parse('${AuthService.baseUrl}/publishers'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        throw Exception();
      }

      final data = jsonDecode(response.body);

      final List<dynamic> content =
          data is Map ? (data['content'] ?? []) : data;

      if (!mounted) return;

      setState(() {
        _publishers = content
            .map(
              (item) => Map<String, dynamic>.from(item),
            )
            .toList();
        _loadingPublishers = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _loadingPublishers = false;
      });
    }
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    final isbn = _isbnController.text.trim();
    final genre = _genreController.text.trim();

    final pages =
        int.tryParse(_pagesController.text.trim());

    final quantity =
        int.tryParse(_quantityController.text.trim());

    if (title.length < 3) {
      _message('Informe um título válido.');
      return;
    }

    if (!RegExp(r'^(978|979)\d{10}$').hasMatch(isbn)) {
      _message('Informe um ISBN válido com 13 dígitos.');
      return;
    }

    if (genre.length < 3) {
      _message('Informe um gênero válido.');
      return;
    }

    if (pages == null || pages < 1) {
      _message('Informe o número de páginas.');
      return;
    }

    if (quantity == null || quantity < 1) {
      _message('Informe uma quantidade válida.');
      return;
    }

    if (_publisherId == null) {
      _message('Selecione uma editora.');
      return;
    }

    setState(() {
      _saving = true;
    });

    try {
      await _service.createBook(
        title: title,
        isbn: isbn,
        genre: genre,
        numberPages: pages,
        quantity: quantity,
        publisherId: _publisherId!,
      );

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      _message(
        e.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  void _message(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: Colors.red.shade800,
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label, {
    TextInputType? keyboardType,
    int? maxLength,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLength: maxLength,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        counterText: '',
        filled: true,
        fillColor: Colors.black.withValues(alpha: 0.12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Colors.white.withValues(alpha: 0.25),
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC89F7A),
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        title: const Text('Adicionar Livro'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 500,
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  _field(
                    _titleController,
                    'Título',
                  ),
                  const SizedBox(height: 14),
                  _field(
                    _isbnController,
                    'ISBN',
                    keyboardType: TextInputType.number,
                    maxLength: 13,
                  ),
                  const SizedBox(height: 14),
                  _field(
                    _genreController,
                    'Gênero',
                  ),
                  const SizedBox(height: 14),
                  _field(
                    _pagesController,
                    'Número de páginas',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 14),
                  _field(
                    _quantityController,
                    'Quantidade',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<int>(
                    value: _publisherId,
                    dropdownColor: cardColor,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Editora',
                      labelStyle: TextStyle(
                        color: Colors.white70,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white24,
                        ),
                      ),
                    ),
                    items: _publishers.map((publisher) {
                      final id = int.tryParse(
                        publisher['id'].toString(),
                      );

                      if (id == null) {
                        return null;
                      }

                      final name =
                          publisher['namePublisher']
                              ?.toString() ??
                          'Editora';

                      return DropdownMenuItem<int>(
                        value: id,
                        child: Text(name),
                      );
                    }).whereType<DropdownMenuItem<int>>().toList(),
                    onChanged: _loadingPublishers
                        ? null
                        : (value) {
                            setState(() {
                              _publisherId = value;
                            });
                          },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _saving ? null : _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: primaryColor,
                      ),
                      child: _saving
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child:
                                  CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'SALVAR',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
