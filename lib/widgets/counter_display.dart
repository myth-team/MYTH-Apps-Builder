import 'package:flutter/material.dart';
import 'package:simple_counter_app/utils/colors.dart'; 

class CounterDisplay extends StatelessWidget {
  final int count;

  const CounterDisplay({
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 60),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Current Count',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 16),
          AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(
                scale: animation,
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              );
            },
            child: Text(
              '$count',
              key: ValueKey<int>(count),
              style: TextStyle(
                fontSize: 80,
                fontWeight: FontWeight.bold,
                color: _getCountColor(count),
              ),
            ),
          ),
          SizedBox(height: 12),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: _getCountColor(count).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getCountIcon(count),
                  size: 18,
                  color: _getCountColor(count),
                ),
                SizedBox(width: 6),
                Text(
                  _getCountStatus(count),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _getCountColor(count),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getCountColor(int value) {
    if (value > 0) {
      return AppColors.successColor;
    } else if (value < 0) {
      return AppColors.secondaryColor;
    }
    return AppColors.primaryColor;
  }

  IconData _getCountIcon(int value) {
    if (value > 0) {
      return Icons.arrow_upward_rounded;
    } else if (value < 0) {
      return Icons.arrow_downward_rounded;
    }
    return Icons.remove_rounded;
  }

  String _getCountStatus(int value) {
    if (value > 0) {
      return 'Positive';
    } else if (value < 0) {
      return 'Negative';
    }
    return 'Zero';
  }
}