import 'package:flutter/material.dart';
import '../models/bill.dart';
import '../services/database_helper.dart';

class BillingProvider with ChangeNotifier {
  final _db = DatabaseHelper.instance;
  List<Bill> _customerBills = [];

  List<Bill> get customerBills => _customerBills;

  Future<void> fetchBillsByCustomer(int customerId) async {
    _customerBills = await _db.getBillsByCustomer(customerId);
    notifyListeners();
  }

  Future<List<Bill>> getAllBills() async {
    final db = await _db.database;
    final res = await db.query('bills', orderBy: 'date DESC');
    return res.map((m) => Bill.fromMap(m)).toList();
  }

  Future<void> saveBill(Bill bill) async {
    await _db.insertBill(bill);
    await _db.updateCustomerReading(bill.customerId, bill.newReading);
    _customerBills.insert(0, bill);
    notifyListeners();
  }

  Future<void> markBillsAsSynced(List<Bill> bills) async {
    await _db.markBillsAsSynced(bills);
    notifyListeners();
  }
}
