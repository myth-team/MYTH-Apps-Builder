import 'package:flutter/material.dart';
import 'package:ride_swift_app/utils/colors.dart'; 

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> with SingleTickerProviderStateMixin {
  bool _isOnline = false;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text('Driver Dashboard', style: TextStyle(color: AppColors.textPrimary)),
        actions: [
          IconButton(icon: Icon(Icons.notifications_outlined, color: AppColors.textPrimary), onPressed: () {}),
          IconButton(icon: Icon(Icons.menu, color: AppColors.textPrimary), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          _buildStatusToggle(),
          _buildEarningsSummary(),
          TabBar(controller: _tabController, labelColor: AppColors.primary, unselectedLabelColor: AppColors.textSecondary, indicatorColor: AppColors.primary, tabs: const [Tab(text: 'Today'), Tab(text: 'This Week')]),
          Expanded(child: TabBarView(controller: _tabController, children: [_buildTodayStats(), _buildWeeklyStats()])),
        ],
      ),
    );
  }

  Widget _buildStatusToggle() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)]),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Status', style: TextStyle(fontSize: 16, color: AppColors.textSecondary)),
              Text(_isOnline ? 'Online' : 'Offline', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: _isOnline ? AppColors.online : AppColors.offline)),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => setState(() => _isOnline = !_isOnline),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 80,
              height: 40,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: _isOnline ? AppColors.online : AppColors.offline),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 300),
                alignment: _isOnline ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(width: 36, height: 36, margin: const EdgeInsets.all(2), decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEarningsSummary() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Text('Today\'s Earnings', style: TextStyle(fontSize: 14, color: Colors.white70)),
          const SizedBox(height: 8),
          Text('\$127.50', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('5', 'Trips'),
              Container(width: 1, height: 30, color: Colors.white30),
              _buildStatItem('2.5h', 'Online'),
              Container(width: 1, height: 30, color: Colors.white30),
              _buildStatItem('\$25.50', 'Avg/Trip'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.white70)),
      ],
    );
  }

  Widget _buildTodayStats() {
    final trips = [
      {'time': '2:30 PM', 'from': '123 Main St', 'to': '456 Oak Ave', 'fare': '\$12.50'},
      {'time': '11:15 AM', 'from': '789 Elm St', 'to': '321 Pine St', 'fare': '\$18.00'},
      {'time': '9:00 AM', 'from': 'Home', 'to': 'Downtown', 'fare': '\$22.00'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: trips.length,
      itemBuilder: (context, index) {
        final trip = trips[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
          child: Row(
            children: [
              Container(
                width: 50, height: 50,
                decoration: BoxDecoration(color: AppColors.primaryLight.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                child: Icon(Icons.directions_car, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(trip['time']!, style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    Text('${trip['from']} → ${trip['to']}', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  ],
                ),
              ),
              Text(trip['fare']!, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.success)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWeeklyStats() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            height: 200,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Weekly Earnings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                const SizedBox(height: 20),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildBar(60, 'Mon'),
                      _buildBar(85, 'Tue'),
                      _buildBar(45, 'Wed'),
                      _buildBar(120, 'Thu'),
                      _buildBar(95, 'Fri'),
                      _buildBar(70, 'Sat'),
                      _buildBar(50, 'Sun'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildInfoCard('Total', '\$525.00', Icons.account_balance_wallet)),
              const SizedBox(width: 12),
              Expanded(child: _buildInfoCard('Bonus', '+\$50.00', Icons.card_giftcard)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBar(double height, String day) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(height: height * 1.5, margin: const EdgeInsets.symmetric(horizontal: 4), decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(4))),
          const SizedBox(height: 8),
          Text(day, style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 32),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(color: AppColors.textSecondary)),
              Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            ],
          ),
        ],
      ),
    );
  }
}