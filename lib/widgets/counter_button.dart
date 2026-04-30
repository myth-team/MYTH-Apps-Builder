import 'package:flutter/material.dart';
import 'package:simple_counter_app/utils/colors.dart'; 
import 'package:simple_counter_app/models/counter_model.dart'; 
import 'package:provider/provider.dart';

enum CounterButtonType { increment, decrement, reset }

class CounterButton extends StatelessWidget {
  final CounterButtonType buttonType;
  final String label;

  const CounterButton({
    required this.buttonType,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CounterModel>(
      builder: (context, counter, child) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _getBackgroundColor(),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              shadowColor: _getShadowColor(),
            ),
            onPressed: () => _handleButtonPress(counter),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getIcon(),
                  size: 24,
                ),
                SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getBackgroundColor() {
    switch (buttonType) {
      case CounterButtonType.increment:
        return AppColors.incrementColor;
      case CounterButtonType.decrement:
        return AppColors.decrementColor;
      case CounterButtonType.reset:
        return AppColors.resetColor;
    }
  }

  Color _getShadowColor() {
    switch (buttonType) {
      case CounterButtonType.increment:
        return AppColors.incrementColor.withOpacity(0.5);
      case CounterButtonType.decrement:
        return AppColors.decrementColor.withOpacity(0.5);
      case CounterButtonType.reset:
        return AppColors.resetColor.withOpacity(0.5);
    }
  }

  IconData _getIcon() {
    switch (buttonType) {
      case CounterButtonType.increment:
        return Icons.add;
      case CounterButtonType.decrement:
        return Icons.remove;
      case CounterButtonType.reset:
        return Icons.refresh;
    }
  }

  void _handleButtonPress(CounterModel counter) {
    switch (buttonType) {
      case CounterButtonType.increment:
        counter.increment();
        break;
      case CounterButtonType.decrement:
        counter.decrement();
        break;
      case CounterButtonType.reset:
        counter.reset();
        break;
    }
  }
}