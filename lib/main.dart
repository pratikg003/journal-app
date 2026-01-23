import 'package:flutter/material.dart';
import 'package:journal_app/pages/home.dart';
import 'package:journal_app/providers/journal_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(create: (_) => JournalProvider(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Journal App',
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}
