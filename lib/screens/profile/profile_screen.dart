import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../routes/app_routes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Color(0xFF1E293B)),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.settings),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            // Avatar Section
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 110,
                    height: 110,
                    decoration: const BoxDecoration(
                      color: Color(0xFF48CFAD),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person, size: 70, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Text(
              user?.fullName ?? "Nguyễn Văn A",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
            ),
            const SizedBox(height: 4),
            Text(
              user?.email ?? "nguyenvana@gmail.com",
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
            const SizedBox(height: 40),

            // Menu Items List
            _buildMenuItem(
              icon: Icons.person_outline, 
              title: "Thông tin cá nhân",
              onTap: () => Navigator.pushNamed(context, AppRoutes.editProfile),
            ),
            _buildMenuItem(
              icon: Icons.lock_outline, 
              title: "Đổi mật khẩu",
              onTap: () => Navigator.pushNamed(context, AppRoutes.changePassword),
            ),
            _buildMenuItem(
              icon: Icons.language_outlined, 
              title: "Ngôn ngữ", 
              trailingText: "Tiếng Việt",
              onTap: () {
                _showLanguageDialog(context);
              }
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon, 
    required String title, 
    String? trailingText, 
    required VoidCallback onTap
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ListTile(
          onTap: onTap,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          leading: Icon(icon, color: const Color(0xFF64748B), size: 22),
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w500, 
              color: Color(0xFF1E293B),
              fontSize: 15,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (trailingText != null)
                Text(
                  trailingText,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              const SizedBox(width: 5),
              const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Chọn ngôn ngữ', style: TextStyle(fontWeight: FontWeight.bold)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Tiếng Việt'),
              trailing: const Icon(Icons.check_circle, color: Color(0xFF48CFAD)),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: const Text('English'),
              onTap: () {
                // Logic change language to EN
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
