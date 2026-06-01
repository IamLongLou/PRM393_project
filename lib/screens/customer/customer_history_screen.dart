import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/customer.dart';
import '../../providers/billing_provider.dart';
import 'meter_reading_screen.dart';
import 'package:intl/intl.dart';

class CustomerHistoryScreen extends StatefulWidget {
  final Customer customer;
  const CustomerHistoryScreen({super.key, required this.customer});

  @override
  State<CustomerHistoryScreen> createState() => _CustomerHistoryScreenState();
}

class _CustomerHistoryScreenState extends State<CustomerHistoryScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BillingProvider>().fetchBillsByCustomer(widget.customer.id ?? 1);
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(title: const Text('Lịch sử hóa đơn')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildCustomerHeader(),
            _buildQuickStats(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                children: [
                  const Icon(Icons.access_time, size: 16, color: Colors.blue),
                  const SizedBox(width: 8),
                  const Text('Danh sách kỳ thanh toán', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  const Spacer(),
                  Text('${context.watch<BillingProvider>().customerBills.length} bản ghi', style: const TextStyle(color: Colors.grey, fontSize: 11)),
                ],
              ),
            ),
            Consumer<BillingProvider>(
              builder: (context, provider, child) {
                final bills = provider.customerBills;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemCount: bills.length,
                  itemBuilder: (context, index) {
                    final bill = bills[index];
                    return _buildBillCard(bill, currencyFormat);
                  },
                );
              },
            ),
            const SizedBox(height: 20),
            _buildInfoNote(),
            const SizedBox(height: 50),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildCustomerHeader() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey.withOpacity(0.1))),
      child: Row(
        children: [
          CircleAvatar(radius: 25, backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=${widget.customer.id}')),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.customer.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const Text('123 Đường Lê Lợi, Quận 1, TP.HCM', style: TextStyle(color: Colors.grey, fontSize: 11)),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(5)),
                  child: const Text('MÃ KH: KH-99210', style: TextStyle(color: Colors.blue, fontSize: 9, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _statBox('Trung bình', '15.2 m³', Colors.green),
          const SizedBox(width: 15),
          _statBox('Tổng nợ', '185.000đ', Colors.blue),
        ],
      ),
    );
  }

  Widget _statBox(String label, String value, Color color) => Expanded(
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: color.withOpacity(0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withOpacity(0.1))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    ),
  );

  Widget _buildBillCard(bill, NumberFormat format) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey.withOpacity(0.1))),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.blue.withOpacity(0.05), shape: BoxShape.circle), child: const Icon(Icons.calendar_month, color: Colors.blue, size: 18)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tháng ${bill.date.month}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      Text('${bill.date.year}', style: const TextStyle(color: Colors.grey, fontSize: 11)),
                    ],
                  ),
                ),
                Text(bill.isSynced ? 'Đã thanh toán' : 'Chưa ghi', style: TextStyle(color: bill.isSynced ? Colors.black87 : Colors.grey, fontSize: 11, fontWeight: FontWeight.bold)),
                const SizedBox(width: 4),
                const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _readingCol('CHỈ SỐ ĐẦU', '${bill.oldReading} m³'),
                    _readingCol('CHỈ SỐ CUỐI', '${bill.newReading} m³'),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(color: Colors.blue.withOpacity(0.05), borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          const Icon(Icons.water_drop, color: Colors.blue, size: 14),
                          const SizedBox(width: 8),
                          const Text('Tiêu thụ', style: TextStyle(color: Colors.grey, fontSize: 10)),
                          const SizedBox(width: 8),
                          Text('${bill.consumption.toInt()} m³', style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 14)),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('Thành tiền', style: TextStyle(color: Colors.grey, fontSize: 10)),
                        Text(format.format(bill.totalAmount), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _readingCol(String label, String value) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
      const SizedBox(height: 4),
      Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
    ],
  );

  Widget _buildInfoNote() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
      child: const Row(
        children: [
          Icon(Icons.info_outline, size: 16, color: Colors.grey),
          const SizedBox(width: 10),
          Expanded(child: Text('Mẹo: Nhấn vào thẻ hóa đơn bất kỳ để cập nhật hoặc ghi mới chỉ số nước cho kỳ hiện tại.', style: TextStyle(fontSize: 10, color: Colors.grey))),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: 0,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.people_outline), label: 'Khách hàng'),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_today_outlined), label: 'Lịch trình'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Cá nhân'),
      ],
    );
  }
}
