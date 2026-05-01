import 'package:flutter/material.dart';
import 'package:ridewise_go_app/utils/colors.dart'; 

class MyTrips extends StatelessWidget {
  const MyTrips({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Trips'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder: (ctx, i) => _TripCard(trip: _mockTrips[i], onTap: () => _showTripDetail(context, _mockTrips[i])),
      ),
    );
  }

  void _showTripDetail(BuildContext context, Map<String, dynamic> trip) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Trip Details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
                ],
              ),
              const Divider(),
              const SizedBox(height: 8),
              _detailRow('Pickup', trip['pickup']),
              _detailRow('Destination', trip['dest']),
              _detailRow('Date', trip['date']),
              _detailRow('Driver', trip['driver']),
              _detailRow('Fare', trip['fare']),
              const SizedBox(height: 12),
              const Text('Rating', style: TextStyle(fontWeight: FontWeight.w600)),
              Row(children: List.generate(5, (i) => Icon(i < (trip['rating'] as int) ? Icons.star : Icons.star_border, color: AppColors.warning, size: 24))),
              const SizedBox(height: 16),
              const Text('Receipt', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(8)),
                child: Column(
                  children: [
                    _receiptRow('Base fare', '\$5.00'),
                    _receiptRow('Distance (3.2 mi)', '\$8.00'),
                    _receiptRow('Time (12 min)', '\$3.00'),
                    const Divider(),
                    _receiptRow('Total', '\$16.00', bold: true),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 90, child: Text(label, style: const TextStyle(color: AppColors.textSecondary))),
          Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }

  Widget _receiptRow(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
          Text(value, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}

class _TripCard extends StatelessWidget {
  final Map<String, dynamic> trip;
  final VoidCallback onTap;

  const _TripCard({required this.trip, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: AppColors.accent.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
          child: const Icon(Icons.local_taxi, color: AppColors.accent),
        ),
        title: Text('${trip['pickup']} → ${trip['dest']}', style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text('${trip['date']} • ${trip['driver']}', style: const TextStyle(color: AppColors.textSecondary)),
        trailing: Text(trip['fare'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.accent)),
      ),
    );
  }
}

final _mockTrips = [
  {'pickup': '123 Main St', 'dest': '456 Oak Ave', 'date': 'Jan 15, 2025', 'fare': '\$16.00', 'driver': 'John D.', 'rating': 5},
  {'pickup': 'Downtown', 'dest': 'Airport', 'date': 'Jan 14, 2025', 'fare': '\$32.50', 'driver': 'Sarah M.', 'rating': 4},
  {'pickup': 'Mall', 'dest': 'Home', 'date': 'Jan 13, 2025', 'fare': '\$12.75', 'driver': 'Mike R.', 'rating': 5},
  {'pickup': 'Office', 'dest': 'Restaurant', 'date': 'Jan 12, 2025', 'fare': '\$8.50', 'driver': 'Emily K.', 'rating': 5},
  {'pickup': 'Home', 'dest': 'Gym', 'date': 'Jan 11, 2025', 'fare': '\$10.00', 'driver': 'David L.', 'rating': 3},
];