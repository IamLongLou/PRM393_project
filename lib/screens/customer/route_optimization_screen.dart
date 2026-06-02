import 'package:flutter/material.dart';
import '../../models/customer.dart';

class RouteOptimizationScreen extends StatelessWidget {
  final Customer customer;

  const RouteOptimizationScreen({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. Background Map Image (Full screen)
          Container(
            height: MediaQuery.of(context).size.height * 0.55,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('https://images.unsplash.com/photo-1526778548025-fa2f459cd5ce?q=80&w=1000&auto=format&fit=crop'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // 2. Custom Map Overlays (Markers & Paths)
          Positioned(
            top: 60,
            left: 20,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          
          Positioned(
            top: 60,
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

          // 3. Start Navigation Button
          Positioned(
            top: MediaQuery.of(context).size.height * 0.45,
            left: 40,
            right: 40,
            child: ElevatedButton.icon(
              onPressed: () {},
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

          // 4. Bottom Info Sheet
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.48,
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
                    const SizedBox(height: 15),
                    Text(
                      customer.address.split(',').first,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    
                    // User Profile Card
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=${customer.id}'),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(customer.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                const SizedBox(height: 2),
                                Text(customer.address, style: TextStyle(color: Colors.grey[500], fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    
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
                            onPressed: () {},
                            icon: const Icon(Icons.call_outlined),
                            label: const Text('Call Client'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.info_outline),
                            label: const Text('Report Issue'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 15),
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
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Text(unit, style: const TextStyle(fontSize: 12, color: Colors.blue)),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
