
import 'package:flutter/material.dart';

import 'modules/login/login_page.dart';
import 'modules/forgotpassword/forgot_password_page.dart';
import 'modules/register/register_page.dart';
import 'modules/menu/menu_page.dart';

void main() {
  runApp(const BibliotecaApp());
}

class BibliotecaApp extends StatelessWidget {
  const BibliotecaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bibliotech',

      home: const LoginPage(),

      routes: {
        '/menu': (context) => const MenuPage(),
        '/forgotpassword': (context) => const ForgotPasswordPage(),
        '/register': (context) => const RegisterPage(),
      },
    );
  }
}
