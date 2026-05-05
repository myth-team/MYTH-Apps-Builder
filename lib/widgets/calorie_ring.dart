import 'package:flutter/material.dart';
import 'dart:math';
import 'package:scan_fit_app/utils/colors.dart'; 

class CalorieRing extends StatelessWidget {
  final double consumed;
  final double goal;
  final double size;

  CalorieRing({
    required this.consumed,
    required this.goal,
    this.size = 200,
  });

  double get _progress => (consumed / goal).clamp(0.0, 1.0);
  double get _remaining => (goal - consumed).clamp(0, goal);
  String get _percentText => '${(_progress * 100).round()}%';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _RingPainter(
              progress: _progress,
              bgColor: AppColors.ringBg,
              progressColor: _progressColor,
              strokeWidth: size * 0.08,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                consumed.round().toString(),
                style: TextStyle(
                  fontSize: size * 0.18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                'of ${goal.round()}',
                style: TextStyle(
                  fontSize: size * 0.08,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 4),
              Text(
                _remaining > 0 ? '${_remaining.round()} left' : 'Over by ${(consumed - goal).round()}',
                style: TextStyle(
                  fontSize: size * 0.07,
                  color: _remaining > 0 ? AppColors.secondary : AppColors.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color get _progressColor {
    if (_progress < 0.5) return AppColors.secondary;
    if (_progress < 0.85) return AppColors.primary;
    if (_progress <= 1.0) return AppColors.warning;
    return AppColors.error;
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final Color bgColor;
  final Color progressColor;
  final double strokeWidth;

  _RingPainter({
    required this.progress,
    required this.bgColor,
    required this.progressColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final bgPaint = Paint()
      ..color = bgColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    final sweepAngle = 2 * pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) {
    return old.progress != progress || old.progressColor != progressColor;
  }
}