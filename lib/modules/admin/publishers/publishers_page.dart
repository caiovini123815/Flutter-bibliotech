import 'package:flutter/material.dart';

import 'add_publisher_page.dart';
import 'models/publisher_model.dart';
import 'services/publishers_service.dart';

class PublishersPage extends StatefulWidget {
  const PublishersPage({super.key});

  @override
  State<PublishersPage> createState() => _PublishersPageState();
}

class _PublishersPageState extends State<PublishersPage> {
  static const Color cardColor = Color(0xFF6B302C);
  static const Color backgroundColor = Color(0xFFC89F7A);

  final PublishersService _service = PublishersService();
  final TextEditingController _searchController =
      TextEditingController();

  List<PublisherModel> _publishers = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadPublishers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadPublishers() async {
    try {
      final publishers = await _service.getPublishers();

      if (!mounted) return;

      setState(() {
        _publishers = publishers;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _loading = false;
      });

      _message(
        e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<void> _addPublisher() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AddPublisherPage(),
      ),
    );

    if (result == true) {
      setState(() {
        _loading = true;
      });

      await _loadPublishers();
    }
  }

  List<PublisherModel> get _filteredPublishers {
    final search = _searchController.text.toLowerCase();

    return _publishers.where((publisher) {
      return publisher.namePublisher
          .toLowerCase()
          .contains(search);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final mobile = constraints.maxWidth < 700;

          return Padding(
            padding: EdgeInsets.all(
              mobile ? 16 : 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Gestão de Editoras',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                  ),
                ),

                const SizedBox(height: 18),

                _buildActions(mobile),

                const SizedBox(height: 18),

                Text(
                  '${_filteredPublishers.length} editoras encontradas',
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
    onChanged: (_) {
      setState(() {});
    },
    decoration: const InputDecoration(
      hintText: 'Procurar por nome da editora...',
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
    onPressed: _addPublisher,
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
      children: [
        SizedBox(
          width: double.infinity,
          child: search,
        ),

        const SizedBox(height: 8),

        Row(
          children: [
            Expanded(
              child: filter,
            ),

            const SizedBox(width: 8),

            Expanded(
              child: add,
            ),
          ],
        ),
      ],
    );
  }

  return Row(
    children: [
      Expanded(
        child: search,
      ),

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
    if (_filteredPublishers.isEmpty) {
      return _empty();
    }

    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 10),
      itemCount: _filteredPublishers.length,
      separatorBuilder: (_, __) =>
          const SizedBox(height: 7),
      itemBuilder: (_, index) {
        final publisher =
            _filteredPublishers[index];

        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
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
                      publisher.namePublisher,
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
                      'E-mail: ${publisher.email}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                      ),
                    ),

                    Text(
                      'Telefone: ${publisher.phonePublisher}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                      ),
                    ),

                    Text(
                      'Site: ${publisher.website}',
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
    if (_filteredPublishers.isEmpty) {
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

          headingTextStyle:
              const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),

          dataTextStyle:
              const TextStyle(
            color: Colors.white,
          ),

          columns: const [
            DataColumn(
              label: Text('Editora'),
            ),
            DataColumn(
              label: Text('E-mail'),
            ),
            DataColumn(
              label: Text('Telefone'),
            ),
            DataColumn(
              label: Text('Site'),
            ),
            DataColumn(
              label: Text('Ações'),
            ),
          ],

          rows: _filteredPublishers.map(
            (publisher) {
              return DataRow(
                cells: [
                  DataCell(
                    Text(
                      publisher.namePublisher,
                    ),
                  ),

                  DataCell(
                    Text(
                      publisher.email,
                    ),
                  ),

                  DataCell(
                    Text(
                      publisher.phonePublisher,
                    ),
                  ),

                  DataCell(
                    Text(
                      publisher.website,
                    ),
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
            },
          ).toList(),
        ),
      ),
    );
  }

  Widget _empty() {
    return const Center(
      child: Text(
        'Nenhuma editora encontrada.',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  void _message(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: Colors.red.shade800,
      ),
    );
  }
}