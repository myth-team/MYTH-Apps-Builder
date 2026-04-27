import 'package:flutter/material.dart';
import 'package:shop_ledger_pro_app/utils/colors.dart'; 

class ChartWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 200),
      painter: _ChartPainter(),
    );
  }
}

class _ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final gridPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = AppColors.border.withOpacity(0.5);

    final List<double> values = [30, 45, 35, 60, 50, 75, 65, 85, 70, 95, 80, 100];
    final List<String> labels = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

    double maxValue = values.reduce((a, b) => a > b ? a : b);
    double chartHeight = size.height - 30;
    double chartWidth = size.width - 40;
    double stepX = chartWidth / (values.length - 1);

    for (int i = 0; i <= 4; i++) {
      double y = chartHeight - (chartHeight * i / 4);
      canvas.drawLine(
        Offset(40, y),
        Offset(size.width, y),
        gridPaint,
      );
    }

    List<Offset> points = [];
    for (int i = 0; i < values.length; i++) {
      double x = 40 + (i * stepX);
      double y = chartHeight - (values[i] / maxValue * chartHeight);
      points.add(Offset(x, y));
    }

    Path gradientPath = Path();
    gradientPath.moveTo(points[0].dx, chartHeight);
    for (int i = 0; i < points.length; i++) {
      gradientPath.lineTo(points[i].dx, points[i].dy);
    }
    gradientPath.lineTo(points.last.dx, chartHeight);
    gradientPath.close();

    paint.shader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        AppColors.primary.withOpacity(0.3),
        AppColors.primary.withOpacity(0.05),
      ],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(gradientPath, paint);

    Path linePath = Path();
    linePath.moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      linePath.lineTo(points[i].dx, points[i].dy);
    }

    linePaint.shader = LinearGradient(
      colors: [AppColors.primary, AppColors.primaryLight],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(linePath, linePaint);

    final dotPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white;

    final dotBorderPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = AppColors.primary;

    for (int i = 0; i < points.length; i++) {
      canvas.drawCircle(points[i], 5, dotBorderPaint);
      canvas.drawCircle(points[i], 3, dotPaint);
    }

    final textStyle = TextStyle(
      color: AppColors.textLight,
      fontSize: 10,
    );

    for (int i = 0; i < labels.length; i += 2) {
      final textSpan = TextSpan(text: labels[i], style: textStyle);
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(40 + (i * stepX) - textPainter.width / 2, size.height - 20),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}