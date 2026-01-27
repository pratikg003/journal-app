import 'package:flutter/material.dart';
import 'package:journal_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.read<AuthProvider>().login();
          },
          child: Text('Login'),
        ),
      ),
    );
  }
}
