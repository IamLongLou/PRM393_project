import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../routes/app_routes.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  int _selectedCustomerIndex = 0;
  
  // Dữ liệu giả lập cho từng khách hàng
  final List<Map<String, dynamic>> _customerData = [
    {
      'name': 'A',
      'totalConsumption': '42.5',
      'totalCost': '510.000',
      'avgConsumption': '14.2',
      'lastReading': '15/10',
      'chartData': [12.0, 15.0, 18.0, 14.0, 16.0, 14.5],
    },
    {
      'name': 'B',
      'totalConsumption': '38.2',
      'totalCost': '458.400',
      'avgConsumption': '12.7',
      'lastReading': '16/10',
      'chartData': [10.0, 12.0, 14.0, 13.0, 15.0, 13.5],
    },
    {
      'name': 'C',
      'totalConsumption': '55.0',
      'totalCost': '660.000',
      'avgConsumption': '18.3',
      'lastReading': '17/10',
      'chartData': [15.0, 18.0, 22.0, 19.0, 21.0, 20.0],
    },
    {
      'name': 'D',
      'totalConsumption': '29.4',
      'totalCost': '352.800',
      'avgConsumption': '9.8',
      'lastReading': '18/10',
      'chartData': [8.0, 9.0, 11.0, 10.0, 12.0, 10.5],
    },
    {
      'name': 'E',
      'totalConsumption': '48.1',
      'totalCost': '577.200',
      'avgConsumption': '16.0',
      'lastReading': '19/10',
      'chartData': [13.0, 16.0, 19.0, 17.0, 18.0, 17.5],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final String updateTime = DateFormat('HH:mm, dd/MM/yyyy').format(now);
    final data = _customerData[_selectedCustomerIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Thống kê'),
        actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {})],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Khách hàng gần đây', style: TextStyle(fontWeight: FontWeight.bold)),
                  const Icon(Icons.search, size: 18, color: Colors.grey),
                ],
              ),
            ),
            _buildAvatarList(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tổng quan: Khách hàng ${data['name']}', 
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                        ),
                        Text('Cập nhật lúc $updateTime', 
                          style: const TextStyle(color: Colors.grey, fontSize: 11)
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
                    child: const Row(
                      children: [
                        Icon(Icons.check_circle_outline, size: 12, color: Colors.grey),
                        SizedBox(width: 4),
                        Text('Đã đồng bộ', style: TextStyle(color: Colors.grey, fontSize: 9, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  )
                ],
              ),
            ),
            _buildInfoGrid(data),
            _buildChartSection(data),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text('Lịch sử ghi gần đây', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            _recentItem('${data['totalConsumption']} m³', data['lastReading'] + '/2023', '${data['totalCost']}đ'),
            _recentItem('12.0 m³', '15/09/2023', '144.000đ'),
            const SizedBox(height: 50),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildAvatarList() {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        itemCount: _customerData.length,
        itemBuilder: (context, i) {
          bool isSelected = _selectedCustomerIndex == i;
          return GestureDetector(
            onTap: () => setState(() => _selectedCustomerIndex = i),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? Colors.blue : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 28,
                      backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=$i'),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(_customerData[i]['name'], 
                    style: TextStyle(
                      fontSize: 12, 
                      color: isSelected ? Colors.blue : Colors.black, 
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal
                    )
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoGrid(Map<String, dynamic> data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        childAspectRatio: 1.6,
        children: [
          _statCard(Icons.water_drop_outlined, 'Tổng tiêu thụ', data['totalConsumption'], 'M³'),
          _statCard(Icons.attach_money, 'Tổng chi phí', data['totalCost'], 'VND'),
          _statCard(Icons.trending_up, 'Trung bình/tháng', data['avgConsumption'], 'M³'),
          _statCard(Icons.calendar_today, 'Lần ghi cuối', data['lastReading'], '2023'),
        ],
      ),
    );
  }

  Widget _statCard(IconData icon, String label, String value, String unit) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: Colors.blue),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(5)),
                child: const Text('ĐÃ THANH TOÁN', style: TextStyle(color: Colors.white, fontSize: 7, fontWeight: FontWeight.bold)),
              )
            ],
          ),
          const Spacer(),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10)),
          Row(
            children: [
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(width: 4),
              Text(unit, style: const TextStyle(color: Colors.grey, fontSize: 9)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartSection(Map<String, dynamic> data) {
    List<double> chartPoints = data['chartData'];
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Xu hướng tiêu thụ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const Text('Tiêu thụ 6 tháng gần nhất (m³)', style: TextStyle(color: Colors.grey, fontSize: 10)),
          const SizedBox(height: 20),
          SizedBox(
            height: 150,
            child: BarChart(
              BarChartData(
                gridData: const FlGridData(show: true, drawVerticalLine: false, horizontalInterval: 5),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 20,
                      getTitlesWidget: (v, m) => Text('${v.toInt()}', style: const TextStyle(fontSize: 8, color: Colors.grey)),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (v, m) => Text('Th${v.toInt() + 5}', style: const TextStyle(fontSize: 8, color: Colors.grey)),
                    ),
                  ),
                  rightTitles: const AxisTitles(),
                  topTitles: const AxisTitles(),
                ),
                borderData: FlBorderData(show: false),
                barGroups: chartPoints.asMap().entries.map((e) => BarChartGroupData(
                  x: e.key,
                  barRods: [
                    BarChartRodData(
                      toY: e.value,
                      color: Colors.blue,
                      width: 15,
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
                    )
                  ],
                )).toList(),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(radius: 3, backgroundColor: Colors.blue),
              SizedBox(width: 5),
              Text('Tiêu thụ (m³)', style: TextStyle(fontSize: 9, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _recentItem(String val, String date, String price) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
    ),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.blue.withValues(alpha: 0.05), shape: BoxShape.circle),
          child: const Icon(Icons.water_drop, color: Colors.blue, size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Chỉ số: $val', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              Text('Ngày ghi: $date', style: const TextStyle(color: Colors.grey, fontSize: 10)),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(price, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
              child: const Text('Tiền mặt', style: TextStyle(color: Colors.grey, fontSize: 9)),
            )
          ],
        )
      ],
    ),
  );

  Widget _buildBottomNav(BuildContext context) => BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    currentIndex: 1, // Stats is usually at index 1 in this nav bar
    selectedItemColor: Colors.blue,
    unselectedItemColor: Colors.grey,
    onTap: (index) {
      if (index == 0) Navigator.pushReplacementNamed(context, AppRoutes.home);
      if (index == 2) Navigator.pushReplacementNamed(context, AppRoutes.sync);
    },
    items: const [
      BottomNavigationBarItem(icon: Icon(Icons.payment), label: 'Payment'),
      BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Stats'),
      BottomNavigationBarItem(icon: Icon(Icons.sync), label: 'Sync'),
    ],
  );
}
