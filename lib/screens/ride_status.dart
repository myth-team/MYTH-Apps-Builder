import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ride_now_app/utils/colors.dart'; 
import 'package:ride_now_app/widgets/status_timeline.dart'; 

class RideStatusScreen extends StatefulWidget {
  @override
  _RideStatusScreenState createState() => _RideStatusScreenState();
}

class _RideStatusScreenState extends State<RideStatusScreen> {
  late StreamController<RideStatus> _statusController;
  late Timer _statusTimer;
  late Timer _etaTimer;
  int _etaSeconds = 180;
  int _statusIndex = 0;

  final List<RideStatus> _statusSequence = [
    RideStatus.requested,
    RideStatus.accepted,
    RideStatus.arriving,
    RideStatus.onTrip,
    RideStatus.completed,
  ];

  @override
  void initState() {
    super.initState();
    _statusController = StreamController<RideStatus>.broadcast();
    _statusController.add(RideStatus.requested);

    _statusTimer = Timer.periodic(Duration(seconds: 4), (_) {
      if (_statusIndex < _statusSequence.length - 1) {
        _statusIndex++;
        _statusController.add(_statusSequence[_statusIndex]);
        if (_statusSequence[_statusIndex] == RideStatus.onTrip) {
          _etaSeconds = 420;
        }
      }
    });

    _etaTimer = Timer.periodic(Duration(seconds: 1), (_) {
      if (_etaSeconds > 0 && _statusIndex < _statusSequence.length - 1) {
        setState(() => _etaSeconds--);
      }
    });
  }

  @override
  void dispose() {
    _statusTimer.cancel();
    _etaTimer.cancel();
    _statusController.close();
    super.dispose();
  }

  String get _etaText {
    final m = _etaSeconds ~/ 60;
    final s = _etaSeconds % 60;
    return '${m}m ${s.toString().padLeft(2, '0')}s';
  }

  void _cancelRide() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Ride Status', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedStatusTimeline(statusStream: _statusController.stream),
            SizedBox(height: 24),
            _DriverInfoCard(),
            SizedBox(height: 20),
            _EtaCard(etaText: _etaText),
            SizedBox(height: 20),
            _CarDetailsCard(),
            SizedBox(height: 24),
            if (_statusIndex < _statusSequence.length - 1)
              SizedBox(
                width: double.infinity,
                height: 54,
                child: OutlinedButton(
                  onPressed: _cancelRide,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: BorderSide(color: AppColors.error),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text('Cancel Ride', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _DriverInfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: Offset(0, 4))],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            child: Icon(Icons.person, size: 40, color: AppColors.primary),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Michael Chen', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.star, size: 16, color: AppColors.warning),
                    SizedBox(width: 4),
                    Text('4.9', style: TextStyle(fontWeight: FontWeight.w600)),
                    Text(' (2,847 trips)', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    _StatBadge(icon: Icons.verified, label: 'Verified'),
                    SizedBox(width: 8),
                    _StatBadge(icon: Icons.local_taxi, label: '5 yrs'),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: Icon(Icons.phone, color: AppColors.primary),
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final IconData icon;
  final String label;

  _StatBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.primary),
          SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _EtaCard extends StatelessWidget {
  final String etaText;

  _EtaCard({required this.etaText});

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
          Container(
            padding: EdgeInsets.all(14),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(16)),
            child: Icon(Icons.access_time_filled, color: Colors.white, size: 28),
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Estimated Arrival', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14)),
              SizedBox(height: 4),
              Text(etaText, style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
            ],
          ),
        ],
      ),
    );
  }
}

class _CarDetailsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Vehicle Details', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _CarDetailItem(icon: Icons.directions_car, label: 'Toyota Camry', sublabel: 'Sedan • White'),
              ),
              Expanded(
                child: _CarDetailItem(icon: Icons.confirmation_number, label: 'ABC-1234', sublabel: 'License Plate'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CarDetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sublabel;

  _CarDetailItem({required this.icon, required this.label, required this.sublabel});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: AppColors.primary, size: 22),
        ),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            Text(sublabel, style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          ],
        ),
      ],
    );
  }
}