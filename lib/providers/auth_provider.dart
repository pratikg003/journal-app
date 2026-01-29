import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier{
  bool _isAuthenticated = false;
  bool _isLoading = false;
  bool _rememberMe = false;

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  bool get rememberMe => _rememberMe;

  AuthProvider(){
    _loadAuthState();
  }

  Future<void> _loadAuthState() async{
    final prefs = await SharedPreferences.getInstance();
    _rememberMe = prefs.getBool('rememberMe') ?? false;

    if(_rememberMe){
    _isAuthenticated = prefs.getBool('isAuthenticated') ?? false;
    } else{
      _isAuthenticated = false;
    }
    _isLoading = false;
    notifyListeners();
  }

  void toggleRememberMe(bool value){
    _rememberMe = value;
    notifyListeners();
  }

  Future<void> login() async{
    _isLoading = true;
    notifyListeners();

    await Future.delayed(Duration(seconds: 2));
    _isAuthenticated = true;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('rememberMe', _rememberMe);

    if(_rememberMe){
    await prefs.setBool('isAuthenticated', true);
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    _isAuthenticated = false;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isAuthenticated');
    await prefs.remove('rememberMe');

    notifyListeners();
  }
}