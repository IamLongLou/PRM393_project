import '../models/customer.dart';

class CustomerService {

  static List<Customer> getCustomers() {

    return [

      Customer(
        id: 1,
        code: "KH001",
        name: "Nguyễn Bảo Long",
        address: "Hà Nội",
        oldReading: 120,
      ),

      Customer(
        id: 2,
        code: "KH002",
        name: "Nguyễn Thị Lan A ",
        address: "Hà Nội",
        oldReading: 300,
      ),

      Customer(
        id: 3,
        code: "KH003",
        name: "Nguyễn Việt Nam",
        address: "Hà Nội",
        oldReading: 450,
      ),
    ];
  }

  static List<Customer> getCollectionList() {
    // Giả lập: KH001 đã thu, KH002 và KH003 chưa thu
    return getCustomers().where((c) => c.code != "KH001").toList();
  }
}