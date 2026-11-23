import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'services/publishers_service.dart';

class AddPublisherPage extends StatefulWidget {
  const AddPublisherPage({super.key});

  @override
  State<AddPublisherPage> createState() => _AddPublisherPageState();
}

class _AddPublisherPageState extends State<AddPublisherPage> {
  static const Color primaryColor = Color(0xFF420F0F);
  static const Color cardColor = Color(0xFF6B302C);
  static const Color backgroundColor = Color(0xFFC89F7A);

  final PublishersService _service = PublishersService();

  final _nameController = TextEditingController();
  final _cnpjController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _websiteController = TextEditingController();

  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _cnpjController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    final cnpj = _cnpjController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final website = _websiteController.text.trim();

    if (name.length < 3) {
      _message('Informe um nome de editora válido.');
      return;
    }

    if (!RegExp(
      r'^[a-zA-ZáàâãéêíóôõúçÁÀÂÃÉÊÍÓÔÕÚÇ\s]+$',
    ).hasMatch(name)) {
      _message(
        'O nome da editora deve conter apenas letras e espaços.',
      );
      return;
    }

    if (!RegExp(r'^\d{14}$').hasMatch(cnpj)) {
      _message('O CNPJ deve conter exatamente 14 números.');
      return;
    }

    if (!RegExp(
      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
    ).hasMatch(email)) {
      _message('Informe um e-mail válido.');
      return;
    }

    if (!RegExp(
      r'^\(\d{2}\) \d{4,5}-\d{4}$',
    ).hasMatch(phone)) {
      _message(
        'O telefone deve estar no formato (00) 00000-0000.',
      );
      return;
    }

    if (!RegExp(
      r'^https?://(www\.)?[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)+(/.*)?$',
    ).hasMatch(website)) {
      _message(
        'O site deve estar no formato https://www.editora.com.br',
      );
      return;
    }

    setState(() {
      _saving = true;
    });

    try {
      await _service.createPublisher(
        namePublisher: name,
        cnpj: cnpj,
        email: email,
        phonePublisher: phone,
        website: website,
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

  void _message(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: Colors.red.shade800,
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label, {
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? hintText,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white38),
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.black.withValues(alpha: 0.12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Colors.white.withValues(alpha: 0.25),
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
          borderSide: BorderSide(color: Colors.white),
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
        title: const Text('Adicionar Editora'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 500,
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  _field(
                    _nameController,
                    'Nome da editora',
                  ),

                  const SizedBox(height: 14),

                  _field(
                    _cnpjController,
                    'CNPJ',
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(14),
                    ],
                    hintText: 'Somente números',
                  ),

                  const SizedBox(height: 14),

                  _field(
                    _emailController,
                    'E-mail',
                    keyboardType: TextInputType.emailAddress,
                  ),

                  const SizedBox(height: 14),

                  _field(
                    _phoneController,
                    'Telefone',
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      _PhoneInputFormatter(),
                    ],
                    hintText: '(00) 00000-0000',
                  ),

                  const SizedBox(height: 14),

                  _field(
                    _websiteController,
                    'Site',
                    keyboardType: TextInputType.url,
                    hintText: 'https://www.editora.com.br',
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

class _PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var digits = newValue.text.replaceAll(
      RegExp(r'\D'),
      '',
    );

    if (digits.length > 11) {
      digits = digits.substring(0, 11);
    }

    String formatted;

    if (digits.isEmpty) {
      formatted = '';
    } else if (digits.length <= 2) {
      formatted = '($digits';
    } else if (digits.length <= 6) {
      formatted =
          '(${digits.substring(0, 2)}) ${digits.substring(2)}';
    } else if (digits.length <= 10) {
      formatted =
          '(${digits.substring(0, 2)}) '
          '${digits.substring(2, 6)}-'
          '${digits.substring(6)}';
    } else {
      formatted =
          '(${digits.substring(0, 2)}) '
          '${digits.substring(2, 7)}-'
          '${digits.substring(7)}';
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(
        offset: formatted.length,
      ),
    );
  }
}