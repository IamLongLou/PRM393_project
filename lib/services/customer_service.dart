import '../models/customer.dart';

class CustomerService {
  static List<Customer> _customers = [
    Customer(id: 1, code: "KH001", name: "Nguyễn Bảo Long", address: "Hải Phòng", oldReading: 120, status: CollectionStatus.completed),
    Customer(id: 2, code: "KH002", name: "Nguyễn TLA", address: "Hà Nội", oldReading: 3000, status: CollectionStatus.pending),
    Customer(id: 3, code: "KH003", name: "Phạm Tú Anh", address: "Nam Định", oldReading: 4650, status: CollectionStatus.pending),
    Customer(id: 4, code: "KH004", name: "Vũ Thị Hương Giang", address: "Hà Giang", oldReading: 1850, status: CollectionStatus.pending),
    Customer(id: 5, code: "KH005", name: "Tạ Huy Đạt", address: "Sơn La", oldReading: 950, status: CollectionStatus.pending),
    Customer(id: 6, code: "KH006", name: "Trương Gia Bình", address: "Hà Nội", oldReading: 9500, status: CollectionStatus.pending),
  ];

  static List<Customer> getCustomers() => _customers;

  /// Danh sách cần đi thu (Chưa hoàn thành)
  static List<Customer> getToCollectList() {
    return _customers.where((c) => c.status != CollectionStatus.completed).toList();
  }

  /// Danh sách lịch sử đã thu (Đã hoàn thành)
  static List<Customer> getCollectionHistory() {
    return _customers.where((c) => c.status == CollectionStatus.completed).toList();
  }

  static void updateStatus(int customerId, CollectionStatus newStatus) {
    int index = _customers.indexWhere((c) => c.id == customerId);
    if (index != -1) {
      _customers[index].status = newStatus;
    }
  }

  static void updateCustomer(int id, String name, String address) {
    int index = _customers.indexWhere((c) => c.id == id);
    if (index != -1) {
      _customers[index].name = name;
      _customers[index].address = address;
    }
  }
}
