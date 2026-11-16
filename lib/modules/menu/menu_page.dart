
import 'dart:ui';

import 'package:flutter/material.dart';
import '../dashboard/dashboard_page.dart';
import '../books/books_page.dart';

import '../../core/services/http/auth_service.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();

  bool _drawerExpanded = true;
  int _selectedIndex = 0;

  static const Color primaryColor = Color(0xFF420F0F);

  final List<Map<String, dynamic>> _menuItems = [
    {'title': 'Início', 'icon': Icons.home},
    {'title': 'Dashboard', 'icon': Icons.dashboard},
    {'title': 'Livros', 'icon': Icons.menu_book},
    {'title': 'Empréstimos', 'icon': Icons.payments},
    {'title': 'Editoras', 'icon': Icons.business_center},
    {'title': 'Usuários', 'icon': Icons.people},
    {'title': 'Configurações', 'icon': Icons.settings},
  ];

  void _selectPage(int index, {bool isMobile = false}) {
    setState(() {
      _selectedIndex = index;
    });

    if (isMobile) {
      Navigator.pop(context);
    }
  }

  Widget _buildSidebar({bool isMobile = false}) {
    return Container(
      width: isMobile ? 300 : (_drawerExpanded ? 300 : 75),
      color: primaryColor,
      child: Column(
        children: [
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: _menuItems.length,
              itemBuilder: (context, index) {
                final item = _menuItems[index];

                return InkWell(
                  onTap: () => _selectPage(
                    index,
                    isMobile: isMobile,
                  ),
                  child: Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    color: _selectedIndex == index
                        ? const Color(0xFF501919)
                        : Colors.transparent,
                    child: Row(
                      children: [
                        Icon(
                          item['icon'] as IconData,
                          color: Colors.white,
                          size: 25,
                        ),
                        if (isMobile || _drawerExpanded) ...[
                          const SizedBox(width: 30),
                          Expanded(
                            child: Text(
                              item['title'] as String,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHome() {
    final screenWidth = MediaQuery.of(context).size.width;

    final titleSize = screenWidth < 400 ? 24.0 : 28.0;

    return SizedBox.expand(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/image-bibliotech.png',
            fit: BoxFit.cover,
          ),

          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 480,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 7,
                      sigmaY: 7,
                    ),
                    child: Container(
                      width: double.infinity,

                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 30,
                      ),

                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(
                          177,
                          125,
                          125,
                          0.90,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),

                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Bem-vindo a BIBLIOTECH',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: titleSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 16),

                          const Text(
                            'O seu sistema moderno de gerenciamento de biblioteca.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),

                          const SizedBox(height: 40),

                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _selectedIndex = 1;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding:
                                  const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(4),
                              ),
                            ),
                            child: const Text(
                              'EXPLORAR',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
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
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder(String title) {
    return Container(
      color: const Color(0xFFC89F7A),
      width: double.infinity,
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildPage() {
  if (_selectedIndex == 0) {
    return _buildHome();
  }

  if (_selectedIndex == 1) {
    return const DashboardPage();
  }
  if (_selectedIndex == 2) {
    return const BooksPage();
  }

  return _buildPlaceholder(
    _menuItems[_selectedIndex]['title'] as String,
  );
}

  Future<void> _logout() async {
    await AuthService().logout();

    if (!mounted) return;

    Navigator.of(context).pushNamedAndRemoveUntil(
      '/',
      (route) => false,
    );
  }

  void _showProfileMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'A tela Meu Perfil será implementada posteriormente.',
        ),
      ),
    );
  }

  Widget _buildUserMenu() {
    return PopupMenuButton<String>(
      icon: const Icon(
        Icons.account_circle,
        color: Colors.white,
        size: 27,
      ),
      color: Colors.white,
      onSelected: (value) {
        if (value == 'profile') {
          _showProfileMessage();
        } else if (value == 'logout') {
          _logout();
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          enabled: false,
          child: Row(
            children: [
              Icon(
                Icons.account_circle,
                color: Color(0xFF420F0F),
                size: 35,
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Usuário',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Conta autenticada',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem(
          value: 'profile',
          child: Row(
            children: [
              Icon(Icons.person, color: Colors.black),
              SizedBox(width: 12),
              Text('Meu Perfil'),
            ],
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem(
          value: 'logout',
          child: Row(
            children: [
              Icon(Icons.logout, color: Colors.red),
              SizedBox(width: 12),
              Text(
                'Sair',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWide = constraints.maxWidth >= 800;

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: const Color(0xFFC89F7A),

          appBar: AppBar(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            elevation: 2,
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                if (isWide) {
                  setState(() {
                    _drawerExpanded = !_drawerExpanded;
                  });
                } else {
                  _scaffoldKey.currentState?.openDrawer();
                }
              },
            ),
            title: const Text(
              'BIBLIOTECH',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            actions: [
              _buildUserMenu(),
              const SizedBox(width: 12),
            ],
          ),

          drawer: isWide
              ? null
              : Drawer(
                  width: 300,
                  backgroundColor: primaryColor,
                  child: SafeArea(
                    child: _buildSidebar(isMobile: true),
                  ),
                ),

          body: Row(
            children: [
              if (isWide) _buildSidebar(),
              Expanded(
                child: _buildPage(),
              ),
            ],
          ),
        );
      },
    );
  }
}
