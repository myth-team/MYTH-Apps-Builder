import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:new_project_app/utils/colors.dart'; 
import 'package:new_project_app/providers/ride_provider.dart';
import 'package:new_project_app/providers/auth_provider.dart';

class DriverEarningsScreen extends StatefulWidget {
  const DriverEarningsScreen({Key? key}) : super(key: key);

  @override
  State<DriverEarningsScreen> createState() => _DriverEarningsScreenState();
}

class _DriverEarningsScreenState extends State<DriverEarningsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  _DateFilter _selectedFilter = _DateFilter.week;
  int _touchedBarIndex = -1;
  bool _isWeeklyView = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fadeController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<RideProvider, AuthProvider>(
      builder: (context, rideProvider, authProvider, _) {
        final dailyData = rideProvider.getDailyEarnings();
        final weeklyData = rideProvider.getWeeklyEarnings();
        final todayEarnings = rideProvider.todayEarningsTotal;
        final weeklyEarnings = rideProvider.weeklyEarningsTotal;

        final totalTrips = dailyData.fold<int>(
          0,
          (sum, d) => sum + (d['trips'] as int),
        );
        final avgFare = totalTrips > 0
            ? dailyData.fold<double>(
                    0, (sum, d) => sum + (d['earnings'] as double)) /
                totalTrips
            : 0.0;

        return Scaffold(
          backgroundColor: AppColors.darkBackground,
          body: FadeTransition(
            opacity: _fadeAnimation,
            child: CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: [
                _buildSliverAppBar(
                    authProvider, todayEarnings, weeklyEarnings),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 24),
                        _SummaryCardsRow(
                          todayEarnings: todayEarnings,
                          weeklyEarnings: weeklyEarnings,
                          totalTrips: totalTrips,
                          avgFare: avgFare,
                        ),
                        SizedBox(height: 28),
                        _ChartSection(
                          isWeeklyView: _isWeeklyView,
                          onToggle: (val) {
                            setState(() {
                              _isWeeklyView = val;
                              _touchedBarIndex = -1;
                            });
                          },
                          touchedBarIndex: _touchedBarIndex,
                          onBarTouched: (idx) {
                            setState(() => _touchedBarIndex = idx);
                          },
                          dailyData: dailyData,
                          weeklyData: weeklyData,
                        ),
                        SizedBox(height: 28),
                        _TripHistorySection(
                          selectedFilter: _selectedFilter,
                          onFilterChanged: (f) {
                            setState(() => _selectedFilter = f);
                          },
                          tripHistory: rideProvider.tripHistory,
                          dailyData: dailyData,
                        ),
                        SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSliverAppBar(
    AuthProvider authProvider,
    double todayEarnings,
    double weeklyEarnings,
  ) {
    return SliverAppBar(
      expandedHeight: 220,
      pinned: true,
      backgroundColor: AppColors.darkSurface,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.white),
        onPressed: () => Navigator.of(context).maybePop(),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.file_download_outlined, color: AppColors.white),
          onPressed: _showExportSheet,
        ),
        SizedBox(width: 8),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: AppColors.earningsGradient,
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 56, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.white.withOpacity(0.2),
                          border: Border.all(
                            color: AppColors.white.withOpacity(0.4),
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons.account_circle_rounded,
                          color: AppColors.white,
                          size: 28,
                        ),
                      ),
                      SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Earnings Dashboard',
                            style: TextStyle(
                              color: AppColors.white.withOpacity(0.85),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            authProvider.currentUser?.name ?? 'Driver',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'This Week',
                            style: TextStyle(
                              color: AppColors.white.withOpacity(0.75),
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '\$${weeklyEarnings.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.white.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.white.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.trending_up_rounded,
                              color: AppColors.white,
                              size: 16,
                            ),
                            SizedBox(width: 6),
                            Text(
                              '+12.5%',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        title: Text(
          'Earnings',
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: false,
      ),
    );
  }

  void _showExportSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _ExportSheet(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Summary Cards Row
// ─────────────────────────────────────────────────────────────────────────────

class _SummaryCardsRow extends StatelessWidget {
  final double todayEarnings;
  final double weeklyEarnings;
  final int totalTrips;
  final double avgFare;

  const _SummaryCardsRow({
    required this.todayEarnings,
    required this.weeklyEarnings,
    required this.totalTrips,
    required this.avgFare,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _SummaryCard(
                label: "Today's Earnings",
                value: '\$${todayEarnings.toStringAsFixed(2)}',
                icon: Icons.wb_sunny_rounded,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary,
                    AppColors.primaryDark,
                  ],
                ),
                trend: '+8.3%',
                trendUp: true,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _SummaryCard(
                label: 'Total Trips',
                value: '$totalTrips',
                icon: Icons.directions_car_rounded,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.tertiary,
                    AppColors.tertiaryDark,
                  ],
                ),
                trend: '+5 trips',
                trendUp: true,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _SummaryCard(
                label: 'Avg. Fare',
                value: '\$${avgFare.toStringAsFixed(2)}',
                icon: Icons.receipt_long_rounded,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.secondary,
                    AppColors.secondaryDark,
                  ],
                ),
                trend: '+\$1.20',
                trendUp: true,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _SummaryCard(
                label: 'Online Hours',
                value: '6.5 hrs',
                icon: Icons.access_time_rounded,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.warning,
                    AppColors.warningDark,
                  ],
                ),
                trend: '-0.5 hrs',
                trendUp: false,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final LinearGradient gradient;
  final String trend;
  final bool trendUp;

  const _SummaryCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.gradient,
    required this.trend,
    required this.trendUp,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.darkBorder,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowDark,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: AppColors.white, size: 18),
              ),
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: trendUp
                      ? AppColors.successSurface
                      : AppColors.errorSurface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      trendUp
                          ? Icons.arrow_upward_rounded
                          : Icons.arrow_downward_rounded,
                      color: trendUp
                          ? AppColors.success
                          : AppColors.error,
                      size: 10,
                    ),
                    SizedBox(width: 2),
                    Text(
                      trend,
                      style: TextStyle(
                        color: trendUp
                            ? AppColors.success
                            : AppColors.error,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              color: AppColors.darkTextPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
            ),
          ),
          SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              color: AppColors.darkTextSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Chart Section
// ─────────────────────────────────────────────────────────────────────────────

class _ChartSection extends StatelessWidget {
  final bool isWeeklyView;
  final ValueChanged<bool> onToggle;
  final int touchedBarIndex;
  final ValueChanged<int> onBarTouched;
  final List<Map<String, dynamic>> dailyData;
  final List<Map<String, dynamic>> weeklyData;

  const _ChartSection({
    required this.isWeeklyView,
    required this.onToggle,
    required this.touchedBarIndex,
    required this.onBarTouched,
    required this.dailyData,
    required this.weeklyData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.darkBorder,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowDark,
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isWeeklyView ? 'Weekly Revenue' : 'Daily Revenue',
                      style: TextStyle(
                        color: AppColors.darkTextPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      isWeeklyView ? 'Last 4 weeks' : 'Last 7 days',
                      style: TextStyle(
                        color: AppColors.darkTextSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                _ToggleSwitch(
                  isWeekly: isWeeklyView,
                  onToggle: onToggle,
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
          Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 20, 20),
            child: SizedBox(
              height: 200,
              child: isWeeklyView
                  ? _WeeklyBarChart(
                      data: weeklyData,
                      touchedIndex: touchedBarIndex,
                      onBarTouched: onBarTouched,
                    )
                  : _DailyBarChart(
                      data: dailyData,
                      touchedIndex: touchedBarIndex,
                      onBarTouched: onBarTouched,
                    ),
            ),
          ),
          if (touchedBarIndex >= 0)
            _ChartTooltipBanner(
              isWeekly: isWeeklyView,
              index: touchedBarIndex,
              dailyData: dailyData,
              weeklyData: weeklyData,
            ),
          SizedBox(height: 4),
        ],
      ),
    );
  }
}

class _ToggleSwitch extends StatelessWidget {
  final bool isWeekly;
  final ValueChanged<bool> onToggle;

  const _ToggleSwitch({
    required this.isWeekly,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkSurfaceElevated,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ToggleButton(
            label: 'Daily',
            active: !isWeekly,
            onTap: () => onToggle(false),
          ),
          _ToggleButton(
            label: 'Weekly',
            active: isWeekly,
            onTap: () => onToggle(true),
          ),
        ],
      ),
    );
  }
}

class _ToggleButton extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _ToggleButton({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? AppColors.white : AppColors.darkTextSecondary,
            fontSize: 12,
            fontWeight: active ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _DailyBarChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final int touchedIndex;
  final ValueChanged<int> onBarTouched;

  const _DailyBarChart({
    required this.data,
    required this.touchedIndex,
    required this.onBarTouched,
  });

  @override
  Widget build(BuildContext context) {
    final maxY = data.fold<double>(
          0,
          (m, d) => (d['earnings'] as double) > m ? (d['earnings'] as double) : m,
        ) *
        1.25;

    final dayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final now = DateTime.now();

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxY,
        minY: 0,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.transparent,
            tooltipPadding: EdgeInsets.zero,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return null;
            },
          ),
          touchCallback: (FlTouchEvent event, BarTouchResponse? response) {
            if (response != null &&
                response.spot != null &&
                event is! FlPointerExitEvent) {
              onBarTouched(response.spot!.touchedBarGroupIndex);
            } else {
              onBarTouched(-1);
            }
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                final idx = value.toInt();
                if (idx < 0 || idx >= data.length) return SizedBox();
                final date = data[idx]['date'] as DateTime;
                final dayIdx = date.weekday - 1;
                return Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    dayLabels[dayIdx % dayLabels.length],
                    style: TextStyle(
                      color: touchedIndex == idx
                          ? AppColors.primaryLight
                          : AppColors.chartLabel,
                      fontSize: 10,
                      fontWeight: touchedIndex == idx
                          ? FontWeight.w700
                          : FontWeight.w400,
                    ),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                if (value == 0) return SizedBox();
                return Text(
                  '\$${value.toStringAsFixed(0)}',
                  style: TextStyle(
                    color: AppColors.chartLabel,
                    fontSize: 9,
                  ),
                );
              },
            ),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: maxY / 4,
          getDrawingHorizontalLine: (val) {
            return FlLine(
              color: AppColors.darkBorder,
              strokeWidth: 1,
              dashArray: [4, 4],
            );
          },
        ),
        borderData: FlBorderData(show: false),
        barGroups: data.asMap().entries.map((entry) {
          final idx = entry.key;
          final earnings = entry.value['earnings'] as double;
          final isTouched = idx == touchedIndex;

          return BarChartGroupData(
            x: idx,
            barRods: [
              BarChartRodData(
                toY: earnings,
                gradient: isTouched
                    ? LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          AppColors.secondary,
                          AppColors.secondaryLight,
                        ],
                      )
                    : LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          AppColors.primary,
                          AppColors.primaryLight,
                        ],
                      ),
                width: 20,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(6),
                ),
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY: maxY,
                  color: AppColors.darkSurfaceElevated,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _WeeklyBarChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final int touchedIndex;
  final ValueChanged<int> onBarTouched;

  const _WeeklyBarChart({
    required this.data,
    required this.touchedIndex,
    required this.onBarTouched,
  });

  @override
  Widget build(BuildContext context) {
    final maxY = data.fold<double>(
          0,
          (m, d) => (d['earnings'] as double) > m ? (d['earnings'] as double) : m,
        ) *
        1.25;

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxY,
        minY: 0,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.transparent,
            tooltipPadding: EdgeInsets.zero,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return null;
            },
          ),
          touchCallback: (FlTouchEvent event, BarTouchResponse? response) {
            if (response != null &&
                response.spot != null &&
                event is! FlPointerExitEvent) {
              onBarTouched(response.spot!.touchedBarGroupIndex);
            } else {
              onBarTouched(-1);
            }
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                final idx = value.toInt();
                if (idx < 0 || idx >= data.length) return SizedBox();
                return Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    'W${idx + 1}',
                    style: TextStyle(
                      color: touchedIndex == idx
                          ? AppColors.primaryLight
                          : AppColors.chartLabel,
                      fontSize: 11,
                      fontWeight: touchedIndex == idx
                          ? FontWeight.w700
                          : FontWeight.w400,
                    ),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 48,
              getTitlesWidget: (value, meta) {
                if (value == 0) return SizedBox();
                return Text(
                  '\$${value.toStringAsFixed(0)}',
                  style: TextStyle(
                    color: AppColors.chartLabel,
                    fontSize: 9,
                  ),
                );
              },
            ),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: maxY / 4,
          getDrawingHorizontalLine: (val) {
            return FlLine(
              color: AppColors.darkBorder,
              strokeWidth: 1,
              dashArray: [4, 4],
            );
          },
        ),
        borderData: FlBorderData(show: false),
        barGroups: data.asMap().entries.map((entry) {
          final idx = entry.key;
          final earnings = entry.value['earnings'] as double;
          final trips = entry.value['trips'] as int;
          final isTouched = idx == touchedIndex;

          return BarChartGroupData(
            x: idx,
            barRods: [
              BarChartRodData(
                toY: earnings,
                gradient: isTouched
                    ? LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          AppColors.tertiary,
                          AppColors.tertiaryLight,
                        ],
                      )
                    : LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          AppColors.primary,
                          AppColors.primaryLight,
                        ],
                      ),
                width: 40,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(8),
                ),
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY: maxY,
                  color: AppColors.darkSurfaceElevated,
                ),
                rodStackItems: [],
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _ChartTooltipBanner extends StatelessWidget {
  final bool isWeekly;
  final int index;
  final List<Map<String, dynamic>> dailyData;
  final List<Map<String, dynamic>> weeklyData;

  const _ChartTooltipBanner({
    required this.isWeekly,
    required this.index,
    required this.dailyData,
    required this.weeklyData,
  });

  @override
  Widget build(BuildContext context) {
    final data = isWeekly ? weeklyData : dailyData;
    if (index < 0 || index >= data.length) return SizedBox();

    final item = data[index];
    final earnings = item['earnings'] as double;
    final trips = item['trips'] as int;

    String label;
    if (isWeekly) {
      label = 'Week ${index + 1}';
    } else {
      final date = item['date'] as DateTime;
      label = '${_dayName(date.weekday)}, ${date.day}/${date.month}';
    }

    return Container(
      margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppColors.white.withOpacity(0.9),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            children: [
              Icon(Icons.attach_money, color: AppColors.white, size: 14),
              Text(
                earnings.toStringAsFixed(2),
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(width: 16),
              Icon(Icons.directions_car_rounded,
                  color: AppColors.white.withOpacity(0.8), size: 14),
              SizedBox(width: 4),
              Text(
                '$trips trips',
                style: TextStyle(
                  color: AppColors.white.withOpacity(0.9),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _dayName(int weekday) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return days[(weekday - 1) % 7];
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Trip History Section
// ─────────────────────────────────────────────────────────────────────────────

enum _DateFilter { today, week, month, all }

class _TripHistorySection extends StatelessWidget {
  final _DateFilter selectedFilter;
  final ValueChanged<_DateFilter> onFilterChanged;
  final List<TripRecord> tripHistory;
  final List<Map<String, dynamic>> dailyData;

  const _TripHistorySection({
    required this.selectedFilter,
    required this.onFilterChanged,
    required this.tripHistory,
    required this.dailyData,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Trip History',
              style: TextStyle(
                color: AppColors.darkTextPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'See All',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        _FilterChips(
          selected: selectedFilter,
          onChanged: onFilterChanged,
        ),
        SizedBox(height: 16),
        if (tripHistory.isEmpty)
          _buildMockHistory()
        else
          _buildRealHistory(tripHistory),
      ],
    );
  }

  Widget _buildMockHistory() {
    final mockTrips = _MockTripData.generate();
    return Column(
      children: mockTrips
          .map((trip) => _TripHistoryCard(trip: trip))
          .toList(),
    );
  }

  Widget _buildRealHistory(List<TripRecord> trips) {
    return Column(
      children: trips
          .take(10)
          .map((trip) => _TripHistoryCardFromRecord(record: trip))
          .toList(),
    );
  }
}

class _FilterChips extends StatelessWidget {
  final _DateFilter selected;
  final ValueChanged<_DateFilter> onChanged;

  const _FilterChips({
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final filters = [
      _FilterOption(filter: _DateFilter.today, label: 'Today'),
      _FilterOption(filter: _DateFilter.week, label: 'This Week'),
      _FilterOption(filter: _DateFilter.month, label: 'Month'),
      _FilterOption(filter: _DateFilter.all, label: 'All Time'),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: BouncingScrollPhysics(),
      child: Row(
        children: filters
            .map((f) => Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: _FilterChip(
                    label: f.label,
                    selected: selected == f.filter,
                    onTap: () => onChanged(f.filter),
                  ),
                ))
            .toList(),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: selected ? AppColors.primaryGradient : null,
          color: selected ? null : AppColors.darkSurface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? Colors.transparent : AppColors.darkBorder,
            width: 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.shadowPrimary,
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected
                ? AppColors.white
                : AppColors.darkTextSecondary,
            fontSize: 13,
            fontWeight:
                selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _TripHistoryCard extends StatelessWidget {
  final _MockTrip trip;

  const _TripHistoryCard({required this.trip});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.darkBorder,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowDark,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primarySurface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.directions_car_rounded,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        trip.riderName,
                        style: TextStyle(
                          color: AppColors.darkTextPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        trip.dateTime,
                        style: TextStyle(
                          color: AppColors.darkTextSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${trip.fare.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: AppColors.tertiary,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 3),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: trip.isCompleted
                          ? AppColors.successSurface
                          : AppColors.errorSurface,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      trip.isCompleted ? 'Completed' : 'Cancelled',
                      style: TextStyle(
                        color: trip.isCompleted
                            ? AppColors.success
                            : AppColors.error,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.darkSurfaceElevated,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.mapPickup,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        trip.pickup,
                        style: TextStyle(
                          color: AppColors.darkTextSecondary,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 3, top: 3, bottom: 3),
                  child: Row(
                    children: [
                      Container(
                        width: 2,
                        height: 14,
                        color: AppColors.darkBorder,
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.mapDropoff,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        trip.dropoff,
                        style: TextStyle(
                          color: AppColors.darkTextSecondary,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              _TripMetricBadge(
                icon: Icons.route_rounded,
                label: trip.distance,
                color: AppColors.info,
              ),
              SizedBox(width: 8),
              _TripMetricBadge(
                icon: Icons.timer_outlined,
                label: trip.duration,
                color: AppColors.warning,
              ),
              SizedBox(width: 8),
              _TripMetricBadge(
                icon: Icons.star_rounded,
                label: trip.rating,
                color: AppColors.starActive,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TripHistoryCardFromRecord extends StatelessWidget {
  final TripRecord record;

  const _TripHistoryCardFromRecord({required this.record});

  @override
  Widget build(BuildContext context) {
    final isCompleted = record.finalState.toString().contains('completed');
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.darkBorder,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.pickupAddress,
                  style: TextStyle(
                    color: AppColors.darkTextPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  record.dropoffAddress,
                  style: TextStyle(
                    color: AppColors.darkTextSecondary,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 6),
                Text(
                  '${record.dateTime.day}/${record.dateTime.month}/${record.dateTime.year}',
                  style: TextStyle(
                    color: AppColors.chartLabel,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${record.fare.toStringAsFixed(2)}',
                style: TextStyle(
                  color: AppColors.tertiary,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 6),
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isCompleted
                      ? AppColors.successSurface
                      : AppColors.errorSurface,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  isCompleted ? 'Completed' : 'Cancelled',
                  style: TextStyle(
                    color: isCompleted
                        ? AppColors.success
                        : AppColors.error,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TripMetricBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _TripMetricBadge({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 12),
          SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Export Sheet
// ─────────────────────────────────────────────────────────────────────────────

class _ExportSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.darkBorder,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Export Earnings',
                style: TextStyle(
                  color: AppColors.darkTextPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.darkSurfaceElevated,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close_rounded,
                    color: AppColors.darkTextSecondary,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'Download your earnings report',
            style: TextStyle(
              color: AppColors.darkTextSecondary,
              fontSize: 13,
            ),
          ),
          SizedBox(height: 24),
          _ExportOption(
            icon: Icons.picture_as_pdf_rounded,
            label: 'Export as PDF',
            subtitle: 'Detailed report with charts',
            color: AppColors.error,
          ),
          SizedBox(height: 12),
          _ExportOption(
            icon: Icons.table_chart_rounded,
            label: 'Export as CSV',
            subtitle: 'Spreadsheet compatible format',
            color: AppColors.success,
          ),
          SizedBox(height: 12),
          _ExportOption(
            icon: Icons.share_rounded,
            label: 'Share Report',
            subtitle: 'Share via any app',
            color: AppColors.info,
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _ExportOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;

  const _ExportOption({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$label coming soon!'),
            backgroundColor: AppColors.darkSurfaceElevated,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.darkSurfaceElevated,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: color.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: AppColors.darkTextPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: AppColors.darkTextSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
            Spacer(),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.darkTextSecondary,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Data Models
// ─────────────────────────────────────────────────────────────────────────────

class _FilterOption {
  final _DateFilter filter;
  final String label;

  const _FilterOption({
    required this.filter,
    required this.label,
  });
}

class _MockTrip {
  final String riderName;
  final String dateTime;
  final double fare;
  final String pickup;
  final String dropoff;
  final String distance;
  final String duration;
  final String rating;
  final bool isCompleted;

  const _MockTrip({
    required this.riderName,
    required this.dateTime,
    required this.fare,
    required this.pickup,
    required this.dropoff,
    required this.distance,
    required this.duration,
    required this.rating,
    required this.isCompleted,
  });
}

class _MockTripData {
  static List<_MockTrip> generate() {
    return [
      _MockTrip(
        riderName: 'Sarah Mitchell',
        dateTime: 'Today, 09:42 AM',
        fare: 18.50,
        pickup: '123 Market St, San Francisco',
        dropoff: 'SF International Airport',
        distance: '14.2 km',
        duration: '28 min',
        rating: '4.8 ★',
        isCompleted: true,
      ),
      _MockTrip(
        riderName: 'James Rodriguez',
        dateTime: 'Today, 07:15 AM',
        fare: 12.20,
        pickup: 'Union Square, San Francisco',
        dropoff: 'UCSF Medical Center',
        distance: '5.8 km',
        duration: '16 min',
        rating: '5.0 ★',
        isCompleted: true,
      ),
      _MockTrip(
        riderName: 'Priya Sharma',
        dateTime: 'Yesterday, 11:30 PM',
        fare: 22.80,
        pickup: 'Nob Hill, San Francisco',
        dropoff: 'San Jose Downtown',
        distance: '72.3 km',
        duration: '55 min',
        rating: '4.6 ★',
        isCompleted: true,
      ),
      _MockTrip(
        riderName: 'Alex Thompson',
        dateTime: 'Yesterday, 03:45 PM',
        fare: 0.00,
        pickup: 'Fisherman\'s Wharf',
        dropoff: 'Caltrain Station',
        distance: '3.1 km',
        duration: '—',
        rating: '—',
        isCompleted: false,
      ),
      _MockTrip(
        riderName: 'Emma Wilson',
        dateTime: 'Dec 10, 08:20 AM',
        fare: 9.75,
        pickup: 'Mission District',
        dropoff: 'Financial District',
        distance: '4.5 km',
        duration: '14 min',
        rating: '4.9 ★',
        isCompleted: true,
      ),
    ];
  }
}