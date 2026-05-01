import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ride_now_app/utils/colors.dart'; 
import 'package:ride_now_app/widgets/map_placeholder.dart'; 

class TripDetailScreen extends StatefulWidget {
  @override
  _TripDetailScreenState createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends State<TripDetailScreen> {
  double _rating = 0;
  final _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Trip Details', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MapPlaceholder(height: 180, label: 'Trip Route'),
            SizedBox(height: 16),
            _buildLocationCard(),
            SizedBox(height: 16),
            _buildFareBreakdown(),
            SizedBox(height: 16),
            _buildPaymentMethod(),
            SizedBox(height: 24),
            _buildRatingSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _locationRow(Icons.location_on, AppColors.success, '123 Main St, Downtown', 'Pickup'),
            Divider(height: 24, color: AppColors.divider),
            _locationRow(Icons.location_on, AppColors.error, '456 Market St, Uptown', 'Drop-off'),
          ],
        ),
      ),
    );
  }

  Widget _locationRow(IconData icon, Color color, String address, String label) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              SizedBox(height: 2),
              Text(address, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFareBreakdown() {
    final items = [
      ('Base fare', '\$3.50'),
      ('Distance (4.2 mi)', '\$8.40'),
      ('Time (18 min)', '\$4.50'),
      ('Surge', '\$2.00'),
    ];

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Fare Breakdown', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
            SizedBox(height: 12),
            ...items.map((item) => _fareRow(item.$1, item.$2)),
            Divider(height: 24, color: AppColors.divider),
            _fareRow('Total', '\$18.40', isTotal: true),
          ],
        ),
      ),
    );
  }

  Widget _fareRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w400,
            color: isTotal ? AppColors.textPrimary : AppColors.textSecondary,
          )),
          Text(value, style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
            color: isTotal ? AppColors.primary : AppColors.textPrimary,
          )),
        ],
      ),
    );
  }

  Widget _buildPaymentMethod() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(Icons.credit_card, color: AppColors.primary),
        title: Text('Visa ending in 4242', style: TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text('Credit Card', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      ),
    );
  }

  Widget _buildRatingSection() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Rate your trip', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  onPressed: () => setState(() => _rating = index + 1),
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: AppColors.warning,
                    size: 36,
                  ),
                );
              }),
            ),
            SizedBox(height: 12),
            TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: 'Add a comment (optional)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: EdgeInsets.all(12),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _rating > 0 ? _submitRating : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text('Submit Rating', style: TextStyle(fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitRating() {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}