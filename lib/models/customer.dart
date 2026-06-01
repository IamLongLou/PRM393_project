enum CollectionStatus { pending, reading, completed }

class Customer {
  final int? id;
  final String code;
  final String name;
  final String address;
  final String phone;
  final int currentReading;
  final CollectionStatus status;

  Customer({
    this.id,
    required this.code,
    required this.name,
    required this.address,
    required this.phone,
    required this.currentReading,
    this.status = CollectionStatus.pending,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'address': address,
      'phone': phone,
      'currentReading': currentReading,
      'status': status.index,
    };
  }

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      id: map['id'],
      code: map['code'] ?? '',
      name: map['name'] ?? '',
      address: map['address'] ?? '',
      phone: map['phone'] ?? '',
      currentReading: map['currentReading'] ?? 0,
      status: CollectionStatus.values[map['status'] ?? 0],
    );
  }

  Customer copyWith({
    int? id,
    String? code,
    String? name,
    String? address,
    String? phone,
    int? currentReading,
    CollectionStatus? status,
  }) {
    return Customer(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      currentReading: currentReading ?? this.currentReading,
      status: status ?? this.status,
    );
  }
}
