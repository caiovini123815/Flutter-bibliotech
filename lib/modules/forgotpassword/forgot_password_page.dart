
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() =>
      _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _newPasswordController =
      TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();

  static const Color vinho = Color(0xFF420F0F);
  static const Color marrom = Color(0xFF6B302C);
  static const Color botao = Color(0xFF794444);

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showMessage(String message, {bool success = false}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: success ? Colors.green.shade700 : Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  void _confirmPassword() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _showMessage(
      'As senhas coincidem! Informações corretas!',
      success: true,
    );
  }

  void _cancel() {
    _newPasswordController.clear();
    _confirmPasswordController.clear();
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
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 450,
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
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
                    padding: const EdgeInsets.fromLTRB(
                      16, 28, 16, 35,
                    ),
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
                            'Recuperar Senha',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFFFCF9F9),
                              fontSize: 32,
                              fontFamily: 'Georgia',
                            ),
                          ),

                          const SizedBox(height: 48),

                          TextFormField(
                            controller: _newPasswordController,
                            obscureText: true,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                            decoration: const InputDecoration(
                              labelText: 'Nova Senha :',
                              labelStyle: TextStyle(
                                color: Colors.white70,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white54,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Preencha este campo!';
                              }

                              if (value.length < 6) {
                                return 'A nova senha deve ter no mínimo 6 caracteres!';
                              }

                              return null;
                            },
                          ),

                          const SizedBox(height: 55),

                          TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: true,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                            decoration: const InputDecoration(
                              labelText: 'Confirmar Senha :',
                              labelStyle: TextStyle(
                                color: Colors.white70,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white54,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Preencha este campo!';
                              }

                              if (value != _newPasswordController.text) {
                                return 'As senhas não coincidem!';
                              }

                              return null;
                            },
                          ),

                          const SizedBox(height: 75),

                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: _cancel,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: botao,
                                  foregroundColor: Colors.white,
                                  elevation: 4,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
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
                                onPressed: _confirmPassword,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: botao,
                                  foregroundColor: Colors.white,
                                  elevation: 4,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 13,
                                  ),
                                  shape: const StadiumBorder(),
                                ),
                                child: const Text(
                                  'CONFIRMAR',
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
