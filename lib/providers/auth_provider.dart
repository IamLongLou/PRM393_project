import 'package:flutter/material.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    // Giả lập delay mạng
    await Future.delayed(const Duration(seconds: 1));

    // Luôn cho phép đăng nhập để tiện kiểm tra
    _user = User(
      username: username.isEmpty ? 'nhanvien01' : username,
      fullName: 'Nguyễn Văn A',
      role: 'Nhân viên ghi số',
    );
    
    _isLoading = false;
    notifyListeners();
    return true;
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}
