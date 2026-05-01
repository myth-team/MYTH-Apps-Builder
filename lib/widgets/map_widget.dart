import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ridenow_app/utils/colors.dart'; 
import 'package:ridenow_app/models/location.dart'; 

class MapWidget extends StatefulWidget {
  final Location? currentLocation;
  final Location? pickupLocation;
  final Location? destinationLocation;
  final Location? driverLocation;
  final List<Location> routePoints;
  final Function(GoogleMapController)? onMapCreated;
  final Function(Location)? onMapTap;
  final bool showCurrentLocation;
  final bool isTrackingDriver;
  final double initialZoom;
  final bool enableMapClick;

  MapWidget({
    super.key,
    this.currentLocation,
    this.pickupLocation,
    this.destinationLocation,
    this.driverLocation,
    this.routePoints = const [],
    this.onMapCreated,
    this.onMapTap,
    this.showCurrentLocation = true,
    this.isTrackingDriver = false,
    this.initialZoom = 14.0,
    this.enableMapClick = true,
  });

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    _updateMarkers();
  }

  @override
  void didUpdateWidget(MapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateMarkers();
    _updatePolylines();
  }

  void _updateMarkers() {
    final markers = <Marker>{};

    if (widget.currentLocation != null && widget.showCurrentLocation) {
      markers.add(
        Marker(
          markerId: MarkerId('current_location'),
          position: LatLng(
            widget.currentLocation!.latitude,
            widget.currentLocation!.longitude,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          infoWindow: InfoWindow(
            title: 'Current Location',
            snippet: widget.currentLocation!.shortAddress,
          ),
        ),
      );
    }

    if (widget.pickupLocation != null) {
      markers.add(
        Marker(
          markerId: MarkerId('pickup'),
          position: LatLng(
            widget.pickupLocation!.latitude,
            widget.pickupLocation!.longitude,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          infoWindow: InfoWindow(
            title: 'Pickup',
            snippet: widget.pickupLocation!.shortAddress,
          ),
          zIndex: 2,
        ),
      );
    }

    if (widget.destinationLocation != null) {
      markers.add(
        Marker(
          markerId: MarkerId('destination'),
          position: LatLng(
            widget.destinationLocation!.latitude,
            widget.destinationLocation!.longitude,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(
            title: 'Destination',
            snippet: widget.destinationLocation!.shortAddress,
          ),
          zIndex: 1,
        ),
      );
    }

    if (widget.driverLocation != null && widget.isTrackingDriver) {
      markers.add(
        Marker(
          markerId: MarkerId('driver'),
          position: LatLng(
            widget.driverLocation!.latitude,
            widget.driverLocation!.longitude,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
          infoWindow: InfoWindow(
            title: 'Your Driver',
            snippet: 'On the way',
          ),
          zIndex: 3,
        ),
      );
    }

    setState(() {
      _markers = markers;
    });
  }

  void _updatePolylines() {
    final polylines = <Polyline>{};

    if (widget.routePoints.isNotEmpty) {
      final points = widget.routePoints
          .map((loc) => LatLng(loc.latitude, loc.longitude))
          .toList();

      polylines.add(
        Polyline(
          polylineId: PolylineId('route'),
          points: points,
          color: AppColors.primary,
          width: 5,
          patterns: [PatternItem.dash(20), PatternItem.gap(10)],
        ),
      );
    } else if (widget.pickupLocation != null && widget.destinationLocation != null) {
      polylines.add(
        Polyline(
          polylineId: PolylineId('direct_route'),
          points: [
            LatLng(
              widget.pickupLocation!.latitude,
              widget.pickupLocation!.longitude,
            ),
            LatLng(
              widget.destinationLocation!.latitude,
              widget.destinationLocation!.longitude,
            ),
          ],
          color: AppColors.primary.withOpacity(0.5),
          width: 3,
          patterns: [PatternItem.dash(15), PatternItem.gap(10)],
        ),
      );
    }

    setState(() {
      _polylines = polylines;
    });
  }

  LatLng? _getInitialPosition() {
    if (widget.currentLocation != null) {
      return LatLng(
        widget.currentLocation!.latitude,
        widget.currentLocation!.longitude,
      );
    }
    if (widget.pickupLocation != null) {
      return LatLng(
        widget.pickupLocation!.latitude,
        widget.pickupLocation!.longitude,
      );
    }
    if (widget.destinationLocation != null) {
      return LatLng(
        widget.destinationLocation!.latitude,
        widget.destinationLocation!.longitude,
      );
    }
    return null;
  }

  void animateToLocation(Location location) {
    _mapController?.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(location.latitude, location.longitude),
      ),
    );
  }

  void fitBounds() {
    if (_markers.isEmpty) return;

    double minLat = double.infinity;
    double maxLat = double.negativeInfinity;
    double minLng = double.infinity;
    double maxLng = double.negativeInfinity;

    for (final marker in _markers) {
      final lat = marker.position.latitude;
      final lng = marker.position.longitude;

      if (lat < minLat) minLat = lat;
      if (lat > maxLat) maxLat = lat;
      if (lng < minLng) minLng = lng;
      if (lng > maxLng) maxLng = lng;
    }

    final bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    _mapController?.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 50),
    );
  }

  @override
  Widget build(BuildContext context) {
    final initialPosition = _getInitialPosition();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: initialPosition ?? LatLng(37.7749, -122.4194),
                zoom: widget.initialZoom,
              ),
              onMapCreated: (controller) {
                _mapController = controller;
                widget.onMapCreated?.call(controller);
              },
              markers: _markers,
              polylines: _polylines,
              myLocationEnabled: widget.showCurrentLocation,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              compassEnabled: false,
              onTap: widget.enableMapClick
                  ? (latLng) {
                      if (widget.onMapTap != null) {
                        final location = Location(
                          latitude: latLng.latitude,
                          longitude: latLng.longitude,
                          address: 'Selected location',
                        );
                        widget.onMapTap!.call(location);
                      }
                    }
                  : null,
              style: _mapStyle,
            ),
            if (widget.isTrackingDriver && widget.driverLocation != null)
              Positioned(
                bottom: 16,
                right: 16,
                child: _buildTrackButton(),
              ),
            Positioned(
              bottom: 16,
              left: 16,
              child: _buildLocationButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackButton() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(Icons.my_location, color: AppColors.textOnPrimary),
        onPressed: () {
          if (widget.driverLocation != null) {
            _mapController?.animateCamera(
              CameraUpdate.newLatLng(
                LatLng(
                  widget.driverLocation!.latitude,
                  widget.driverLocation!.longitude,
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildLocationButton() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(Icons.my_location, color: AppColors.primary),
        onPressed: () {
          if (widget.currentLocation != null) {
            _mapController?.animateCamera(
              CameraUpdate.newLatLng(
                LatLng(
                  widget.currentLocation!.latitude,
                  widget.currentLocation!.longitude,
                ),
              ),
            );
          }
        },
      ),
    );
  }

  static const String _mapStyle = '''
  [
    {
      "featureType": "poi",
      "elementType": "labels",
      "stylers": [{"visibility": "off"}]
    }
  ]
  ''';
}