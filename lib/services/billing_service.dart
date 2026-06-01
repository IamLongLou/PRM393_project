import '../models/bill.dart';

class BillingService {
  // QUY TẮC NGHIỆP VỤ (Business Rules) - Tính tiền nước bậc thang
  static const double priceLevel1 = 5973;  // 0-10 m3 đầu tiên
  static const double priceLevel2 = 7052;  // Từ trên 10-20 m3
  static const double priceLevel3 = 8669;  // Từ trên 20-30 m3
  static const double priceLevel4 = 15929; // Trên 30 m3
  
  static const double vatRate = 0.05;      // Thuế VAT 5%
  static const double envFeeRate = 0.10;   // Phí bảo vệ môi trường 10%

  /// Hàm tính tiền nước phức tạp theo lũy kế bậc thang
  static double calculateAmount(int consumption) {
    if (consumption <= 0) return 0;
    
    double baseAmount = 0;
    
    if (consumption <= 10) {
      baseAmount = consumption * priceLevel1;
    } else if (consumption <= 20) {
      baseAmount = (10 * priceLevel1) + (consumption - 10) * priceLevel2;
    } else if (consumption <= 30) {
      baseAmount = (10 * priceLevel1) + (10 * priceLevel2) + (consumption - 20) * priceLevel3;
    } else {
      baseAmount = (10 * priceLevel1) + (10 * priceLevel2) + (10 * priceLevel3) + (consumption - 30) * priceLevel4;
    }

    // Cộng thêm thuế VAT và Phí môi trường
    double vat = baseAmount * vatRate;
    double envFee = baseAmount * envFeeRate;
    
    return baseAmount + vat + envFee;
  }

  // Quản lý danh sách hóa đơn tạm thời trong phiên làm việc (State Management giả lập)
  static List<Bill> pendingBills = [];

  static void addPendingBill(Bill bill) {
    pendingBills.add(bill);
  }

  static List<Bill> getHistory(int customerId) {
    // Trả về lịch sử giả lập + các hóa đơn vừa ghi (nếu có)
    return [
      Bill(id: 101, customerId: customerId, month: DateTime(2023, 11), oldReading: 100, newReading: 115, totalAmount: 125000, isPaid: true),
      Bill(id: 102, customerId: customerId, month: DateTime(2023, 12), oldReading: 115, newReading: 132, totalAmount: 148000, isPaid: true),
      ...pendingBills.where((b) => b.customerId == customerId),
    ];
  }
}
