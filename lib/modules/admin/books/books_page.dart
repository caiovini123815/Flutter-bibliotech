import 'package:flutter/material.dart';

import 'add_book_page.dart';
import 'models/book_model.dart';
import 'services/books_service.dart';

class BooksPage extends StatefulWidget {
  const BooksPage({super.key});

  @override
  State<BooksPage> createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  static const Color cardColor = Color(0xFF6B302C);
  static const Color backgroundColor = Color(0xFFC89F7A);

  final BooksService _service = BooksService();
  final TextEditingController _searchController =
      TextEditingController();

  List<BookModel> _books = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadBooks() async {
    try {
      final books = await _service.getBooks();

      if (!mounted) return;

      setState(() {
        _books = books;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _addBook() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AddBookPage(),
      ),
    );

    if (result == true) {
      setState(() {
        _loading = true;
      });

      await _loadBooks();
    }
  }

  List<BookModel> get _filteredBooks {
    final search = _searchController.text.toLowerCase();

    return _books.where((book) {
      return book.title.toLowerCase().contains(search);
    }).toList();
  }

  String _date(String? date) {
    if (date == null || date.isEmpty) {
      return '—';
    }

    final parts = date.split('-');

    if (parts.length != 3) {
      return date;
    }

    return '${parts[2]}/${parts[1]}/${parts[0]}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final mobile = constraints.maxWidth < 700;

          return Padding(
            padding: EdgeInsets.all(mobile ? 16 : 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Gestão de Livros',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                  ),
                ),
                const SizedBox(height: 18),
                _buildActions(mobile),
                const SizedBox(height: 18),
                Text(
                  '${_filteredBooks.length} livros encontrados',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: _loading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : mobile
                          ? _buildMobile()
                          : _buildDesktop(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildActions(bool mobile) {
  final search = TextField(
    controller: _searchController,
    onChanged: (_) => setState(() {}),
    decoration: const InputDecoration(
      hintText: 'Procurar por nome do livro...',
      prefixIcon: Icon(Icons.search),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
      ),
    ),
  );

  final filter = ElevatedButton.icon(
    onPressed: () {},
    icon: const Icon(Icons.filter_alt),
    label: const Text('FILTRO'),
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black87,
      minimumSize: const Size(0, 44),
    ),
  );

  final add = ElevatedButton.icon(
    onPressed: _addBook,
    icon: const Icon(Icons.add),
    label: const Text('ADICIONAR'),
    style: ElevatedButton.styleFrom(
      backgroundColor: cardColor,
      foregroundColor: Colors.white,
      minimumSize: const Size(0, 44),
    ),
  );

  if (mobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        search,
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: filter),
            const SizedBox(width: 8),
            Expanded(child: add),
          ],
        ),
      ],
    );
  }

  return Row(
    children: [
      Expanded(child: search),
      const SizedBox(width: 15),
      SizedBox(
        width: 190,
        child: filter,
      ),
      const SizedBox(width: 15),
      SizedBox(
        width: 190,
        child: add,
      ),
    ],
  );
}

  Widget _buildMobile() {
    if (_filteredBooks.isEmpty) {
      return _empty();
    }

    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 10),
      itemCount: _filteredBooks.length,
      separatorBuilder: (_, __) =>
          const SizedBox(height: 7),
      itemBuilder: (_, index) {
        final book = _filteredBooks[index];

        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 9,
          ),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Lançamento: ${_date(book.publicationDate)}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      'Quantidade: ${book.quantity}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      'Editora: ${book.publisherName}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.edit,
                color: Color(0xFFE0C98F),
                size: 17,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDesktop() {
    if (_filteredBooks.isEmpty) {
      return _empty();
    }

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 50,
          headingRowColor:
              WidgetStateProperty.all(
            const Color(0xFF5B2926),
          ),
          headingTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          dataTextStyle: const TextStyle(
            color: Colors.white,
          ),
          columns: const [
            DataColumn(label: Text('Livro')),
            DataColumn(label: Text('Autor')),
            DataColumn(label: Text('Lançamento')),
            DataColumn(label: Text('Quantidade')),
            DataColumn(label: Text('Editora')),
            DataColumn(label: Text('Ações')),
          ],
          rows: _filteredBooks.map((book) {
            return DataRow(
              cells: [
                DataCell(Text(book.title)),
                const DataCell(Text('—')),
                DataCell(
                  Text(_date(book.publicationDate)),
                ),
                DataCell(
                  Text(book.quantity.toString()),
                ),
                DataCell(
                  Text(book.publisherName),
                ),
                DataCell(
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.edit,
                      color: Color(0xFFE0C98F),
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _empty() {
    return const Center(
      child: Text(
        'Nenhum livro encontrado.',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}