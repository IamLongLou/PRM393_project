import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/customer.dart';
import '../models/bill.dart';
import '../providers/billing_provider.dart';
import '../screens/customer/customer_detail_screen.dart';
import '../screens/customer/receipt_screen.dart';
import '../screens/customer/route_optimization_screen.dart';
import 'package:intl/intl.dart';

class CustomerCard extends StatelessWidget {
  final Customer customer;

  const CustomerCard({super.key, required this.customer});

  Future<void> _makeCall(String phone) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(launchUri)) await launchUrl(launchUri);
  }

  Future<void> _sendSMS(String phone) async {
    final Uri launchUri = Uri(scheme: 'sms', path: phone);
    if (await canLaunchUrl(launchUri)) await launchUrl(launchUri);
  }

  Future<void> _openMap(String address) async {
    final String googleMapsUrl = "https://www.google.com/maps/dir/?api=1&destination=${Uri.encodeComponent(address)}&travelmode=driving";
    final String appleMapsUrl = "http://maps.apple.com/?daddr=${Uri.encodeComponent(address)}";
    
    final Uri googleUri = Uri.parse(googleMapsUrl);
    final Uri appleUri = Uri.parse(appleMapsUrl);

    if (await canLaunchUrl(googleUri)) {
      await launchUrl(googleUri, mode: LaunchMode.externalApplication);
    } else if (await canLaunchUrl(appleUri)) {
      await launchUrl(appleUri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (customer.status == CollectionStatus.completed) {
      return _buildCompletedCard(context);
    } else {
      return _buildPendingCard(context);
    }
  }

  Widget _buildPendingCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=${customer.id}'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(customer.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text('MÃ KH: ${customer.code}', style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: Colors.blue.withOpacity(0.05), borderRadius: BorderRadius.circular(20)),
                child: const Text('Chờ ghi số', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 10)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.location_on, size: 16, color: Colors.blue),
              const SizedBox(width: 6),
              Expanded(child: Text(customer.address, style: const TextStyle(color: Colors.grey, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis)),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _actionIcon(Icons.phone_outlined, 'Gọi điện', Colors.green, () => _makeCall(customer.phone)),
              _actionIcon(Icons.chat_bubble_outline, 'Nhắn tin', Colors.orange, () => _sendSMS(customer.phone)),
              _actionIcon(Icons.map_outlined, 'Bản đồ', Colors.blue, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RouteOptimizationScreen(customer: customer),
                  ),
                );
              }),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey.withOpacity(0.1))),
            child: Row(
              children: [
                const Icon(Icons.speed, size: 18, color: Colors.grey),
                const SizedBox(width: 10),
                const Text('Chỉ số cũ', style: TextStyle(color: Colors.grey, fontSize: 13)),
                const Spacer(),
                Text('${customer.currentReading}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const Text(' m³', style: TextStyle(color: Colors.grey, fontSize: 10)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CustomerDetailScreen(customer: customer))),
              icon: const Icon(Icons.flash_on, size: 18),
              label: const Text('Ghi số & Thu tiền', style: TextStyle(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedCard(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    
    return FutureBuilder<List<Bill>>(
      future: Provider.of<BillingProvider>(context, listen: false).getAllBills(),
      builder: (context, snapshot) {
        Bill? latestBill;
        if (snapshot.hasData) {
          try {
            latestBill = snapshot.data!.firstWhere((b) => b.customerId == customer.id);
          } catch (e) {
            // No bill found for this customer yet
          }
        }

        final amountText = latestBill != null ? currencyFormat.format(latestBill.totalAmount) : "N/A";
        final dateText = latestBill != null ? DateFormat('HH:mm - dd/MM/yyyy').format(latestBill.date) : "N/A";

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=${customer.id}'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(customer.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        const SizedBox(height: 4),
                        Text(customer.code, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16, color: Colors.blue),
                  const SizedBox(width: 6),
                  Expanded(child: Text(customer.address, style: const TextStyle(color: Colors.grey, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis)),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _actionIcon(Icons.phone_outlined, 'Gọi điện', Colors.green, () => _makeCall(customer.phone)),
                  _actionIcon(Icons.chat_bubble_outline, 'Nhắn tin', Colors.orange, () => _sendSMS(customer.phone)),
                  _actionIcon(Icons.map_outlined, 'Bản đồ', Colors.blue, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RouteOptimizationScreen(customer: customer),
                      ),
                    );
                  }),
                ],
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.blue.withOpacity(0.03), borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox.shrink(),
                        Row(
                          children: [
                            const Icon(Icons.access_time, size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(dateText, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(amountText, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        Row(
                          children: [
                            Icon(Icons.check_circle, size: 14, color: Colors.grey[400]),
                            const SizedBox(width: 4),
                            Text('THÀNH CÔNG', style: TextStyle(fontSize: 10, color: Colors.grey[400], fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: latestBill == null ? null : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReceiptScreen(customer: customer, bill: latestBill!),
                      ),
                    );
                  },
                  icon: const Icon(Icons.print_outlined, size: 16),
                  label: const Text('Xem / In hóa đơn', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.grey[100],
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _actionIcon(IconData icon, String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
