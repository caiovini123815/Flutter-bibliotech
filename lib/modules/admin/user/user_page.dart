
import 'package:flutter/material.dart';

import 'add_user_page.dart';
import 'models/user_model.dart';
import 'services/users_service.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  static const Color cardColor = Color(0xFF6B302C);
  static const Color backgroundColor = Color(0xFFC89F7A);

  final UsersService _service = UsersService();
  final TextEditingController _searchController =
      TextEditingController();

  List<UserModel> _users = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadUsers() async {
    try {
      final users = await _service.getUsers();

      if (!mounted) return;

      setState(() {
        _users = users;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao carregar usuários: $e'),
        ),
      );
    }
  }

  Future<void> _addUser() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AddUserPage(),
      ),
    );

    if (result == true) {
      setState(() {
        _loading = true;
      });

      await _loadUsers();
    }
  }

  Future<void> _toggleUserStatus(UserModel user) async {
    try {
      if (user.isDisable) {
        await _service.enableUser(user.id);
      } else {
        await _service.disableUser(user.id);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            user.isDisable
                ? 'Usuário ativado com sucesso!'
                : 'Usuário desativado com sucesso!',
          ),
        ),
      );

      setState(() {
        _loading = true;
      });

      await _loadUsers();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao alterar usuário: $e'),
        ),
      );
    }
  }

  List<UserModel> get _filteredUsers {
    final search = _searchController.text.toLowerCase();

    return _users.where((user) {
      return user.nameFull.toLowerCase().contains(search) ||
          user.phone.toLowerCase().contains(search);
    }).toList();
  }

  String _date(DateTime? date) {
    if (date == null) {
      return '—';
    }

    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }

  String _profile(UserModel user) {
    return user.isAdmin ? 'Administrador' : 'Usuário';
  }

  String _status(UserModel user) {
    return user.isDisable ? 'Inativo' : 'Ativo';
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
                  'Gestão de Usuários',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                  ),
                ),
                const SizedBox(height: 18),
                _buildActions(mobile),
                const SizedBox(height: 18),
                Text(
                  '${_filteredUsers.length} usuários encontrados',
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
        hintText: 'Procurar por nome ou telefone...',
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
      onPressed: _addUser,
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
    if (_filteredUsers.isEmpty) {
      return _empty();
    }

    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 10),
      itemCount: _filteredUsers.length,
      separatorBuilder: (_, __) =>
          const SizedBox(height: 7),
      itemBuilder: (_, index) {
        final user = _filteredUsers[index];

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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.nameFull,
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
                      'Telefone: ${user.phone}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      'Nascimento: ${_date(user.dateBirth)}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      'Perfil: ${_profile(user)}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      'Status: ${_status(user)}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                tooltip: user.isDisable
                    ? 'Ativar usuário'
                    : 'Desativar usuário',
                onPressed: () => _toggleUserStatus(user),
                icon: Icon(
                  user.isDisable
                      ? Icons.check_circle_outline
                      : Icons.block,
                  color: const Color(0xFFE0C98F),
                  size: 20,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDesktop() {
    if (_filteredUsers.isEmpty) {
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
            DataColumn(label: Text('Nome')),
            DataColumn(label: Text('Telefone')),
            DataColumn(label: Text('Nascimento')),
            DataColumn(label: Text('Endereço')),
            DataColumn(label: Text('Perfil')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Ações')),
          ],
          rows: _filteredUsers.map((user) {
            return DataRow(
              cells: [
                DataCell(Text(user.nameFull)),
                DataCell(Text(user.phone)),
                DataCell(Text(_date(user.dateBirth))),
                DataCell(
                  SizedBox(
                    width: 180,
                    child: Text(
                      user.address,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                DataCell(Text(_profile(user))),
                DataCell(Text(_status(user))),
                DataCell(
                  IconButton(
                    tooltip: user.isDisable
                        ? 'Ativar usuário'
                        : 'Desativar usuário',
                    onPressed: () => _toggleUserStatus(user),
                    icon: Icon(
                      user.isDisable
                          ? Icons.check_circle_outline
                          : Icons.block,
                      color: const Color(0xFFE0C98F),
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
        'Nenhum usuário encontrado.',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
