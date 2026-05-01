import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ridenow_app/utils/colors.dart'; 
import 'package:ridenow_app/models/ride.dart'; 
import 'package:ridenow_app/widgets/ride_history_item.dart'; 
import 'package:ridenow_app/services/ride_service.dart'; 

class RideHistoryScreen extends StatefulWidget {
  const RideHistoryScreen({super.key});

  @override
  State<RideHistoryScreen> createState() => _RideHistoryScreenState();
}

class _RideHistoryScreenState extends State<RideHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadHistory();
    });
  }

  Future<void> _loadHistory() async {
    final rideService = context.read<RideService>();
    await rideService.loadRideHistory();
  }

  Future<void> _refreshHistory() async {
    final rideService = context.read<RideService>();
    await rideService.loadRideHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Consumer<RideService>(
        builder: (context, rideService, child) {
          if (rideService.isLoading) {
            return _buildLoading();
          }

          final history = rideService.rideHistory;

          if (history.isEmpty) {
            return _buildEmptyState();
          }

          return _buildHistoryList(history);
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        'Ride History',
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      actions: [
        IconButton(
          icon: Icon(Icons.search, color: AppColors.textSecondary),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Search feature coming soon')),
            );
          },
        ),
        IconButton(
          icon: Icon(Icons.filter_list, color: AppColors.textSecondary),
          onPressed: () {
            _showFilterSheet();
          },
        ),
      ],
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColors.primary),
          SizedBox(height: 16),
          Text(
            'Loading rides...',
            style: TextStyle(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.history,
                size: 50,
                color: AppColors.primaryLight,
              ),
            ),
            SizedBox(height: 24),
            Text(
              'No Rides Yet',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Your completed rides will appear here',
              style: TextStyle(
                fontSize: 15,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
              icon: Icon(Icons.directions_car),
              label: Text('Book Your First Ride'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textOnPrimary,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryList(List<Ride> history) {
    final completedRides = history.where((r) => r.isCompleted).toList();
    final cancelledRides = history.where((r) => r.isCancelled).toList();

    return RefreshIndicator(
      onRefresh: _refreshHistory,
      color: AppColors.primary,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _buildSummaryCards(history),
          ),
          if (completedRides.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: _buildSectionHeader('Completed Rides', completedRides.length),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return RideHistoryItem(
                      ride: completedRides[index],
                      onTap: () => _showRideDetails(completedRides[index]),
                    );
                  },
                  childCount: completedRides.length,
                ),
              ),
            ),
          ],
          if (cancelledRides.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: _buildSectionHeader('Cancelled Rides', cancelledRides.length),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return RideHistoryItem(
                      ride: cancelledRides[index],
                      onTap: () => _showRideDetails(cancelledRides[index]),
                    );
                  },
                  childCount: cancelledRides.length,
                ),
              ),
            ),
          ],
          SliverToBoxAdapter(
            child: SizedBox(height: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(List<Ride> history) {
    final totalSpent = history
        .where((r) => r.isCompleted && r.actualPrice != null)
        .fold<double>(0, (sum, r) => sum + r.actualPrice!);

    final totalRides = history.where((r) => r.isCompleted).length;

    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              icon: Icons.directions_car,
              label: 'Total Rides',
              value: totalRides.toString(),
              color: AppColors.primary,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: _buildSummaryCard(
              icon: Icons.payments,
              label: 'Total Spent',
              value: '\$${totalSpent.toStringAsFixed(0)}',
              color: AppColors.accent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, int count) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(width: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              count.toString(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filter Rides',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 20),
              _buildFilterOption('All Rides', true),
              _buildFilterOption('Completed', false),
              _buildFilterOption('Cancelled', false),
              _buildFilterOption('This Week', false),
              _buildFilterOption('This Month', false),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.textOnPrimary,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('Apply Filters'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterOption(String label, bool isSelected) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      trailing: isSelected
          ? Icon(Icons.check, color: AppColors.primary)
          : null,
      onTap: () {
        Navigator.pop(context);
      },
    );
  }

  void _showRideDetails(Ride ride) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Ride Details',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 20),
                  RideHistoryItem(ride: ride),
                  SizedBox(height: 20),
                  _buildDetailRow('Ride ID', ride.id),
                  _buildDetailRow('Date', ride.createdAt.toString().split(' ')[0]),
                  _buildDetailRow('Status', ride.statusDisplayName),
                  _buildDetailRow('Type', ride.rideTypeDisplayName),
                  _buildDetailRow('Distance', ride.formattedDistance),
                  _buildDetailRow('Duration', ride.formattedDuration),
                  if (ride.driver != null) ...[
                    _buildDetailRow('Driver', ride.driver!.name),
                    _buildDetailRow('Vehicle', ride.driver!.vehicleInfo.model),
                    _buildDetailRow('License', ride.driver!.vehicleInfo.licensePlate),
                  ],
                  if (ride.isCompleted && ride.actualPrice != null) ...[
                    Divider(height: 32),
                    _buildDetailRow('Base Fare', '\$${ride.estimatedPrice.toStringAsFixed(2)}'),
                    _buildDetailRow('Final Fare', '\$${ride.actualPrice!.toStringAsFixed(2)}'),
                  ],
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Receipt feature coming soon')),
                            );
                          },
                          icon: Icon(Icons.receipt_long),
                          label: Text('View Receipt'),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, '/home');
                          },
                          icon: Icon(Icons.replay),
                          label: Text('Book Again'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.textOnPrimary,
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}