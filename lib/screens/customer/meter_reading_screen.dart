import 'package:flutter/material.dart';
import '../../models/customer.dart';
import '../../models/bill.dart';
import '../../services/billing_service.dart';
import 'collection_summary_screen.dart';

/// Màn hình Ghi chỉ số (Step 1: Ghi nhận dữ liệu)
class MeterReadingScreen extends StatefulWidget {
  final Customer customer;
  const MeterReadingScreen({super.key, required this.customer});

  @override
  State<MeterReadingScreen> createState() => _MeterReadingScreenState();
}

class _MeterReadingScreenState extends State<MeterReadingScreen> {
  final _readingController = TextEditingController();
  int _consumption = 0;
  double _totalAmount = 0;

  void _calculate(String value) {
    int newReading = int.tryParse(value) ?? 0;
    if (newReading >= widget.customer.oldReading) {
      setState(() {
        _consumption = newReading - widget.customer.oldReading;
        _totalAmount = BillingService.calculateAmount(_consumption);
      });
    } else {
      setState(() {
        _consumption = 0;
        _totalAmount = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nhập chỉ số nước")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Thông tin mô tả quy trình
            _buildStepIndicator(),
            const SizedBox(height: 20),
            
            // Thông tin khách hàng
            _buildCustomerHeader(),
            const SizedBox(height: 20),
            
            // Form nhập liệu
            _buildReadingForm(),
            const SizedBox(height: 20),
            
            // Chụp ảnh (Bằng chứng offline)
            _buildPhotoSection(),
            const SizedBox(height: 30),
            
            // Tóm tắt nhanh Business Rule
            if (_consumption > 0) _buildQuickSummary(),
            
            const SizedBox(height: 40),
            
            // Navigation: Chuyển dữ liệu sang trang Summary
            _buildNextButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("CHỤP ẢNH ĐỒNG HỒ (BẮT BUỘC)", 
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey)),
        const SizedBox(height: 10),
        InkWell(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Đang mở camera chụp ảnh..."))
            );
          },
          child: Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey[300]!, style: BorderStyle.solid),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.camera_alt, size: 40, color: Colors.blue[300]),
                const SizedBox(height: 5),
                const Text("Nhấn để chụp ảnh", style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStepIndicator() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        children: [
          Icon(Icons.wifi_off, color: Colors.orange, size: 18),
          SizedBox(width: 8),
          Text("CHẾ ĐỘ NGOẠI TUYẾN (OFFLINE)", 
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildCustomerHeader() {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.person)),
        title: Text(widget.customer.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("Địa chỉ: ${widget.customer.address}\nChỉ số cũ: ${widget.customer.oldReading} m³"),
        isThreeLine: true,
      ),
    );
  }

  Widget _buildReadingForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("CHỈ SỐ HIỆN TẠI (GHI TRÊN ĐỒNG HỒ)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey)),
        const SizedBox(height: 10),
        TextField(
          controller: _readingController,
          keyboardType: TextInputType.number,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
          decoration: InputDecoration(
            hintText: "0000",
            suffixText: "m³",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            filled: true,
            fillColor: Colors.blue[50]!.withOpacity(0.3),
          ),
          onChanged: _calculate,
        ),
      ],
    );
  }

  Widget _buildQuickSummary() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildQuickStat("TIÊU THỤ", "$_consumption m³"),
          _buildQuickStat("TẠM TÍNH", "${_totalAmount.toStringAsFixed(0)} đ"),
        ],
      ),
    );
  }

  Widget _buildQuickStat(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }

  Widget _buildNextButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: _consumption <= 0 ? null : () {
          final bill = Bill(
            id: DateTime.now().millisecondsSinceEpoch,
            customerId: widget.customer.id,
            month: DateTime.now(),
            oldReading: widget.customer.oldReading,
            newReading: int.parse(_readingController.text),
            totalAmount: _totalAmount,
            isPaid: true, // Thanh toán ngay tại chỗ
          );
          
          // Chuyển dữ liệu sang trang Summary
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CollectionSummaryScreen(
                customer: widget.customer,
                bill: bill,
              ),
            ),
          );
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("XEM CHI TIẾT & THU TIỀN"),
            SizedBox(width: 10),
            Icon(Icons.arrow_forward),
          ],
        ),
      ),
    );
  }
}
