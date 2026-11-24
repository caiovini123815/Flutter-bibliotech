
import 'package:flutter/material.dart';

import '../../core/services/http/auth_service.dart';
import '../admin/rents/services/rents_service.dart';
import '../admin/rents/models/rent_model.dart';

class UserDashboardPage extends StatefulWidget {
  const UserDashboardPage({super.key});

  static const Color backgroundColor = Color(0xFFC89F7A);
  static const Color cardColor = Color(0xFF6B302C);
  static const Color primaryColor = Color(0xFF420F0F);

  @override
  State<UserDashboardPage> createState() => _UserDashboardPageState();
}

class _UserDashboardPageState extends State<UserDashboardPage> {
  final RentsService _rentsService = RentsService();
  final AuthService _authService = AuthService();

  List<RentModel> _userRents = [];

  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    try {
      setState(() {
        _loading = true;
        _error = null;
      });

      final userId = await _authService.getUserId();

      if (userId == null) {
        throw Exception('Não foi possível identificar o usuário logado.');
      }

      final rents = await _rentsService.getRents();

      final userRents = rents
          .where((rent) => rent.userId == userId)
          .toList();

      userRents.sort(
        (a, b) => b.rentDate.compareTo(a.rentDate),
      );

      if (!mounted) return;

      setState(() {
        _userRents = userRents;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  int get _activeRents {
    return _userRents.where((rent) => rent.returnDate == null).length;
  }

  int get _returnedRents {
    return _userRents.where((rent) => rent.returnDate != null).length;
  }

  int get _totalRents => _userRents.length;

  String _formatDate(DateTime? date) {
    if (date == null) return 'Não informado';

    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  String _statusText(RentModel rent) {
    if (rent.returnDate != null) {
      return 'Devolvido';
    }

    return 'Em andamento';
  }

  Color _statusColor(RentModel rent) {
    if (rent.returnDate != null) {
      return const Color(0xFF81C784);
    }

    return const Color(0xFFFFE082);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      color: UserDashboardPage.backgroundColor,
      child: _loading
          ? const Center(
              child: CircularProgressIndicator(
                color: UserDashboardPage.primaryColor,
              ),
            )
          : _error != null
              ? _buildError()
              : SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth < 600 ? 24 : 32,
                    vertical: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'MINHA DASHBOARD',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 16),

                      Container(
                        height: 1,
                        width: double.infinity,
                        color: Colors.white.withOpacity(0.8),
                      ),

                      const SizedBox(height: 24),

                      LayoutBuilder(
                        builder: (context, constraints) {
                          if (constraints.maxWidth >= 800) {
                            return Row(
                              children: [
                                Expanded(
                                  child: _buildInfoCard(
                                    'Aluguéis ativos',
                                    _activeRents.toString(),
                                    'Livros ainda não devolvidos',
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildInfoCard(
                                    'Livros devolvidos',
                                    _returnedRents.toString(),
                                    'Aluguéis finalizados',
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildInfoCard(
                                    'Total de aluguéis',
                                    _totalRents.toString(),
                                    'Todos os seus aluguéis',
                                  ),
                                ),
                              ],
                            );
                          }

                          return Column(
                            children: [
                              _buildInfoCard(
                                'Aluguéis ativos',
                                _activeRents.toString(),
                                'Livros ainda não devolvidos',
                              ),
                              const SizedBox(height: 16),
                              _buildInfoCard(
                                'Livros devolvidos',
                                _returnedRents.toString(),
                                'Aluguéis finalizados',
                              ),
                              const SizedBox(height: 16),
                              _buildInfoCard(
                                'Total de aluguéis',
                                _totalRents.toString(),
                                'Todos os seus aluguéis',
                              ),
                            ],
                          );
                        },
                      ),

                      const SizedBox(height: 48),

                      _buildRentalsCard(),
                    ],
                  ),
                ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.white,
              size: 48,
            ),
            const SizedBox(height: 12),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loadDashboard,
              icon: const Icon(Icons.refresh),
              label: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    String title,
    String value,
    String subtitle,
  ) {
    return Container(
      width: double.infinity,
      height: 128,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: UserDashboardPage.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFFFFE9A8),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              color: Color(0xFFE5E5E5),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRentalsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: UserDashboardPage.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Meus últimos aluguéis',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 18),

          if (_userRents.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  'Você ainda não possui aluguéis.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ),
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth >= 700) {
                  return _buildDesktopTable();
                }

                return _buildMobileList();
              },
            ),
        ],
      ),
    );
  }

  Widget _buildDesktopTable() {
    final recentRents = _userRents.take(5).toList();

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          color: Colors.black.withOpacity(0.15),
          child: const Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  'Livro alugado',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'Data do aluguel',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: Text(
                    'Status',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        ...recentRents.map((rent) {
          return _buildTableRow(rent);
        }),
      ],
    );
  }

  Widget _buildTableRow(RentModel rent) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(0.1),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              rent.bookTitle,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              _formatDate(rent.rentDate),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: _buildStatusBadge(
                _statusText(rent),
                _statusColor(rent),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileList() {
    final recentRents = _userRents.take(5).toList();

    return Column(
      children: recentRents.map((rent) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildRentalItem(rent),
        );
      }).toList(),
    );
  }

  Widget _buildRentalItem(RentModel rent) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Livro alugado',
            style: TextStyle(
              color: Color(0xFFFFE9A8),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            rent.bookTitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 12),

          const Text(
            'Data do aluguel',
            style: TextStyle(
              color: Color(0xFFFFE9A8),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            _formatDate(rent.rentDate),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Status',
                style: TextStyle(
                  color: Color(0xFFFFE9A8),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              _buildStatusBadge(
                _statusText(rent),
                _statusColor(rent),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(
    String text,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
