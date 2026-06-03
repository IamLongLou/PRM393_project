import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/customer_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/customer.dart';
import '../../routes/app_routes.dart';
import '../../core/utils/formatter_utils.dart';
import '../../core/constants/app_strings.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Widget _buildWeatherCard() {
    final hour = DateTime.now().hour;
    IconData weatherIcon;
    Color iconColor;
    String temperature;

    if (hour >= 6 && hour < 12) {
      weatherIcon = Icons.wb_sunny;
      iconColor = Colors.orange;
      temperature = '28°C';
    } else if (hour >= 12 && hour < 18) {
      weatherIcon = Icons.wb_cloudy;
      iconColor = Colors.blueGrey;
      temperature = '32°C';
    } else if (hour >= 18 && hour < 22) {
      weatherIcon = Icons.nightlight_round;
      iconColor = Colors.indigo;
      temperature = '26°C';
    } else {
      weatherIcon = Icons.ac_unit;
      iconColor = Colors.lightBlueAccent;
      temperature = '22°C';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
      ),
      child: Row(
        children: [
          Icon(weatherIcon, color: iconColor, size: 20),
          const SizedBox(width: 6),
          Text(temperature, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = FormatterUtils.formatDate(DateTime.now(), pattern: 'EEEE, d MMMM, yyyy');
    final user = Provider.of<AuthProvider>(context).user;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context, user?.fullName ?? 'Người dùng', user?.role ?? 'user'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('${FormatterUtils.getGreeting()}, 👋', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        const Spacer(),
                        _buildWeatherCard(),
                      ],
                    ),
                    Text('Hôm nay: $formattedDate', style: const TextStyle(color: Colors.grey, fontSize: 14)),
                    const SizedBox(height: 20),
                    if (user?.role != 'user') _buildReadyBanner(),
                    const SizedBox(height: 20),
                    if (user?.role == 'staff') _buildStaffStats(context),
                    if (user?.role == 'admin') _buildAdminStats(context),
                    if (user?.role == 'user') _buildUserHeader(),
                    const SizedBox(height: 30),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('CHỨC NĂNG CHÍNH', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text('Xem tất cả', style: TextStyle(color: Colors.blue, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 15),
                    _buildFunctionGrid(context, user?.role ?? 'user'),
                    const SizedBox(height: 20),
                    _buildNoticeBanner(user?.role ?? 'user'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context, user?.role ?? 'user'),
    );
  }

  Widget _buildAppBar(BuildContext context, String name, String role) {
    String roleLabel = role == 'admin' ? 'Quản trị' : (role == 'staff' ? 'Nhân viên' : 'Khách hàng');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF2196F3), Color(0xFF00BCD4)],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.water_drop, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(AppStrings.appName, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(roleLabel, style: const TextStyle(fontSize: 10, color: Colors.blue, fontWeight: FontWeight.bold)),
            ],
          ),
          const Spacer(),
          InkWell(
            onTap: () => Navigator.pushNamed(context, AppRoutes.notifications),
            child: const Stack(
              children: [
                Icon(Icons.notifications_none, size: 28),
                Positioned(right: 0, top: 0, child: CircleAvatar(radius: 5, backgroundColor: Colors.red)),
              ],
            ),
          ),
          const SizedBox(width: 15),
          InkWell(
            onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
            child: CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage('https://ui-avatars.com/api/?name=$name&background=random'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStaffStats(BuildContext context) {
    return Consumer<CustomerProvider>(
      builder: (context, provider, child) {
        final customers = provider.allCustomers;
        final pendingCount = customers.where((c) => c.status != CollectionStatus.completed).length;
        final completedCount = customers.where((c) => c.status == CollectionStatus.completed).length;
        
        return Row(
          children: [
            _buildStatCard(context, '$pendingCount', 'CHƯA GHI', Colors.orange, 0),
            const SizedBox(width: 15),
            _buildStatCard(context, '$completedCount', 'HOÀN TẤT', Colors.green, 1),
          ],
        );
      },
    );
  }

  Widget _buildAdminStats(BuildContext context) {
    return Row(
      children: [
        _buildStatCard(context, '1.2B', 'DOANH THU', Colors.blue, 0),
        const SizedBox(width: 15),
        _buildStatCard(context, '98%', 'TỶ LỆ THU', Colors.purple, 1),
      ],
    );
  }

  Widget _buildUserHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Số dư hiện tại', style: TextStyle(fontSize: 14, color: Colors.black54)),
          SizedBox(height: 5),
          Text('452,000 đ', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blue)),
          SizedBox(height: 10),
          Text('Hạn thanh toán: 30/06/2026', style: TextStyle(fontSize: 12, color: Colors.redAccent, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildReadyBanner() {
    final String lastSync = DateFormat('HH:mm a').format(DateTime.now().subtract(const Duration(minutes: 45)));
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Dữ liệu đã sẵn sàng', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text('Đồng bộ lần cuối: $lastSync', style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.green)),
            child: const Text('Ổn định', style: TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String value, String label, Color color, int tabIndex) {
    return Expanded(
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, AppRoutes.customerList, arguments: {'tabIndex': tabIndex}),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10)]),
          child: Row(
            children: [
              Icon(Icons.analytics_outlined, color: color, size: 24),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFunctionGrid(BuildContext context, String role) {
    return Consumer<CustomerProvider>(
      builder: (context, provider, child) {
        final pendingCount = provider.allCustomers.where((c) => c.status != CollectionStatus.completed).length;
        
        List<Widget> cards = [];
        
        if (role == 'admin') {
          cards = [
            _funcCard(context, 'Quản lý NV', 'Quản lý nhân viên thu tiền', Icons.badge_outlined, Colors.indigo, AppRoutes.settings),
            _funcCard(context, 'Doanh thu', 'Thống kê tài chính toàn hệ thống', Icons.payments_outlined, Colors.green, AppRoutes.statistics),
            _funcCard(context, 'Khách hàng', 'Danh sách hộ dân toàn thành phố', Icons.people_outline, Colors.blue, AppRoutes.customerList),
            _funcCard(context, 'Cấu hình', 'Cài đặt đơn giá & hệ thống', Icons.settings_suggest_outlined, Colors.orange, AppRoutes.settings),
          ];
        } else if (role == 'staff') {
          cards = [
            _funcCard(context, 'Khách hàng', 'Danh sách hộ dân & ghi chỉ số nước', Icons.people_outline, Colors.blue, AppRoutes.customerList, hasBadge: true, badgeValue: '$pendingCount'),
            _funcCard(context, 'Đồng bộ', 'Tải lên kết quả & cập nhật dữ liệu', Icons.sync, Colors.green, AppRoutes.sync),
            _funcCard(context, 'Thống kê', 'Báo cáo sản lượng & hiệu suất thu', Icons.bar_chart, Colors.purple, AppRoutes.statistics),
            _funcCard(context, 'Lịch sử', 'Nhật ký hoạt động & biên lai đã xuất', Icons.history, Colors.grey, AppRoutes.history),
          ];
        } else {
          cards = [
            _funcCard(context, 'Hóa đơn', 'Xem hóa đơn tiền nước tháng này', Icons.receipt_long_outlined, Colors.blue, AppRoutes.history),
            _funcCard(context, 'Thanh toán', 'Thanh toán trực tuyến an toàn', Icons.account_balance_wallet_outlined, Colors.green, AppRoutes.home),
            _funcCard(context, 'Lịch sử', 'Lịch sử sử dụng nước & thanh toán', Icons.history, Colors.purple, AppRoutes.history),
            _funcCard(context, 'Hỗ trợ', 'Gửi yêu cầu hỗ trợ kỹ thuật', Icons.support_agent_outlined, Colors.orange, AppRoutes.settings),
          ];
        }

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
          childAspectRatio: 1.2,
          children: cards,
        );
      },
    );
  }

  Widget _funcCard(BuildContext context, String title, String desc, IconData icon, Color color, String route, {bool hasBadge = false, String badgeValue = '0'}) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, route),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(height: 12),
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 4),
                Text(desc, style: const TextStyle(color: Colors.grey, fontSize: 10), maxLines: 2),
              ],
            ),
          ),
          if (hasBadge)
            Positioned(
              right: 10, top: 10,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                child: Text(badgeValue, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNoticeBanner(String role) {
    String message = role == 'user' 
      ? 'Khu vực của bạn sẽ tạm ngừng cấp nước từ 23h đêm nay để bảo trì định kỳ. Quý khách vui lòng dự trữ nước.'
      : 'Khu vực Hòa Lạc, huyện Thạch Thất đang có có sự cố mất nước ở trường ĐH FPT. Vui lòng nhắc nhở sinh viên ngừng đến trường.';
      
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: const Color(0xFFE3F2FD), borderRadius: BorderRadius.circular(15)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, color: Colors.blue),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Thông báo hệ thống', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text(message, style: const TextStyle(color: Colors.black54, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context, String role) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: 0,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        if (index == 0) return;
        if (index == 1) {
          if (role == 'user') {
             Navigator.pushReplacementNamed(context, AppRoutes.history);
          } else {
             Navigator.pushReplacementNamed(context, AppRoutes.customerList);
          }
        }
        if (index == 2) Navigator.pushReplacementNamed(context, AppRoutes.history);
        if (index == 3) Navigator.pushReplacementNamed(context, AppRoutes.settings);
      },
      items: [
        const BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Trang chủ'),
        BottomNavigationBarItem(
          icon: Icon(role == 'user' ? Icons.receipt_long_outlined : Icons.people_outline), 
          label: role == 'user' ? 'Hóa đơn' : 'Khách hàng'
        ),
        const BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Lịch sử'),
        const BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Cài đặt'),
      ],
    );
  }
}
