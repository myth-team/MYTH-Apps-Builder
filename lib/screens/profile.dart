import 'package:flutter/material.dart';
import 'package:scan_fit_app/utils/colors.dart'; 
import 'package:scan_fit_app/widgets/animated_counter.dart'; 

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  double _calorieGoal = 2000;
  double _weight = 70;
  String _healthTarget = 'Maintain';
  final List<double> _recentCalories = [1950, 2100, 1800, 2200, 2050, 1900, 2000];

  @override
  Widget build(BuildContext context) {
    final avgCalories = _recentCalories.reduce((a, b) => a + b) / _recentCalories.length;
    final trend = _getTrendLabel(avgCalories);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        title: Text(
          'Profile & Settings',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _SectionTitle('Your Targets'),
          SizedBox(height: 12),
          _GoalCard(
            icon: Icons.local_fire_department,
            label: 'Daily Calorie Goal',
            value: '${_calorieGoal.round()} kcal',
            color: AppColors.primary,
            onTap: () => _showCaloriePicker(context),
          ),
          SizedBox(height: 12),
          _GoalCard(
            icon: Icons.monitor_weight,
            label: 'Current Weight',
            value: '${_weight.round()} kg',
            color: AppColors.secondary,
            onTap: () => _showWeightPicker(context),
          ),
          SizedBox(height: 12),
          _GoalCard(
            icon: Icons.track_changes,
            label: 'Health Target',
            value: _healthTarget,
            color: AppColors.accent,
            onTap: () => _showTargetPicker(context),
          ),
          SizedBox(height: 28),
          _SectionTitle('Health Feedback'),
          SizedBox(height: 12),
          _FeedbackCard(trend: trend, avgCalories: avgCalories),
          SizedBox(height: 28),
          _SectionTitle('Recent Trends'),
          SizedBox(height: 12),
          _TrendBars(calories: _recentCalories, goal: _calorieGoal),
        ],
      ),
    );
  }

  String _getTrendLabel(double avg) {
    final diff = avg - _calorieGoal;
    if (diff.abs() < 100) return 'On Track';
    if (diff < 0) return 'Under Budget';
    return 'Over Budget';
  }

  void _showCaloriePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Daily Calorie Goal',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 8),
              AnimatedCounter(
                target: _calorieGoal.round(),
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
                suffix: ' kcal',
              ),
              Slider(
                value: _calorieGoal,
                min: 1200,
                max: 4000,
                divisions: 28,
                activeColor: AppColors.primary,
                onChanged: (v) => setModalState(() => _calorieGoal = v),
              ),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {});
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showWeightPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Current Weight',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 8),
              AnimatedCounter(
                target: _weight.round(),
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondary,
                ),
                suffix: ' kg',
              ),
              Slider(
                value: _weight,
                min: 40,
                max: 150,
                divisions: 110,
                activeColor: AppColors.secondary,
                onChanged: (v) => setModalState(() => _weight = v),
              ),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {});
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTargetPicker(BuildContext context) {
    final targets = ['Lose Weight', 'Maintain', 'Gain Muscle'];
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: targets.map((t) => ListTile(
            title: Text(
              t,
              style: TextStyle(
                color: _healthTarget == t ? AppColors.accent : AppColors.textPrimary,
                fontWeight: _healthTarget == t ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            trailing: _healthTarget == t
                ? Icon(Icons.check_circle, color: AppColors.accent)
                : null,
            onTap: () {
              setState(() => _healthTarget = t);
              Navigator.pop(context);
            },
          )).toList(),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
        letterSpacing: 0.5,
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final VoidCallback onTap;

  _GoalCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeedbackCard extends StatelessWidget {
  final String trend;
  final double avgCalories;

  _FeedbackCard({required this.trend, required this.avgCalories});

  @override
  Widget build(BuildContext context) {
    final isOnTrack = trend == 'On Track';
    final isUnder = trend == 'Under Budget';

    return Card(
      elevation: 0,
      color: isOnTrack
          ? AppColors.success.withOpacity(0.08)
          : isUnder
              ? AppColors.primary.withOpacity(0.08)
              : AppColors.error.withOpacity(0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isOnTrack
                      ? Icons.sentiment_satisfied
                      : isUnder
                          ? Icons.sentiment_neutral
                          : Icons.sentiment_dissatisfied,
                  color: isOnTrack
                      ? AppColors.success
                      : isUnder
                          ? AppColors.primary
                          : AppColors.error,
                  size: 28,
                ),
                SizedBox(width: 12),
                Text(
                  trend,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isOnTrack
                        ? AppColors.success
                        : isUnder
                            ? AppColors.primary
                            : AppColors.error,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              isOnTrack
                  ? 'Great job! You\'re consistently hitting your calorie target. Keep up the balanced approach.'
                  : isUnder
                      ? 'You\'re running a bit under your goal. Make sure you\'re eating enough to fuel your body.'
                      : 'You\'ve been going over your target lately. Try smaller portions or more nutrient-dense foods.',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
                height: 1.5,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '7-day average: ${avgCalories.round()} kcal',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrendBars extends StatelessWidget {
  final List<double> calories;
  final double goal;

  _TrendBars({required this.calories, required this.goal});

  @override
  Widget build(BuildContext context) {
    final maxVal = calories.reduce((a, b) => a > b ? a : b);
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return Card(
      elevation: 0,
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(calories.length, (i) {
            final ratio = (calories[i] / maxVal).clamp(0.1, 1.0);
            final isOver = calories[i] > goal;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 28,
                  height: 100 * ratio,
                  decoration: BoxDecoration(
                    color: isOver ? AppColors.error.withOpacity(0.7) : AppColors.primary.withOpacity(0.7),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(6),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  days[i],
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}