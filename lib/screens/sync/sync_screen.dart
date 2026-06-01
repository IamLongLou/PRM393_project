import 'package:flutter/material.dart';
import '../../services/billing_service.dart';

/// Màn hình đồng bộ dữ liệu (Sync Data Online)
class SyncScreen extends StatefulWidget {
  const SyncScreen({super.key});

  @override
  State<SyncScreen> createState() => _SyncScreenState();
}

class _SyncScreenState extends State<SyncScreen> {
  bool _isSyncing = false;
  int _successCount = 0;
  late int _pendingCount;

  @override
  void initState() {
    super.initState();
    _pendingCount = BillingService.pendingBills.length;
  }

  void _startSync() async {
    if (_pendingCount == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Không có dữ liệu mới để đồng bộ."))
      );
      return;
    }

    setState(() {
      _isSyncing = true;
      _successCount = 0;
    });

    // Giả lập quá trình đồng bộ từng bản ghi
    for (int i = 1; i <= _pendingCount; i++) {
      await Future.delayed(const Duration(milliseconds: 500));
      setState(() {
        _successCount = i;
      });
    }

    // Sau khi đồng bộ xong, xóa danh sách tạm
    BillingService.pendingBills.clear();

    setState(() {
      _isSyncing = false;
      _pendingCount = 0;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Đồng bộ thành công $_successCount bản ghi!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Đồng bộ dữ liệu")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isSyncing ? Icons.sync : (_pendingCount > 0 ? Icons.cloud_upload : Icons.cloud_done),
              size: 100,
              color: _isSyncing ? Colors.orange : (_pendingCount > 0 ? Colors.blue : Colors.green),
            ),
            const SizedBox(height: 20),
            Text(
              _isSyncing ? "Đang gửi dữ liệu lên máy chủ..." : 
              (_pendingCount > 0 ? "Bạn có $_pendingCount bản ghi chưa đồng bộ" : "Dữ liệu đã được cập nhật mới nhất"),
              style: const TextStyle(fontSize: 16),
            ),
            if (_successCount > 0)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  "Đã đồng bộ thành công: $_successCount/5",
                  style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: _isSyncing ? null : _startSync,
              icon: Icon(_isSyncing ? Icons.hourglass_empty : Icons.refresh),
              label: Text(_isSyncing ? "Vui lòng chờ..." : "Bắt đầu đồng bộ"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
