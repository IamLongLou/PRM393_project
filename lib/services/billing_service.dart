import '../models/bill.dart';

class BillingService {
  // Biểu giá nước mẫu (VND/m3)
  static const double level1 = 5973;  // 0-10 m3
  static const double level2 = 7052;  // 10-20 m3
  static const double level3 = 8669;  // 20-30 m3
  static const double level4 = 15929; // Trên 30 m3
  
  static const double taxRate = 0.15; // VAT 10% + Phí BVMT 5%

  static double calculateAmount(int consumption) {
    double total = 0;

    if (consumption <= 10) {
      total = consumption * level1;
    } else if (consumption <= 20) {
      total = (10 * level1) + (consumption - 10) * level2;
    } else if (consumption <= 30) {
      total = (10 * level1) + (10 * level2) + (consumption - 20) * level3;
    } else {
      total = (10 * level1) + (10 * level2) + (10 * level3) + (consumption - 30) * level4;
    }

    return total * (1 + taxRate);
  }

  // Dữ liệu mẫu lịch sử thu tiền cho biểu đồ
  static List<Bill> getHistory(int customerId) {
    return [
      Bill(id: 1, customerId: customerId, month: DateTime(2023, 10), oldReading: 100, newReading: 115, totalAmount: calculateAmount(15), isPaid: true),
      Bill(id: 2, customerId: customerId, month: DateTime(2023, 11), oldReading: 115, newReading: 132, totalAmount: calculateAmount(17), isPaid: true),
      Bill(id: 3, customerId: customerId, month: DateTime(2023, 12), oldReading: 132, newReading: 155, totalAmount: calculateAmount(23), isPaid: true),
      Bill(id: 4, customerId: customerId, month: DateTime(2024, 01), oldReading: 155, newReading: 170, totalAmount: calculateAmount(15), isPaid: true),
    ];
  }
}
