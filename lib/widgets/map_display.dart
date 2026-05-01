import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ridesync_app/utils/colors.dart'; 

class MapDisplay extends StatefulWidget {
  final LatLng? initialPosition;
  final Set<Marker> markers;
  final Set<Polyline> polylines;
  final Set<Circle> circles;
  final Function(GoogleMapController)? onMapCreated;
  final Function(LatLng)? onTap;
  final Function(CameraPosition)? onCameraMove;
  final bool showMyLocation;
  final bool enableMyLocationButton;
  final bool zoomControlsEnabled;
  final MapType mapType;
  final double? padding;
  final Widget? floatingActionButton;
  final Widget? infoWindowWidget;

  const MapDisplay({
    super.key,
    this.initialPosition,
    this.markers = const {},
    this.polylines = const {},
    this.circles = const {},
    this.onMapCreated,
    this.onTap,
    this.onCameraMove,
    this.showMyLocation = true,
    this.enableMyLocationButton = true,
    this.zoomControlsEnabled = false,
    this.mapType = MapType.normal,
    this.padding,
    this.floatingActionButton,
    this.infoWindowWidget,
  });

  @override
  State<MapDisplay> createState() => _MapDisplayState();
}

class _MapDisplayState extends State<MapDisplay> {
  GoogleMapController? _mapController;
  LatLng? _currentPosition;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    if (widget.showMyLocation) {
      try {
        final permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          await Geolocator.requestPermission();
        }

        final position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
          ),
        );
        
        if (mounted) {
          setState(() {
            _currentPosition = LatLng(position.latitude, position.longitude);
            _isLoading = false;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _currentPosition = widget.initialPosition ?? 
                const LatLng(37.7749, -122.4194);
            _isLoading = false;
          });
        }
      }
    } else {
      setState(() {
        _currentPosition = widget.initialPosition ?? 
            const LatLng(37.7749, -122.4194);
        _isLoading = false;
      });
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    if (widget.onMapCreated != null) {
      widget.onMapCreated!(controller);
    }
  }

  Future<void> _goToCurrentLocation() async {
    if (_mapController != null && _currentPosition != null) {
      await _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          _currentPosition!,
          16.0,
        ),
      );
    }
  }

  Future<void> animateToPosition(LatLng position, {double zoom = 16.0}) async {
    if (_mapController != null) {
      await _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(position, zoom),
      );
    }
  }

  Future<void> animateToRoute(List<LatLng> points) async {
    if (_mapController != null && points.isNotEmpty) {
      double minLat = points.first.latitude;
      double maxLat = points.first.latitude;
      double minLng = points.first.longitude;
      double maxLng = points.first.longitude;

      for (var point in points) {
        if (point.latitude < minLat) minLat = point.latitude;
        if (point.latitude > maxLat) maxLat = point.latitude;
        if (point.longitude < minLng) minLng = point.longitude;
        if (point.longitude > maxLng) maxLng = point.longitude;
      }

      final bounds = LatLngBounds(
        southwest: LatLng(minLat - 0.01, minLng - 0.01),
        northeast: LatLng(maxLat + 0.01, maxLng + 0.01),
      );

      await _mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 50),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final initialPosition = _currentPosition ?? widget.initialPosition ?? 
        const LatLng(37.7749, -122.4194);

    return Stack(
      children: [
        GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: initialPosition,
            zoom: 15.0,
          ),
          markers: widget.markers,
          polylines: widget.polylines,
          circles: widget.circles,
          onTap: widget.onTap,
          onCameraMove: widget.onCameraMove,
          myLocationEnabled: widget.showMyLocation && _currentPosition != null,
          myLocationButtonEnabled: widget.enableMyLocationButton,
          zoomControlsEnabled: widget.zoomControlsEnabled,
          mapType: widget.mapType,
          padding: widget.padding != null 
              ? EdgeInsets.only(top: widget.padding!) 
              : const EdgeInsets.only(bottom: 0),
          compassEnabled: true,
          rotateGesturesEnabled: true,
          tiltGesturesEnabled: true,
          scrollGesturesEnabled: true,
          zoomGesturesEnabled: true,
        ),
        if (_isLoading)
          Container(
            color: AppColors.background,
            child: const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            ),
          ),
        if (widget.floatingActionButton != null)
          Positioned(
            right: 16,
            bottom: 100,
            child: widget.floatingActionButton!,
          ),
        if (widget.infoWindowWidget != null)
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: widget.infoWindowWidget!,
          ),
      ],
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}

class MapMarkerHelper {
  static Marker createRiderMarker({
    required LatLng position,
    String? title,
    String? snippet,
    VoidCallback? onTap,
  }) {
    return Marker(
      markerId: const MarkerId('rider'),
      position: position,
      infoWindow: title != null 
          ? InfoWindow(title: title, snippet: snippet) 
          : const InfoWindow(),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      onTap: onTap ?? () {},
    );
  }

  static Marker createDriverMarker({
    required LatLng position,
    String? title,
    String? snippet,
    VoidCallback? onTap,
  }) {
    return Marker(
      markerId: MarkerId('driver_${position.latitude}_${position.longitude}'),
      position: position,
      infoWindow: title != null 
          ? InfoWindow(title: title, snippet: snippet) 
          : const InfoWindow(),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      onTap: onTap ?? () {},
    );
  }

  static Marker createPickupMarker({
    required LatLng position,
    VoidCallback? onTap,
  }) {
    return Marker(
      markerId: const MarkerId('pickup'),
      position: position,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      onTap: onTap ?? () {},
    );
  }

  static Marker createDropoffMarker({
    required LatLng position,
    VoidCallback? onTap,
  }) {
    return Marker(
      markerId: const MarkerId('dropoff'),
      position: position,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      onTap: onTap ?? () {},
    );
  }

  static Polyline createRoutePolyline({
    required List<LatLng> points,
    Color color = AppColors.mapRouteActive,
    double width = 4.0,
  }) {
    return Polyline(
      polylineId: const PolylineId('route'),
      points: points,
      color: color,
      width: width,
      geodesic: true,
      endCap: Cap.roundCap,
      startCap: Cap.roundCap,
    );
  }

  static Circle createRadiusCircle({
    required LatLng center,
    double radius = 1000,
    Color fillColor = AppColors.mapZoneActive,
    Color strokeColor = AppColors.primary,
  }) {
    return Circle(
      circleId: const CircleId('radius'),
      center: center,
      radius: radius,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: 2,
    );
  }
}