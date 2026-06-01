class Bill {
  final int id;
  final int customerId;
  final DateTime month;
  final int oldReading;
  final int newReading;
  final double totalAmount;
  final bool isPaid;

  Bill({
    required this.id,
    required this.customerId,
    required this.month,
    required this.oldReading,
    required this.newReading,
    required this.totalAmount,
    this.isPaid = false,
  });

  int get consumption => newReading - oldReading;
}
