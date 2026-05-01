import 'package:flutter/material.dart';
import 'package:ridenow_go_app/models/ride.dart'; 
import 'package:ridenow_go_app/services/ride_service.dart'; 
import 'package:ridenow_go_app/utils/colors.dart'; 

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final RideService _rideService = RideService.instance;

  List<Ride> _rideHistory = [];
  bool _isLoadingHistory = true;

  final List<Map<String, dynamic>> _savedPlaces = [
    {'icon': Icons.home_rounded, 'label': 'Home', 'address': '123 Market St, San Francisco'},
    {'icon': Icons.work_outline_rounded, 'label': 'Work', 'address': '456 Mission St, San Francisco'},
    {'icon': Icons.favorite_outline_rounded, 'label': 'Gym', 'address': '789 Fillmore St, San Francisco'},
  ];

  final List<Map<String, dynamic>> _promoCodes = [
    {'code': 'WELCOME50', 'discount': '50% off', 'expires': 'Dec 31'},
    {'code': 'RIDE20', 'discount': '20% off', 'expires': 'Nov 15'},
  ];

  @override
  void initState() {
    super.initState();
    _loadRideHistory();
  }

  Future<void> _loadRideHistory() async {
    final history = await _rideService.getRideHistory(limit: 10);
    setState(() {
      _rideHistory = history;
      _isLoadingHistory = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatsSection(),
                SizedBox(height: 20),
                _buildSavedPlacesSection(),
                SizedBox(height: 20),
                _buildPromoCodesSection(),
                SizedBox(height: 20),
                _buildRideHistorySection(),
                SizedBox(height: 20),
                _buildSettingsSection(),
                SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: AppColors.primary,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: AppColors.buildGradient(AppColors.primaryGradient),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildAvatar(),
                SizedBox(height: 12),
                Text(
                  'Alex Johnson',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                _buildTierBadge(),
              ],
            ),
          ),
        ),
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.edit_outlined, color: Colors.white),
          onPressed: () {
            // Edit profile
          },
        ),
      ],
    );
  }

  Widget _buildAvatar() {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: ClipOval(
            child: Image.network(
              'https://i.pravatar.cc/150?img=11',
              width: 90,
              height: 90,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: AppColors.primaryDark,
                  child: Center(
                    child: Text(
                      'AJ',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.tierGold,
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
          ),
          child: Icon(
            Icons.star_rounded,
            size: 14,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildTierBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.tierGold.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.tierGold.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.emoji_events_rounded,
            size: 16,
            color: AppColors.tierGold,
          ),
          SizedBox(width: 6),
          Text(
            'Gold Member',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.tierGold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 12,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildStatItem(
            icon: Icons.local_taxi_rounded,
            value: '47',
            label: 'Rides',
            color: AppColors.primary,
          ),
          Container(
            width: 1,
            height: 50,
            color: AppColors.divider,
            margin: EdgeInsets.symmetric(horizontal: 16),
          ),
          _buildStatItem(
            icon: Icons.route_rounded,
            value: '324',
            label: 'km',
            color: AppColors.success,
          ),
          Container(
            width: 1,
            height: 50,
            color: AppColors.divider,
            margin: EdgeInsets.symmetric(horizontal: 16),
          ),
          _buildStatItem(
            icon: Icons.schedule_rounded,
            value: '86',
            label: 'Hours',
            color: AppColors.secondary,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 22,
            ),
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavedPlacesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Saved Places',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Add new place
                },
                child: Text(
                  'Add New',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 20),
            itemCount: _savedPlaces.length,
            itemBuilder: (context, index) {
              final place = _savedPlaces[index];
              return _buildSavedPlaceCard(place);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSavedPlaceCard(Map<String, dynamic> place) {
    return Container(
      width: 160,
      margin: EdgeInsets.only(right: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            place['icon'] as IconData,
            color: AppColors.primary,
            size: 24,
          ),
          SizedBox(height: 12),
          Text(
            place['label'] as String,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 4),
          Text(
            place['address'] as String,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildPromoCodesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Promo Codes',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        SizedBox(height: 12),
        SizedBox(
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 20),
            itemCount: _promoCodes.length,
            itemBuilder: (context, index) {
              final promo = _promoCodes[index];
              return _buildPromoCard(promo);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPromoCard(Map<String, dynamic> promo) {
    return Container(
      width: 200,
      margin: EdgeInsets.only(right: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.buildGradient(AppColors.accentGradient),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                promo['code'] as String,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 1,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  promo['discount'] as String,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Spacer(),
          Text(
            'Expires ${promo['expires']}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRideHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ride History',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton(
                onPressed: () {
                  // View all history
                },
                child: Text(
                  'View All',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12),
        if (_isLoadingHistory)
          Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
          )
        else
          ..._rideHistory.take(5).map((ride) => _buildRideHistoryItem(ride)),
      ],
    );
  }

  Widget _buildRideHistoryItem(Ride ride) {
    return InkWell(
      onTap: () {
        // View ride details
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: AppColors.buildGradient(AppColors.primaryGradient),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(
                  Icons.local_taxi_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ride.typeDisplay,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${ride.pickup.shortDisplay} → ${ride.destination.shortDisplay}',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${ride.distanceDisplay ?? '--'} · ${ride.durationDisplay ?? '--'}',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  ride.fareDisplay ?? '--',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: ride.isCompleted
                        ? AppColors.success.withOpacity(0.1)
                        : AppColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    ride.isCompleted ? 'Completed' : 'Cancelled',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: ride.isCompleted ? AppColors.success : AppColors.error,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection() {
    final settings = [
      {'icon': Icons.notifications_outlined, 'label': 'Notifications', 'color': AppColors.primary},
      {'icon': Icons.security_outlined, 'label': 'Security', 'color': AppColors.success},
      {'icon': Icons.help_outline_rounded, 'label': 'Help & Support', 'color': AppColors.warning},
      {'icon': Icons.info_outline_rounded, 'label': 'About', 'color': AppColors.info},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Settings',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        SizedBox(height: 12),
        ...settings.map((setting) => _buildSettingItem(setting)),
      ],
    );
  }

  Widget _buildSettingItem(Map<String, dynamic> setting) {
    return InkWell(
      onTap: () {
        // Navigate to setting
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: (setting['color'] as Color).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                setting['icon'] as IconData,
                color: setting['color'] as Color,
                size: 22,
              ),
            ),
            SizedBox(width: 14),
            Expanded(
              child: Text(
                setting['label'] as String,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textTertiary,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}