
import 'package:flutter/material.dart';
import '../../core/services/http/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _rememberMe = false;
  bool _showPassword = false;
  bool _isLoading = false;

  static const Color wine = Color(0xFF420F0F);
  static const Color cardColor = Color(0xFF6B302C);
  static const Color buttonColor = Color(0xFF794444);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final email =
        _emailController.text.trim().toLowerCase();
    final password = _passwordController.text;

    if (!email.endsWith('@gmail.com')) {
      _showMessage(
        'O e-mail deve terminar com @gmail.com!',
      );
      return;
    }

    if (password.length < 6) {
      _showMessage(
        'A senha deve ter no mínimo 6 caracteres!',
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await AuthService().login(
        email: email,
        password: password,
      );

      if (!mounted) return;

      final bool isAdmin = result['isAdmin'] == true;

      // A autenticação foi concluída.
      // O AuthService já armazenou o token e os dados do usuário.

      Navigator.pushReplacementNamed(
        context,
        '/menu',
      );

    } catch (e) {
      if (!mounted) return;

      _showMessage(
        'Não foi possível entrar. Verifique seu e-mail, senha e conexão com o servidor.',
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        color: Color(0xFFD8C5C2),
        fontSize: 16,
      ),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: Color(0xFFD8C5C2),
        ),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.white,
        ),
      ),
      errorStyle: const TextStyle(
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/image-bibliotech.png',
              fit: BoxFit.cover,
            ),

            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                ),
                child: Container(
                  width: 450,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: wine,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 30,
                        spreadRadius: 5,
                        offset: Offset(0, 20),
                      ),
                    ],
                  ),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(
                      16,
                      12,
                      16,
                      16,
                    ),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 15),

                          const Text(
                            'LOGIN',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontFamily: 'Georgia',
                            ),
                          ),

                          const SizedBox(height: 45),

                          TextFormField(
                            controller: _emailController,
                            keyboardType:
                                TextInputType.emailAddress,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                            decoration:
                                _inputDecoration('E-mail :'),
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty) {
                                return 'Preencha o e-mail!';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 30),

                          TextFormField(
                            controller: _passwordController,
                            obscureText: !_showPassword,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                            decoration:
                                _inputDecoration('Password :')
                                    .copyWith(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _showPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color:
                                      const Color(0xFFD8C5C2),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _showPassword =
                                        !_showPassword;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty) {
                                return 'Preencha a senha!';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 25),

                          SizedBox(
                            width: double.infinity,
                            height: 42,
                            child: ElevatedButton(
                              onPressed: _isLoading
                                  ? null
                                  : _submitForm,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: buttonColor,
                                foregroundColor: Colors.white,
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(30),
                                ),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child:
                                          CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text(
                                      'ENTRAR',
                                      style: TextStyle(
                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),

                          const SizedBox(height: 18),

                          Align(
                            alignment: Alignment.centerLeft,
                            child: CheckboxListTile(
                              contentPadding: EdgeInsets.zero,
                              controlAffinity:
                                  ListTileControlAffinity.leading,
                              title: const Text(
                                'Lembrar-se',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              value: _rememberMe,
                              activeColor: buttonColor,
                              checkColor: Colors.white,
                              side: const BorderSide(
                                color: Colors.white,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _rememberMe = value ?? false;
                                });
                              },
                            ),
                          ),

                          const SizedBox(height: 20),

                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 25,
                            runSpacing: 12,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/register',
                                  );
                                },
                                child: const Text(
                                  'Cadastrar-se',
                                  style: TextStyle(
                                    color: Colors.white,
                                    decoration:
                                        TextDecoration.underline,
                                  ),
                                ),
                              ),

                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/forgotpassword',
                                  );
                                },
                                child: const Text(
                                  'Esqueceu a senha?',
                                  style: TextStyle(
                                    color: Colors.white,
                                    decoration:
                                        TextDecoration.underline,
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
          ],
        ),
      ),
    );
  }
}
