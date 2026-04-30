import 'package:flutter/material.dart';
import 'package:simple_counter_app/utils/colors.dart'; 
import 'package:simple_counter_app/models/counter_model.dart'; 
import 'package:provider/provider.dart';

class CounterDisplay extends StatelessWidget {
  const CounterDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CounterModel>(
      builder: (context, counter, child) {
        return Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: AppColors.cardColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Counter Value',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 20,
                ),
                decoration: BoxDecoration(
                  color: _getBackgroundColor(counter.count),
                  borderRadius: BorderRadius.circular(15),
                  ...[
                    BoxShadow(
                      color: _getBackgroundColor(counter.count).withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  '${counter.count}',
                  style: TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                _getStatusText(counter.count),
                style: TextStyle(
                  fontSize: 16,
                  color: _getStatusColor(counter.count),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getBackgroundColor(int count) {
    if (count > 0) {
      return AppColors.incrementColor.withOpacity(0.1);
    } else if (count < 0) {
      return AppColors.decrementColor.withOpacity(0.1);
    }
    return AppColors.backgroundColor;
  }

  String _getStatusText(int count) {
    if (count > 0) {
      return 'Positive';
    } else if (count < 0) {
      return 'Negative';
    }
    return 'Zero';
  }

  Color _getStatusColor(int count) {
    if (count > 0) {
      return AppColors.incrementColor;
    } else if (count < 0) {
      return AppColors.decrementColor;
    }
    return AppColors.textSecondary;
  }
}