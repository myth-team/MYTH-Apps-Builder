import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ride_now_app/utils/colors.dart'; 
import 'package:ride_now_app/widgets/map_placeholder.dart'; 
import 'package:ride_now_app/widgets/ride_type_chip.dart'; 

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  String _selectedRideType = 'Economy';

  final List<Map<String, dynamic>> _pastTrips = [
    {'date': 'Today, 9:30 AM', 'from': 'Home', 'to': 'Office', 'fare': '\$12.50', 'status': 'Completed'},
    {'date': 'Yesterday, 6:15 PM', 'from': 'Mall', 'to': 'Home', 'fare': '\$8.75', 'status': 'Completed'},
    {'date': 'Jan 15, 2:00 PM', 'from': 'Airport', 'to': 'Hotel', 'fare': '\$34.20', 'status': 'Completed'},
  ];

  void _navigateTo(String route) {
    Navigator.pushNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: [
            _BookTab(
              selectedRideType: _selectedRideType,
              onRideTypeSelected: (t) => setState(() => _selectedRideType = t),
              onRequestRide: () => _navigateTo('/ride_status'),
            ),
            _ActivityTab(trips: _pastTrips, onTripTap: () => _navigateTo('/trip_detail')),
            _AccountTab(
              onPayments: () => _navigateTo('/payments'),
              onDriverMode: () => _navigateTo('/driver_mode'),
              onAdminPanel: () => _navigateTo('/admin_panel'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.local_taxi), label: 'Book'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Activity'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
      ),
    );
  }
}

class _BookTab extends StatelessWidget {
  final String selectedRideType;
  final ValueChanged<String> onRideTypeSelected;
  final VoidCallback onRequestRide;

  _BookTab({required this.selectedRideType, required this.onRideTypeSelected, required this.onRequestRide});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Where to?', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          SizedBox(height: 16),
          MapPlaceholder(height: 180, label: 'Live Map'),
          SizedBox(height: 16),
          _LocationField(icon: Icons.location_on, color: AppColors.primary, hint: 'Pickup location'),
          SizedBox(height: 12),
          _LocationField(icon: Icons.flag, color: AppColors.accent, hint: 'Drop-off location'),
          SizedBox(height: 20),
          Text('Select Ride', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: RideTypeChip(
                  label: 'Economy',
                  icon: Icons.local_taxi,
                  price: '\$12.50',
                  selected: selectedRideType == 'Economy',
                  onTap: () => onRideTypeSelected('Economy'),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: RideTypeChip(
                  label: 'Premium',
                  icon: Icons.star,
                  price: '\$22.00',
                  selected: selectedRideType == 'Premium',
                  onTap: () => onRideTypeSelected('Premium'),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: RideTypeChip(
                  label: 'Bike',
                  icon: Icons.two_wheeler,
                  price: '\$6.00',
                  selected: selectedRideType == 'Bike',
                  onTap: () => onRideTypeSelected('Bike'),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          _FareEstimateCard(rideType: selectedRideType),
          SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: onRequestRide,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: Text('Request Ride', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationField extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String hint;

  _LocationField({required this.icon, required this.color, required this.hint});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          SizedBox(width: 12),
          Text(hint, style: TextStyle(color: AppColors.textSecondary, fontSize: 15)),
        ],
      ),
    );
  }
}

class _FareEstimateCard extends StatelessWidget {
  final String rideType;

  _FareEstimateCard({required this.rideType});

  double get _baseFare {
    switch (rideType) {
      case 'Premium':
        return 22.0;
      case 'Bike':
        return 6.0;
      default:
        return 12.5;
    }
  }

  @override
  Widget build(BuildContext context) {
    final fare = _baseFare;
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: Offset(0, 4))],
      ),
      child: Column(
        children: [
          _FareRow('Base fare', '\$${fare.toStringAsFixed(2)}'),
          SizedBox(height: 8),
          _FareRow('Distance (5.2 mi)', '\$${(fare * 0.4).toStringAsFixed(2)}'),
          SizedBox(height: 8),
          _FareRow('Time (12 min)', '\$${(fare * 0.2).toStringAsFixed(2)}'),
          Divider(height: 24, color: AppColors.divider),
          _FareRow('Total Estimate', '\$${(fare * 1.6).toStringAsFixed(2)}', isTotal: true),
        ],
      ),
    );
  }
}

class _FareRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;

  _FareRow(this.label, this.value, {this.isTotal = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(
          fontSize: isTotal ? 16 : 14,
          fontWeight: isTotal ? FontWeight.w700 : FontWeight.w400,
          color: isTotal ? AppColors.textPrimary : AppColors.textSecondary,
        )),
        Text(value, style: TextStyle(
          fontSize: isTotal ? 18 : 14,
          fontWeight: isTotal ? FontWeight.w700 : FontWeight.w600,
          color: isTotal ? AppColors.primary : AppColors.textPrimary,
        )),
      ],
    );
  }
}

class _ActivityTab extends StatelessWidget {
  final List<Map<String, dynamic>> trips;
  final VoidCallback onTripTap;

  _ActivityTab({required this.trips, required this.onTripTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Text('Your Trips', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: trips.length,
            itemBuilder: (context, index) {
              final trip = trips[index];
              return Card(
                margin: EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                child: ListTile(
                  onTap: onTripTap,
                  contentPadding: EdgeInsets.all(16),
                  leading: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                    child: Icon(Icons.local_taxi, color: AppColors.primary),
                  ),
                  title: Text('${trip['from']} → ${trip['to']}', style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(trip['date'], style: TextStyle(color: AppColors.textSecondary)),
                  trailing: Text(trip['fare'], style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary, fontSize: 16)),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _AccountTab extends StatelessWidget {
  final VoidCallback onPayments;
  final VoidCallback onDriverMode;
  final VoidCallback onAdminPanel;

  _AccountTab({required this.onPayments, required this.onDriverMode, required this.onAdminPanel});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ProfileHeader(),
          SizedBox(height: 24),
          Text('Favorites', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          SizedBox(height: 12),
          _FavoriteTile(icon: Icons.home, label: 'Home', address: '123 Main St'),
          _FavoriteTile(icon: Icons.work, label: 'Work', address: '456 Office Blvd'),
          SizedBox(height: 24),
          Text('Settings', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          SizedBox(height: 12),
          _SettingsTile(icon: Icons.payment, label: 'Payment Methods', onTap: onPayments),
          _SettingsTile(icon: Icons.drive_eta, label: 'Switch to Driver', onTap: onDriverMode),
          _SettingsTile(icon: Icons.support_agent, label: 'Help & Support', onTap: () {}),
          _SettingsTile(icon: Icons.admin_panel_settings, label: 'Admin Access', onTap: onAdminPanel),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: Colors.white.withOpacity(0.2),
            child: Icon(Icons.person, size: 36, color: Colors.white),
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Alex Johnson', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
              Text('+1 234 567 890', style: TextStyle(color: Colors.white.withOpacity(0.8))),
            ],
          ),
        ],
      ),
    );
  }
}

class _FavoriteTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String address;

  _FavoriteTile({required this.icon, required this.label, required this.address});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      title: Text(label, style: TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(address, style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
      trailing: Icon(Icons.chevron_right, color: AppColors.textSecondary),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  _SettingsTile({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      leading: Icon(icon, color: AppColors.primary),
      title: Text(label, style: TextStyle(fontWeight: FontWeight.w500)),
      trailing: Icon(Icons.chevron_right, color: AppColors.textSecondary),
      onTap: onTap,
    );
  }
}