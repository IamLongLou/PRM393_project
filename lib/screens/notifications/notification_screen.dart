import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dữ liệu mẫu thông báo
    final List<Map<String, String>> notifications = [
      {
        'title': 'Thông báo hệ thống',
        'content': 'Khu vực Hòa Lạc, huyện Thạch Thất đang có có sự cố mất nước ở trường ĐH FPT. Vui lòng nhắc nhở sinh viên ngừng đến trường.',
        'time': '10 phút trước',
        'type': 'system'
      },
      {
        'title': 'Lịch bảo trì',
        'content': 'Khu vực của bạn sẽ tạm ngừng cấp nước từ 23h đêm nay để bảo trì định kỳ. Quý khách vui lòng dự trữ nước.',
        'time': '2 giờ trước',
        'type': 'maintenance'
      },
      {
        'title': 'Thanh toán thành công',
        'content': 'Hóa đơn tháng 05/2024 của khách hàng Nguyễn Văn A đã được thanh toán thành công.',
        'time': '5 giờ trước',
        'type': 'payment'
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Thông báo', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final item = notifications[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 15),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _getIconColor(item['type']!).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(_getIcon(item['type']!), color: _getIconColor(item['type']!), size: 20),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(item['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          Text(item['time']!, style: const TextStyle(color: Colors.grey, fontSize: 10)),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        item['content']!,
                        style: const TextStyle(color: Colors.black54, fontSize: 13, height: 1.4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  IconData _getIcon(String type) {
    switch (type) {
      case 'system': return Icons.info_outline;
      case 'maintenance': return Icons.build_circle_outlined;
      case 'payment': return Icons.check_circle_outline;
      default: return Icons.notifications_none;
    }
  }

  Color _getIconColor(String type) {
    switch (type) {
      case 'system': return Colors.blue;
      case 'maintenance': return Colors.orange;
      case 'payment': return Colors.green;
      default: return Colors.grey;
    }
  }
}
