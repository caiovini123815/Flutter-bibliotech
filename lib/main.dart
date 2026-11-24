
import 'package:flutter/material.dart';

import 'modules/login/login_page.dart';
import 'modules/admin/menu/menu_page.dart';
import 'modules/users/users_dashboard_page.dart';
import 'modules/forgotpassword/forgot_password_page.dart';
import 'modules/register/register_page.dart';

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
      initialRoute: '/login',

      routes: {
        '/login': (context) => const LoginPage(),

        '/admin': (context) => const MenuPage(),

        '/user': (context) => const UserDashboardPage(),

        '/users': (context) => const UserDashboardPage(),

        '/forgotpassword': (context) => const ForgotPasswordPage(),

        '/register': (context) => const RegisterPage(),
      },
    );
  }
}
