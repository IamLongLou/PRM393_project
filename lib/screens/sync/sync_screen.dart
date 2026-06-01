import 'package:flutter/material.dart';

class SyncScreen extends StatelessWidget {
  const SyncScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Trung tâm Đồng bộ', style: TextStyle(fontWeight: FontWeight.bold))),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.all(15),
            decoration: BoxDecoration(color: const Color(0xFF00E5FF), borderRadius: BorderRadius.circular(15)),
            child: Row(
              children: [
                const Icon(Icons.wifi_off, color: Colors.white),
                const SizedBox(width: 15),
                const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Cần Đồng Bộ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), Text('3 bản ghi đang chờ đẩy lên hệ thống', style: TextStyle(color: Colors.white70, fontSize: 11))])),
                Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)), child: const Text('Pending', style: TextStyle(color: Color(0xFF00E5FF), fontWeight: FontWeight.bold, fontSize: 11))),
              ],
            ),
          ),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('DANH SÁCH PHIẾU THU', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey)), Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(5)), child: const Text('3 bản ghi', style: TextStyle(fontSize: 10, color: Colors.grey)))])),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(15),
              children: [
                _syncCard('Nguyễn Văn An', '456.000đ'),
                _syncCard('Trần Thị Bích', '320.000đ'),
                _syncCard('Lê Hoàng Long', '1.240.000đ'),
              ],
            ),
          ),
          _infoBox(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                ElevatedButton.icon(onPressed: (){}, icon: const Icon(Icons.sync), label: const Text('Đồng bộ Ngay'), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00E5FF), minimumSize: const Size(double.infinity, 55), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)))),
                const SizedBox(height: 10),
                const Text('YÊU CẦU KẾT NỐI INTERNET (4G/WIFI)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _syncCard(String name, String price) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.cyan.withValues(alpha: 0.1))),
    child: Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('MÃ PHIẾU: REC-20240501', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)), Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: Colors.cyan.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(10)), child: const Text('CHỜ XỬ LÝ', style: TextStyle(color: Colors.cyan, fontSize: 9, fontWeight: FontWeight.bold)))]),
        const SizedBox(height: 10),
        Row(children: [const Icon(Icons.person_pin, color: Colors.cyan, size: 18), const SizedBox(width: 10), Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14))]),
        const SizedBox(height: 8),
        const Row(children: [Icon(Icons.location_on_outlined, size: 14, color: Colors.grey), SizedBox(width: 8), Text('123 Đường Lê Lợi, Phường 4, Quận Gò Vấp, TP.HCM', style: TextStyle(color: Colors.grey, fontSize: 11))]),
        const Row(children: [Icon(Icons.access_time, size: 14, color: Colors.grey), SizedBox(width: 8), Text('Hôm nay, 08:45', style: TextStyle(color: Colors.grey, fontSize: 11))]),
        const Divider(height: 30, thickness: 0.1),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Tổng thanh toán:', style: TextStyle(color: Colors.black54, fontSize: 12)), Text(price, style: const TextStyle(color: Colors.cyan, fontWeight: FontWeight.bold, fontSize: 16))]),
      ],
    ),
  );

  Widget _infoBox() => Container(margin: const EdgeInsets.symmetric(horizontal: 20), padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.cyan.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.cyan.withValues(alpha: 0.1), style: BorderStyle.solid)), child: const Column(children: [Icon(Icons.info_outline, color: Colors.cyan, size: 30), SizedBox(height: 10), Text('Dữ liệu sẽ được lưu trữ an toàn trên thiết bị cho đến\nkhi quá trình đồng bộ hoàn tất.', textAlign: TextAlign.center, style: TextStyle(color: Colors.cyan, fontSize: 11))]));

  Widget _buildBottomNav() => BottomNavigationBar(type: BottomNavigationBarType.fixed, selectedItemColor: Colors.blue, unselectedItemColor: Colors.grey, items: const [BottomNavigationBarItem(icon: Icon(Icons.payment), label: 'Payment'), BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Stats'), BottomNavigationBarItem(icon: Icon(Icons.sync), label: 'Sync')]);
}
