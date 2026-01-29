import 'package:flutter/material.dart';
import 'package:journal_app/pages/home.dart';
import 'package:journal_app/pages/login_screen.dart';
import 'package:journal_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    if (auth.isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator(color: Colors.grey)),
      );
    }

    return auth.isAuthenticated ? const Home() : const LoginScreen();
  }
}
