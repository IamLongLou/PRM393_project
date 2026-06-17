import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/customer.dart';
import '../models/bill.dart';
import '../models/user.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('water_billing_final.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(
      path, 
      version: 1, 
      onCreate: _createDB
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('CREATE TABLE customers (id INTEGER PRIMARY KEY, code TEXT UNIQUE, name TEXT, address TEXT, phone TEXT, currentReading INTEGER, status INTEGER)');
    await db.execute('CREATE TABLE bills (id INTEGER PRIMARY KEY AUTOINCREMENT, customerId INTEGER, customerName TEXT, customerCode TEXT, billCode TEXT UNIQUE, date TEXT, oldReading INTEGER, newReading INTEGER, consumption REAL, unitPrice REAL, amount REAL, vat REAL, totalAmount REAL, imagePath TEXT, isSynced INTEGER)');
    await db.execute('CREATE TABLE user_session (username TEXT PRIMARY KEY, fullName TEXT, role TEXT, email TEXT, phone TEXT, token TEXT, lastLoginAt TEXT)');
  }

  Future<void> saveSession(User user, String? token) async {
    final db = await database;
    await db.insert('user_session', {
      ...user.toMap(), 
      'token': token, 
      'lastLoginAt': DateTime.now().toIso8601String()
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<User?> getLastSession() async {
    final db = await database;
    final res = await db.query('user_session', orderBy: 'lastLoginAt DESC', limit: 1);
    return res.isEmpty ? null : User.fromMap(res.first);
  }

  Future<void> clearSession() async {
    final db = await database;
    await db.delete('user_session');
  }

  Future<List<Customer>> getAllCustomers() async {
    final db = await database;
    final res = await db.query('customers', orderBy: 'code ASC');
    return res.map(Customer.fromMap).toList();
  }

  Future<void> upsertCustomers(List<Customer> customers) async {
    final db = await database;
    final batch = db.batch();
    for (var c in customers) batch.insert('customers', c.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    await batch.commit(noResult: true);
  }

  Future<void> updateCustomerReading(int id, int newReading) async {
    final db = await database;
    await db.update('customers', {'currentReading': newReading, 'status': 2}, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> insertBill(Bill bill) async {
    final db = await database;
    await db.insert('bills', bill.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Bill>> getUnsyncedBills() async {
    final db = await database;
    final res = await db.query('bills', where: 'isSynced = ?', whereArgs: [0]);
    return res.map(Bill.fromMap).toList();
  }

  Future<void> markBillsAsSynced(List<Bill> bills) async {
    final db = await database;
    for (var b in bills) {
      await db.update('bills', {'isSynced': 1}, where: 'billCode = ?', whereArgs: [b.billCode]);
    }
  }

  Future<List<Bill>> getBillsByCustomer(int customerId) async {
    final db = await database;
    final res = await db.query('bills', where: 'customerId = ?', whereArgs: [customerId], orderBy: 'date DESC');
    return res.map(Bill.fromMap).toList();
  }
}
