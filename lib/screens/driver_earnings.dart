import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:ridesync_app/utils/colors.dart'; 
import 'package:intl/intl.dart';

class DriverEarnings extends StatefulWidget {
  const DriverEarnings({super.key});

  @override
  State<DriverEarnings> createState() => _DriverEarningsState();
}

class _DriverEarningsState extends State<DriverEarnings> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isWeeklyView = false;
  
  final List<EarningDay> _dailyEarnings = [
    EarningDay(day: 'Mon', amount: 85.50, trips: 8),
    EarningDay(day: 'Tue', amount: 120.75, trips: 12),
    EarningDay(day: 'Wed', amount: 95.25, trips: 9),
    EarningDay(day: 'Thu', amount: 145.00, trips: 14),
    EarningDay(day: 'Fri', amount: 180.50, trips: 18),
    EarningDay(day: 'Sat', amount: 210.75, trips: 21),
    EarningDay(day: 'Sun', amount: 165.00, trips: 16),
  ];

  final List<EarningDay> _weeklyEarnings = [
    EarningDay(day: 'Week 1', amount: 850.50, trips: 82),
    EarningDay(day: 'Week 2', amount: 920.25, trips: 88),
    EarningDay(day: 'Week 3', amount: 780.00, trips: 75),
    EarningDay(day: 'Week 4', amount: 1050.75, trips: 98),
  ];

  final List<RecentTrip> _recentTrips = [
    RecentTrip(
      id: '1',
      date: DateTime.now().subtract(const Duration(hours: 2)),
      pickupLocation: '123 Main Street',
      dropoffLocation: '456 Market Street',
      fare: 18.50,
      distance: 3.2,
      duration: const Duration(minutes: 12),
    ),
    RecentTrip(
      id: '2',
      date: DateTime.now().subtract(const Duration(hours: 5)),
      pickupLocation: '789 Oak Avenue',
      dropoffLocation: '101 Pine Street',
      fare: 25.00,
      distance: 5.1,
      duration: const Duration(minutes: 18),
    ),
    RecentTrip(
      id: '3',
      date: DateTime.now().subtract(const Duration(hours: 8)),
      pickupLocation: '202 Broadway',
      dropoffLocation: '303 Mission Street',
      fare: 12.75,
      distance: 2.3,
      duration: const Duration(minutes: 9),
    ),
    RecentTrip(
      id: '4',
      date: DateTime.now().subtract(const Duration(days: 1)),
      pickupLocation: '404 Howard Street',
      dropoffLocation: '505 Folsom Street',
      fare: 15.00,
      distance: 2.8,
      duration: const Duration(minutes: 11),
    ),
    RecentTrip(
      id: '5',
      date: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
      pickupLocation: '606 Valencia Street',
      dropoffLocation: '707 Castro Street',
      fare: 22.50,
      distance: 4.5,
      duration: const Duration(minutes: 16),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _isWeeklyView = _tabController.index == 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentEarnings = _isWeeklyView ? _weeklyEarnings : _dailyEarnings;
    final totalEarnings = currentEarnings.fold<double>(0, (sum, day) => sum + day.amount);
    final totalTrips = currentEarnings.fold<int>(0, (sum, day) => sum + day.trips);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Earnings',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today, color: AppColors.textPrimary),
            onPressed: () => _showDatePicker(),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Daily'),
            Tab(text: 'Weekly'),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildEarningsSummary(totalEarnings, totalTrips),
            _buildChart(currentEarnings),
            _buildRecentTrips(),
          ],
        ),
      ),
    );
  }

  Widget _buildEarningsSummary(double totalEarnings, int totalTrips) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(77),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isWeeklyView ? 'This Week' : 'Today',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textOnPrimary.withAlpha(204),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${totalEarnings.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textOnPrimary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.textOnPrimary.withAlpha(51),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.account_balance_wallet,
                  color: AppColors.textOnPrimary,
                  size: 28,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.textOnPrimary.withAlpha(26),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.directions_car, color: AppColors.textOnPrimary, size: 20),
                      const SizedBox(height: 4),
                      Text(
                        '$totalTrips',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textOnPrimary,
                        ),
                      ),
                      Text(
                        'Trips',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textOnPrimary.withAlpha(179),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.textOnPrimary.withAlpha(26),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.schedule, color: AppColors.textOnPrimary, size: 20),
                      const SizedBox(height: 4),
                      Text(
                        _isWeeklyView ? '7.2h' : '4.5h',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textOnPrimary,
                        ),
                      ),
                      Text(
                        'Online Hours',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textOnPrimary.withAlpha(179),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.textOnPrimary.withAlpha(26),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.trending_up, color: AppColors.textOnPrimary, size: 20),
                      const SizedBox(height: 4),
                      Text(
                        '\$${(totalEarnings / (totalTrips > 0 ? totalTrips : 1)).toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textOnPrimary,
                        ),
                      ),
                      Text(
                        'Avg/Trip',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textOnPrimary.withAlpha(179),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChart(List<EarningDay> earnings) {
    final maxAmount = earnings.map((e) => e.amount).reduce((a, b) => a > b ? a : b);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey300.withAlpha(51),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Earnings Trend',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                _isWeeklyView ? 'Weekly' : 'Daily',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxAmount * 1.2,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (group) => AppColors.grey800,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '\$${earnings[groupIndex].amount.toStringAsFixed(2)}',
                        TextStyle(
                          color: AppColors.textOnPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < earnings.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              earnings[index].day,
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 11,
                              ),
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                      reservedSize: 30,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '\$${value.toInt()}',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 10,
                          ),
                        );
                      },
                      reservedSize: 40,
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: maxAmount / 4,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: AppColors.grey200,
                      strokeWidth: 1,
                    );
                  },
                ),
                barGroups: List.generate(earnings.length, (index) {
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: earnings[index].amount,
                        color: AppColors.primary,
                        width: _isWeeklyView ? 24 : 16,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(6),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTrips() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Trips',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'See All',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ..._recentTrips.map((trip) => _buildTripItem(trip)),
        ],
      ),
    );
  }

  Widget _buildTripItem(RecentTrip trip) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey300.withAlpha(51),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withAlpha(51),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.directions_car,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${trip.pickupLocation} → ${trip.dropoffLocation}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 12, color: AppColors.textSecondary),
                    const SizedBox(width: 2),
                    Text(
                      _formatTripTime(trip.date),
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.straighten, size: 12, color: AppColors.textSecondary),
                    const SizedBox(width: 2),
                    Text(
                      '${trip.distance.toStringAsFixed(1)} km',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${trip.fare.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              Text(
                '${trip.duration.inMinutes} min',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTripTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return DateFormat('MMM d, h:mm a').format(date);
    }
  }

  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.textOnPrimary,
              surface: AppColors.cardBackground,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

class EarningDay {
  final String day;
  final double amount;
  final int trips;

  EarningDay({required this.day, required this.amount, required this.trips});
}

class RecentTrip {
  final String id;
  final DateTime date;
  final String pickupLocation;
  final String dropoffLocation;
  final double fare;
  final double distance;
  final Duration duration;

  RecentTrip({
    required this.id,
    required this.date,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.fare,
    required this.distance,
    required this.duration,
  });
}