import 'package:flutter/material.dart';
import 'package:simple_counter_app/models/counter_model.dart'; 
import 'package:simple_counter_app/utils/colors.dart'; 

class CounterDisplay extends StatelessWidget {
  final CounterModel counterModel;

  const CounterDisplay({
    super.key,
    required this.counterModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 60),
      decoration: BoxDecoration(
        color: AppColors.cardBackgroundColor,
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
            'COUNTER',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 3,
              color: AppColors.textSecondaryColor,
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
              '${counterModel.count}',
              key: ValueKey<int>(counterModel.count),
              style: TextStyle(
                fontSize: 80,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimaryColor,
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Current Value',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }
}