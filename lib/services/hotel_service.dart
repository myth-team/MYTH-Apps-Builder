import 'package:flutter/foundation.dart';
import 'package:golden_stay_app/models/hotel.dart'; 

class HotelService extends ChangeNotifier {
  List<Hotel> _hotels = [];
  List<Hotel> _featuredHotels = [];
  Hotel? _selectedHotel;
  Room? _selectedRoom;
  bool _isLoading = false;
  String? _error;
  
  // Search and filter state
  String _searchQuery = '';
  String _selectedCity = '';
  List<String> _selectedAmenities = [];
  String _sortBy = 'price_asc';
  int _currentPage = 1;
  bool _hasMore = true;

  // Booking state
  DateTime? _checkInDate;
  DateTime? _checkOutDate;
  int _guestCount = 1;
  int _roomCount = 1;
  List<Hotel> _cart = [];

  // Getters
  List<Hotel> get hotels => _hotels;
  List<Hotel> get featuredHotels => _featuredHotels;
  Hotel? get selectedHotel => _selectedHotel;
  Room? get selectedRoom => _selectedRoom;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;
  String get selectedCity => _selectedCity;
  List<String> get selectedAmenities => _selectedAmenities;
  String get sortBy => _sortBy;
  bool get hasMore => _hasMore;
  DateTime? get checkInDate => _checkInDate;
  DateTime? get checkOutDate => _checkOutDate;
  int get guestCount => _guestCount;
  int get roomCount => _roomCount;
  List<Hotel> get cart => _cart;

  HotelService() {
    _loadMockHotels();
  }

  Future<void> _loadMockHotels() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 800));
      
      _hotels = _generateMockHotels();
      _featuredHotels = _hotels.where((h) => h.isFeatured).toList();
      _isLoading = false;
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load hotels: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshHotels() async {
    _currentPage = 1;
    _hasMore = true;
    await _loadMockHotels();
  }

  Future<void> loadMoreHotels() async {
    if (!_hasMore || _isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      final moreHotels = _generateMockHotels(page: _currentPage + 1);
      _hotels.addAll(moreHotels);
      _currentPage++;
      
      if (_currentPage > 3) {
        _hasMore = false;
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load more hotels: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _currentPage = 1;
    _filterHotels();
  }

  void setSelectedCity(String city) {
    _selectedCity = city;
    _currentPage = 1;
    _filterHotels();
  }

  void toggleAmenity(String amenity) {
    if (_selectedAmenities.contains(amenity)) {
      _selectedAmenities.remove(amenity);
    } else {
      _selectedAmenities.add(amenity);
    }
    _currentPage = 1;
    _filterHotels();
  }

  void setSortBy(String sortBy) {
    _sortBy = sortBy;
    _currentPage = 1;
    _filterHotels();
  }

  void _filterHotels() {
    var filtered = List<Hotel>.from(_hotels);

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((hotel) {
        return hotel.name.toLowerCase().contains(query) ||
            hotel.city.toLowerCase().contains(query) ||
            hotel.address.toLowerCase().contains(query);
      }).toList();
    }

    // Filter by city
    if (_selectedCity.isNotEmpty) {
      filtered = filtered.where((hotel) => 
        hotel.city.toLowerCase() == _selectedCity.toLowerCase()
      ).toList();
    }

    // Filter by amenities
    if (_selectedAmenities.isNotEmpty) {
      filtered = filtered.where((hotel) {
        return _selectedAmenities.every((amenity) =>
          hotel.amenities.any((a) => a.toLowerCase().contains(amenity.toLowerCase()))
        );
      }).toList();
    }

    // Sort
    switch (_sortBy) {
      case 'price_asc':
        filtered.sort((a, b) => a.pricePerNight.compareTo(b.pricePerNight));
        break;
      case 'price_desc':
        filtered.sort((a, b) => b.pricePerNight.compareTo(a.pricePerNight));
        break;
      case 'rating':
        filtered.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'reviews':
        filtered.sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
        break;
    }

    _hotels = filtered;
    notifyListeners();
  }

  void selectHotel(Hotel hotel) {
    _selectedHotel = hotel;
    notifyListeners();
  }

  void selectRoom(Room room) {
    _selectedRoom = room;
    notifyListeners();
  }

  void clearSelection() {
    _selectedHotel = null;
    _selectedRoom = null;
    notifyListeners();
  }

  // Booking methods
  void setCheckInDate(DateTime? date) {
    _checkInDate = date;
    notifyListeners();
  }

  void setCheckOutDate(DateTime? date) {
    _checkOutDate = date;
    notifyListeners();
  }

  void setGuestCount(int count) {
    _guestCount = count.clamp(1, 10);
    notifyListeners();
  }

  void setRoomCount(int count) {
    _roomCount = count.clamp(1, 5);
    notifyListeners();
  }

  int get nightsCount {
    if (_checkInDate == null || _checkOutDate == null) return 0;
    return _checkOutDate!.difference(_checkInDate!).inDays;
  }

  double get totalPrice {
    if (_selectedRoom == null || nightsCount == 0) return 0;
    return _selectedRoom!.pricePerNight * _roomCount * nightsCount;
  }

  double get taxAmount => totalPrice * 0.12;

  double get grandTotal => totalPrice + taxAmount;

  String get formattedTotal => '\$${grandTotal.toStringAsFixed(2)}';
  String get formattedTax => '\$${taxAmount.toStringAsFixed(2)}';
  String get formattedSubtotal => '\$${totalPrice.toStringAsFixed(2)}';

  void addToCart(Hotel hotel) {
    if (!_cart.contains(hotel)) {
      _cart.add(hotel);
      notifyListeners();
    }
  }

  void removeFromCart(Hotel hotel) {
    _cart.remove(hotel);
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  Future<bool> confirmBooking() async {
    if (_selectedHotel == null || _selectedRoom == null) return false;
    if (_checkInDate == null || _checkOutDate == null) return false;

    _isLoading = true;
    notifyListeners();

    try {
      // Simulate booking API call
      await Future.delayed(const Duration(seconds: 2));
      
      _isLoading = false;
      
      // Clear booking details but keep the hotel in cart temporarily
      _selectedRoom = null;
      _checkInDate = null;
      _checkOutDate = null;
      _guestCount = 1;
      _roomCount = 1;
      
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to confirm booking: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  List<String> get availableCities {
    return _hotels.map((h) => h.city).toSet().toList()..sort();
  }

  List<String> get availableAmenities {
    final amenities = <String>{};
    for (final hotel in _hotels) {
      amenities.addAll(hotel.amenities);
    }
    return amenities.toList()..sort();
  }

  List<Hotel> searchHotels(String query) {
    if (query.isEmpty) return _hotels;
    final lowerQuery = query.toLowerCase();
    return _hotels.where((hotel) {
      return hotel.name.toLowerCase().contains(lowerQuery) ||
          hotel.city.toLowerCase().contains(lowerQuery) ||
          hotel.address.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  List<Hotel> getHotelsByCity(String city) {
    if (city.isEmpty) return _hotels;
    return _hotels.where((h) => 
      h.city.toLowerCase() == city.toLowerCase()
    ).toList();
  }

  static Hotel? getHotelById(String id) {
    // This is a static method placeholder - in real app would fetch from data
    return null;
  }

  List<Hotel> _generateMockHotels({int page = 1}) {
    final cities = ['Paris', 'London', 'Dubai', 'Tokyo', 'New York', 'Singapore', 'Rome', 'Barcelona'];
    final hotelNames = [
      'The Grand Palace', 'Luxury Suites', 'Royal Hotel', 'Diamond Resort',
      'Platinum Inn', 'Golden Stay', 'Crown Hotel', 'Empress Hotel',
      'Prestige Hotel', 'Majestic Resort', 'Elite Hotel', 'Premier Suites',
      'Regency Hotel', 'Imperial Hotel', 'Sovereign Hotel', 'Grandeur Resort'
    ];
    
    final amenitiesList = [
      ['WiFi', 'Pool', 'Gym', 'Spa', 'Restaurant'],
      ['WiFi', 'Parking', 'Bar', 'Room Service'],
      ['WiFi', 'Pool', 'Beach', 'Spa', 'Restaurant', 'Bar'],
      ['WiFi', 'Gym', 'Business Center', 'Laundry'],
      ['WiFi', 'Pool', 'Pet Friendly', 'Parking'],
      ['WiFi', 'Airport Shuttle', 'Concierge', 'Restaurant'],
    ];

    final baseIndex = (page - 1) * 10;
    final hotels = <Hotel>[];

    for (var i = 0; i < 10; i++) {
      final index = baseIndex + i;
      final city = cities[index % cities.length];
      final name = hotelNames[index % hotelNames.length];
      final amenities = amenitiesList[index % amenitiesList.length];
      
      hotels.add(Hotel(
        id: 'hotel_${index + 1}',
        name: '$name $city',
        description: 'Experience unparalleled luxury at $name $city. '
            'Our exquisite hotel offers world-class amenities, stunning views, '
            'and exceptional service that will make your stay unforgettable.',
        address: '${100 + (index * 10)} ${['Main', 'King', 'Queen', 'Park', 'Ocean'][index % 5]} Street',
        city: city,
        rating: 4.0 + (index % 10) * 0.1,
        reviewCount: 50 + (index * 23),
        pricePerNight: 150.0 + (index * 45),
        images: [
          'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800',
          'https://images.unsplash.com/photo-1582719508461-906c9d6868a4?w=800',
          'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=800',
          'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=800',
        ],
        amenities: amenities,
        rooms: _generateMockRooms('hotel_${index + 1}'),
        thumbnailUrl: 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800',
        isFeatured: index < 4,
      ));
    }

    return hotels;
  }

  List<Room> _generateMockRooms(String hotelId) {
    final roomTypes = [
      ('Standard Room', 'King', 2, 25.0),
      ('Deluxe Room', 'King', 2, 35.0),
      ('Superior Room', 'Queen', 2, 30.0),
      ('Suite', 'King', 3, 50.0),
      ('Executive Suite', 'King', 4, 70.0),
      ('Presidential Suite', 'King', 6, 100.0),
    ];

    return roomTypes.asMap().entries.map((entry) {
      final index = entry.key;
      final type = entry.value;
      return Room(
        id: '${hotelId}_room_$index',
        hotelId: hotelId,
        name: type.$1,
        description: 'Comfortable ${type.$1} with modern amenities and elegant decor. '
            'Perfect for a relaxing stay.',
        maxGuests: type.$3,
        pricePerNight: type.$4 * 10,
        images: [
          'https://images.unsplash.com/photo-1631049307264-da0ec9d70304?w=800',
          'https://images.unsplash.com/photo-1590490360182-c33d57733427?w=800',
        ],
        amenities: ['WiFi', 'TV', 'Air Conditioning', 'Mini Bar', 'Safe'],
        availableCount: index < 3 ? 5 - index : 2,
        size: type.$4 + 10,
        bedType: type.$2,
      );
    }).toList();
  }
}