import 'package:flutter/material.dart';
import '../../models/customer.dart';
import '../../models/bill.dart';
import '../../services/billing_service.dart';
import 'meter_reading_screen.dart';

/// Màn hình Chi tiết hóa đơn tiền nước - Bắt chước mẫu Hóa đơn điện tử (Ảnh 2)
class CustomerHistoryScreen extends StatelessWidget {
  final Customer customer;

  const CustomerHistoryScreen({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    final history = BillingService.getHistory(customer.id);
    // Giả sử lấy hóa đơn gần nhất để hiển thị chi tiết
    final bill = history.last;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF007BC3), // Màu xanh đặc trưng của EVN/VNPAY
        elevation: 0,
        title: const Text("Chi tiết hóa đơn tiền nước", 
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MeterReadingScreen(customer: customer)),
          );
        },
        label: const Text("Ghi chỉ số mới"),
        icon: const Icon(Icons.edit_note),
        backgroundColor: Colors.blue[700],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Khung thông tin tổng quát hóa đơn (Bắt chước Image 2)
            _buildMainInfoCard(bill),

            const Padding(
              padding: EdgeInsets.only(left: 16, top: 20, bottom: 8),
              child: Text("Chi tiết tiền nước", 
                style: TextStyle(color: Color(0xFF007BC3), fontSize: 16, fontWeight: FontWeight.bold)),
            ),

            // 2. Bảng chi tiết tính toán (Bắt chước Image 2)
            _buildDetailedPriceTable(bill),
            
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildMainInfoCard(Bill bill) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[400]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // Tên khách hàng
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Khách hàng", style: TextStyle(fontSize: 16)),
                Text(customer.name, 
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF007BC3))),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1),
          // Header hóa đơn
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Hóa đơn", style: TextStyle(fontSize: 16)),
                Text("Kỳ ${bill.month.month} năm ${bill.month.year}", 
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1),
          // Từ ngày - Đến ngày
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSubInfo("Từ ngày", "01/${bill.month.month}/${bill.month.year}"),
                _buildSubInfo("Đến ngày", "30/${bill.month.month}/${bill.month.year}", alignRight: true),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1),
          // Chỉ số cũ - Chỉ số mới - Tiêu thụ
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(child: _buildSubInfo("Chỉ số cũ", bill.oldReading.toString())),
                Expanded(child: _buildSubInfo("Chỉ số mới", bill.newReading.toString(), center: true)),
                Expanded(child: _buildSubInfo("Tiêu thụ", bill.consumption.toString(), alignRight: true)),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1),
          // Giá biểu - Định mức
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSubInfo("Giá biểu", "11"),
                _buildSubInfo("Định mức", "12", alignRight: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedPriceTable(Bill bill) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(2),
          1: FlexColumnWidth(1.2),
          2: FlexColumnWidth(1.5),
          3: FlexColumnWidth(1.5),
        },
        border: TableBorder.all(color: Colors.grey[400]!, width: 1),
        children: [
          // Dòng tiêu đề bảng
          TableRow(
            children: [
              _buildCell(""),
              _buildCell("Tiêu thụ m³", isHeader: true),
              _buildCell("Đơn giá (đ)", isHeader: true),
              _buildCell("Thành tiền (đ)", isHeader: true),
            ],
          ),
          // Dòng Tiền nước
          TableRow(
            children: [
              _buildCell("Tiền nước", isHeader: true, alignLeft: true),
              _buildCell(bill.consumption.toString()),
              _buildCell("6.700"),
              _buildCell(_formatMoney(bill.consumption * 6700)),
            ],
          ),
          // Dòng TDVTN (Thuế/Phí dịch vụ)
          TableRow(
            children: [
              _buildCell("TDVTN", isHeader: true, alignLeft: true),
              _buildCell(bill.consumption.toString()),
              _buildCell("1.005"),
              _buildCell(_formatMoney(bill.consumption * 1005)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubInfo(String label, String value, {bool alignRight = false, bool center = false, bool isBold = false}) {
    return Column(
      crossAxisAlignment: alignRight ? CrossAxisAlignment.end : (center ? CrossAxisAlignment.center : CrossAxisAlignment.start),
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 15, fontWeight: isBold ? FontWeight.bold : FontWeight.w500)),
      ],
    );
  }

  Widget _buildCell(String text, {bool isHeader = false, bool alignLeft = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      child: Text(
        text,
        textAlign: alignLeft ? TextAlign.left : TextAlign.center,
        style: TextStyle(
          fontSize: 13,
          color: isHeader && alignLeft ? const Color(0xFF007BC3) : Colors.black,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  String _formatMoney(num amount) {
    return amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }
}
