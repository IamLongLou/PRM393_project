import 'package:flutter/material.dart';
import '../models/bill.dart';

class SyncProvider with ChangeNotifier {
  // Dữ liệu viết sẵn cho 3 bản ghi chờ đồng bộ theo yêu cầu
  List<Bill> _unsyncedBills = [
    Bill(
      id: 101,
      customerId: 1, // Nguyen Bao Long
      billCode: 'KH001',
      date: DateTime(2024, 6, 5, 14, 31),
      oldReading: 110,
      newReading: 126,
      consumption: 16,
      unitPrice: 12000,
      amount: 192000,
      vat: 19200,
      totalAmount: 211200,
      isSynced: false,
    ),
    Bill(
      id: 102,
      customerId: 2, // Pham Tu Anh
      billCode: 'KH002',
      date: DateTime(2024, 6, 5, 14, 32),
      oldReading: 70,
      newReading: 127,
      consumption: 57,
      unitPrice: 12000,
      amount: 684000,
      vat: 68400,
      totalAmount: 752400,
      isSynced: false,
    ),
    Bill(
      id: 103,
      customerId: 5, // Truong Tri Binh
      billCode: 'KH005',
      date: DateTime(2024, 6, 5, 14, 33),
      oldReading: 320,
      newReading: 345,
      consumption: 25,
      unitPrice: 12000,
      amount: 300000,
      vat: 30000,
      totalAmount: 330000,
      isSynced: false,
    ),
  ];
  
  bool _isSyncing = false;

  List<Bill> get unsyncedBills => _unsyncedBills;
  bool get isSyncing => _isSyncing;

  Future<void> fetchUnsyncedBills() async {
    // Không cần fetch từ DB để demo chạy ngay
    notifyListeners();
  }

  Future<void> syncAll() async {
    if (_unsyncedBills.isEmpty) return;
    
    _isSyncing = true;
    notifyListeners();

    // Giả lập quá trình đồng bộ
    await Future.delayed(const Duration(seconds: 2));

    _unsyncedBills = [];
    _isSyncing = false;
    notifyListeners();
  }
}
