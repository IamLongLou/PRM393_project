import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../models/customer.dart';
import '../../models/bill.dart';
import '../../providers/billing_provider.dart';
import '../../providers/customer_provider.dart';
import '../../routes/app_routes.dart';
import 'receipt_screen.dart';
import 'package:intl/intl.dart';

class PaymentScreen extends StatelessWidget {
  final Customer customer;
  final int newReading;
  final String imagePath;

  const PaymentScreen({super.key, required this.customer, required this.newReading, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    int consumption = newReading - customer.currentReading;
    bool isRollover = false;
    
    // Xử lý trường hợp quay vòng đồng hồ (Ví dụ: 9999 -> 0001)
    if (consumption < 0) {
      // Giả định đồng hồ có 4 chữ số (max 9999), nếu âm thì có thể là quay vòng
      // Nếu chỉ số cũ rất lớn (vùng 9xxx) và mới rất nhỏ (vùng 0xxx)
      if (customer.currentReading > 9000 && newReading < 1000) {
        consumption = (10000 - customer.currentReading) + newReading;
        isRollover = true;
      } else {
        consumption = 0; // Vẫn để 0 nếu không phải quay vòng để tránh lỗi tiền âm
      }
    }

    final double amount = consumption * 12000.0;
    final double vat = amount * 0.1;
    final double total = amount + vat;
    final format = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Thanh Toán Mới', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (newReading < customer.currentReading && !isRollover)
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.red[50], borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.red[200]!)),
                child: const Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, color: Colors.red),
                    SizedBox(width: 10),
                    Expanded(child: Text('Cảnh báo: Chỉ số mới đang thấp hơn chỉ số cũ. Vui lòng kiểm tra lại!', style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold))),
                  ],
                ),
              ),
            _sectionHeader(Icons.person_outline, 'THÔNG TIN KHÁCH HÀNG'),
            _buildCustomerInfo(context),
            const SizedBox(height: 25),
            _sectionHeader(Icons.water_drop_outlined, 'CHỈ SỐ NƯỚC (M³)'),
            Row(
              children: [
                _readingBox(context, 'Chỉ số Cũ', '${customer.currentReading}', false),
                const SizedBox(width: 15),
                _readingBox(context, 'Chỉ số Mới', '$newReading', true),
              ],
            ),
            const SizedBox(height: 25),
            _sectionHeader(Icons.description_outlined, 'CHI TIẾT HÓA ĐƠN'),
            _buildBillDetail(context, consumption, amount, vat, total, format, isRollover),
            const SizedBox(height: 25),
            _buildQRCode(context, total),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: (newReading < customer.currentReading && !isRollover) ? null : () => _confirmPayment(context, consumption, total),
              icon: const Icon(Icons.receipt_long_outlined),
              label: const Text('Lập Hóa Đơn & In Biên Lai'),
              style: ElevatedButton.styleFrom(
                backgroundColor: (newReading < customer.currentReading && !isRollover) ? Colors.grey : Colors.blue,
              ),
            ),
            const SizedBox(height: 15),
            const Center(child: Text('Dữ liệu sẽ được lưu tạm thời trên thiết bị và đồng bộ tự\nđộng khi có kết nối mạng ổn định.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 10))),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _sectionHeader(IconData icon, String title) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(children: [Icon(icon, size: 18, color: Colors.blue), const SizedBox(width: 8), Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey))]),
  );

  Widget _buildCustomerInfo(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color, 
        borderRadius: BorderRadius.circular(15), 
        border: Border.all(color: Colors.grey.withOpacity(0.1))
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 28, backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=${customer.id}')),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(customer.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isDark ? Colors.white : Colors.black)),
                Text('# DB: 102938475', style: TextStyle(color: isDark ? Colors.white60 : Colors.grey[600], fontSize: 11)),
                Row(children: [const Icon(Icons.location_on, size: 10, color: Colors.grey), const SizedBox(width: 4), Text(customer.address, style: TextStyle(color: isDark ? Colors.white54 : Colors.grey, fontSize: 11))]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _readingBox(BuildContext context, String label, String value, bool isNew) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: isNew ? Colors.blue : Colors.grey, fontSize: 11, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(
            height: 60,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isNew ? (isDark ? Colors.white.withOpacity(0.1) : Colors.white) : (isDark ? Colors.white.withOpacity(0.05) : Colors.grey[50]), 
              borderRadius: BorderRadius.circular(12), 
              border: Border.all(color: isNew ? Colors.blue : Colors.transparent)
            ),
            child: Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
          ),
        ],
      ),
    );
  }

  Widget _buildBillDetail(BuildContext context, int consumption, double amount, double vat, double total, NumberFormat format, bool isRollover) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color, 
        borderRadius: BorderRadius.circular(15), 
        border: Border.all(color: Colors.grey.withOpacity(0.1))
      ),
      child: Column(
        children: [
          _billRow(context, Icons.info_outline, 'Tiêu thụ (Mới - Cũ)', '$consumption m³${isRollover ? " (Quay vòng)" : ""}'),
          _billRow(context, null, 'Đơn giá định mức', '12.000 đ/m³'),
          const Divider(height: 30),
          _billRow(context, null, 'Thành tiền (trước VAT)', format.format(amount)),
          _billRow(context, null, 'Thuế VAT (10%)', format.format(vat)),
          const Divider(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('TỔNG CỘNG\n(Bao gồm VAT)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.grey)),
              Text(format.format(total), style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.pinkAccent)),
            ],
          )
        ],
      ),
    );
  }

  Widget _billRow(BuildContext context, IconData? icon, String label, String value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          if (icon != null) ...[Icon(icon, size: 14, color: Colors.grey), const SizedBox(width: 8)],
          Text(label, style: TextStyle(color: isDark ? Colors.white70 : Colors.black87, fontSize: 13)),
          const Spacer(),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: isDark ? Colors.white : Colors.black)),
        ],
      ),
    );
  }

  Widget _buildQRCode(BuildContext context, double total) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Column(
        children: [
          const Text('QUÉT MÃ QR ĐỂ THANH TOÁN', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white, // QR code usually needs white background
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
            ),
            child: QrImageView(
              data: "Payment amount: ${total.toInt()} VND",
              version: QrVersions.auto,
              size: 180.0,
            ),
          ),
        ],
      ),
    );
  }

  void _confirmPayment(BuildContext context, int consumption, double total) async {
    final bill = Bill(customerId: customer.id!, billCode: 'INV-20231024-8892', date: DateTime.now(), oldReading: customer.currentReading, newReading: newReading, consumption: consumption.toDouble(), unitPrice: 12000, amount: total / 1.1, vat: total - (total/1.1), totalAmount: total, isSynced: false);
    context.read<BillingProvider>().saveBill(bill);
    context.read<CustomerProvider>().updateCustomerReading(customer.id!, newReading);
    Navigator.push(context, MaterialPageRoute(builder: (_) => ReceiptScreen(customer: customer, bill: bill)));
  }

  Widget _buildBottomNav(BuildContext context) => BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    currentIndex: 1, // Thuộc phần Khách hàng
    selectedItemColor: Colors.blue,
    unselectedItemColor: Colors.grey,
    onTap: (index) {
      if (index == 0) Navigator.pushReplacementNamed(context, AppRoutes.home);
      if (index == 1) Navigator.pushReplacementNamed(context, AppRoutes.customerList);
      if (index == 2) Navigator.pushReplacementNamed(context, AppRoutes.history);
      if (index == 3) Navigator.pushReplacementNamed(context, AppRoutes.settings);
    },
    items: const [
      BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Trang chủ'),
      BottomNavigationBarItem(icon: Icon(Icons.people_outline), label: 'Khách hàng'),
      BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Lịch sử'),
      BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Cài đặt'),
    ],
  );
}
