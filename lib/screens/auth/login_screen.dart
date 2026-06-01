import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../routes/app_routes.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            const SizedBox(height: 80),
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(color: Color(0xFF2196F3), shape: BoxShape.circle),
                child: const Icon(Icons.water_drop, size: 40, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Hệ thống quản lý thu tiền nước hiện trường', 
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 14)
            ),
            const SizedBox(height: 40),
            _buildFieldLabel('Tên đăng nhập'),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Nhập tài khoản nhân viên',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 20),
            _buildFieldLabel('Mật khẩu'),
            const TextField(
              obscureText: true,
              decoration: InputDecoration(
                hintText: '••••••••',
                prefixIcon: Icon(Icons.lock_outline),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Checkbox(value: false, onChanged: (v){}),
                const Text('Ghi nhớ đăng nhập', style: TextStyle(color: Colors.grey, fontSize: 13)),
                const Spacer(),
                const Text('Quên mật khẩu?', style: TextStyle(color: Colors.blue, fontSize: 13)),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.home),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Đăng nhập hệ thống'),
                  SizedBox(width: 10),
                  Icon(Icons.arrow_forward, size: 18),
                ],
              ),
            ),
            const SizedBox(height: 30),
            _buildDemoBox(context),
            const SizedBox(height: 50),
            const Text('ⓘ PHIÊN BẢN 2.4.0 (BUILD 20241025)', style: TextStyle(fontSize: 10, color: Colors.grey)),
            const Text('© 2024 Water Utility Solutions. All rights reserved.', style: TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      ),
    );
  }

  Widget _buildDemoBox(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.green.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Icon(Icons.verified_user_outlined, color: Colors.green, size: 20),
              SizedBox(width: 10),
              Text('Truy cập nhanh (Demo Mode)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              _demoInfo('User: nhanvien01'),
              const Spacer(),
              _demoInfo('Pass: 123456'),
            ],
          ),
          const SizedBox(height: 15),
          OutlinedButton(
            onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.home),
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white,
              side: const BorderSide(color: Colors.green),
              minimumSize: const Size(double.infinity, 45),
            ),
            child: const Text('Vào Dashboard ngay', style: TextStyle(color: Colors.green)),
          )
        ],
      ),
    );
  }

  Widget _demoInfo(String text) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
    child: Text(text, style: const TextStyle(fontSize: 12, color: Colors.grey)),
  );
}
