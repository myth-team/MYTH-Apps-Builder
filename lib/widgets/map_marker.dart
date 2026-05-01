import 'package:flutter/material.dart';
import 'package:ridenow_go_app/utils/colors.dart'; 

/// Custom map markers for the ride-hailing app.
/// Includes pickup, destination, driver, and nearby driver variants
/// with vibrant styling and pulse animations.
class MapMarker extends StatelessWidget {
  final MarkerType type;
  final double size;
  final bool pulse;
  final String? label;
  final VoidCallback? onTap;

  MapMarker({
    required this.type,
    this.size = 48,
    this.pulse = false,
    this.label,
    this.onTap,
  });

  MapMarker.pickup({
    this.size = 48,
    this.pulse = false,
    this.label,
    this.onTap,
  }) : type = MarkerType.pickup;

  MapMarker.destination({
    this.size = 48,
    this.pulse = false,
    this.label,
    this.onTap,
  }) : type = MarkerType.destination;

  MapMarker.driver({
    this.size = 44,
    this.pulse = true,
    this.label,
    this.onTap,
  }) : type = MarkerType.driver;

  MapMarker.nearbyDriver({
    this.size = 36,
    this.pulse = false,
    this.label,
    this.onTap,
  }) : type = MarkerType.nearbyDriver;

  Color get _markerColor {
    switch (type) {
      case MarkerType.pickup:
        return AppColors.mapPin;
      case MarkerType.destination:
        return AppColors.destinationPin;
      case MarkerType.driver:
        return AppColors.secondary;
      case MarkerType.nearbyDriver:
        return AppColors.mapPinNearby;
    }
  }

  List<Color> get _markerGradient {
    switch (type) {
      case MarkerType.pickup:
        return AppColors.primaryGradient;
      case MarkerType.destination:
        return [AppColors.destinationPin, Color(0xFFDC2626)];
      case MarkerType.driver:
        return AppColors.accentGradient;
      case MarkerType.nearbyDriver:
        return AppColors.successGradient;
    }
  }

  IconData get _markerIcon {
    switch (type) {
      case MarkerType.pickup:
        return Icons.person_pin_circle_rounded;
      case MarkerType.destination:
        return Icons.location_on_rounded;
      case MarkerType.driver:
        return Icons.local_taxi_rounded;
      case MarkerType.nearbyDriver:
        return Icons.local_taxi_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: size * 2,
        height: size * 2.5,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            if (pulse) ...[
              _buildPulseRing(),
            ],
            _buildMarkerBody(),
            Positioned(
              bottom: 0,
              child: _buildPinShadow(),
            ),
            if (label != null) ...[
              Positioned(
                top: 0,
                child: _buildLabel(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPulseRing() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 1500),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: 1.0 - value,
          child: Transform.scale(
            scale: 1.0 + value * 0.8,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _markerColor.withOpacity(0.3),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMarkerBody() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: AppColors.buildGradient(_markerGradient),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: _markerColor.withOpacity(0.4),
                blurRadius: 12,
                spreadRadius: 2,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Icon(
              _markerIcon,
              size: size * 0.5,
              color: Colors.white,
            ),
          ),
        ),
        CustomPaint(
          size: Size(size * 0.5, size * 0.3),
          painter: _TrianglePainter(color: _markerGradient.last),
        ),
      ],
    );
  }

  Widget _buildPinShadow() {
    return Container(
      width: size * 0.6,
      height: size * 0.15,
      decoration: BoxDecoration(
        shape: BoxShape.oval,
        color: AppColors.shadowStrong.withOpacity(0.3),
      ),
    );
  }

  Widget _buildLabel() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        label!,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}

enum MarkerType {
  pickup,
  destination,
  driver,
  nearbyDriver,
}

/// Custom painter for the marker triangle pointer.
class _TrianglePainter extends CustomPainter {
  final Color color;

  _TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width / 2, size.height)
      ..lineTo(0, 0)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Animated driver marker with rotation support for heading.
class DriverMapMarker extends StatefulWidget {
  final double size;
  final double? heading;
  final bool isEnRoute;
  final VoidCallback? onTap;

  DriverMapMarker({
    this.size = 44,
    this.heading,
    this.isEnRoute = true,
    this.onTap,
  });

  @override
  State<DriverMapMarker> createState() => _DriverMapMarkerState();
}

class _DriverMapMarkerState extends State<DriverMapMarker>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: SizedBox(
        width: widget.size * 2.5,
        height: widget.size * 2.5,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                final value = _pulseController.value;
                return Opacity(
                  opacity: 1.0 - value,
                  child: Transform.scale(
                    scale: 1.0 + value * 0.6,
                    child: Container(
                      width: widget.size * 1.5,
                      height: widget.size * 1.5,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.secondary.withOpacity(0.2),
                      ),
                    ),
                  ),
                );
              },
            ),
            Transform.rotate(
              angle: (widget.heading ?? 0) * 3.141592653589793 / 180,
              child: Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  gradient: AppColors.buildGradient(AppColors.accentGradient),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.secondary.withOpacity(0.5),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.navigation_rounded,
                    size: widget.size * 0.45,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            if (widget.isEnRoute)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.success,
                    border: Border.all(
                      color: AppColors.surface,
                      width: 2,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}