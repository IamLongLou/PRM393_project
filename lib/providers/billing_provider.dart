import 'package:flutter/material.dart';
import '../models/bill.dart';
import '../services/database_helper.dart';

class BillingProvider with ChangeNotifier {
  // Tạo sẵn danh sách lịch sử giả lập cho các khách hàng
  List<Bill> _allBills = [
    // Khách hàng 5: Tào Tháo
    Bill(customerId: 5, customerName: 'Tào Tháo', customerCode: 'KH005', billCode: 'HD0524005', date: DateTime(2024, 5, 19), oldReading: 290, newReading: 320, consumption: 30, unitPrice: 12000, amount: 360000, vat: 36000, totalAmount: 396000, isSynced: true),
    Bill(customerId: 5, customerName: 'Tào Tháo', customerCode: 'KH005', billCode: 'HD0424005', date: DateTime(2024, 4, 19), oldReading: 265, newReading: 290, consumption: 25, unitPrice: 12000, amount: 300000, vat: 30000, totalAmount: 330000, isSynced: true),

    // Khách hàng 4: Gia Cát Lượng
    Bill(customerId: 4, customerName: 'Gia Cát Lượng', customerCode: 'KH004', billCode: 'HD0524004', date: DateTime(2024, 5, 18), oldReading: 30, newReading: 45, consumption: 15, unitPrice: 12000, amount: 180000, vat: 18000, totalAmount: 198000, isSynced: true),

    // Khách hàng 3: Trương Phi
    Bill(customerId: 3, customerName: 'Trương Phi', customerCode: 'KH003', billCode: 'HD0524003', date: DateTime(2024, 5, 17), oldReading: 190, newReading: 210, consumption: 20, unitPrice: 12000, amount: 240000, vat: 24000, totalAmount: 264000, isSynced: true),
    Bill(customerId: 3, customerName: 'Trương Phi', customerCode: 'KH003', billCode: 'HD0424003', date: DateTime(2024, 4, 17), oldReading: 172, newReading: 190, consumption: 18, unitPrice: 12000, amount: 216000, vat: 21600, totalAmount: 237600, isSynced: true),

    // Khách hàng 2: Quan Vũ
    Bill(customerId: 2, customerName: 'Quan Vũ', customerCode: 'KH002', billCode: 'HD0524002', date: DateTime(2024, 5, 16), oldReading: 70, newReading: 80, consumption: 10, unitPrice: 12000, amount: 120000, vat: 12000, totalAmount: 132000, isSynced: true),
    Bill(customerId: 2, customerName: 'Quan Vũ', customerCode: 'KH002', billCode: 'HD0424002', date: DateTime(2024, 4, 16), oldReading: 55, newReading: 70, consumption: 15, unitPrice: 12000, amount: 180000, vat: 18000, totalAmount: 198000, isSynced: true),

    // Khách hàng 1: Lưu Bị
    Bill(customerId: 1, customerName: 'Lưu Bị', customerCode: 'KH001', billCode: 'HD0524001', date: DateTime(2024, 5, 15), oldReading: 110, newReading: 125, consumption: 15, unitPrice: 12000, amount: 180000, vat: 18000, totalAmount: 198000, isSynced: true),
    Bill(customerId: 1, customerName: 'Lưu Bị', customerCode: 'KH001', billCode: 'HD0424001', date: DateTime(2024, 4, 15), oldReading: 95, newReading: 110, consumption: 15, unitPrice: 12000, amount: 180000, vat: 18000, totalAmount: 198000, isSynced: true),
    Bill(customerId: 1, customerName: 'Lưu Bị', customerCode: 'KH001', billCode: 'HD0324001', date: DateTime(2024, 3, 15), oldReading: 82, newReading: 95, consumption: 13, unitPrice: 12000, amount: 156000, vat: 15600, totalAmount: 171600, isSynced: true),
  ];

  List<Bill> _customerBills = [];
  bool _isLoading = false;

  List<Bill> get customerBills => _customerBills;
  bool get isLoading => _isLoading;

  Future<void> fetchBillsByCustomer(int customerId) async {
    _isLoading = true;
    notifyListeners();
    
    // Giả lập load dữ liệu nhanh
    await Future.delayed(const Duration(milliseconds: 300));
    
    // Lấy từ danh sách giả lập
    _customerBills = _allBills.where((b) => b.customerId == customerId).toList();
    
    // Sắp xếp theo ngày mới nhất lên đầu
    _customerBills.sort((a, b) => b.date.compareTo(a.date));
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> saveBill(Bill bill) async {
    // Lưu vào cả hai danh sách để cập nhật UI ngay lập tức
    _allBills.insert(0, bill);
    _customerBills.insert(0, bill);
    notifyListeners();
  }

  Future<List<Bill>> getAllBills() async {
    // Sắp xếp tất cả hóa đơn theo ngày mới nhất
    _allBills.sort((a, b) => b.date.compareTo(a.date));
    return _allBills;
  }

  Future<void> markBillsAsSynced(List<Bill> syncedBills) async {
    for (var i = 0; i < _allBills.length; i++) {
      if (syncedBills.any((b) => b.billCode == _allBills[i].billCode)) {
        _allBills[i] = _allBills[i].copyWith(isSynced: true);
      }
    }
    notifyListeners();
  }
}
