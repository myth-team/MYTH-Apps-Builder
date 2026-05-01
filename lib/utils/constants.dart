class AppConstants {
  // App Info
  static const String appName = 'Ride Now';
  static const String appVersion = '1.0.0';

  // API Endpoints (placeholder)
  static const String baseUrl = 'https://api.ridenow.app';
  static const String apiVersion = '/v1';

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 350);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;

  // Border Radius
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;
  static const double radiusRound = 100.0;

  // Icon Sizes
  static const double iconS = 16.0;
  static const double iconM = 24.0;
  static const double iconL = 32.0;
  static const double iconXL = 48.0;

  // Ride Types
  static const List<RideType> rideTypes = [
    RideType(
      id: 'economy',
      name: 'Economy',
      description: 'Affordable everyday rides',
      icon: 'directions_car',
      baseFare: 5.0,
      perKm: 1.5,
      perMinute: 0.3,
      capacity: 4,
      color: 0xFF6366F1,
    ),
    RideType(
      id: 'comfort',
      name: 'Comfort',
      description: 'Newer cars, extra space',
      icon: 'airline_seat_recline_extra',
      baseFare: 8.0,
      perKm: 2.0,
      perMinute: 0.4,
      capacity: 4,
      color: 0xFF8B5CF6,
    ),
    RideType(
      id: 'premium',
      name: 'Premium',
      description: 'Luxury vehicles',
      icon: 'star',
      baseFare: 15.0,
      perKm: 3.0,
      perMinute: 0.6,
      capacity: 3,
      color: 0xFFEC4899,
    ),
    RideType(
      id: 'luxury',
      name: 'Luxury',
      description: 'Premium experience',
      icon: 'diamond',
      baseFare: 25.0,
      perKm: 5.0,
      perMinute: 1.0,
      capacity: 2,
      color: 0xFFF59E0B,
    ),
  ];

  // Promotions
  static const List<Promotion> promotions = [
    Promotion(
      id: 'promo1',
      title: '50% OFF',
      subtitle: 'First 3 rides',
      description: 'Get 50% off on your first 3 rides',
      code: 'FIRST50',
      discount: 50,
      minDistance: 2,
    ),
    Promotion(
      id: 'promo2',
      title: 'FREE RIDE',
      subtitle: 'Refer a friend',
      description: 'Get a free ride for every friend you refer',
      code: 'FREERIDE',
      discount: 100,
      minDistance: 0,
    ),
  ];

  // Recent Rides Limit
  static const int recentRidesLimit = 10;
}

class RideType {
  final String id;
  final String name;
  final String description;
  final String icon;
  final double baseFare;
  final double perKm;
  final double perMinute;
  final int capacity;
  final int color;

  const RideType({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.baseFare,
    required this.perKm,
    required this.perMinute,
    required this.capacity,
    required this.color,
  });

  double calculateFare(double distanceKm, int durationMinutes) {
    return baseFare + (distanceKm * perKm) + (durationMinutes * perMinute);
  }
}

class Promotion {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final String code;
  final int discount;
  final int minDistance;

  const Promotion({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.code,
    required this.discount,
    required this.minDistance,
  });
}