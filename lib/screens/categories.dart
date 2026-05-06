import 'package:flutter/material.dart';
import 'package:new_project_app/utils/colors.dart'; 
import 'dart:math' as math;

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  String? selectedCategory;

  final List<Map<String, dynamic>> _categoryData = [
    {'name': 'Food', 'amount': 450.0, 'color': AppColors.categoryFood, 'icon': Icons.restaurant},
    {'name': 'Transport', 'amount': 200.0, 'color': AppColors.categoryTransport, 'icon': Icons.directions_car},
    {'name': 'Salary', 'amount': 3000.0, 'color': AppColors.categorySalary, 'icon': Icons.work},
    {'name': 'Utilities', 'amount': 150.0, 'color': AppColors.categoryUtilities, 'icon': Icons.bolt},
    {'name': 'Entertainment', 'amount': 120.0, 'color': AppColors.categoryEntertainment, 'icon': Icons.movie},
    {'name': 'Other', 'amount': 80.0, 'color': AppColors.categoryOther, 'icon': Icons.more_horiz},
  ];

  double get _totalAmount {
    return _categoryData.fold(0.0, (sum, item) => sum + (item['amount'] as double));
  }

  @override
  Widget build(BuildContext context) 
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catr  DAUD'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
      ),
      body: Column(
        children: [
          _buildPieChart(),
          const Divider(height: 1),
          Expanded(
            child: _buildCategoryList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPieChart() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          SizedBox(
            height: 180,
            width: 180,
            child: CustomPaint(
              painter: PieChartPainter(
                data: _categoryData,
                total: _totalAmount,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Total: \$${_totalAmount.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _categoryData.length,
      itemBuilder: (context, index) {
        final category = _categoryData[index];
        final percentage = (category['amount'] as double) / _totalAmount * 100;
        final isSelected = selectedCategory == category['name'];

        return _CategoryTile(
          name: category['name'] as String,
          amount: category['amount'] as double,
          color: category['color'] as Color,
          icon: category['icon'] as IconData,
          percentage: percentage,
          isSelected: isSelected,
          onTap: () {
            setState(() {
              selectedCategory = isSelected ? null : category['name'] as String;
            });
          },
        );
      },
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final String name;
  final double amount;
  final Color color;
  final IconData icon;
  final double percentage;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryTile({
    required this.name,
    required this.amount,
    required this.color,
    required this.icon,
    required this.percentage,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isSelected ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isSelected
            ? BorderSide(color: color, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: percentage / 100,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${amount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: name == 'Salary' ? AppColors.income : AppColors.expense,
                    ),
                  ),
                  Text(
                    '${percentage.toStringAsFixed(1)}%',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PieChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;
  final double total;

  PieChartPainter({required this.data, required this.total});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;

    double startAngle = -math.pi / 2;

    for (final item in data) {
      final sweepAngle = (item['amount'] as double) / total * 2 * math.pi;
      final paint = Paint()
        ..color = item['color'] as Color
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      startAngle += sweepAngle;
    }

    final innerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius * 0.5, innerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}