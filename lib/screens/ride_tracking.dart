import 'package:flutter/material.dart';
import 'package:ridewise_go_app/utils/colors.dart'; 

class RideTracking extends StatefulWidget {
  const RideTracking({super.key});

  @override
  State<RideTracking> createState() => _RideTrackingState();
}

class _RideTrackingState extends State<RideTracking> {
  String _status = 'Requested';
  final List<String> _statusTimeline = ['Requested', 'Accepted', 'Arriving', 'In Trip'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ride Tracking'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          _buildMapPlaceholder(),
          _buildStatusBadge(),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomSheet(),
          ),
        ],
      ),
    );
  }

  Widget _buildMapPlaceholder() {
    return Container(
      color: AppColors.shimmer,
      child: Stack(
        children: [
          Center(child: Icon(Icons.map, size: 120, color: AppColors.textLight)),
          const Positioned(
            top: 40,
            left: 20,
            child: _DriverMarker(),
          ),
          const Positioned(
            bottom: 200,
            right: 30,
            child: _UserMarker(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    return Positioned(
      top: 16,
      left: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: _getStatusColor(_status),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.local_taxi, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(_status, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSheet() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTimeline(),
          const SizedBox(height: 20),
          _buildDriverCard(),
          const SizedBox(height: 20),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildTimeline() {
    return Row(
      children: _statusTimeline.asMap().entries.map((entry) {
        final idx = entry.key;
        final label = entry.value;
        final isActive = _statusTimeline.indexOf(_status) >= idx;
        return Expanded(
          child: Column(
            children: [
              Container(
                height: 4,
                decoration: BoxDecoration(
                  color: idx > 0 ? (isActive ? AppColors.accent : AppColors.divider) : Colors.transparent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 4),
              Text(label, style: TextStyle(fontSize: 10, color: isActive ? AppColors.textPrimary : AppColors.textLight)),
              const SizedBox(height: 4),
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive ? AppColors.accent : AppColors.divider,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDriverCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.primary,
            child: Icon(Icons.person, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('John Driver', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                const Text('Toyota Camry • ABC 1234', style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                const SizedBox(height: 4),
                Row(children: List.generate(5, (i) => const Icon(Icons.star, size: 16, color: AppColors.warning))),
              ],
            ),
          ),
          Column(
            children: [
              _buildIconButton(Icons.phone, AppColors.success),
              const SizedBox(height: 8),
              _buildIconButton(Icons.message, AppColors.info),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, Color color) {
    return GestureDetector(
      onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Tapped $icon'))),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
            label: const Text('Cancel Ride'),
            style: OutlinedButton.styleFrom(foregroundColor: AppColors.error, side: const BorderSide(color: AppColors.error), padding: const EdgeInsets.symmetric(vertical: 14)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.phone),
            label: const Text('Call Driver'),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.success, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14)),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Requested': return AppColors.statusRequested;
      case 'Accepted': return AppColors.statusAccepted;
      case 'Arriving': return AppColors.statusArriving;
      case 'In Trip': return AppColors.statusInTrip;
      default: return AppColors.statusCompleted;
    }
  }
}

class _DriverMarker extends StatelessWidget {
  const _DriverMarker();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: AppColors.accent, shape: BoxShape.circle, boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 8)]),
      child: const Icon(Icons.local_taxi, color: Colors.white, size: 24),
    );
  }
}

class _UserMarker extends StatelessWidget {
  const _UserMarker();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: AppColors.info, shape: BoxShape.circle, boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 8)]),
      child: const Icon(Icons.person, color: Colors.white, size: 24),
    );
  }
}