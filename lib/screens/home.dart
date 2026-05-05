import 'package:flutter/material.dart';
import 'package:scan_fit_app/utils/colors.dart'; 
import 'package:scan_fit_app/widgets/calorie_ring.dart'; 
import 'package:scan_fit_app/widgets/food_log_tile.dart'; 
import 'package:scan_fit_app/screens/scan.dart'; 

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  double _dailyGoal = 2000;
  double _consumed = 1450;
  final List<Map<String, dynamic>> _todayLogs = [
    {'name': 'Oatmeal with berries', 'calories': 320, 'time': '08:30 AM'},
    {'name': 'Grilled chicken salad', 'calories': 450, 'time': '12:15 PM'},
    {'name': 'Greek yogurt', 'calories': 180, 'time': '03:00 PM'},
  ];
  final List<Map<String, dynamic>> _history = [
    {'date': 'Yesterday', 'total': 1950, 'goal': 2000},
    {'date': 'Jun 12', 'total': 2200, 'goal': 2000},
    {'date': 'Jun 11', 'total': 1750, 'goal': 2000},
  ];

  void _addLog(String name, int calories) {
    setState(() {
      _todayLogs.insert(0, {
        'name': name,
        'calories': calories,
        'time': '${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}',
      });
      _consumed += calories;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text('ScanFit', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(Icons.settings_outlined, color: AppColors.textPrimary),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _DashboardTab(
            consumed: _consumed,
            goal: _dailyGoal,
            logs: _todayLogs,
            onQuickAdd: _showQuickAdd,
          ),
          ScanTab(onAdd: _addLog),
          _HistoryTab(history: _history),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), activeIcon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.camera_alt_outlined), activeIcon: Icon(Icons.camera_alt), label: 'Scan'),
          BottomNavigationBarItem(icon: Icon(Icons.history_outlined), activeIcon: Icon(Icons.history), label: 'History'),
        ],
      ),
    );
  }

  void _showQuickAdd() {
    final nameCtrl = TextEditingController();
    final calCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Quick Add', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            SizedBox(height: 16),
            TextField(
              controller: nameCtrl,
              decoration: _inputDeco('Food name'),
            ),
            SizedBox(height: 12),
            TextField(
              controller: calCtrl,
              keyboardType: TextInputType.number,
              decoration: _inputDeco('Calories'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final cal = int.tryParse(calCtrl.text) ?? 0;
                if (nameCtrl.text.isNotEmpty && cal > 0) {
                  _addLog(nameCtrl.text, cal);
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: Text('Add to Today'),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDeco(String label) => InputDecoration(
    labelText: label,
    filled: true,
    fillColor: AppColors.surface,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
  );
}

class _DashboardTab extends StatelessWidget {
  final double consumed;
  final double goal;
  final List<Map<String, dynamic>> logs;
  final VoidCallback onQuickAdd;

  _DashboardTab({required this.consumed, required this.goal, required this.logs, required this.onQuickAdd});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 24),
          CalorieRing(consumed: consumed, goal: goal),
          SizedBox(height: 24),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: _StatCard(
                    label: 'Remaining',
                    value: '${(goal - consumed).clamp(0, goal).round()}',
                    color: AppColors.secondary,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    label: 'Burned',
                    value: '420',
                    color: AppColors.accent,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onQuickAdd,
                icon: Icon(Icons.add),
                label: Text('Quick Add Food'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
          ),
          SizedBox(height: 24),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text('Today\'s Log', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            ),
          ),
          SizedBox(height: 12),
          ...logs.map((l) => FoodLogTile(
            name: l['name'],
            calories: l['calories'],
            time: l['time'],
            onDelete: () {},
          )),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  _StatCard({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
          SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

class _HistoryTab extends StatelessWidget {
  final List<Map<String, dynamic>> history;

  _HistoryTab({required this.history});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 16),
      itemCount: history.length,
      itemBuilder: (_, i) {
        final day = history[i];
        final diff = (day['total'] - day['goal']).round();
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: AppColors.surface,
          child: InkWell(
            onTap: () => Navigator.pushNamed(context, '/day_detail', arguments: day),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: diff <= 0 ? AppColors.secondary.withOpacity(0.1) : AppColors.warning.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      diff <= 0 ? Icons.check : Icons.trending_up,
                      color: diff <= 0 ? AppColors.secondary : AppColors.warning,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(day['date'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                        SizedBox(height: 4),
                        Text('${day['total']} / ${day['goal']} kcal', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        diff <= 0 ? '${diff.abs()} under' : '$diff over',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: diff <= 0 ? AppColors.secondary : AppColors.warning,
                        ),
                      ),
                      Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 20),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}