import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/customer.dart';
import '../models/bill.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('water_billing.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const String idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const String textType = 'TEXT NOT NULL';
    const String intType = 'INTEGER NOT NULL';
    const String realType = 'REAL NOT NULL';
    const String nullableText = 'TEXT';

    await db.execute('''
      CREATE TABLE customers (
        id $idType,
        code $textType,
        name $textType,
        address $textType,
        phone $textType,
        currentReading $intType,
        status $intType
      )
    ''');

    await db.execute('''
      CREATE TABLE bills (
        id $idType,
        customerId $intType,
        billCode $textType,
        date $textType,
        oldReading $intType,
        newReading $intType,
        consumption $realType,
        unitPrice $realType,
        amount $realType,
        vat $realType,
        totalAmount $realType,
        imagePath $nullableText,
        isSynced $intType,
        FOREIGN KEY (customerId) REFERENCES customers (id) ON DELETE CASCADE
      )
    ''');

    await _seedDatabase(db);
  }

  Future _seedDatabase(Database db) async {
    // 20 Sample Customers
    final List<Map<String, dynamic>> customers = List.generate(20, (i) {
      return {
        'code': 'KH${(1234 + i).toString().padLeft(4, '0')}',
        'name': 'Nguyễn Văn ${String.fromCharCode(65 + i)}',
        'address': '${123 + i} Đường ABC, Quận ${(i % 12) + 1}',
        'phone': '09012345${i.toString().padLeft(2, '0')}',
        'currentReading': 100 + (i * 10),
        'status': i < 10 ? 0 : 2, // First 10 pending, last 10 completed
      };
    });

    for (var customer in customers) {
      await db.insert('customers', customer);
    }

    // 6 months history for each customer (some might only have a few)
    // And 10 pending sync records
    for (int i = 1; i <= 20; i++) {
      for (int m = 1; m <= 6; m++) {
        bool isPending = (i <= 10 && m == 6); // Latest month for first 10 is pending sync
        
        int oldR = 100 + (i * 10) + (m - 1) * 15;
        int newR = oldR + 15 + (i % 5);
        double consumption = (newR - oldR).toDouble();
        double unitPrice = 12000.0;
        double amount = consumption * unitPrice;
        double vat = amount * 0.1;
        double total = amount + vat;

        await db.insert('bills', {
          'customerId': i,
          'billCode': 'HD2024${m.toString().padLeft(2, '0')}${i.toString().padLeft(4, '0')}',
          'date': DateTime(2024, m, 15).toIso8601String(),
          'oldReading': oldR,
          'newReading': newR,
          'consumption': consumption,
          'unitPrice': unitPrice,
          'amount': amount,
          'vat': vat,
          'totalAmount': total,
          'imagePath': null,
          'isSynced': isPending ? 0 : 1,
        });
      }
    }
  }

  // Customer Methods
  Future<List<Customer>> getAllCustomers() async {
    final db = await instance.database;
    final result = await db.query('customers');
    return result.map((json) => Customer.fromMap(json)).toList();
  }

  Future<Customer?> getCustomerById(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      'customers',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Customer.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateCustomer(Customer customer) async {
    final db = await instance.database;
    return db.update(
      'customers',
      customer.toMap(),
      where: 'id = ?',
      whereArgs: [customer.id],
    );
  }

  // Bill Methods
  Future<List<Bill>> getBillsByCustomerId(int customerId) async {
    final db = await instance.database;
    final result = await db.query(
      'bills',
      where: 'customerId = ?',
      whereArgs: [customerId],
      orderBy: 'date DESC',
    );
    return result.map((json) => Bill.fromMap(json)).toList();
  }

  Future<List<Bill>> getAllBills() async {
    final db = await instance.database;
    final result = await db.query('bills', orderBy: 'date DESC');
    return result.map((json) => Bill.fromMap(json)).toList();
  }

  Future<List<Bill>> getUnsyncedBills() async {
    final db = await instance.database;
    final result = await db.query(
      'bills',
      where: 'isSynced = ?',
      whereArgs: [0],
    );
    return result.map((json) => Bill.fromMap(json)).toList();
  }

  Future<int> insertBill(Bill bill) async {
    final db = await instance.database;
    return await db.insert('bills', bill.toMap());
  }

  Future<int> updateBill(Bill bill) async {
    final db = await instance.database;
    return db.update(
      'bills',
      bill.toMap(),
      where: 'id = ?',
      whereArgs: [bill.id],
    );
  }
}
