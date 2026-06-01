import '../models/customer.dart';
import 'database_helper.dart';

class CustomerService {
  static Future<List<Customer>> getCustomers() async {
    return await DatabaseHelper.instance.getAllCustomers();
  }

  static Future<void> updateStatus(int customerId, CollectionStatus newStatus) async {
    final customer = await DatabaseHelper.instance.getCustomerById(customerId);
    if (customer != null) {
      await DatabaseHelper.instance.updateCustomer(customer.copyWith(status: newStatus));
    }
  }
}
