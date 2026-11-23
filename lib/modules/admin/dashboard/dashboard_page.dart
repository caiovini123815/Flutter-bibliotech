import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  static const Color backgroundColor = Color(0xFFC89F7A);
  static const Color cardColor = Color(0xFF6B302C);
  static const Color primaryColor = Color(0xFF420F0F);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      color: backgroundColor,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth < 600 ? 24 : 32,
          vertical: 24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'DASHBOARD',
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
                          'Livro mais alugado no mês',
                          'Dom Casmurro',
                          '42 aluguéis',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildInfoCard(
                          'Aluguéis no mês',
                          '128',
                          'Total aluguéis',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildInfoCard(
                          'Usuários logados',
                          '15',
                          'Ativos no momento',
                        ),
                      ),
                    ],
                  );
                }

                return Column(
                  children: [
                    _buildInfoCard(
                      'Livro mais alugado no mês',
                      'Dom Casmurro',
                      '42 aluguéis',
                    ),
                    const SizedBox(height: 16),
                    _buildInfoCard(
                      'Aluguéis no mês',
                      '128',
                      'Total aluguéis',
                    ),
                    const SizedBox(height: 16),
                    _buildInfoCard(
                      'Usuários logados',
                      '15',
                      'Ativos no momento',
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
        color: cardColor,
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
        color: cardColor,
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
            'Últimos aluguéis',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 18),
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
                flex: 2,
                child: Text(
                  'Usuário',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
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
        _buildTableRow(
          'Caio Vinícius',
          'O Alquimista',
          'Retornado N/P',
          const Color(0xFF81C784),
        ),
        _buildTableRow(
          'João Vitor',
          '1984',
          'Retornado C/A',
          const Color(0xFFFFE082),
        ),
        _buildTableRow(
          'Jéssica',
          'O Pequeno Príncipe',
          'Pendente',
          const Color(0xFFF3A6C7),
        ),
      ],
    );
  }

  Widget _buildTableRow(
    String user,
    String book,
    String status,
    Color statusColor,
  ) {
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
            flex: 2,
            child: Text(
              user,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              book,
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
                status,
                statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileList() {
    return Column(
      children: [
        _buildRentalItem(
          'Caio Vinícius',
          'O Alquimista',
          'Retornado N/P',
          const Color(0xFF81C784),
        ),
        const SizedBox(height: 12),
        _buildRentalItem(
          'João Vitor',
          '1984',
          'Retornado C/A',
          const Color(0xFFFFE082),
        ),
        const SizedBox(height: 12),
        _buildRentalItem(
          'Jéssica',
          'O Pequeno Príncipe',
          'Pendente',
          const Color(0xFFF3A6C7),
        ),
      ],
    );
  }

  Widget _buildRentalItem(
    String user,
    String book,
    String status,
    Color statusColor,
  ) {
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
            'Usuário',
            style: TextStyle(
              color: Color(0xFFFFE9A8),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            user,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
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
            book,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
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
                status,
                statusColor,
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