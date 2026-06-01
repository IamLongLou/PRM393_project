import 'package:flutter/material.dart';
import '../models/customer.dart';
import '../services/database_helper.dart';

class CustomerProvider with ChangeNotifier {
  List<Customer> _customers = [
    Customer(id: 1, code: 'KH001', name: 'Nguyen Bao Long', address: '12-A Phố Huế, Hai Bà Trưng', phone: '0912345001', currentReading: 125, status: CollectionStatus.pending),
    Customer(id: 2, code: 'KH002', name: 'Pham Tu Anh', address: '88 Đường Láng, Đống Đa', phone: '0987654002', currentReading: 80, status: CollectionStatus.pending),
    Customer(id: 3, code: 'KH003', name: 'Vu Thi Huong Giang', address: '15/2 Trần Duy Hưng, Cầu Giấy', phone: '0904444003', currentReading: 210, status: CollectionStatus.completed),
    Customer(id: 4, code: 'KH004', name: 'Ta Huy Dat', address: 'Tòa nhà Landmark 81, Bình Thạnh', phone: '0911222004', currentReading: 45, status: CollectionStatus.reading),
    Customer(id: 5, code: 'KH005', name: 'Truong Tri Binh', address: 'Khu dân cư Him Lam, Quận 7', phone: '0933555005', currentReading: 320, status: CollectionStatus.pending),
  ];
  List<Customer> _filteredCustomers = [];
  bool _isLoading = false;

  List<Customer> get customers => _filteredCustomers.isEmpty && _customers.isNotEmpty ? _customers : _filteredCustomers;
  List<Customer> get allCustomers => _customers;
  bool get isLoading => _isLoading;

  Future<void> fetchCustomers() async {
    if (_customers.isNotEmpty && !_isLoading) {
      notifyListeners();
      return;
    }
    
    _isLoading = true;
    notifyListeners();
    try {
      // Giả lập load nhanh 500ms
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      debugPrint("Lỗi load DB: $e");
    }
    
    _filteredCustomers = [];
    _isLoading = false;
    notifyListeners();
  }

  void searchCustomers(String query) {
    if (query.isEmpty) {
      _filteredCustomers = [];
    } else {
      _filteredCustomers = _customers.where((c) => 
        c.name.toLowerCase().contains(query.toLowerCase()) || 
        c.code.toLowerCase().contains(query.toLowerCase())
      ).toList();
    }
    notifyListeners();
  }

  Future<void> updateCustomerStatus(int id, CollectionStatus status) async {
    final index = _customers.indexWhere((c) => c.id == id);
    if (index != -1) {
      _customers[index] = _customers[index].copyWith(status: status);
      notifyListeners();
    }
  }

  void updateCustomerReading(int id, int newReading) {
    final index = _customers.indexWhere((c) => c.id == id);
    if (index != -1) {
      _customers[index] = _customers[index].copyWith(
        currentReading: newReading,
        status: CollectionStatus.completed,
      );
      notifyListeners();
    }
  }
}
