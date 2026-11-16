import 'package:flutter/material.dart';

import 'models/book_model.dart';
import 'services/books_service.dart';

class BooksPage extends StatefulWidget {
  const BooksPage({super.key});

  @override
  State<BooksPage> createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  static const Color primaryColor = Color(0xFF420F0F);
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
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _loading = false;
      });
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
          final isMobile = constraints.maxWidth < 700;

          return Padding(
            padding: EdgeInsets.all(isMobile ? 16 : 24),
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
                _buildActions(isMobile),
                const SizedBox(height: 20),
                Text(
                  '${_filteredBooks.length} livros encontrados',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: _loading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : isMobile
                          ? _buildMobileList()
                          : _buildDesktopTable(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildActions(bool isMobile) {
    if (isMobile) {
      return Column(
        children: [
          TextField(
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
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildFilterButton(),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildAddButton(),
              ),
            ],
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: TextField(
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
          ),
        ),
        const SizedBox(width: 15),
        SizedBox(
          width: 205,
          child: _buildFilterButton(),
        ),
        const SizedBox(width: 15),
        SizedBox(
          width: 205,
          child: _buildAddButton(),
        ),
      ],
    );
  }

  Widget _buildFilterButton() {
    return SizedBox(
      height: 48,
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.filter_alt),
        label: const Text('FILTRO'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return SizedBox(
      height: 48,
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text('ADICIONAR'),
        style: ElevatedButton.styleFrom(
          backgroundColor: cardColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopTable() {
    if (_filteredBooks.isEmpty) {
      return _buildEmpty();
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 50,
          headingRowColor: WidgetStateProperty.all(
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
                      size: 19,
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

  Widget _buildMobileList() {
    if (_filteredBooks.isEmpty) {
      return _buildEmpty();
    }

    return ListView.separated(
      itemCount: _filteredBooks.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final book = _filteredBooks[index];

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      book.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(
                      Icons.edit,
                      color: Color(0xFFE0C98F),
                      size: 19,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _info('Autor', '—'),
              _info(
                'Lançamento',
                _date(book.publicationDate),
              ),
              _info(
                'Quantidade',
                book.quantity.toString(),
              ),
              _info(
                'Editora',
                book.publisherName,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _info(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          SizedBox(
            width: 95,
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return const Center(
      child: Text(
        'Nenhum livro encontrado.',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
  }
}