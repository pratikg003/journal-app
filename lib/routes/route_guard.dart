import 'package:flutter/material.dart';
import 'package:journal_app/pages/login_screen.dart';
import 'package:journal_app/pages/profile_screen.dart';
import 'package:journal_app/pages/settings_screen.dart';
import 'package:journal_app/routes/app_routes.dart';

Route<dynamic> appRouteGuard(
  RouteSettings settings,
  bool isLoggedIn,
) {
  switch (settings.name) {
    case AppRoutes.profile:
      return _protected(const ProfileScreen(), isLoggedIn);

    case AppRoutes.settings:
      return _protected(const SettingsScreen(), isLoggedIn);

    default:
      return MaterialPageRoute(
        builder: (_) => const Scaffold(
          body: Center(child: Text('Unknown route')),
        ),
      );
  }
}

MaterialPageRoute _protected(Widget page, bool isLoggedIn) {
  return MaterialPageRoute(
    builder: (_) => isLoggedIn ? page : const LoginScreen(),
  );
}

