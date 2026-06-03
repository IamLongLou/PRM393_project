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

    // Danh sách tài khoản giả lập cho phân quyền
    final mockUsers = [
      {'user': 'admin', 'pass': 'admin123', 'name': 'Quản Trị Viên', 'role': 'admin', 'email': 'admin@water.com', 'phone': '0987654321'},
      {'user': 'nhanvien01', 'pass': '123456', 'name': 'Nguyễn Văn A', 'role': 'staff', 'email': 'nguyenvana@gmail.com', 'phone': '0912345678'},
      {'user': 'khachhang01', 'pass': '654321', 'name': 'Lê Minh Triết', 'role': 'user', 'email': 'trietle@gmail.com', 'phone': '0901234567'},
      {'user': 'abc', 'pass': '123', 'name': 'Khách Hàng Mới', 'role': 'user', 'email': 'abc@gmail.com', 'phone': '0900000000'},
    ];

    try {
      final userData = mockUsers.firstWhere(
        (u) => u['user'] == username && u['pass'] == password
      );

      _user = User(
        username: userData['user']!,
        fullName: userData['name']!,
        role: userData['role']!,
        email: userData['email'],
        phone: userData['phone'],
      );
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProfile(String name, String email, String phone) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (_user != null) {
      _user = _user!.copyWith(fullName: name, email: email, phone: phone);
      _isLoading = false;
      notifyListeners();
      return true;
    }
    _isLoading = false;
    return false;
  }

  Future<bool> changePassword(String oldPass, String newPass) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Trong thực tế sẽ gọi API, ở đây giả định luôn thành công nếu ko trống
    if (newPass.isNotEmpty) {
      _isLoading = false;
      notifyListeners();
      return true;
    }
    _isLoading = false;
    return false;
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}
