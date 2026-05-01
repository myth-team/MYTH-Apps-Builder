import 'package:flutter/material.dart';

class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'RideNow';
  static const String appVersion = '1.0.0';

  // API Configuration
  static const String baseUrl = 'https://api.ridenow.app';
  static const String apiVersion = 'v1';
  static const Duration apiTimeout = Duration(seconds: 30);

  // Animation Durations
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);
  static const Duration splashDuration = Duration(seconds: 2);

  // Padding & Margin
  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double paddingXL = 32.0;
  static const double paddingXXL = 48.0;

  static const double marginXS = 4.0;
  static const double marginS = 8.0;
  static const double marginM = 16.0;
  static const double marginL = 24.0;
  static const double marginXL = 32.0;

  // Border Radius
  static const double radiusXS = 4.0;
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;
  static const double radiusFull = 100.0;

  static const BorderRadius borderRadiusXS = BorderRadius.all(Radius.circular(4.0));
  static const BorderRadius borderRadiusS = BorderRadius.all(Radius.circular(8.0));
  static const BorderRadius borderRadiusM = BorderRadius.all(Radius.circular(12.0));
  static const BorderRadius borderRadiusL = BorderRadius.all(Radius.circular(16.0));
  static const BorderRadius borderRadiusXL = BorderRadius.all(Radius.circular(24.0));

  // Icon Sizes
  static const double iconXS = 16.0;
  static const double iconS = 20.0;
  static const double iconM = 24.0;
  static const double iconL = 32.0;
  static const double iconXL = 48.0;
  static const double iconXXL = 64.0;

  // Font Sizes
  static const double fontXS = 10.0;
  static const double fontS = 12.0;
  static const double fontM = 14.0;
  static const double fontL = 16.0;
  static const double fontXL = 18.0;
  static const double fontXXL = 24.0;
  static const double fontDisplay = 32.0;
  static const double fontTitle = 28.0;

  // Font Weights
  static const FontWeight fontWeightLight = FontWeight.w300;
  static const FontWeight fontWeightRegular = FontWeight.w400;
  static const FontWeight fontWeightMedium = FontWeight.w500;
  static const FontWeight fontWeightSemiBold = FontWeight.w600;
  static const FontWeight fontWeightBold = FontWeight.w700;

  // Elevation
  static const double elevationNone = 0.0;
  static const double elevationS = 2.0;
  static const double elevationM = 4.0;
  static const double elevationL = 8.0;
  static const double elevationXL = 16.0;

  // Map Configuration
  static const double defaultMapZoom = 15.0;
  static const double minMapZoom = 10.0;
  static const double maxMapZoom = 20.0;
  static const double defaultMapLat = 37.7749;
  static const double defaultMapLng = -122.4194;
  static const double driverMarkerRotation = 0.0;
  static const double driverMarkerSize = 40.0;

  // Ride Configuration
  static const double baseFare = 5.0;
  static const double perKmRate = 1.5;
  static const double perMinuteRate = 0.3;
  static const double minimumFare = 8.0;
  static const double cancellationFee = 5.0;
  static const int driverSearchRadius = 5000;
  static const int driverSearchTimeout = 30;

  // Ride Types
  static const String rideTypeEconomy = 'economy';
  static const String rideTypeComfort = 'comfort';
  static const String rideTypePremium = 'premium';
  static const String rideTypeXL = 'xl';

  static const Map<String, double> rideTypeBaseFares = {
    rideTypeEconomy: 5.0,
    rideTypeComfort: 8.0,
    rideTypePremium: 15.0,
    rideTypeXL: 12.0,
  };

  static const Map<String, double> rideTypePerKmRates = {
    rideTypeEconomy: 1.5,
    rideTypeComfort: 2.0,
    rideTypePremium: 3.5,
    rideTypeXL: 2.5,
  };

  static const Map<String, double> rideTypePerMinuteRates = {
    rideTypeEconomy: 0.3,
    rideTypeComfort: 0.4,
    rideTypePremium: 0.6,
    rideTypeXL: 0.5,
  };

  static const Map<String, int> rideTypeMaxPassengers = {
    rideTypeEconomy: 4,
    rideTypeComfort: 4,
    rideTypePremium: 3,
    rideTypeXL: 6,
  };

  static const Map<String, String> rideTypeDisplayNames = {
    rideTypeEconomy: 'Economy',
    rideTypeComfort: 'Comfort',
    rideTypePremium: 'Premium',
    rideTypeXL: 'XL',
  };

  // Ride Status
  static const String statusPending = 'pending';
  static const String statusAccepted = 'accepted';
  static const String statusDriverAssigned = 'driver_assigned';
  static const String statusArriving = 'arriving';
  static const String statusArrived = 'arrived';
  static const String statusInProgress = 'in_progress';
  static const String statusCompleted = 'completed';
  static const String statusCancelled = 'cancelled';

  static const Map<String, String> rideStatusDisplayNames = {
    statusPending: 'Finding Driver',
    statusAccepted: 'Driver Accepted',
    statusDriverAssigned: 'Driver Assigned',
    statusArriving: 'Driver Arriving',
    statusArrived: 'Driver Arrived',
    statusInProgress: 'Ride in Progress',
    statusCompleted: 'Ride Completed',
    statusCancelled: 'Ride Cancelled',
  };

  // Payment Methods
  static const String paymentMethodCash = 'cash';
  static const String paymentMethodCard = 'card';
  static const String paymentMethodWallet = 'wallet';

  static const List<String> paymentMethods = [
    paymentMethodCash,
    paymentMethodCard,
    paymentMethodWallet,
  ];

  // Validation
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 32;
  static const int minNameLength = 2;
  static const int maxNameLength = 50;
  static const int phoneNumberLength = 10;

  // Date/Time Formats
  static const String dateFormatShort = 'MMM dd';
  static const String dateFormatMedium = 'MMM dd, yyyy';
  static const String dateFormatLong = 'EEEE, MMMM dd, yyyy';
  static const String timeFormat12h = 'hh:mm a';
  static const String timeFormat24h = 'HH:mm';
  static const String dateTimeFormat = 'MMM dd, yyyy hh:mm a';

  // Storage Keys
  static const String storageKeyUserToken = 'user_token';
  static const String storageKeyUserId = 'user_id';
  static const String storageKeyUserProfile = 'user_profile';
  static const String storageKeyRecentLocations = 'recent_locations';
  static const String storageKeyFavoriteLocations = 'favorite_locations';
  static const String storageKeySelectedPaymentMethod = 'selected_payment_method';
  static const String storageKeyAppSettings = 'app_settings';

  // Default Values
  static const String defaultPaymentMethod = paymentMethodCash;
  static const int defaultSearchResultCount = 10;
  static const double defaultRadius = 1000.0;

  // Social Links
  static const String supportPhone = '+1-800-RIDE-NOW';
  static const String supportEmail = 'support@ridenow.app';
  static const String termsOfServiceUrl = 'https://ridenow.app/terms';
  static const String privacyPolicyUrl = 'https://ridenow.app/privacy';
  static const String websiteUrl = 'https://ridenow.app';

  // Asset Paths
  static const String assetPathImages = 'assets/images';
  static const String assetPathIcons = 'assets/icons';
  static const String assetPathAnimations = 'assets/animations';

  // Placeholder Images
  static const String placeholderProfile = '$assetPathImages/profile_placeholder.png';
  static const String placeholderCar = '$assetPathImages/car_placeholder.png';
  static const String placeholderMap = '$assetPathImages/map_placeholder.png';

  // Rating
  static const double minRating = 1.0;
  static const double maxRating = 5.0;
  static const double defaultRating = 5.0;

  // Ride History
  static const int maxRideHistoryItems = 100;
  static const int defaultPageSize = 20;

  // Location
  static const double defaultLatitude = 37.7749;
  static const double defaultLongitude = -122.4194;
  static const double defaultLocationAccuracy = 50.0;
  static const int locationUpdateInterval = 5000;
  static const int locationDistanceFilter = 10;
}
```dart
import 'package:flutter/material.dart';

class AppConstants {
  AppConstants._();

  static const String appName = 'RideNow';
  static const String appVersion = '1.0.0';

  static const String baseUrl = 'https://api.ridenow.app';
  static const String apiVersion = 'v1';
  static const Duration apiTimeout = Duration(seconds: 30);

  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);
  static const Duration splashDuration = Duration(seconds: 2);

  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double paddingXL = 32.0;
  static const double paddingXXL = 48.0;

  static const double marginXS = 4.0;
  static const double marginS = 8.0;
  static const double marginM = 16.0;
  static const double marginL = 24.0;
  static const double marginXL = 32.0;

  static const double radiusXS = 4.0;
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;
  static const double radiusFull = 100.0;

  static const BorderRadius borderRadiusXS = BorderRadius.all(Radius.circular(4.0));
  static const BorderRadius borderRadiusS = BorderRadius.all(Radius.circular(8.0));
  static const BorderRadius borderRadiusM = BorderRadius.all(Radius.circular(12.0));
  static const BorderRadius borderRadiusL = BorderRadius.all(Radius.circular(16.0));
  static const BorderRadius borderRadiusXL = BorderRadius.all(Radius.circular(24.0));

  static const double iconXS = 16.0;
  static const double iconS = 20.0;
  static const double iconM = 24.0;
  static const double iconL = 32.0;
  static const double iconXL = 48.0;
  static const double iconXXL = 64.0;

  static const double fontXS = 10.0;
  static const double fontS = 12.0;
  static const double fontM = 14.0;
  static const double fontL = 16.0;
  static const double fontXL = 18.0;
  static const double fontXXL = 24.0;
  static const double fontDisplay = 32.0;
  static const double fontTitle = 28.0;

  static const FontWeight fontWeightLight = FontWeight.w300;
  static const FontWeight fontWeightRegular = FontWeight.w400;
  static const FontWeight fontWeightMedium = FontWeight.w500;
  static const FontWeight fontWeightSemiBold = FontWeight.w600;
  static const FontWeight fontWeightBold = FontWeight.w700;

  static const double elevationNone = 0.0;
  static const double elevationS = 2.0;
  static const double elevationM = 4.0;
  static const double elevationL = 8.0;
  static const double elevationXL = 16.0;

  static const double defaultMapZoom = 15.0;
  static const double minMapZoom = 10.0;
  static const double maxMapZoom = 20.0;
  static const double defaultMapLat = 37.7749;
  static const double defaultMapLng = -122.4194;
  static const double driverMarkerRotation = 0.0;
  static const double driverMarkerSize = 40.0;

  static const double baseFare = 5.0;
  static const double perKmRate = 1.5;
  static const double perMinuteRate = 0.3;
  static const double minimumFare = 8.0;
  static const double cancellationFee = 5.0;
  static const int driverSearchRadius = 5000;
  static const int driverSearchTimeout = 30;

  static const String rideTypeEconomy = 'economy';
  static const String rideTypeComfort = 'comfort';
  static const String rideTypePremium = 'premium';
  static const String rideTypeXL = 'xl';

  static const Map<String, double> rideTypeBaseFares = {
    rideTypeEconomy: 5.0,
    rideTypeComfort: 8.0,
    rideTypePremium: 15.0,
    rideTypeXL: 12.0,
  };

  static const Map<String, double> rideTypePerKmRates = {
    rideTypeEconomy: 1.5,
    rideTypeComfort: 2.0,
    rideTypePremium: 3.5,
    rideTypeXL: 2.5,
  };

  static const Map<String, double> rideTypePerMinuteRates = {
    rideTypeEconomy: 0.3,
    rideTypeComfort: 0.4,
    rideTypePremium: 0.6,
    rideTypeXL: 0.5,
  };

  static const Map<String, int> rideTypeMaxPassengers = {
    rideTypeEconomy: 4,
    rideTypeComfort: 4,
    rideTypePremium: 3,
    rideTypeXL: 6,
  };

  static const Map<String, String> rideTypeDisplayNames = {
    rideTypeEconomy: 'Economy',
    rideTypeComfort: 'Comfort',
    rideTypePremium: 'Premium',
    rideTypeXL: 'XL',
  };

  static const String statusPending = 'pending';
  static const String statusAccepted = 'accepted';
  static const String statusDriverAssigned = 'driver_assigned';
  static const String statusArriving = 'arriving';
  static const String statusArrived = 'arrived';
  static const String statusInProgress = 'in_progress';
  static const String statusCompleted = 'completed';
  static const String statusCancelled = 'cancelled';

  static const Map<String, String> rideStatusDisplayNames = {
    statusPending: 'Finding Driver',
    statusAccepted: 'Driver Accepted',
    statusDriverAssigned: 'Driver Assigned',
    statusArriving: 'Driver Arriving',
    statusArrived: 'Driver Arrived',
    statusInProgress: 'Ride in Progress',
    statusCompleted: 'Ride Completed',
    statusCancelled: 'Ride Cancelled',
  };

  static const String paymentMethodCash = 'cash';
  static const String paymentMethodCard = 'card';
  static const String paymentMethodWallet = 'wallet';

  static const List<String> paymentMethods = <String>[
    paymentMethodCash,
    paymentMethodCard,
    paymentMethodWallet,
  ];

  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 32;
  static const int minNameLength = 2;
  static const int maxNameLength = 50;
  static const int phoneNumberLength = 10;

  static const String dateFormatShort = 'MMM dd';
  static const String dateFormatMedium = 'MMM dd, yyyy';
  static const String dateFormatLong = 'EEEE, MMMM dd, yyyy';
  static const String timeFormat12h = 'hh:mm a';
  static const String timeFormat24h = 'HH:mm';
  static const String dateTimeFormat = 'MMM dd, yyyy hh:mm a';

  static const String storageKeyUserToken = 'user_token';
  static const String storageKeyUserId = 'user_id';
  static const String storageKeyUserProfile = 'user_profile';
  static const String storageKeyRecentLocations = 'recent_locations';
  static const String storageKeyFavoriteLocations = 'favorite_locations';
  static const String storageKeySelectedPaymentMethod = 'selected_payment_method';
  static const String storageKeyAppSettings = 'app_settings';

  static const String defaultPaymentMethod = paymentMethodCash;
  static const int defaultSearchResultCount = 10;
  static const double defaultRadius = 1000.0;

  static const String supportPhone = '+1-800-RIDE-NOW';
  static const String supportEmail = 'support@ridenow.app';
  static const String termsOfServiceUrl = 'https://ridenow.app/terms';
  static const String privacyPolicyUrl = 'https://ridenow.app/privacy';
  static const String websiteUrl = 'https://ridenow.app';

  static const String assetPathImages = 'assets/images';
  static const String assetPathIcons = 'assets/icons';
  static const String assetPathAnimations = 'assets/animations';

  static const String placeholderProfile = 'assets/images/profile_placeholder.png';
  static const String placeholderCar = 'assets/images/car_placeholder.png';
  static const String placeholderMap = 'assets/images/map_placeholder.png';

  static const double minRating = 1.0;
  static const double maxRating = 5.0;
  static const double defaultRating = 5.0;

  static const int maxRideHistoryItems = 100;
  static const int defaultPageSize = 20;

  static const double defaultLatitude = 37.7749;
  static const double defaultLongitude = -122.4194;
  static const double defaultLocationAccuracy = 50.0;
  static const int locationUpdateInterval = 5000;
  static const int locationDistanceFilter = 10;
}