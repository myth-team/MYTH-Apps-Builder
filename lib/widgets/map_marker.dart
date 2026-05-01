import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:new_project_app/utils/colors.dart'; 

/// The visual role / persona for a map marker.
enum MapMarkerType {
  driver,
  pickup,
  dropoff,
  rider,
}

/// A fully self-contained, animated map marker widget rendered in Flutter.
/// This is used as the source for [BitmapDescriptor] generation via
/// [RepaintBoundary] + [RenderRepaintBoundary] in screen-level code, or
/// simply rendered directly inside an overlay / map widget child.
class MapMarker extends StatefulWidget {
  final MapMarkerType type;

  /// Bearing in degrees (0–360). 0 = north. Used to rotate the driver arrow.
  final double bearing;

  /// Display label shown below the marker (e.g. driver name or "Pickup").
  final String? label;

  /// Overall size of the pin icon area (width & height of the marker head).
  final double size;

  /// Whether to play the pulse animation (useful for the selected / active marker).
  final bool animated;

  /// Custom accent colour override — falls back to type-based colour when null.
  final Color? accentColor;

  const MapMarker({
    Key? key,
    required this.type,
    this.bearing = 0,
    this.label,
    this.size = 48,
    this.animated = true,
    this.accentColor,
  }) : super(key: key);

  @override
  State<MapMarker> createState() => _MapMarkerState();
}

class _MapMarkerState extends State<MapMarker>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );

    if (widget.animated) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(MapMarker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animated && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!widget.animated && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get _accentColor {
    if (widget.accentColor != null) return widget.accentColor!;
    switch (widget.type) {
      case MapMarkerType.driver:
        return AppColors.mapDriverMarker;
      case MapMarkerType.pickup:
        return AppColors.mapPickup;
      case MapMarkerType.dropoff:
        return AppColors.mapDropoff;
      case MapMarkerType.rider:
        return AppColors.secondary;
    }
  }

  IconData get _icon {
    switch (widget.type) {
      case MapMarkerType.driver:
        return Icons.navigation_rounded;
      case MapMarkerType.pickup:
        return Icons.radio_button_checked_rounded;
      case MapMarkerType.dropoff:
        return Icons.location_on_rounded;
      case MapMarkerType.rider:
        return Icons.person_pin_circle_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double size = widget.size;
    final double pinWidth = size;
    final double pinHeight = size * 1.4;
    final Color accent = _accentColor;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final double scale =
                widget.animated ? _pulseAnimation.value : 1.0;
            return Transform.scale(
              scale: scale,
              child: child,
            );
          },
          child: SizedBox(
            width: pinWidth,
            height: pinHeight,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                // ── Pulse ring ────────────────────────────────────────────
                if (widget.animated)
                  AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, _) {
                      return Positioned(
                        top: 0,
                        child: Opacity(
                          opacity:
                              (1.15 - _pulseAnimation.value).clamp(0.0, 1.0),
                          child: Container(
                            width: size * _pulseAnimation.value,
                            height: size * _pulseAnimation.value,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: accent
                                  .withOpacity(0.18 * _pulseAnimation.value),
                              border: Border.all(
                                color: accent.withOpacity(0.35),
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                // ── Marker head ───────────────────────────────────────────
                Positioned(
                  top: widget.animated ? size * 0.075 : 0,
                  child: _MarkerHead(
                    type: widget.type,
                    size: size * (widget.animated ? 0.85 : 1.0),
                    accentColor: accent,
                    icon: _icon,
                    bearing: widget.bearing,
                  ),
                ),

                // ── Pin tail ──────────────────────────────────────────────
                Positioned(
                  bottom: 0,
                  child: CustomPaint(
                    size: Size(size * 0.28, size * 0.38),
                    painter: _PinTailPainter(color: accent),
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── Label ─────────────────────────────────────────────────────────
        if (widget.label != null && widget.label!.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(top: size * 0.06),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: size * 0.2,
                vertical: size * 0.06,
              ),
              decoration: BoxDecoration(
                color: AppColors.darkSurface.withOpacity(0.88),
                borderRadius: BorderRadius.circular(size * 0.2),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowDark,
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                widget.label!,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: size * 0.24,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Private: Marker head circle with icon
// ─────────────────────────────────────────────────────────────────────────────

class _MarkerHead extends StatelessWidget {
  final MapMarkerType type;
  final double size;
  final Color accentColor;
  final IconData icon;
  final double bearing;

  const _MarkerHead({
    required this.type,
    required this.size,
    required this.accentColor,
    required this.icon,
    required this.bearing,
  });

  @override
  Widget build(BuildContext context) {
    final double radians = bearing * (math.pi / 180.0);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _lighten(accentColor, 0.15),
            accentColor,
            _darken(accentColor, 0.12),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.45),
            blurRadius: size * 0.35,
            offset: Offset(0, size * 0.12),
            spreadRadius: size * 0.02,
          ),
          BoxShadow(
            color: accentColor.withOpacity(0.18),
            blurRadius: size * 0.6,
            offset: Offset(0, size * 0.2),
          ),
        ],
        border: Border.all(
          color: AppColors.white.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Center(
        child: type == MapMarkerType.driver
            ? Transform.rotate(
                angle: radians,
                child: Icon(
                  icon,
                  color: AppColors.white,
                  size: size * 0.54,
                ),
              )
            : Icon(
                icon,
                color: AppColors.white,
                size: size * 0.54,
              ),
      ),
    );
  }

  Color _lighten(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness((hsl.lightness + amount).clamp(0.0, 1.0))
        .toColor();
  }

  Color _darken(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness((hsl.lightness - amount).clamp(0.0, 1.0))
        .toColor();
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Private: Triangular pin tail painter
// ─────────────────────────────────────────────────────────────────────────────

class _PinTailPainter extends CustomPainter {
  final Color color;

  const _PinTailPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = color.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();

    canvas.drawPath(path, shadowPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_PinTailPainter oldDelegate) =>
      oldDelegate.color != color;
}

// ─────────────────────────────────────────────────────────────────────────────
// Public: Static factory helpers for common marker configurations
// ─────────────────────────────────────────────────────────────────────────────

/// Convenience factory class for creating pre-configured [MapMarker] instances.
class MapMarkerFactory {
  MapMarkerFactory._();

  /// Creates an animated driver marker rotated to the given [bearing].
  static MapMarker driver({
    double bearing = 0,
    String? driverName,
    double size = 48,
  }) {
    return MapMarker(
      type: MapMarkerType.driver,
      bearing: bearing,
      label: driverName,
      size: size,
      animated: true,
    );
  }

  /// Creates a pickup location marker.
  static MapMarker pickup({String? label, double size = 44}) {
    return MapMarker(
      type: MapMarkerType.pickup,
      label: label ?? 'Pickup',
      size: size,
      animated: false,
    );
  }

  /// Creates a dropoff location marker.
  static MapMarker dropoff({String? label, double size = 44}) {
    return MapMarker(
      type: MapMarkerType.dropoff,
      label: label ?? 'Drop-off',
      size: size,
      animated: false,
    );
  }

  /// Creates a rider location marker.
  static MapMarker rider({double size = 40}) {
    return MapMarker(
      type: MapMarkerType.rider,
      size: size,
      animated: true,
    );
  }
}