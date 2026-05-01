import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'Golden Stay';
  static const String appFullName = 'Golden Stay Luxury Hotels';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';

  static const String baseUrl = 'https://api.goldenstay.com';
  static const String apiVersion = '/api/v1';

  static const Duration animationDurationShort = Duration(milliseconds: 200);
  static const Duration animationDurationMedium = Duration(milliseconds: 350);
  static const Duration animationDurationLong = Duration(milliseconds: 500);

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
  static const double marginXXL = 48.0;

  static const double borderRadiusS = 4.0;
  static const double borderRadiusM = 8.0;
  static const double borderRadiusL = 12.0;
  static const double borderRadiusXL = 16.0;
  static const double borderRadiusRound = 100.0;

  static const double iconSizeS = 16.0;
  static const double iconSizeM = 24.0;
  static const double iconSizeL = 32.0;
  static const double iconSizeXL = 48.0;

  static const double buttonHeightS = 36.0;
  static const double buttonHeightM = 48.0;
  static const double buttonHeightL = 56.0;

  static const double cardElevation = 4.0;
  static const double bottomNavBarHeight = 80.0;
  static const double appBarHeight = 56.0;

  static const String dateFormat = 'yyyy-MM-dd';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm:ss';
  static const String displayDateFormat = 'MMM dd, yyyy';
  static const String displayTimeFormat = 'HH:mm';
  static const String displayDateTimeFormat = 'MMM dd, yyyy at HH:mm';

  static const int maxImageUploadSize = 5242880;
  static const int thumbnailSize = 300;
  static const int mediumImageSize = 800;
  static const int largeImageSize = 1200;

  static const int maxSearchResults = 50;
  static const int defaultPageSize = 20;
  static const int maxRecentSearches = 10;
  static const int maxFavorites = 100;

  static const double minPriceFilter = 0.0;
  static const double maxPriceFilter = 10000.0;
  static const double priceFilterStep = 50.0;

  static const double minRatingFilter = 0.0;
  static const double maxRatingFilter = 5.0;

  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 32;
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 20;

  static const int otpExpirationMinutes = 5;
  static const int maxOtpAttempts = 3;
  static const int otpResendCooldownSeconds = 60;

  static const int bookingCancellationHours = 24;
  static const int bookingModificationHours = 12;

  static const double processingFeePercentage = 2.5;
  static const double taxPercentage = 10.0;
  static const double serviceChargePercentage = 5.0;

  static const List<String> supportedLanguages = [
    'en',
    'es',
    'fr',
    'de',
    'it',
    'pt',
    'ar',
    'zh',
    'ja',
  ];
}

class StorageKeys {
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String userId = 'user_id';
  static const String userEmail = 'user_email';
  static const String userProfile = 'user_profile';
  static const String isLoggedIn = 'is_logged_in';
  static const String isFirstLaunch = 'is_first_launch';
  static const String language = 'language';
  static const String currency = 'currency';
  static const String themeMode = 'theme_mode';
  static const String recentSearches = 'recent_searches';
  static const String favoriteHotelIds = 'favorite_hotel_ids';
  static const String bookingHistory = 'booking_history';
  static const String cartItems = 'cart_items';
  static const String filterPreferences = 'filter_preferences';
}

class ValidationPatterns {
  static final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  static final RegExp phoneRegex = RegExp(
    r'^\+?[1-9]\d{1,14}$',
  );
  static final RegExp passwordRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
  );
  static final RegExp nameRegex = RegExp(
    r'^[a-zA-Z\s\-]+$',
  );
  static final RegExp passportRegex = RegExp(
    r'^[A-Z0-9]{6,9}$',
  );
}

class RoomTypes {
  static const String standard = 'Standard';
  static const String deluxe = 'Deluxe';
  static const String suite = 'Suite';
  static const String juniorSuite = 'Junior Suite';
  static const String presidentialSuite = 'Presidential Suite';
  static const String familyRoom = 'Family Room';
  static const String twin = 'Twin';
  static const String doubleRoom = 'Double';
  static const String single = 'Single';
  static const String penthouse = 'Penthouse';
  static const String bungalow = 'Bungalow';
  static const String villa = 'Villa';

  static const List<String> all = [
    standard,
    deluxe,
    suite,
    juniorSuite,
    presidentialSuite,
    familyRoom,
    twin,
    doubleRoom,
    single,
    penthouse,
    bungalow,
    villa,
  ];
}

class BedTypes {
  static const String single = 'Single';
  static const String double = 'Double';
  static const String twin = 'Twin';
  static const String queen = 'Queen';
  static const String king = 'King';
  static const String californiaKing = 'California King';
  static const String bunk = 'Bunk';

  static const List<String> all = [
    single,
    double,
    twin,
    queen,
    king,
    californiaKing,
    bunk,
  ];
}

class ViewTypes {
  static const String city = 'City View';
  static const String garden = 'Garden View';
  static const String pool = 'Pool View';
  static const String sea = 'Sea View';
  static const String mountain = 'Mountain View';
  static const String river = 'River View';
  static const String forest = 'Forest View';
  static const String beach = 'Beach View';

  static const List<String> all = [
    city,
    garden,
    pool,
    sea,
    mountain,
    river,
    forest,
    beach,
  ];
}

class HotelAmenities {
  static const String wifi = 'WiFi';
  static const String parking = 'Parking';
  static const String pool = 'Pool';
  static const String spa = 'Spa';
  static const String gym = 'Gym';
  static const String restaurant = 'Restaurant';
  static const String bar = 'Bar';
  static const String roomService = 'Room Service';
  static const String concierge = 'Concierge';
  static const String laundry = 'Laundry';
  static const String airportShuttle = 'Airport Shuttle';
  static const String businessCenter = 'Business Center';
  static const String meetingRoom = 'Meeting Room';
  static const String petFriendly = 'Pet Friendly';
  static const String disabledAccess = 'Disabled Access';
  static const String casino = 'Casino';
  static const String beachAccess = 'Beach Access';
  static const String tennis = 'Tennis Court';
  static const String golf = 'Golf Course';
  static const String kidsClub = 'Kids Club';

  static const List<String> all = [
    wifi,
    parking,
    pool,
    spa,
    gym,
    restaurant,
    bar,
    roomService,
    concierge,
    laundry,
    airportShuttle,
    businessCenter,
    meetingRoom,
    petFriendly,
    disabledAccess,
    casino,
    beachAccess,
    tennis,
    golf,
    kidsClub,
  ];
}

class RoomAmenities {
  static const String airConditioning = 'Air Conditioning';
  static const String heating = 'Heating';
  static const String tv = 'TV';
  static const String minibar = 'Minibar';
  static const String safe = 'Safe';
  static const String coffeeMaker = 'Coffee Maker';
  static const String balcony = 'Balcony';
  static const String terrace = 'Terrace';
  static const String jacuzzi = 'Jacuzzi';
  static const String bathtub = 'Bathtub';
  static const String shower = 'Shower';
  static const String workspace = 'Workspace';
  static const String iron = 'Iron';
  static const String hairDryer = 'Hair Dryer';
  static const String toiletries = 'Toiletries';
  static const String bathrobes = 'Bathrobes';
  static const String slippers = 'Slippers';
  static const String soundproof = 'Soundproof';
  static const String wakeUpService = 'Wake-up Service';
  static const String dailyHousekeeping = 'Daily Housekeeping';

  static const List<String> all = [
    airConditioning,
    heating,
    tv,
    minibar,
    safe,
    coffeeMaker,
    balcony,
    terrace,
    jacuzzi,
    bathtub,
    shower,
    workspace,
    iron,
    hairDryer,
    toiletries,
    bathrobes,
    slippers,
    soundproof,
    wakeUpService,
    dailyHousekeeping,
  ];
}

class BookingStatuses {
  static const String pending = 'Pending';
  static const String confirmed = 'Confirmed';
  static const String checkedIn = 'Checked In';
  static const String checkedOut = 'Checked Out';
  static const String cancelled = 'Cancelled';
  static const String noShow = 'No Show';
  static const String refunded = 'Refunded';

  static const List<String> all = [
    pending,
    confirmed,
    checkedIn,
    checkedOut,
    cancelled,
    noShow,
    refunded,
  ];
}

class PaymentStatuses {
  static const String pending = 'Pending';
  static const String processing = 'Processing';
  static const String completed = 'Completed';
  static const String failed = 'Failed';
  static const String refunded = 'Refunded';
  static const String partiallyRefunded = 'Partially Refunded';

  static const List<String> all = [
    pending,
    processing,
    completed,
    failed,
    refunded,
    partiallyRefunded,
  ];
}

class PaymentMethods {
  static const String creditCard = 'Credit Card';
  static const String debitCard = 'Debit Card';
  static const String paypal = 'PayPal';
  static const String applePay = 'Apple Pay';
  static const String googlePay = 'Google Pay';
  static const String bankTransfer = 'Bank Transfer';
  static const String cash = 'Cash';

  static const List<String> all = [
    creditCard,
    debitCard,
    paypal,
    applePay,
    googlePay,
    bankTransfer,
    cash,
  ];
}

class LoyaltyTiers {
  static const String bronze = 'Bronze';
  static const String silver = 'Silver';
  static const String gold = 'Gold';
  static const String platinum = 'Platinum';
  static const String diamond = 'Diamond';

  static const List<String> all = [
    bronze,
    silver,
    gold,
    platinum,
    diamond,
  ];

  static const Map<String, int> tierThresholds = {
    bronze: 0,
    silver: 5000,
    gold: 15000,
    platinum: 50000,
    diamond: 100000,
  };

  static const Map<String, double> tierDiscounts = {
    bronze: 0.0,
    silver: 0.05,
    gold: 0.10,
    platinum: 0.15,
    diamond: 0.20,
  };
}

class Currencies {
  static const String usd = 'USD';
  static const String eur = 'EUR';
  static const String gbp = 'GBP';
  static const String jpy = 'JPY';
  static const String cny = 'CNY';
  static const String aud = 'AUD';
  static const String cad = 'CAD';
  static const String chf = 'CHF';
  static const String sar = 'SAR';
  static const String aed = 'AED';

  static const List<String> all = [
    usd,
    eur,
    gbp,
    jpy,
    cny,
    aud,
    cad,
    chf,
    sar,
    aed,
  ];

  static const Map<String, String> symbols = {
    usd: '\$',
    eur: '€',
    gbp: '£',
    jpy: '¥',
    cny: '¥',
    aud: 'A\$',
    cad: 'C\$',
    chf: 'CHF',
    sar: 'SAR',
    aed: 'AED',
  };
}

class SortOptions {
  static const String recommended = 'Recommended';
  static const String priceLowToHigh = 'Price: Low to High';
  static const String priceHighToLow = 'Price: High to Low';
  static const String ratingHighToLow = 'Rating: High to Low';
  static const String newest = 'Newest';
  static const String mostPopular = 'Most Popular';
  static const String distance = 'Distance';

  static const List<String> all = [
    recommended,
    priceLowToHigh,
    priceHighToLow,
    ratingHighToLow,
    newest,
    mostPopular,
    distance,
  ];
}

class FilterOptions {
  static const double defaultMinPrice = 0.0;
  static const double defaultMaxPrice = 1000.0;
  static const double defaultMinRating = 0.0;
  static const int defaultGuests = 1;
  static const int defaultRooms = 1;
  static const int defaultNights = 1;
}

class ErrorMessages {
  static const String networkError = 'Please check your internet connection and try again.';
  static const String serverError = 'Something went wrong. Please try again later.';
  static const String unauthorized = 'Session expired. Please login again.';
  static const String notFound = 'Resource not found.';
  static const String validationError = 'Please check the form and try again.';
  static const String unknownError = 'An unexpected error occurred.';

  static const String invalidEmail = 'Please enter a valid email address.';
  static const String invalidPassword = 'Password must be at least 8 characters with uppercase, lowercase, number, and special character.';
  static const String invalidPhone = 'Please enter a valid phone number.';
  static const String requiredField = 'This field is required.';
  static const String passwordsDoNotMatch = 'Passwords do not match.';

  static const String noHotelsFound = 'No hotels found matching your criteria.';
  static const String noRoomsAvailable = 'No rooms available for the selected dates.';
  static const String bookingFailed = 'Failed to complete booking. Please try again.';
  static const String paymentFailed = 'Payment failed. Please try again.';
}

class SuccessMessages {
  static const String loginSuccess = 'Welcome back!';
  static const String registerSuccess = 'Account created successfully.';
  static const String bookingSuccess = 'Booking confirmed!';
  static const String profileUpdated = 'Profile updated successfully.';
  static const String passwordChanged = 'Password changed successfully.';
  static const String emailVerified = 'Email verified successfully.';
  static const String favoriteAdded = 'Added to favorites.';
  static const String favoriteRemoved = 'Removed from favorites.';
  static const String reviewSubmitted = 'Review submitted successfully.';
  static const String cancellationSuccess = 'Booking cancelled successfully.';
}

class AssetPaths {
  static const String imagesPath = 'assets/images/';
  static const String iconsPath = 'assets/icons/';
  static const String logosPath = 'assets/logos/';
  static const String animationsPath = 'assets/animations/';

  static const String logo = '${logosPath}logo.png';
  static const String splashLogo = '${logosPath}splash_logo.png';
  static const String profilePlaceholder = '${imagesPath}profile_placeholder.png';
  static const String hotelPlaceholder = '${imagesPath}hotel_placeholder.png';
  static const String roomPlaceholder = '${imagesPath}room_placeholder.png';
  static const String noImage = '${imagesPath}no_image.png';
  static const String emptyState = '${imagesPath}empty_state.png';
  static const String errorState = '${imagesPath}error_state.png';
  static const String successState = '${imagesPath}success_state.png';

  static const String googleIcon = '${iconsPath}google.png';
  static const String appleIcon = '${iconsPath}apple.png';
  static const String facebookIcon = '${iconsPath}facebook.png';
}

class ApiEndpoints {
  static const String authLogin = '/auth/login';
  static const String authRegister = '/auth/register';
  static const String authLogout = '/auth/logout';
  static const String authRefresh = '/auth/refresh';
  static const String authForgotPassword = '/auth/forgot-password';
  static const String authResetPassword = '/auth/reset-password';
  static const String authVerifyEmail = '/auth/verify-email';
  static const String authChangePassword = '/auth/change-password';

  static const String users = '/users';
  static const String userProfile = '/users/profile';
  static const String userPreferences = '/users/preferences';
  static const String userFavorites = '/users/favorites';
  static const String userBookings = '/users/bookings';

  static const String hotels = '/hotels';
  static const String hotelDetail = '/hotels/{id}';
  static const String hotelRooms = '/hotels/{id}/rooms';
  static const String hotelReviews = '/hotels/{id}/reviews';
  static const String hotelAmenities = '/hotels/{id}/amenities';
  static const String hotelImages = '/hotels/{id}/images';

  static const String rooms = '/rooms';
  static const String roomDetail = '/rooms/{id}';
  static const String roomAvailability = '/rooms/{id}/availability';

  static const String bookings = '/bookings';
  static const String bookingDetail = '/bookings/{id}';
  static const String bookingCancel = '/bookings/{id}/cancel';
  static const String bookingModify = '/bookings/{id}/modify';

  static const String payments = '/payments';
  static const String paymentProcess = '/payments/process';
  static const String paymentVerify = '/payments/verify';

  static const String search = '/search';
  static const String suggestions = '/search/suggestions';

  static const String reviews = '/reviews';
  static const String reviewDetail = '/reviews/{id}';

  static const String categories = '/categories';
  static const String destinations = '/destinations';
}