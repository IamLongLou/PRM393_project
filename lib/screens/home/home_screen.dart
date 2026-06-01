import 'package:flutter/material.dart';
import '../customer/customer_list_screen.dart';
import '../profile/profile_screen.dart';
import '../sync/sync_screen.dart';
import '../../services/customer_service.dart';

/// Màn hình Dashboard dành cho Nhân viên Thu tiền nước
/// Tích hợp đầy đủ nghiệp vụ: Thống kê, Ghi số, Thu tiền và Đồng bộ
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildOverviewTab(),
      const CustomerListScreen(), // Danh sách đi thu
      const Center(child: Text("Báo cáo doanh thu")),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: pages[_selectedIndex],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue[700],
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), label: "Tổng quan"),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: "Đi thu"),
          BottomNavigationBarItem(icon: Icon(Icons.analytics_outlined), label: "Báo cáo"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Cá nhân"),
        ],
      ),
    );
  }

  /// Tab Tổng quan: Mô tả chi tiết tiến độ và các phím tắt nghiệp vụ
  Widget _buildOverviewTab() {
    int total = CustomerService.getCustomers().length;
    int completed = CustomerService.getCollectionHistory().length;
    int pending = CustomerService.getToCollectList().length;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          
          // Mô tả công việc (Description)
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Text(
              "NHIỆM VỤ HÔM NAY",
              style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2, color: Colors.blueGrey),
            ),
          ),
          
          _buildStatsCard(total, completed, pending),
          
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              "NGHIỆP VỤ CHÍNH",
              style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2, color: Colors.blueGrey),
            ),
          ),
          
          _buildActionGrid(),
          
          // Hướng dẫn sử dụng nhanh
          _buildQuickGuide(),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, left: 24, right: 24, bottom: 30),
      decoration: BoxDecoration(
        color: Colors.blue[700],
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Nhân viên quản lý thu", style: TextStyle(color: Colors.white70)),
          SizedBox(height: 4),
          Text("NGUYỄN VĂN A", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildStatsCard(int total, int completed, int pending) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15)],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _statItem(total.toString(), "Tổng hộ"),
              _statItem(completed.toString(), "Đã thu", color: Colors.green),
              _statItem(pending.toString(), "Chưa thu", color: Colors.orange),
            ],
          ),
          const SizedBox(height: 20),
          LinearProgressIndicator(
            value: total > 0 ? completed / total : 0,
            backgroundColor: Colors.grey[200],
            color: Colors.green,
            minHeight: 10,
            borderRadius: BorderRadius.circular(5),
          ),
          const SizedBox(height: 10),
          Text("${((completed/total)*100).toStringAsFixed(0)}% Hoàn thành", style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildActionGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
        childAspectRatio: 1.4,
        children: [
          _actionCard(Icons.people_alt_outlined, "Danh sách đi thu", Colors.blue, () => setState(() => _selectedIndex = 1)),
          _actionCard(Icons.cloud_sync, "Đồng bộ (Offline)", Colors.orange, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SyncScreen()))),
          _actionCard(Icons.history_edu, "Lịch sử thu tiền", Colors.green, () {
            setState(() => _selectedIndex = 2);
          }),
          _actionCard(Icons.warning_amber_rounded, "Báo cáo sự cố", Colors.red, () {}),
        ],
      ),
    );
  }

  Widget _buildQuickGuide() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(15)),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Hướng dẫn nhanh:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.blue)),
          SizedBox(height: 8),
          Text("1. Chọn 'Đi thu' để bắt đầu ghi số nước.", style: TextStyle(fontSize: 13)),
          Text("2. Nhập số nước -> Xem bảng tính lũy kế -> Thu tiền.", style: TextStyle(fontSize: 13)),
          Text("3. Dữ liệu sẽ lưu Offline và cần Đồng bộ sau ca làm.", style: TextStyle(fontSize: 13)),
        ],
      ),
    );
  }

  Widget _statItem(String val, String label, {Color color = Colors.black}) {
    return Column(
      children: [
        Text(val, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  Widget _actionCard(IconData icon, String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey[200]!)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 35),
            const SizedBox(height: 10),
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
