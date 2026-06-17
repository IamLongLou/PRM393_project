import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../models/customer.dart';
import '../../models/bill.dart';
import '../../providers/billing_provider.dart';
import '../../providers/customer_provider.dart';
import 'receipt_screen.dart';
import 'package:intl/intl.dart';

class PaymentScreen extends StatelessWidget {
  final Customer customer;
  final int newReading;
  final String imagePath;

  const PaymentScreen({super.key, required this.customer, required this.newReading, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    int consumption = newReading - customer.currentReading;
    final double amount = consumption * 12000.0;
    final double vat = amount * 0.1;
    final double total = amount + vat;
    final format = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

    return Scaffold(
      appBar: AppBar(title: const Text('Thanh Toán')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
             Text('Khách hàng: ${customer.name}'),
             Text('Chỉ số cũ: ${customer.currentReading}'),
             Text('Chỉ số mới: $newReading'),
             const Divider(),
             Text('Tổng cộng: ${format.format(total)}'),
             const SizedBox(height: 30),
             Center(child: QrImageView(data: "PAY_${customer.code}_$total", size: 200)),
             const SizedBox(height: 30),
             ElevatedButton(
               onPressed: () => _confirmPayment(context, consumption, total),
               child: const Text('Lập Hóa Đơn'),
             )
          ],
        ),
      ),
    );
  }

  void _confirmPayment(BuildContext context, int consumption, double total) async {
    final bill = Bill(
      customerId: customer.id!,
      customerName: customer.name,
      customerCode: customer.code,
      billCode: 'INV-${customer.code}-${DateTime.now().millisecondsSinceEpoch}',
      date: DateTime.now(),
      oldReading: customer.currentReading,
      newReading: newReading,
      consumption: consumption.toDouble(),
      unitPrice: 12000,
      amount: total / 1.1,
      vat: total - (total/1.1),
      totalAmount: total,
      isSynced: false,
    );
    await context.read<BillingProvider>().saveBill(bill);
    await context.read<CustomerProvider>().fetch();
    if (context.mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ReceiptScreen(customer: customer, bill: bill)));
  }
}
