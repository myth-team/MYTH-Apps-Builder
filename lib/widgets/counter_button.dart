import 'package:flutter/material.dart';
import 'package:simple_counter_app/utils/colors.dart'; 

enum CounterButtonType { increment, decrement, reset }

class CounterButton extends StatelessWidget {
  final CounterButtonType type;
  final VoidCallback onPressed;

  const CounterButton({
    super.key,
    required this.type,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color iconColor;
    IconData icon;
    String tooltip;

    switch (type) {
      case CounterButtonType.increment:
        backgroundColor = AppColors.incrementColor;
        iconColor = Colors.white;
        icon = Icons.add;
        tooltip = 'Increment';
        break;
      case CounterButtonType.decrement:
        backgroundColor = AppColors.decrementColor;
        iconColor = Colors.white;
        icon = Icons.remove;
        tooltip = 'Decrement';
        break;
      case CounterButtonType.reset:
        backgroundColor = AppColors.secondaryColor;
        iconColor = Colors.white;
        icon = Icons.refresh;
        tooltip = 'Reset';
        break;
    }

    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(20),
          child: Ink(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: backgroundColor.withValues(alpha: 0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Container(
              width: 80,
              height: 80,
              alignment: Alignment.center,
              child: Icon(
                icon,
                color: iconColor,
                size: 32,
              ),
            ),
          ),
        ),
      ),
    );
  }
}