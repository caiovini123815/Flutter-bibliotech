
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _dateController = TextEditingController();
  final _cpfController = TextEditingController();
  final _addressController = TextEditingController();

  static const Color vinho = Color(0xFF420F0F);
  static const Color marrom = Color(0xFF6B302C);
  static const Color botao = Color(0xFF794444);

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _telephoneController.dispose();
    _dateController.dispose();
    _cpfController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  InputDecoration _decoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white54),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
      errorStyle: const TextStyle(color: Colors.yellowAccent),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: 'Selecione sua data de nascimento',
    );

    if (selectedDate != null) {
      final day = selectedDate.day.toString().padLeft(2, '0');
      final month = selectedDate.month.toString().padLeft(2, '0');
      final year = selectedDate.year;

      setState(() {
        _dateController.text = '$day/$month/$year';
      });
    }
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Informações preenchidas corretamente!'),
          backgroundColor: Color(0xFF397A45),
          behavior: SnackBarBehavior.floating,
        ),
      );

  }

  void _cancelRegister() {
    _nameController.clear();
    _emailController.clear();
    _telephoneController.clear();
    _dateController.clear();
    _cpfController.clear();
    _addressController.clear();

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/image-bibliotech.png',
            fit: BoxFit.cover,
          ),

          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 450),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: vinho,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 25,
                        spreadRadius: 5,
                        offset: Offset(0, 15),
                      ),
                    ],
                  ),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(30, 20, 30, 35),
                    decoration: BoxDecoration(
                      color: marrom,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Cadastrar-se',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFFFCF9F9),
                              fontSize: 32,
                              fontFamily: 'Georgia',
                            ),
                          ),

                          const SizedBox(height: 25),

                          TextFormField(
                            controller: _nameController,
                            style: const TextStyle(color: Colors.white),
                            decoration: _decoration('Nome Completo :'),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Preencha este campo!';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 8),

                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(color: Colors.white),
                            decoration: _decoration('E-mail :'),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Preencha este campo!';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 8),

                          TextFormField(
                            controller: _telephoneController,
                            keyboardType: TextInputType.phone,
                            style: const TextStyle(color: Colors.white),
                            decoration: _decoration('Telefone :'),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Preencha este campo!';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 8),

                          TextFormField(
                            controller: _dateController,
                            readOnly: true,
                            onTap: _selectDate,
                            style: const TextStyle(color: Colors.white),
                            decoration: _decoration('Data de Nascimento :')
                                .copyWith(
                              suffixIcon: const Icon(
                                Icons.calendar_today,
                                color: Colors.white70,
                                size: 18,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Selecione sua data de nascimento!';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 8),

                          TextFormField(
                            controller: _cpfController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              CpfInputFormatter(),
                            ],
                            style: const TextStyle(color: Colors.white),
                            decoration: _decoration('CPF :'),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Preencha este campo!';
                              }
                              if (value.replaceAll(RegExp(r'\D'), '').length != 11) {
                                return 'Digite um CPF completo!';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 8),

                          TextFormField(
                            controller: _addressController,
                            style: const TextStyle(color: Colors.white),
                            decoration: _decoration('Endereço :'),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Preencha este campo!';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 48),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: _cancelRegister,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: botao,
                                  foregroundColor: Colors.white,
                                  elevation: 4,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 13,
                                  ),
                                  shape: const StadiumBorder(),
                                ),
                                child: const Text(
                                  'CANCELAR',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                              ElevatedButton(
                                onPressed: _submitForm,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: botao,
                                  foregroundColor: Colors.white,
                                  elevation: 4,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 13,
                                  ),
                                  shape: const StadiumBorder(),
                                ),
                                child: const Text(
                                  'CADASTRAR',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
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
}

class CpfInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String digits = newValue.text.replaceAll(RegExp(r'\D'), '');

    if (digits.length > 11) {
      digits = digits.substring(0, 11);
    }

    final result = StringBuffer();

    for (int i = 0; i < digits.length; i++) {
      if (i == 3 || i == 6) {
        result.write('.');
      } else if (i == 9) {
        result.write('-');
      }
      result.write(digits[i]);
    }

    final text = result.toString();

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
