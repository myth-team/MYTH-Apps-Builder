import 'package:flutter/material.dart';
import 'package:scan_fit_app/utils/colors.dart'; 

class MacrosCard extends StatelessWidget {
  final double protein;
  final double carbs;
  final double fat;

  MacrosCard({
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  @override
  Widget build(BuildContext context) {
    final total = protein + carbs + fat;
    final pPct = total > 0 ? protein / total : 0.33;
    final cPct = total > 0 ? carbs / total : 0.33;
    final fPct = total > 0 ? fat / total : 0.34;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Macro Breakdown',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Row(
              children: [
                Expanded(
                  flex: (pPct * 100).round(),
                  child: Container(height: 8, color: AppColors.accent),
                ),
                Expanded(
                  flex: (cPct * 100).round(),
                  child: Container(height: 8, color: AppColors.primary),
                ),
                Expanded(
                  flex: (fPct * 100).round(),
                  child: Container(height: 8, color: AppColors.secondary),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _MacroItem(
                label: 'Protein',
                value: '${protein.round()}g',
                color: AppColors.accent,
                pct: '${(pPct * 100).round()}%',
              ),
              _MacroItem(
                label: 'Carbs',
                value: '${carbs.round()}g',
                color: AppColors.primary,
                pct: '${(cPct * 100).round()}%',
              ),
              _MacroItem(
                label: 'Fat',
                value: '${fat.round()}g',
                color: AppColors.secondary,
                pct: '${(fPct * 100).round()}%',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MacroItem extends StatelessWidget {
  final String label;
  final String value;
  final String pct;
  final Color color;

  _MacroItem({
    required this.label,
    required this.value,
    required this.pct,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 2),
        Text(
          pct,
          style: TextStyle(
            fontSize: 11,
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}