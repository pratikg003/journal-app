import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier{
  bool _isAuthenticated = false;
  bool _isLoading = false;

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;

  Future<void> login() async{
    _isLoading = true;
    notifyListeners();

    await Future.delayed(Duration(seconds: 2));

    _isAuthenticated = true;
    _isLoading = false;
    notifyListeners();
  }

  void logout() {
    _isAuthenticated = false;
    notifyListeners();
  }
}