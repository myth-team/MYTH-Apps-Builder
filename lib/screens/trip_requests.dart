import 'package:flutter/material.dart';
import 'package:ride_swift_app/utils/colors.dart'; 

class TripRequestsScreen extends StatelessWidget {
  const TripRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final requests = [
      {'distance': '0.3 mi', 'fare': '\$15.50', 'pickup': '123 Main St', 'dropoff': '456 Oak Ave', 'rider': 'Alice M.', 'rating': 4.8},
      {'distance': '0.8 mi', 'fare': '\$22.00', 'pickup': '789 Elm St', 'dropoff': '321 Pine St', 'rider': 'Bob K.', 'rating': 4.9},
      {'distance': '1.2 mi', 'fare': '\$28.50', 'pickup': '555 Broadway', 'dropoff': '777 Market St', 'rider': 'Carol L.', 'rating': 4.7},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text('Trip Requests', style: TextStyle(color: AppColors.textPrimary)),
        leading: IconButton(icon: Icon(Icons.arrow_back, color: AppColors.textPrimary), onPressed: () => Navigator.pop(context)),
      ),
      body: requests.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox_outlined, size: 80, color: AppColors.textHint),
                  const SizedBox(height: 16),
                  Text('No pending requests', style: TextStyle(fontSize: 18, color: AppColors.textSecondary)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: requests.length,
              itemBuilder: (context, index) => _RequestCard(request: requests[index]),
            ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  final Map<String, dynamic> request;

  const _RequestCard({required this.request});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)]),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [AppColors.primary, AppColors.primaryDark], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                CircleAvatar(radius: 24, backgroundColor: Colors.white, child: Icon(Icons.person, color: AppColors.primary, size: 28)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(request['rider'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                      Row(children: [const Icon(Icons.star, size: 16, color: Colors.amber), const SizedBox(width: 4), Text(request['rating'], style: const TextStyle(color: Colors.white))]),
                    ],
                  ),
                ),
                Text(request['fare'], style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildLocationRow(Icons.circle, request['pickup'], AppColors.success),
                const SizedBox(height: 12),
                _buildLocationRow(Icons.location_on, request['dropoff'], AppColors.error),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.near_me, size: 20, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text('${request['distance']} away', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 56,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: BorderSide(color: AppColors.error, width: 2),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {},
                      child: const Text('Decline', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => Navigator.pushNamed(context, '/ride_tracking'),
                      child: const Text('Accept', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationRow(IconData icon, String address, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 12),
        Expanded(child: Text(address, style: TextStyle(fontSize: 16, color: AppColors.textPrimary))),
      ],
    );
  }
}