import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ride_now_app/utils/colors.dart'; 

class DriverModeScreen extends StatefulWidget {
  @override
  _DriverModeScreenState createState() => _DriverModeScreenState();
}

class _DriverModeScreenState extends State<DriverModeScreen> {
  bool _isOnline = false;
  bool _hasRideRequest = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Driver Mode', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _OnlineToggle(
              isOnline: _isOnline,
              onToggle: (v) => setState(() {
                _isOnline = v;
                if (v) Future.delayed(Duration(seconds: 2), () => setState(() => _hasRideRequest = true));
              }),
            ),
            SizedBox(height: 20),
            if (_hasRideRequest && _isOnline) _RideRequestCard(
              onAccept: () => setState(() => _hasRideRequest = false),
              onDecline: () => setState(() => _hasRideRequest = false),
            ),
            SizedBox(height: 20),
            _EarningsSection(),
            SizedBox(height: 20),
            _WithdrawalButton(),
          ],
        ),
      ),
    );
  }
}

class _OnlineToggle extends StatelessWidget {
  final bool isOnline;
  final ValueChanged<bool> onToggle;

  _OnlineToggle({required this.isOnline, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isOnline ? AppColors.success : AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isOnline ? Colors.white.withOpacity(0.2) : AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              isOnline ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: isOnline ? Colors.white : AppColors.primary,
              size: 28,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isOnline ? 'You\'re Online' : 'You\'re Offline',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isOnline ? Colors.white : AppColors.textPrimary,
                  ),
                ),
                Text(
                  isOnline ? 'Receiving ride requests' : 'Tap to start earning',
                  style: TextStyle(color: isOnline ? Colors.white.withOpacity(0.8) : AppColors.textSecondary),
                ),
              ],
            ),
          ),
          Switch(
            value: isOnline,
            onChanged: onToggle,
            activeColor: Colors.white,
            activeTrackColor: Colors.white.withOpacity(0.3),
            inactiveThumbColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

class _RideRequestCard extends StatelessWidget {
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  _RideRequestCard({required this.onAccept, required this.onDecline});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(0.3), width: 2),
        boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.1), blurRadius: 16, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                child: Text('NEW REQUEST', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 12)),
              ),
              Text('\$14.50', style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary)),
            ],
          ),
          SizedBox(height: 16),
          _RequestLocationRow(icon: Icons.location_on, color: AppColors.primary, label: 'Pickup', address: '123 Main St, Downtown'),
          SizedBox(height: 12),
          _RequestLocationRow(icon: Icons.flag, color: AppColors.accent, label: 'Drop-off', address: '456 Office Blvd, Midtown'),
          SizedBox(height: 16),
          Row(
            children: [
              _ActionButton(
                label: 'Decline',
                color: AppColors.error,
                onTap: onDecline,
                outlined: true,
              ),
              SizedBox(width: 12),
              _ActionButton(
                label: 'Accept',
                color: AppColors.success,
                onTap: onAccept,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RequestLocationRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String address;

  _RequestLocationRow({required this.icon, required this.color, required this.label, required this.address});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            Text(address, style: TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool outlined;

  _ActionButton({required this.label, required this.color, required this.onTap, this.outlined = false});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: outlined ? Colors.transparent : color,
            borderRadius: BorderRadius.circular(14),
            border: outlined ? Border.all(color: color) : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: outlined ? color : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _EarningsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Earnings', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _EarningsCard(label: 'Today', amount: '\$142.50', trips: '8 trips', color: AppColors.primary)),
            SizedBox(width: 12),
            Expanded(child: _EarningsCard(label: 'This Week', amount: '\$892.00', trips: '47 trips', color: AppColors.secondary)),
          ],
        ),
      ],
    );
  }
}

class _EarningsCard extends StatelessWidget {
  final String label;
  final String amount;
  final String trips;
  final Color color;

  _EarningsCard({required this.label, required this.amount, required this.trips, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          SizedBox(height: 8),
          Text(amount, style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
          SizedBox(height: 4),
          Text(trips, style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        ],
      ),
    );
  }
}

class _WithdrawalButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: Icon(Icons.account_balance_wallet),
        label: Text('Withdraw Earnings', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }
}