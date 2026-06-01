import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _autoSync = true;
  bool _biometric = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.flash_on, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 8),
            const Text(
              'WaterFlow',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileCard(),
            const SizedBox(height: 10),
            _buildSectionTitle('DEVICE & DATA'),
            _buildSettingsGroup([
              _buildSettingItem(
                icon: Icons.print_outlined,
                title: 'Thermal Printer',
                trailing: const Text(
                  'Disconnected',
                  style: TextStyle(color: Colors.red, fontSize: 13, fontWeight: FontWeight.w500),
                ),
              ),
              const Divider(height: 1, indent: 60),
              _buildSettingItem(
                icon: Icons.sync,
                title: 'Auto-Sync',
                trailing: Switch(
                  value: _autoSync,
                  onChanged: (v) => setState(() => _autoSync = v),
                  activeColor: Colors.blue,
                ),
              ),
              const Divider(height: 1, indent: 60),
              _buildSettingItem(
                icon: Icons.delete_outline,
                title: 'Clear Cache',
                subtitle: 'Current usage: 24.5 MB',
                trailing: TextButton(
                  onPressed: () {},
                  child: const Text('CLEAR', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ]),
            _buildSectionTitle('SECURITY'),
            _buildSettingsGroup([
              _buildSettingItem(
                icon: Icons.lock_outline,
                title: 'Change Password',
                trailing: const Icon(Icons.chevron_right, color: Colors.grey),
              ),
              const Divider(height: 1, indent: 60),
              _buildSettingItem(
                icon: Icons.fingerprint,
                title: 'Biometric Login',
                trailing: Switch(
                  value: _biometric,
                  onChanged: (v) => setState(() => _biometric = v),
                  activeColor: Colors.blue,
                ),
              ),
            ]),
            _buildSectionTitle('SUPPORT'),
            _buildSettingsGroup([
              _buildSettingItem(
                icon: Icons.info_outline,
                title: 'App Version',
                trailing: const Text('v2.4.0', style: TextStyle(color: Colors.grey, fontSize: 14)),
              ),
              const Divider(height: 1, indent: 60),
              _buildSettingItem(
                icon: Icons.help_outline,
                title: 'Help Center',
                trailing: const Icon(Icons.chevron_right, color: Colors.grey),
              ),
            ]),
            const SizedBox(height: 30),
            Center(
              child: TextButton.icon(
                onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false),
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Icon(Icons.edit_outlined, size: 20, color: Colors.grey[600]),
          ),
          Center(
            child: Column(
              children: [
                Stack(
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=a'),
                    ),
                    Positioned(
                      right: 2,
                      bottom: 2,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: const CircleAvatar(radius: 6, backgroundColor: Colors.green),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Nguyen Van A',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Active',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Staff ID: NV-2024-001',
                  style: TextStyle(color: Colors.grey[500], fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 25, bottom: 10, top: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSettingsGroup(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required Widget trailing,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue.withValues(alpha: 0.05),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: const Color(0xFF2196F3), size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      ),
      subtitle: subtitle != null
          ? Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey))
          : null,
      trailing: trailing,
    );
  }
}
