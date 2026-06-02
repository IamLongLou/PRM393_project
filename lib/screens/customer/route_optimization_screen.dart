import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/customer.dart';

class RouteOptimizationScreen extends StatefulWidget {
  final Customer customer;

  const RouteOptimizationScreen({super.key, required this.customer});

  @override
  State<RouteOptimizationScreen> createState() => _RouteOptimizationScreenState();
}

class _RouteOptimizationScreenState extends State<RouteOptimizationScreen> {
  late GoogleMapController mapController;

  // Tọa độ giả lập cho demo (Gần Hồ Hoàn Kiếm, Hà Nội)
  final LatLng _center = const LatLng(21.0285, 105.8542);
  final LatLng _destination = const LatLng(21.0245, 105.8412);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> _startNavigation() async {
    final String googleMapsUrl = "google.navigation:q=${_destination.latitude},${_destination.longitude}";
    final String appleMapsUrl = "http://maps.apple.com/?daddr=${_destination.latitude},${_destination.longitude}";
    
    if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
      await launchUrl(Uri.parse(googleMapsUrl));
    } else if (await canLaunchUrl(Uri.parse(appleMapsUrl))) {
      await launchUrl(Uri.parse(appleMapsUrl));
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không thể mở ứng dụng bản đồ')),
        );
      }
    }
  }

  Future<void> _callClient() async {
    final Uri launchUri = Uri(scheme: 'tel', path: widget.customer.phone);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  void _reportIssue() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Báo cáo sự cố'),
        content: const TextField(
          decoration: InputDecoration(hintText: 'Nhập nội dung sự cố...'),
          maxLines: 3,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã gửi báo cáo sự cố')),
              );
            },
            child: const Text('Gửi'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. Real Google Map
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 14.0,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId('current_pos'),
                  position: _center,
                  infoWindow: const InfoWindow(title: 'Vị trí của bạn'),
                ),
                Marker(
                  markerId: const MarkerId('dest_pos'),
                  position: _destination,
                  infoWindow: InfoWindow(title: widget.customer.name),
                  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
                ),
              },
              // Thêm polyline giả lập nếu muốn vẽ đường đi
            ),
          ),

          // 2. Back Button
          Positioned(
            top: 50,
            left: 20,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          // 3. Map Controls (Top Right)
          Positioned(
            top: 50,
            right: 20,
            child: Column(
              children: [
                _mapControlIcon(Icons.settings_outlined),
                const SizedBox(height: 10),
                _mapControlIcon(Icons.layers_outlined),
                const SizedBox(height: 10),
                _mapControlIcon(Icons.search),
              ],
            ),
          ),

          // 4. Start Navigation Button (Floating in middle)
          Positioned(
            top: MediaQuery.of(context).size.height * 0.52,
            left: 40,
            right: 40,
            child: ElevatedButton.icon(
              onPressed: _startNavigation,
              icon: const Icon(Icons.navigation_outlined, color: Colors.white),
              label: const Text('Start Navigation', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2196F3),
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                elevation: 10,
                shadowColor: Colors.blue.withValues(alpha: 0.5),
              ),
            ),
          ),

          // 5. Bottom Info Sheet
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.42,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, -5)),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.blue.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text('NEXT DESTINATION', style: TextStyle(color: Colors.blue, fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 10),
                        const Icon(Icons.access_time, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        const Text('ETA 10:45 AM', style: TextStyle(color: Colors.grey, fontSize: 11)),
                        const Spacer(),
                        const Icon(Icons.more_vert, color: Colors.grey),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.customer.address.split(',').first,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),
                    
                    // User Profile Card
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 22,
                            backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=${widget.customer.id}'),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.customer.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                Text(widget.customer.address, style: TextStyle(color: Colors.grey[500], fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    
                    // Stats Row
                    Row(
                      children: [
                        _infoStat('DISTANCE', '4.8', 'km'),
                        const SizedBox(width: 15),
                        _infoStat('TIME TO ARRIVAL', '12', 'min'),
                      ],
                    ),
                    const Spacer(),
                    
                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _callClient,
                            icon: const Icon(Icons.call_outlined),
                            label: const Text('Call Client'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _reportIssue,
                            icon: const Icon(Icons.info_outline),
                            label: const Text('Report Issue'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _mapControlIcon(IconData icon) => CircleAvatar(
    backgroundColor: Colors.white,
    radius: 20,
    child: Icon(icon, color: Colors.black54, size: 20),
  );

  Widget _infoStat(String label, String value, String unit) => Expanded(
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 9, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text(unit, style: const TextStyle(fontSize: 11, color: Colors.blue)),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
