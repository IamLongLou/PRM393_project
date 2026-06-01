class Bill {
  final int? id;
  final int customerId;
  final String? customerName;
  final String? customerCode;
  final String billCode;
  final DateTime date;
  final int oldReading;
  final int newReading;
  final double consumption;
  final double unitPrice;
  final double amount;
  final double vat;
  final double totalAmount;
  final String? imagePath;
  final bool isSynced;

  Bill({
    this.id,
    required this.customerId,
    this.customerName,
    this.customerCode,
    required this.billCode,
    required this.date,
    required this.oldReading,
    required this.newReading,
    required this.consumption,
    required this.unitPrice,
    required this.amount,
    required this.vat,
    required this.totalAmount,
    this.imagePath,
    this.isSynced = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerId': customerId,
      'customerName': customerName,
      'customerCode': customerCode,
      'billCode': billCode,
      'date': date.toIso8601String(),
      'oldReading': oldReading,
      'newReading': newReading,
      'consumption': consumption,
      'unitPrice': unitPrice,
      'amount': amount,
      'vat': vat,
      'totalAmount': totalAmount,
      'imagePath': imagePath,
      'isSynced': isSynced ? 1 : 0,
    };
  }

  factory Bill.fromMap(Map<String, dynamic> map) {
    return Bill(
      id: map['id'],
      customerId: map['customerId'],
      customerName: map['customerName'],
      customerCode: map['customerCode'],
      billCode: map['billCode'] ?? '',
      date: DateTime.parse(map['date']),
      oldReading: map['oldReading'],
      newReading: map['newReading'],
      consumption: map['consumption'].toDouble(),
      unitPrice: map['unitPrice'].toDouble(),
      amount: map['amount'].toDouble(),
      vat: map['vat'].toDouble(),
      totalAmount: map['totalAmount'].toDouble(),
      imagePath: map['imagePath'],
      isSynced: map['isSynced'] == 1,
    );
  }
}
