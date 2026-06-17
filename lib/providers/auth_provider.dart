import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/database_helper.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  final _db = DatabaseHelper.instance;
  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  AuthProvider() { _check(); }

  Future<void> _check() async {
    _user = await _db.getLastSession();
    notifyListeners();
  }

  Future<bool> login(String u, String p) async {
    _isLoading = true; 
    notifyListeners();
    final res = await ApiService.login(u, p);
    if (res != null) {
      _user = User.fromMap(res['user']);
      await _db.saveSession(_user!, res['token']);
      _isLoading = false; 
      notifyListeners();
      return true;
    } else {
      final last = await _db.getLastSession();
      if (last != null && last.username == u) {
        _user = last; 
        _isLoading = false; 
        notifyListeners();
        return true;
      }
    }
    _isLoading = false; 
    notifyListeners();
    return false;
  }

  Future<bool> updateProfile(String name, String email, String phone) async {
    if (_user == null) return false;
    _isLoading = true; 
    notifyListeners();
    // Simulate API update
    await Future.delayed(const Duration(milliseconds: 500));
    _user = User(
      username: _user!.username,
      fullName: name,
      role: _user!.role,
      email: email,
      phone: phone,
    );
    await _db.saveSession(_user!, null);
    _isLoading = false; 
    notifyListeners();
    return true;
  }

  Future<bool> changePassword(String oldPass, String newPass) async {
    _isLoading = true; 
    notifyListeners();
    // Simulate API update
    await Future.delayed(const Duration(milliseconds: 800));
    _isLoading = false; 
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _user = null; 
    await _db.clearSession(); 
    notifyListeners();
  }
}
