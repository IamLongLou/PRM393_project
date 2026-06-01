import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../models/customer.dart';
import '../../models/bill.dart';
import '../../services/billing_service.dart';

class CustomerHistoryScreen extends StatelessWidget {
  final Customer customer;

  const CustomerHistoryScreen({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    final history = BillingService.getHistory(customer.id);

    return Scaffold(
      appBar: AppBar(title: Text("Lịch sử: ${customer.name}")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Biểu đồ tiêu thụ (m3)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              SizedBox(
                height: 200,
                child: BarChart(
                  BarChartData(
                    barGroups: history.asMap().entries.map((e) {
                      return BarChartGroupData(
                        x: e.key,
                        barRods: [BarChartRodData(toY: e.value.consumption.toDouble(), color: Colors.blue)],
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Text("Lịch sử hóa đơn", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: history.length,
                itemBuilder: (context, index) {
                  final bill = history[index];
                  return Card(
                    child: ListTile(
                      title: Text("Tháng ${bill.month.month}/${bill.month.year}"),
                      subtitle: Text("Tiêu thụ: ${bill.consumption} m3"),
                      trailing: Text("${bill.totalAmount.toStringAsFixed(0)} đ", 
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
