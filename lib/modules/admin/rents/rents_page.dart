
import 'package:flutter/material.dart';

import 'add_rent_page.dart';
import 'models/rent_model.dart';
import 'services/rents_service.dart';

class RentsPage extends StatefulWidget {
  const RentsPage({super.key});

  @override
  State<RentsPage> createState() => _RentsPageState();
}

class _RentsPageState extends State<RentsPage> {
  static const Color cardColor = Color(0xFF6B302C);
  static const Color backgroundColor = Color(0xFFC89F7A);

  final RentsService _rentsService = RentsService();

  final TextEditingController _searchController =
      TextEditingController();

  List<RentModel> _rents = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadRents();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadRents() async {
    try {
      final rents = await _rentsService.getRents();

      if (!mounted) return;

      setState(() {
        _rents = rents;
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

  Future<void> _addRent() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AddRentPage(),
      ),
    );

    if (result == true && mounted) {
      setState(() {
        _loading = true;
      });

      await _loadRents();
    }
  }

  Future<void> _returnRent(RentModel rent) async {
    try {
      await _rentsService.returnRent(rent.id);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Livro devolvido com sucesso!'),
        ),
      );

      await _loadRents();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst('Exception: ', ''),
          ),
        ),
      );
    }
  }

  List<RentModel> get _filteredRents {
    final search = _searchController.text.toLowerCase().trim();

    return _rents.where((rent) {
      return rent.userName.toLowerCase().contains(search) ||
          rent.bookTitle.toLowerCase().contains(search);
    }).toList();
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '—';

    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  Color _statusColor(String status) {
    if (status == 'RETURNED') {
      return const Color(0xFFE0C98F);
    }

    return Colors.orange.shade200;
  }

  String _statusText(String status) {
    if (status == 'RETURNED') {
      return 'DEVOLVIDO';
    }

    if (status == 'RENTED') {
      return 'ALUGADO';
    }

    return status;
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
                  'Gestão de Aluguéis',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                  ),
                ),

                const SizedBox(height: 18),

                _buildActions(mobile),

                const SizedBox(height: 18),

                Text(
                  '${_filteredRents.length} aluguéis encontrados',
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
        hintText: 'Procurar por usuário ou livro...',
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
      onPressed: _addRent,
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
    if (_filteredRents.isEmpty) {
      return _empty();
    }

    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 10),
      itemCount: _filteredRents.length,
      separatorBuilder: (_, __) =>
          const SizedBox(height: 7),
      itemBuilder: (_, index) {
        final rent = _filteredRents[index];

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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rent.userName,
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
                      'Livro: ${rent.bookTitle}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                      ),
                    ),

                    Text(
                      'Aluguel: ${_formatDate(rent.rentDate)}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                      ),
                    ),

                    Text(
                      'Vencimento: ${_formatDate(rent.returnPeriod)}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                      ),
                    ),

                    if (rent.returnDate != null)
                      Text(
                        'Devolvido em: ${_formatDate(rent.returnDate)}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 10,
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: _statusColor(rent.status),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _statusText(rent.status),
                      style: const TextStyle(
                        color: Color(0xFF420F0F),
                        fontWeight: FontWeight.bold,
                        fontSize: 9,
                      ),
                    ),
                  ),

                  if (rent.status == 'RENTED') ...[
                    const SizedBox(height: 8),

                    SizedBox(
                      height: 32,
                      child: ElevatedButton(
                        onPressed: () => _returnRent(rent),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE0C98F),
                          foregroundColor: cardColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'DEVOLVER',
                          style: TextStyle(fontSize: 9),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDesktop() {
    if (_filteredRents.isEmpty) {
      return _empty();
    }

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: DataTable(
            columnSpacing: 35,
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
              DataColumn(label: Text('Usuário')),
              DataColumn(label: Text('Livro')),
              DataColumn(label: Text('Aluguel')),
              DataColumn(label: Text('Vencimento')),
              DataColumn(label: Text('Status')),
              DataColumn(label: Text('Ações')),
            ],
            rows: _filteredRents.map((rent) {
              return DataRow(
                cells: [
                  DataCell(Text(rent.userName)),
                  DataCell(Text(rent.bookTitle)),
                  DataCell(
                    Text(_formatDate(rent.rentDate)),
                  ),
                  DataCell(
                    Text(_formatDate(rent.returnPeriod)),
                  ),
                  DataCell(
                    Text(
                      _statusText(rent.status),
                      style: TextStyle(
                        color: _statusColor(rent.status),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DataCell(
                    rent.status == 'RENTED'
                        ? TextButton(
                            onPressed: () => _returnRent(rent),
                            child: const Text(
                              'DEVOLVER',
                              style: TextStyle(
                                color: Color(0xFFE0C98F),
                              ),
                            ),
                          )
                        : const Text(
                            '—',
                            style: TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _empty() {
    return const Center(
      child: Text(
        'Nenhum aluguel encontrado.',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
