enum CollectionStatus { pending, reading, completed }

class Customer {
  int id;
  String code;
  String name;
  String address;
  int oldReading;
  CollectionStatus status; // Trạng thái: Chờ ghi, Đang ghi, Đã hoàn thành

  Customer({
    required this.id,
    required this.code,
    required this.name,
    required this.address,
    required this.oldReading,
    this.status = CollectionStatus.pending,
  });
}
