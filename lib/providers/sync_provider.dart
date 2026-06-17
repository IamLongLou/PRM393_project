import 'package:flutter/material.dart';
import '../models/bill.dart';
import '../services/database_helper.dart';
import '../services/api_service.dart';

class SyncProvider with ChangeNotifier {
  final _db = DatabaseHelper.instance;
  List<Bill> _unsynced = [];
  bool _isSyncing = false;

  List<Bill> get unsyncedBills => _unsynced;
  bool get isSyncing => _isSyncing;

  Future<void> fetchUnsynced() async {
    _unsynced = await _db.getUnsyncedBills();
    notifyListeners();
  }

  Future<void> syncAll() async {
    if (_unsynced.isEmpty) return;
    _isSyncing = true; notifyListeners();
    final success = await ApiService.syncBills(_unsynced);
    if (success) {
      await _db.markBillsAsSynced(_unsynced);
      _unsynced = [];
    }
    _isSyncing = false; notifyListeners();
  }
}
