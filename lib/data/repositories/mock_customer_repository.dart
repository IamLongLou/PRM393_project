import '../../models/customer.dart';
import 'customer_repository.dart';

class MockCustomerRepository implements CustomerRepository {
  final List<Customer> _data = [
    Customer(id: 1, code: 'KH001', name: 'Lưu Bị', address: '12-A Phố Huế, Hai Bà Trưng, Hà Nội', phone: '0912345001', currentReading: 125, status: CollectionStatus.pending),
    Customer(id: 2, code: 'KH002', name: 'Quan Vũ', address: '88 Đường Láng, Đống Đa, Hà Nội', phone: '0987654002', currentReading: 80, status: CollectionStatus.pending),
    Customer(id: 3, code: 'KH003', name: 'Trương Phi', address: '15/2 Trần Duy Hưng, Cầu Giấy, Hà Nội', phone: '0904444003', currentReading: 210, status: CollectionStatus.completed),
    Customer(id: 4, code: 'KH004', name: 'Gia Cát Lượng', address: 'Lạch Tray, Ngô Quyền, Hải Phòng', phone: '0911222004', currentReading: 45, status: CollectionStatus.reading),
    Customer(id: 5, code: 'KH005', name: 'Tào Tháo', address: 'Trần Hưng Đạo, TP. Bắc Ninh', phone: '0933555005', currentReading: 320, status: CollectionStatus.pending),
    Customer(id: 6, code: 'KH006', name: 'Tôn Quyền', address: 'Khu đô thị Mon Bay, Hạ Long, Quảng Ninh', phone: '0944006006', currentReading: 150, status: CollectionStatus.pending),
    Customer(id: 7, code: 'KH007', name: 'Triệu Vân', address: 'Quang Trung, TP. Thái Bình', phone: '0944007007', currentReading: 95, status: CollectionStatus.pending),
    Customer(id: 8, code: 'KH008', name: 'Chu Du', address: '15 Nguyễn Trãi, Thanh Xuân, Hà Nội', phone: '0944008008', currentReading: 180, status: CollectionStatus.pending),
    Customer(id: 9, code: 'KH009', name: 'Lữ Bố', address: '89 Cầu Giấy, Cầu Giấy, Hà Nội', phone: '0944009009', currentReading: 60, status: CollectionStatus.pending),
    Customer(id: 10, code: 'KH010', name: 'Điêu Thuyền', address: 'Lê Lợi, TP. Bắc Giang', phone: '0944010010', currentReading: 275, status: CollectionStatus.pending),
    Customer(id: 11, code: 'KH011', name: 'Tư Mã Ý', address: 'Hùng Vương, TP. Việt Trì, Phú Thọ', phone: '0944011011', currentReading: 110, status: CollectionStatus.pending),
    Customer(id: 12, code: 'KH012', name: 'Hạ Hầu Đôn', address: 'Phố Hiến, TP. Hưng Yên', phone: '0944012012', currentReading: 400, status: CollectionStatus.pending),
    Customer(id: 13, code: 'KH013', name: 'Hứa Chử', address: 'Trần Đăng Ninh, TP. Nam Định', phone: '0944013013', currentReading: 135, status: CollectionStatus.pending),
    Customer(id: 14, code: 'KH014', name: 'Trương Liêu', address: 'Vinhomes Ocean Park, Gia Lâm, Hà Nội', phone: '0944014014', currentReading: 20, status: CollectionStatus.pending),
    Customer(id: 15, code: 'KH015', name: 'Hoàng Trung', address: 'Tòa nhà Lotte, Liễu Giai, Ba Đình, Hà Nội', phone: '0944015015', currentReading: 245, status: CollectionStatus.pending),
  ];

  @override
  Future<List<Customer>> getAll() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _data;
  }

  @override
  Future<Customer?> getById(int id) async {
    try {
      return _data.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> save(Customer item) async {
    _data.add(item);
  }

  @override
  Future<void> update(Customer item) async {
    final index = _data.indexWhere((c) => c.id == item.id);
    if (index != -1) _data[index] = item;
  }

  @override
  Future<List<Customer>> search(String query) async {
    if (query.isEmpty) return _data;
    return _data.where((c) => 
      c.name.toLowerCase().contains(query.toLowerCase()) || 
      c.code.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  @override
  Future<void> updateReading(int id, int newReading) async {
    final index = _data.indexWhere((c) => c.id == id);
    if (index != -1) {
      _data[index] = _data[index].copyWith(
        currentReading: newReading,
        status: CollectionStatus.completed,
      );
    }
  }
}
