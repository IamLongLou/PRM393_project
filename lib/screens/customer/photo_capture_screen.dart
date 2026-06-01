import 'package:flutter/material.dart';
import '../../models/customer.dart';
import 'payment_screen.dart';

class PhotoCaptureScreen extends StatefulWidget {
  final Customer customer;
  final int newReading;
  const PhotoCaptureScreen({super.key, required this.customer, required this.newReading});

  @override
  State<PhotoCaptureScreen> createState() => _PhotoCaptureScreenState();
}

class _PhotoCaptureScreenState extends State<PhotoCaptureScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  IconButton(icon: const Icon(Icons.chevron_left, color: Colors.white), onPressed: () => Navigator.pop(context)),
                  const Text('Chụp ảnh công tơ', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [Icon(Icons.location_on, color: Colors.blue, size: 14), SizedBox(width: 4), Text('123 Đường Lê Lợi, Quận 1, TP.HCM', style: TextStyle(color: Colors.white, fontSize: 11))]),
                      Row(children: [Icon(Icons.access_time, color: Colors.blue, size: 14), SizedBox(width: 4), Text('1/6/2024 - 15:16', style: TextStyle(color: Colors.white, fontSize: 11))]),
                    ],
                  ),
                  Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(5)), child: const Text('HD-99281', style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold))),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), image: const DecorationImage(image: NetworkImage('https://st.depositphotos.com/1715574/2619/i/450/depositphotos_26190289-stock-photo-water-meter.jpg'), fit: BoxFit.cover)),
                  ),
                  // Overlay khung
                  Positioned(top: 50, left: 50, child: Container(width: 30, height: 30, decoration: const BoxDecoration(border: Border(top: BorderSide(color: Colors.blue, width: 3), left: BorderSide(color: Colors.blue, width: 3))))),
                  Positioned(top: 50, right: 50, child: Container(width: 30, height: 30, decoration: const BoxDecoration(border: Border(top: BorderSide(color: Colors.blue, width: 3), right: BorderSide(color: Colors.blue, width: 3))))),
                  Positioned(bottom: 50, left: 50, child: Container(width: 30, height: 30, decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.blue, width: 3), left: BorderSide(color: Colors.blue, width: 3))))),
                  Positioned(bottom: 50, right: 50, child: Container(width: 30, height: 30, decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.blue, width: 3), right: BorderSide(color: Colors.blue, width: 3))))),
                  
                  Positioned(
                    top: 60, left: 60,
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ISO 400', style: TextStyle(color: Colors.white70, fontSize: 10)),
                        Text('F 1.8', style: TextStyle(color: Colors.white70, fontSize: 10)),
                        Text('EV +0.3', style: TextStyle(color: Colors.white70, fontSize: 10)),
                      ],
                    ),
                  ),
                  
                  Positioned(
                    bottom: 70,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(20)),
                      child: const Row(children: [Icon(Icons.center_focus_weak, color: Colors.white, size: 16), SizedBox(width: 8), Text('Căn chỉnh số vào khung', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold))]),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: const Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(20)),
              child: Row(
                children: [
                  Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), shape: BoxShape.circle), child: const Icon(Icons.info_outline, color: Colors.blue)),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('CHỈ SỐ VỪA NHẬP', style: TextStyle(color: Colors.white60, fontSize: 10, fontWeight: FontWeight.bold)),
                      Text('${widget.newReading.toString().padLeft(5, '0')} m³', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Chụp lại'),
                      style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: const BorderSide(color: Colors.white24)),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PaymentScreen(customer: widget.customer, newReading: widget.newReading, imagePath: ""))),
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text('Xác nhận & Lưu'),
                    ),
                  ),
                ],
              ),
            ),
            const Text('Ảnh chụp sẽ được đính kèm tọa độ GPS và dấu thời gian thực\nđể đảm bảo tính minh bạch của dữ liệu.', 
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 9)
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
