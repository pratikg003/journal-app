import 'package:flutter/material.dart';
import 'package:journal_app/pages/auth_gate.dart';
import 'package:journal_app/providers/auth_provider.dart';
import 'package:journal_app/providers/journal_provider.dart';
import 'package:journal_app/routes/route_guard.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => JournalProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        return MaterialApp(
          title: 'Journal App',
          home: const AuthGate(),
          onGenerateRoute: (settings) =>
              appRouteGuard(settings, auth.isAuthenticated),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
