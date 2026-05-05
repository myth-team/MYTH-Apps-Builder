import 'package:flutter/material.dart';
import 'package:scan_fit_app/utils/colors.dart'; 
import 'package:scan_fit_app/widgets/food_log_tile.dart'; 

class DayDetailScreen extends StatelessWidget {
  final Map<String, dynamic> args;

  DayDetailScreen({required this.args});

  @override
  Widget build(BuildContext context) {
    final date = args['date'] ?? 'Unknown';
    final total = args['total'] ?? 0;
    final goal = args['goal'] ?? 2000;
    final diff = total - goal;
    final meals = _generateMeals(total);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(date, style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            _SummaryCard(total: total, goal: goal, diff: diff),
            SizedBox(height: 24),
            _MealTimeChart(meals: meals),
            SizedBox(height: 24),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text('Meals', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              ),
            ),
            SizedBox(height: 12),
            ...meals.map((m) => FoodLogTile(
              name: m['name'],
              calories: m['calories'],
              time: m['time'],
            )),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _generateMeals(int total) {
    final names = ['Breakfast bowl', 'Lunch special', 'Afternoon snack', 'Dinner plate'];
    final times = ['08:00 AM', '12:30 PM', '03:45 PM', '07:15 PM'];
    final ratios = [0.25, 0.35, 0.15, 0.25];
    return List.generate(4, (i) => {
      'name': names[i],
      'calories': (total * ratios[i]).round(),
      'time': times[i],
    });
  }
}

class _SummaryCard extends StatelessWidget {
  final int total;
  final int goal;
  final int diff;

  _SummaryCard({required this.total, required this.goal, required this.diff});

  @override
  Widget build(BuildContext context) {
    final onTrack = diff <= 0;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _SummaryItem(label: 'Total', value: '$total', color: AppColors.textPrimary),
              Container(width: 1, height: 50, color: AppColors.ringBg),
              _SummaryItem(label: 'Goal', value: '$goal', color: AppColors.textSecondary),
              Container(width: 1, height: 50, color: AppColors.ringBg),
              _SummaryItem(
                label: onTrack ? 'Under' : 'Over',
                value: '${diff.abs()}',
                color: onTrack ? AppColors.secondary : AppColors.warning,
              ),
            ],
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: onTrack ? AppColors.secondary.withOpacity(0.1) : AppColors.warning.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              onTrack ? 'Great job staying on track!' : 'A bit over your goal today',
              style: TextStyle(
                color: onTrack ? AppColors.secondary : AppColors.warning,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  _SummaryItem({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color)),
        SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      ],
    );
  }
}

class _MealTimeChart extends StatelessWidget {
  final List<Map<String, dynamic>> meals;

  _MealTimeChart({required this.meals});

  @override
  Widget build(BuildContext context) {
    final maxCal = meals.map((m) => m['calories'] as int).reduce((a, b) => a > b ? a : b);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Meal Distribution', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: meals.map((m) {
              final height = maxCal > 0 ? (m['calories'] / maxCal * 120).clamp(20.0, 120.0) : 20.0;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    children: [
                      Text('${m['calories']}', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                      SizedBox(height: 6),
                      Container(
                        height: height,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.7 + (meals.indexOf(m) % 3) * 0.1),
                          borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        (m['time'] as String).split(' ')[0],
                        style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}