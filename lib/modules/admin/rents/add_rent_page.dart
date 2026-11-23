
import 'package:flutter/material.dart';

import '../books/models/book_model.dart';
import '../books/services/books_service.dart';
import 'services/rents_service.dart';
import '../user/models/user_model.dart';
import '../user/services/users_service.dart';

class AddRentPage extends StatefulWidget {
  const AddRentPage({super.key});

  @override
  State<AddRentPage> createState() => _AddRentPageState();
}

class _AddRentPageState extends State<AddRentPage> {
  static const Color primaryColor = Color(0xFF420F0F);
  static const Color cardColor = Color(0xFF6B302C);
  static const Color backgroundColor = Color(0xFFC89F7A);
  static const Color fieldColor = Color(0xFF5B2926);

  final _formKey = GlobalKey<FormState>();

  final _rentsService = RentsService();
  final _usersService = UsersService();
  final _booksService = BooksService();

  List<UserModel> _users = [];
  List<BookModel> _books = [];

  int? _selectedUserId;
  int? _selectedBookId;

  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final users = await _usersService.getUsers();
      final books = await _booksService.getBooks();

      if (!mounted) return;

      setState(() {
        _users = users.where((user) => !user.isDisable).toList();
        _books = books.where((book) => book.quantity > 0).toList();
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst('Exception: ', ''),
          ),
        ),
      );
    }
  }

  Future<void> _saveRent() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedUserId == null || _selectedBookId == null) {
      return;
    }

    setState(() {
      _saving = true;
    });

    try {
      await _rentsService.createRent(
        userId: _selectedUserId!,
        bookId: _selectedBookId!,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Aluguel cadastrado com sucesso!'),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst('Exception: ', ''),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        color: Colors.white70,
        fontSize: 13,
      ),
      prefixIcon: Icon(
        icon,
        color: Colors.white70,
        size: 20,
      ),
      filled: true,
      fillColor: fieldColor,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 14,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: const BorderSide(
          color: Colors.white24,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: const BorderSide(
          color: Color(0xFFE0C98F),
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: const BorderSide(
          color: Colors.redAccent,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: const BorderSide(
          color: Colors.redAccent,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
        title: const Text(
          'Adicionar Aluguel',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      body: _loading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            )
          : LayoutBuilder(
              builder: (context, constraints) {
                final mobile = constraints.maxWidth < 700;

                return SingleChildScrollView(
                  padding: EdgeInsets.all(mobile ? 16 : 24),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight -
                          (mobile ? 32 : 48),
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 480,
                        ),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Novo Aluguel',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 21,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 6),

                                const Text(
                                  'Selecione o usuário e o livro para realizar o aluguel.',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),

                                const SizedBox(height: 22),

                                DropdownButtonFormField<int>(
                                  value: _selectedUserId,
                                  dropdownColor: cardColor,
                                  iconEnabledColor: Colors.white70,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                                  decoration: _inputDecoration(
                                    label: 'Usuário',
                                    icon: Icons.person_outline,
                                  ),
                                  items: _users.map((user) {
                                    return DropdownMenuItem<int>(
                                      value: user.id,
                                      child: Text(
                                        user.nameFull,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedUserId = value;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Selecione um usuário';
                                    }
                                    return null;
                                  },
                                ),

                                const SizedBox(height: 14),

                                DropdownButtonFormField<int>(
                                  value: _selectedBookId,
                                  dropdownColor: cardColor,
                                  iconEnabledColor: Colors.white70,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                                  decoration: _inputDecoration(
                                    label: 'Livro',
                                    icon: Icons.menu_book_outlined,
                                  ),
                                  items: _books.map((book) {
                                    return DropdownMenuItem<int>(
                                      value: book.id,
                                      child: Text(
                                        '${book.title} (${book.quantity} disponível)',
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedBookId = value;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Selecione um livro';
                                    }
                                    return null;
                                  },
                                ),

                                const SizedBox(height: 22),

                                SizedBox(
                                  width: double.infinity,
                                  height: 44,
                                  child: ElevatedButton(
                                    onPressed:
                                        _saving ? null : _saveRent,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: cardColor,
                                      disabledBackgroundColor:
                                          Colors.white70,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25),
                                      ),
                                    ),
                                    child: _saving
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child:
                                                CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: cardColor,
                                            ),
                                          )
                                        : const Text(
                                            'CADASTRAR ALUGUEL',
                                            style: TextStyle(
                                              fontSize: 12,
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
                  ),
                );
              },
            ),
    );
  }
}
