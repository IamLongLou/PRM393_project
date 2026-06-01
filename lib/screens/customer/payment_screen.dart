import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/customer.dart';
import '../../models/bill.dart';
import '../../providers/billing_provider.dart';
import '../../providers/customer_provider.dart';
import 'receipt_screen.dart';
import 'package:intl/intl.dart';

class PaymentScreen extends StatelessWidget {
  final Customer customer;
  final int newReading;
  final String imagePath;

  const PaymentScreen({super.key, required this.customer, required this.newReading, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    final int consumption = newReading - customer.currentReading;
    final double amount = (consumption > 0 ? consumption : 0) * 12000;
    final double vat = amount * 0.1;
    final double total = amount + vat;
    final format = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Thanh Toán Mới', style: TextStyle(fontWeight: FontWeight.bold))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionHeader(Icons.person_outline, 'THÔNG TIN KHÁCH HÀNG'),
            _buildCustomerInfo(),
            const SizedBox(height: 25),
            _sectionHeader(Icons.water_drop_outlined, 'CHỈ SỐ NƯỚC (M³)'),
            Row(
              children: [
                _readingBox('Chỉ số Cũ', '${customer.currentReading}', false),
                const SizedBox(width: 15),
                _readingBox('Chỉ số Mới', '$newReading', true),
              ],
            ),
            const SizedBox(height: 25),
            _sectionHeader(Icons.description_outlined, 'CHI TIẾT HÓA ĐƠN'),
            _buildBillDetail(consumption, amount, vat, total, format),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () => _confirmPayment(context, consumption, total),
              icon: const Icon(Icons.receipt_long_outlined),
              label: const Text('Lập Hóa Đơn & In Biên Lai'),
            ),
            const SizedBox(height: 15),
            const Center(child: Text('Dữ liệu sẽ được lưu tạm thời trên thiết bị và đồng bộ tự\nđộng khi có kết nối mạng ổn định.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 10))),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _sectionHeader(IconData icon, String title) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(children: [Icon(icon, size: 18, color: Colors.blue), const SizedBox(width: 8), Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey))]),
  );

  Widget _buildCustomerInfo() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey.withOpacity(0.1))),
      child: Row(
        children: [
          CircleAvatar(radius: 28, backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=${customer.id}')),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(customer.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text('# DB: 102938475', style: TextStyle(color: Colors.grey[600], fontSize: 11)),
                Row(children: [const Icon(Icons.location_on, size: 10, color: Colors.grey), const SizedBox(width: 4), Text(customer.address, style: const TextStyle(color: Colors.grey, fontSize: 11))]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _readingBox(String label, String value, bool isNew) => Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: isNew ? Colors.blue : Colors.grey, fontSize: 11, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          height: 60,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: isNew ? Colors.white : Colors.grey[50], borderRadius: BorderRadius.circular(12), border: Border.all(color: isNew ? Colors.blue : Colors.transparent)),
          child: Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
      ],
    ),
  );

  Widget _buildBillDetail(int consumption, double amount, double vat, double total, NumberFormat format) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey.withOpacity(0.1))),
      child: Column(
        children: [
          _billRow(Icons.info_outline, 'Tiêu thụ (Mới - Cũ)', '${consumption > 0 ? consumption : 0} m³'),
          _billRow(null, 'Đơn giá định mức', '12.000 đ/m³'),
          const Divider(height: 30),
          _billRow(null, 'Thành tiền (trước VAT)', format.format(amount)),
          _billRow(null, 'Thuế VAT (10%)', format.format(vat)),
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

  Widget _billRow(IconData? icon, String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        if (icon != null) ...[Icon(icon, size: 14, color: Colors.grey), const SizedBox(width: 8)],
        Text(label, style: const TextStyle(color: Colors.black87, fontSize: 13)),
        const Spacer(),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    ),
  );

  void _confirmPayment(BuildContext context, int consumption, double total) async {
    final bill = Bill(customerId: customer.id!, billCode: 'INV-20231024-8892', date: DateTime.now(), oldReading: customer.currentReading, newReading: newReading, consumption: consumption.toDouble(), unitPrice: 12000, amount: total / 1.1, vat: total - (total/1.1), totalAmount: total, isSynced: false);
    context.read<BillingProvider>().saveBill(bill);
    context.read<CustomerProvider>().updateCustomerReading(customer.id!, newReading);
    Navigator.push(context, MaterialPageRoute(builder: (_) => ReceiptScreen(customer: customer, bill: bill)));
  }

  Widget _buildBottomNav() => BottomNavigationBar(type: BottomNavigationBarType.fixed, selectedItemColor: Colors.blue, unselectedItemColor: Colors.grey, items: const [BottomNavigationBarItem(icon: Icon(Icons.payment), label: 'Payment'), BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Stats'), BottomNavigationBarItem(icon: Icon(Icons.sync), label: 'Sync')]);
}
