import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ride_now_app/utils/colors.dart'; 
import 'package:ride_now_app/utils/constants.dart'; 

enum LocationInputType { pickup, destination }

class LocationInput extends StatefulWidget {
  final LocationInputType type;
  final String? hintText;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final VoidCallback? onClear;
  final bool enabled;
  final TextEditingController? controller;

  const LocationInput({
    super.key,
    required this.type,
    this.hintText,
    this.initialValue,
    this.onChanged,
    this.onTap,
    this.onClear,
    this.enabled = true,
    this.controller,
  });

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  late TextEditingController _controller;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController(text: widget.initialValue);
    _hasText = _controller.text.isNotEmpty;
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPickup = widget.type == LocationInputType.pickup;
    final defaultHint = isPickup ? 'Where to?' : 'Enter destination';
    
    return GestureDetector(
      onTap: widget.enabled ? widget.onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingM,
          vertical: AppConstants.spacingS,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          border: Border.all(
            color: AppColors.border,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withAlpha(13),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isPickup 
                    ? AppColors.primary.withAlpha(26)
                    : AppColors.accent.withAlpha(26),
                borderRadius: BorderRadius.circular(AppConstants.radiusS),
              ),
              child: Icon(
                isPickup ? Icons.trip_origin : Icons.location_on_outlined,
                color: isPickup ? AppColors.primary : AppColors.accent,
                size: 20,
              ),
            ),
            const SizedBox(width: AppConstants.spacingS),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isPickup ? 'Pickup' : 'Destination',
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: isPickup ? AppColors.primary : AppColors.accent,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  TextField(
                    controller: _controller,
                    enabled: widget.enabled,
                    onChanged: widget.onChanged,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: widget.hintText ?? defaultHint,
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 14,
                        color: AppColors.textTertiary,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                      fillColor: Colors.transparent,
                      filled: true,
                    ),
                  ),
                ],
              ),
            ),
            if (_hasText && widget.onClear != null)
              GestureDetector(
                onTap: widget.onClear,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.textTertiary.withAlpha(26),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class LocationInputData {
  final String address;
  final double? latitude;
  final double? longitude;
  final String? placeId;

  const LocationInputData({
    required this.address,
    this.latitude,
    this.longitude,
    this.placeId,
  });

  factory LocationInputData.fromJson(Map<String, dynamic> json) {
    return LocationInputData(
      address: json['address'] as String,
      latitude: json['latitude'] as double?,
      longitude: json['longitude'] as double?,
      placeId: json['placeId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'placeId': placeId,
    };
  }
}