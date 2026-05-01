import 'package:flutter/material.dart';
import 'package:rideflow_app/utils/colors.dart'; 

/// Map view widget for displaying interactive maps with markers and routes
/// Supports rider and driver modes with different marker types
class MapView extends StatefulWidget {
  final double initialLatitude;
  final double initialLongitude;
  final double zoomLevel;
  final List<MapMarker> markers;
  final List<MapRoute> routes;
  final MapMarker? userLocation;
  final bool showUserLocation;
  final bool enableMyLocationButton;
  final bool isDriverMode;
  final Function(MapMarker)? onMarkerTap;
  final Function(double, double)? onMapTap;
  final Function(double, double, double)? onMapMoved;

  const MapView({
    super.key,
    required this.initialLatitude,
    required this.initialLongitude,
    this.zoomLevel = 14.0,
    this.markers = const [],
    this.routes = const [],
    this.userLocation,
    this.showUserLocation = true,
    this.enableMyLocationButton = true,
    this.isDriverMode = false,
    this.onMarkerTap,
    this.onMapTap,
    this.onMapMoved,
  });

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late double _currentLat;
  late double _currentLng;
  late double _currentZoom;

  @override
  void initState() {
    super.initState();
    _currentLat = widget.initialLatitude;
    _currentLng = widget.initialLongitude;
    _currentZoom = widget.zoomLevel;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Map placeholder - in production, use GoogleMap or Mapbox
        GestureDetector(
          onTapUp: (details) {
            if (widget.onMapTap != null) {
              widget.onMapTap!(_currentLat, _currentLng);
            }
          },
          child: Container(
            color: AppColors.surfaceVariant,
            child: Stack(
              children: [
                // Grid pattern to simulate map
                CustomPaint(
                  painter: _MapGridPainter(),
                  size: Size.infinite,
                ),
                // Markers
                ...widget.markers.map((marker) => _buildMarker(marker)),
                // Routes
                ...widget.routes.map((route) => _buildRoute(route)),
                // User location indicator
                if (widget.showUserLocation && widget.userLocation != null)
                  _buildUserLocation(widget.userLocation!),
              ],
            ),
          ),
        ),
        // My Location Button
        if (widget.enableMyLocationButton)
          Positioned(
            right: 16,
            bottom: 16,
            child: _MyLocationButton(
              onPressed: () {
                // Center on user location
              },
            ),
          ),
      ],
    );
  }

  Widget _buildMarker(MapMarker marker) {
    return Positioned(
      left: marker.screenPosition.dx - 20,
      top: marker.screenPosition.dy - 40,
      child: GestureDetector(
        onTap: () => widget.onMarkerTap?.call(marker),
        child: _MapMarkerWidget(
          markerType: marker.type,
          isSelected: marker.isSelected,
        ),
      ),
    );
  }

  Widget _buildRoute(MapRoute route) {
    return CustomPaint(
      painter: _RoutePainter(
        color: route.isActive ? AppColors.mapRouteActive : AppColors.mapRouteCompleted,
        strokeWidth: route.isActive ? 4.0 : 3.0,
      ),
      size: Size.infinite,
    );
  }

  Widget _buildUserLocation(MapMarker location) {
    return Positioned(
      left: location.screenPosition.dx - 12,
      top: location.screenPosition.dy - 12,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: AppShadows.medium,
        ),
      ),
    );
  }
}

class _MyLocationButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _MyLocationButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: AppRadius.medium,
      elevation: 4,
      shadowColor: AppColors.shadow,
      child: InkWell(
        onTap: onPressed,
        borderRadius: AppRadius.medium,
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: AppRadius.medium,
          ),
          child: const Icon(
            Icons.my_location,
            color: AppColors.primary,
            size: 24,
          ),
        ),
      ),
    );
  }
}

class _MapMarkerWidget extends StatelessWidget {
  final MapMarkerType markerType;
  final bool isSelected;

  const _MapMarkerWidget({
    required this.markerType,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: isSelected ? 48 : 40,
          height: isSelected ? 48 : 40,
          decoration: BoxDecoration(
            color: _getMarkerColor(),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: isSelected ? 3 : 2,
            ),
            boxShadow: isSelected ? AppShadows.medium : AppShadows.small,
          ),
          child: Icon(
            _getMarkerIcon(),
            color: Colors.white,
            size: isSelected ? 24 : 20,
          ),
        ),
        // Marker pointer
        CustomPaint(
          size: const Size(16, 8),
          painter: _MarkerPointerPainter(color: _getMarkerColor()),
        ),
      ],
    );
  }

  Color _getMarkerColor() {
    switch (markerType) {
      case MapMarkerType.driver:
        return AppColors.mapMarkerDriver;
      case MapMarkerType.pickup:
        return AppColors.mapMarkerPickup;
      case MapMarkerType.dropoff:
        return AppColors.mapMarkerDropoff;
      case MapMarkerType.user:
        return AppColors.primary;
      case MapMarkerType.driverSelected:
        return AppColors.secondary;
    }
  }

  IconData _getMarkerIcon() {
    switch (markerType) {
      case MapMarkerType.driver:
        return Icons.directions_car;
      case MapMarkerType.pickup:
        return Icons.location_on;
      case MapMarkerType.dropoff:
        return Icons.flag;
      case MapMarkerType.user:
        return Icons.person;
      case MapMarkerType.driverSelected:
        return Icons.directions_car;
    }
  }
}

class _MarkerPointerPainter extends CustomPainter {
  final Color color;

  _MarkerPointerPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.border.withOpacity(0.3)
      ..strokeWidth = 0.5;

    const spacing = 40.0;

    // Draw vertical lines
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Draw horizontal lines
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RoutePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  _RoutePainter({
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Placeholder - in production, draw actual route polyline
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Draw sample route for demonstration
    final path = Path()
      ..moveTo(size.width * 0.2, size.height * 0.5)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.3,
        size.width * 0.8,
        size.height * 0.5,
      );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Enum for map marker types
enum MapMarkerType {
  driver,
  pickup,
  dropoff,
  user,
  driverSelected,
}

/// Model for map markers
class MapMarker {
  final String id;
  final double latitude;
  final double longitude;
  final MapMarkerType type;
  final bool isSelected;
  final String? title;
  final String? subtitle;
  final Offset screenPosition;

  const MapMarker({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.type,
    this.isSelected = false,
    this.title,
    this.subtitle,
    required this.screenPosition,
  });

  MapMarker copyWith({
    String? id,
    double? latitude,
    double? longitude,
    MapMarkerType? type,
    bool? isSelected,
    String? title,
    String? subtitle,
    Offset? screenPosition,
  }) {
    return MapMarker(
      id: id ?? this.id,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      type: type ?? this.type,
      isSelected: isSelected ?? this.isSelected,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      screenPosition: screenPosition ?? this.screenPosition,
    );
  }
}

/// Model for map routes
class MapRoute {
  final List<LatLng> points;
  final bool isActive;
  final double distanceKm;
  final Duration estimatedDuration;

  const MapRoute({
    required this.points,
    this.isActive = true,
    this.distanceKm = 0.0,
    this.estimatedDuration = Duration.zero,
  });
}

/// Simple lat lng model
class LatLng {
  final double latitude;
  final double longitude;

  const LatLng({
    required this.latitude,
    required this.longitude,
  });
}

/// Extension to create sample markers for testing
extension MapMarkerExtensions on List<MapMarker> {
  static List<MapMarker> sampleRiderMarkers() {
    return [
      MapMarker(
        id: 'driver_1',
        latitude: 37.7850,
        longitude: -122.4090,
        type: MapMarkerType.driver,
        title: 'John D.',
        subtitle: 'Toyota Camry • 4.9 ★',
        screenPosition: const Offset(150, 200),
      ),
      MapMarker(
        id: 'driver_2',
        latitude: 37.7880,
        longitude: -122.4080,
        type: MapMarkerType.driver,
        title: 'Sarah M.',
        subtitle: 'Honda Civic • 4.8 ★',
        screenPosition: const Offset(200, 250),
      ),
      MapMarker(
        id: 'driver_3',
        latitude: 37.7820,
        longitude: -122.4100,
        type: MapMarkerType.driver,
        title: 'Mike R.',
        subtitle: 'Tesla Model 3 • 5.0 ★',
        screenPosition: const Offset(120, 280),
      ),
      MapMarker(
        id: 'pickup',
        latitude: 37.7840,
        longitude: -122.4095,
        type: MapMarkerType.pickup,
        title: 'Pickup Location',
        screenPosition: const Offset(180, 180),
      ),
    ];
  }

  static List<MapMarker> sampleDriverMarkers() {
    return [
      MapMarker(
        id: 'user_1',
        latitude: 37.7850,
        longitude: -122.4090,
        type: MapMarkerType.user,
        title: 'Alice W.',
        subtitle: 'Going to Downtown',
        screenPosition: const Offset(150, 200),
      ),
      MapMarker(
        id: 'user_2',
        latitude: 37.7880,
        longitude: -122.4080,
        type: MapMarkerType.user,
        title: 'Bob K.',
        subtitle: 'Going to Airport',
        screenPosition: const Offset(200, 250),
      ),
    ];
  }
}