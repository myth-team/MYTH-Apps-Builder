import 'package:flutter/material.dart';
import 'package:scan_fit_app/utils/colors.dart'; 
import 'package:scan_fit_app/widgets/calorie_ring.dart'; 
import 'package:scan_fit_app/widgets/food_log_tile.dart'; 
import 'package:scan_fit_app/widgets/animated_counter.dart'; 
import 'package:scan_fit_app/widgets/macros_card.dart'; 
import 'package:scan_fit_app/widgets/streak_card.dart'; 
import 'package:scan_fit_app/widgets/modern_app_bar.dart'; 
import 'package:scan_fit_app/widgets/modern_drawer.dart'; 
import 'package:scan_fit_app/screens/scan.dart'; 
import 'package:scan_fit_app/screens/history.dart'; 

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  double _dailyGoal = 2000;
  double _consumed = 1450;
  double _protein = 85;
  double _carbs = 140;
  double _fat = 55;
  int _streak = 5;

  final List<Map<String, dynamic>> _todayLogs = [
    {'name': 'Oatmeal with berries', 'calories': 320, 'time': '08:30 AM', 'protein': 12, 'carbs': 54, 'fat': 6},
    {'name': 'Grilled chicken salad', 'calories': 450, 'time': '12:15 PM', 'protein': 42, 'carbs': 18, 'fat': 22},
    {'name': 'Greek yogurt', 'calories': 180, 'time': '03:00 PM', 'protein': 18, 'carbs': 8, 'fat': 10},
  ];

  final List<Map<String, dynamic>> _history = [
    {'date': 'Yesterday', 'total': 1950, 'goal': 2000},
    {'date': 'Jun 12', 'total': 2200, 'goal': 2000},
    {'date': 'Jun 11', 'total': 1750, 'goal': 2000},
  ];

  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _addLog(String name, int calories) {
    setState(() {
      _todayLogs.insert(0, {
        'name': name,
        'calories': calories,
        'time': '${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}',
        'protein': 20,
        'carbs': 30,
        'fat': 12,
      });
      _consumed += calories;
      _protein += 20;
      _carbs += 30;
      _fat += 12;
    });
  }

  void _deleteLog(int index) {
    setState(() {
      final log = _todayLogs.removeAt(index);
      _consumed -= log['calories'] as int;
      _protein -= (log['protein'] ?? 0) as num;
      _carbs -= (log['carbs'] ?? 0) as num;
      _fat -= (log['fat'] ?? 0) as num;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawer: ModernDrawer(
        onProfileTap: () {
          Navigator.pop(context);
          setState(() => _currentIndex = 3);
        },
        onHistoryTap: () {
          Navigator.pop(context);
          setState(() => _currentIndex = 2);
        },
      ),
      body: AnimatedBuilder(
        animation: _animController,
        builder: (context, child) {
          return IndexedStack(
            index: _currentIndex,
            children: [
              _DashboardTab(
                consumed: _consumed,
                goal: _dailyGoal,
                logs: _todayLogs,
                protein: _protein,
                carbs: _carbs,
                fat: _fat,
                streak: _streak,
                onQuickAdd: _showQuickAdd,
                onDelete: _deleteLog,
                animController: _animController,
              ),
              ScanTab(onAdd: _addLog),
              HistoryScreen(history: _history),
            ],
          );
        },
      ),
      bottomNavigationBar: _ModernBottomNav(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }

  void _showQuickAdd() {
    final nameCtrl = TextEditingController();
    final calCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: AppColors.textPrimary.withOpacity(0.1),
              blurRadius: 32,
              offset: Offset(0, 16),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: AppColors.ringBg,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              'Quick Add',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 20),
            _ModernTextField(controller: nameCtrl, label: 'Food name', icon: Icons.restaurant_outlined),
            SizedBox(height: 12),
            _ModernTextField(
              controller: calCtrl,
              label: 'Calories',
              icon: Icons.local_fire_department_outlined,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 24),
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
                padding: EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              child: Text(
                'Add to Today',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardTab extends StatelessWidget {
  final double consumed;
  final double goal;
  final List<Map<String, dynamic>> logs;
  final double protein;
  final double carbs;
  final double fat;
  final int streak;
  final VoidCallback onQuickAdd;
  final Function(int) onDelete;
  final AnimationController animController;

  _DashboardTab({
    required this.consumed,
    required this.goal,
    required this.logs,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.streak,
    required this.onQuickAdd,
    required this.onDelete,
    required this.animController,
  });

  @override
  Widget build(BuildContext context) {
    final slideAnim = Tween<Offset>(begin: Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: animController, curve: Interval(0.0, 0.6, curve: Curves.easeOutCubic)),
    );
    final fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: animController, curve: Interval(0.0, 0.5, curve: Curves.easeOut)),
    );

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: ModernAppBar(
            title: 'Today',
            onMenuTap: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        SliverToBoxAdapter(
          child: FadeTransition(
            opacity: fadeAnim,
            child: SlideTransition(
              position: slideAnim,
              child: Column(
                children: [
                  SizedBox(height: 16),
                  CalorieRing(consumed: consumed, goal: goal),
                  SizedBox(height: 24),
                  StreakCard(streakDays: streak, bestStreak: 12),
                  SizedBox(height: 20),
                  _QuickStatsRow(consumed: consumed, goal: goal),
                  SizedBox(height: 20),
                  MacrosCard(protein: protein, carbs: carbs, fat: fat),
                  SizedBox(height: 24),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: onQuickAdd,
                        icon: Icon(Icons.add_rounded, size: 20),
                        label: Text(
                          'Quick Add Food',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  _SectionHeader(title: 'Today\'s Log', count: logs.length),
                  SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.only(bottom: 24),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) => FoodLogTile(
                name: logs[i]['name'],
                calories: logs[i]['calories'],
                time: logs[i]['time'],
                onDelete: () => onDelete(i),
              ),
              childCount: logs.length,
            ),
          ),
        ),
      ],
    );
  }
}

class _QuickStatsRow extends StatelessWidget {
  final double consumed;
  final double goal;

  _QuickStatsRow({required this.consumed, required this.goal});

  @override
  Widget build(BuildContext context) {
    final remaining = (goal - consumed).clamp(0, goal).round();
    final burned = 420;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _StatCard(
              label: 'Remaining',
              value: remaining,
              color: AppColors.secondary,
              icon: Icons.flag_rounded,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: _StatCard(
              label: 'Burned',
              value: burned,
              color: AppColors.accent,
              icon: Icons.local_fire_department_rounded,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: _StatCard(
              label: 'Net',
              value: (consumed - burned).round().abs(),
              color: AppColors.primary,
              icon: Icons.trending_down_rounded,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  final IconData icon;

  _StatCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withOpacity(0.04),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          SizedBox(height: 12),
          AnimatedCounter(
            target: value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final int count;

  _SectionHeader({required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
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
          Spacer(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$count items',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModernTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;

  _ModernTextField({
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 20),
        filled: true,
        fillColor: AppColors.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.primary.withOpacity(0.3), width: 1.5),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}

class _ModernBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  _ModernBottomNav({
    required this.currentIndex,
    required this.onTap,
  });

  final List<_NavItem> _items = [
    _NavItem(icon: Icons.home_rounded, label: 'Home'),
    _NavItem(icon: Icons.camera_alt_rounded, label: 'Scan'),
    _NavItem(icon: Icons.history_rounded, label: 'History'),
    _NavItem(icon: Icons.person_rounded, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.fromLTRB(20, 0, 20, 12),
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surface.withOpacity(0.95),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: AppColors.textPrimary.withOpacity(0.08),
              blurRadius: 24,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_items.length, (i) {
            final selected = i == currentIndex;
            return GestureDetector(
              onTap: () => onTap(i),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                padding: EdgeInsets.symmetric(
                  horizontal: selected ? 20 : 12,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: selected ? AppColors.primary.withOpacity(0.12) : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedScale(
                      scale: selected ? 1.1 : 1.0,
                      duration: Duration(milliseconds: 200),
                      child: Icon(
                        _items[i].icon,
                        color: selected ? AppColors.primary : AppColors.textSecondary,
                        size: 22,
                      ),
                    ),
                    if (selected) ...[
                      SizedBox(width: 8),
                      Text(
                        _items[i].label,
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  _NavItem({required this.icon, required this.label});
}