
import 'package:flutter/material.dart';

import 'services/users_service.dart';

class AddUserPage extends StatefulWidget {
  const AddUserPage({super.key});

  @override
  State<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  static const Color primaryColor = Color(0xFF420F0F);
  static const Color cardColor = Color(0xFF6B302C);

  final UsersService _service = UsersService();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _cpfController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();

  DateTime? _birthDate;

  bool _saving = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _cpfController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _message(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: Colors.red.shade800,
      ),
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }

  String _dateForApi(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }

  Future<void> _selectBirthDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: 'Data de nascimento',
      cancelText: 'CANCELAR',
      confirmText: 'CONFIRMAR',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selected != null) {
      setState(() {
        _birthDate = selected;
      });
    }
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final cpf = _cpfController.text.trim();
    final phone = _phoneController.text.trim();
    final address = _addressController.text.trim();
    final password = _passwordController.text;

    if (name.length < 3 || name.length > 100 ||
        !RegExp(r'^[A-Za-zÀ-ÿ ]+$').hasMatch(name)) {
      _message('Informe um nome válido.');
      return;
    }

    if (email.length < 5 || email.length > 150 ||
        !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
            .hasMatch(email)) {
      _message('Informe um e-mail válido.');
      return;
    }

    if (!RegExp(r'^\d{11}$').hasMatch(cpf)) {
      _message('O CPF deve conter exatamente 11 números.');
      return;
    }

    if (!RegExp(r'^\(\d{2}\) \d{4,5}-\d{4}$')
        .hasMatch(phone)) {
      _message('Telefone inválido. Use (00) 00000-0000.');
      return;
    }

    if (_birthDate == null) {
      _message('Selecione a data de nascimento.');
      return;
    }

    if (address.length < 10 || address.length > 150 ||
        !RegExp(r'^.+,\s*\d+\s*-\s*.+$')
            .hasMatch(address)) {
      _message('Endereço inválido. Use: Rua, Número - Cidade.');
      return;
    }

    if (password.length < 8 || password.length > 72 ||
        !RegExp(r'^(?=.*[A-Z])(?=.*\d)[A-Za-z\d]+$')
            .hasMatch(password)) {
      _message(
        'A senha precisa ter 8 caracteres, uma letra maiúscula e um número.',
      );
      return;
    }

    setState(() {
      _saving = true;
    });

    try {
      await _service.createUser(
        nameFull: name,
        email: email,
        cpf: cpf,
        phone: phone,
        birthDate: _dateForApi(_birthDate!),
        address: address,
        password: password,
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

  Widget _field(
    TextEditingController controller,
    String label, {
    TextInputType? keyboardType,
    int? maxLength,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLength: maxLength,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        counterText: '',
        suffixIcon: suffixIcon,
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

  Widget _birthDateField() {
    return InkWell(
      onTap: _selectBirthDate,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Data de nascimento',
          labelStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: Colors.black.withValues(alpha: 0.12),
          suffixIcon: const Icon(
            Icons.calendar_month,
            color: Colors.white70,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Colors.white.withValues(alpha: 0.25),
            ),
          ),
        ),
        child: Text(
          _birthDate == null
              ? 'Selecione uma data'
              : _formatDate(_birthDate!),
          style: TextStyle(
            color: _birthDate == null
                ? Colors.white70
                : Colors.white,
          ),
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
        title: const Text('Adicionar Usuário'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 500,
            ),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  _field(
                    _nameController,
                    'Nome completo',
                  ),
                  const SizedBox(height: 14),

                  _field(
                    _emailController,
                    'E-mail',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 14),

                  _field(
                    _cpfController,
                    'CPF (somente números)',
                    keyboardType: TextInputType.number,
                    maxLength: 11,
                  ),
                  const SizedBox(height: 14),

                  _field(
                    _phoneController,
                    'Telefone (00) 00000-0000',
                    keyboardType: TextInputType.phone,
                    maxLength: 15,
                  ),
                  const SizedBox(height: 14),

                  _birthDateField(),
                  const SizedBox(height: 14),

                  _field(
                    _addressController,
                    'Endereço (Rua, Número - Cidade)',
                  ),
                  const SizedBox(height: 14),

                  _field(
                    _passwordController,
                    'Senha',
                    obscureText: _obscurePassword,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.white70,
                      ),
                    ),
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
                              child: CircularProgressIndicator(
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
