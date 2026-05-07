import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Stylist {
  final String id;
  final String name;
  final String? imageUrl;
  final String bio;
  final List<String> specialties;
  final double rating;
  final int reviewCount;

  Stylist({
    required this.id,
    required this.name,
    this.imageUrl,
    required this.bio,
    required this.specialties,
    required this.rating,
    required this.reviewCount,
  });
}

class Service {
  final String id;
  final String name;
  final String description;
  final double price;
  final int durationMinutes;

  Service({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.durationMinutes,
  });
}

class Booking {
  final String id;
  final String stylistId;
  final String stylistName;
  final String serviceName;
  final DateTime dateTime;
  final double price;
  final String status;

  Booking({
    required this.id,
    required this.stylistId,
    required this.stylistName,
    required this.serviceName,
    required this.dateTime,
    required this.price,
    this.status = 'upcoming',
  });
}

class AppState extends ChangeNotifier {
  late SharedPreferences _prefs;

  // User profile
  String userName = 'Guest User';
  String userPhone = '';
  String membershipTier = 'Silver';
  bool notificationsEnabled = true;

  // App settings
  bool isDarkMode = false;
  String language = 'English';

  // Data
  final List<Stylist> stylists = [];
  final List<Service> services = [];
  final List<Booking> bookings = [];
  final Set<String> favoriteStylistIds = {};

  // UI state
  String? homeFilterSpecialty;
  int currentTabIndex = 0;

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    _prefs = await SharedPreferences.getInstance();

    userName = _prefs.getString('userName') ?? 'Guest User';
    userPhone = _prefs.getString('userPhone') ?? '';
    membershipTier = _prefs.getString('membershipTier') ?? 'Silver';
    notificationsEnabled = _prefs.getBool('notificationsEnabled') ?? true;
    isDarkMode = _prefs.getBool('isDarkMode') ?? false;
    language = _prefs.getString('language') ?? 'English';

    final favs = _prefs.getStringList('favoriteStylistIds');
    if (favs != null) favoriteStylistIds.addAll(favs);

    _loadMockData();
    _initialized = true;
    notifyListeners();
  }

  void _loadMockData() {
    stylists.addAll([
      Stylist(
        id: '1',
        name: 'Sarah Chen',
        imageUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200',
        bio: 'Color specialist with 8 years experience. Loves creating vibrant, personalized looks.',
        specialties: ['Color', 'Balayage', 'Highlights'],
        rating: 4.9,
        reviewCount: 127,
      ),
      Stylist(
        id: '2',
        name: 'Marcus Johnson',
        imageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200',
        bio: 'Precision cuts and modern styles. Award-winning barber turned salon stylist.',
        specialties: ['Precision Cut', 'Fade', 'Beard'],
        rating: 4.8,
        reviewCount: 93,
      ),
      Stylist(
        id: '3',
        name: 'Elena Rodriguez',
        imageUrl: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=200',
        bio: 'Texture and curl expert. Helping clients embrace their natural beauty.',
        specialties: ['Curly Hair', 'Treatment', 'Styling'],
        rating: 4.7,
        reviewCount: 156,
      ),
    ]);

    services.addAll([
      Service(
        id: '1',
        name: 'Signature Haircut',
        description: 'Consultation, wash, precision cut, and style',
        price: 65,
        durationMinutes: 45,
      ),
      Service(
        id: '2',
        name: 'Full Color',
        description: 'Root to tip color application with gloss treatment',
        price: 120,
        durationMinutes: 90,
      ),
      Service(
        id: '3',
        name: 'Balayage',
        description: 'Hand-painted highlights for natural dimension',
        price: 180,
        durationMinutes: 120,
      ),
      Service(
        id: '4',
        name: 'Deep Conditioning',
        description: 'Restorative treatment for damaged hair',
        price: 45,
        durationMinutes: 30,
      ),
    ]);
  }

  // Profile
  Future<void> updateProfile(String name, String phone) async {
    userName = name;
    userPhone = phone;
    await _prefs.setString('userName', name);
    await _prefs.setString('userPhone', phone);
    notifyListeners();
  }

  Future<void> setMembershipTier(String tier) async {
    membershipTier = tier;
    await _prefs.setString('membershipTier', tier);
    notifyListeners();
  }

  // Settings
  Future<void> setDarkMode(bool value) async {
    isDarkMode = value;
    await _prefs.setBool('isDarkMode', value);
    notifyListeners();
  }

  Future<void> setNotifications(bool value) async {
    notificationsEnabled = value;
    await _prefs.setBool('notificationsEnabled', value);
    notifyListeners();
  }

  Future<void> setLanguage(String value) async {
    language = value;
    await _prefs.setString('language', value);
    notifyListeners();
  }

  Future<void> clearAllData() async {
    await _prefs.clear();
    favoriteStylistIds.clear();
    bookings.clear();
    userName = 'Guest User';
    userPhone = '';
    membershipTier = 'Silver';
    notificationsEnabled = true;
    isDarkMode = false;
    language = 'English';
    notifyListeners();
  }

  // Favorites
  Future<void> toggleFavorite(String stylistId) async {
    if (favoriteStylistIds.contains(stylistId)) {
      favoriteStylistIds.remove(stylistId);
    } else {
      favoriteStylistIds.add(stylistId);
    }
    await _prefs.setStringList('favoriteStylistIds', favoriteStylistIds.toList());
    notifyListeners();
  }

  bool isFavorite(String stylistId) => favoriteStylistIds.contains(stylistId);

  List<Stylist> get favoriteStylists =>
      stylists.where((s) => favoriteStylistIds.contains(s.id)).toList();

  // Bookings
  Future<void> addBooking(Booking booking) async {
    bookings.add(booking);
    _persistBookings();
    notifyListeners();
  }

  Future<void> cancelBooking(String id) async {
    final booking = bookings.firstWhere((b) => b.id == id);
    final idx = bookings.indexOf(booking);
    bookings[idx] = Booking(
      id: booking.id,
      stylistId: booking.stylistId,
      stylistName: booking.stylistName,
      serviceName: booking.serviceName,
      dateTime: booking.dateTime,
      price: booking.price,
      status: 'cancelled',
    );
    _persistBookings();
    notifyListeners();
  }

  void _persistBookings() {
    final data = bookings.map((b) => jsonEncode({
      'id': b.id,
      'stylistId': b.stylistId,
      'stylistName': b.stylistName,
      'serviceName': b.serviceName,
      'dateTime': b.dateTime.toIso8601String(),
      'price': b.price,
      'status': b.status,
    })).toList();
    _prefs.setStringList('bookings', data);
  }

  List<Booking> get upcomingBookings => bookings
      .where((b) => b.status == 'upcoming' && b.dateTime.isAfter(DateTime.now()))
      .toList()
    ..sort((a, b) => a.dateTime.compareTo(b.dateTime));

  List<Booking> get pastBookings => bookings
      .where((b) => b.status != 'upcoming' || b.dateTime.isBefore(DateTime.now()))
      .toList()
    ..sort((a, b) => b.dateTime.compareTo(a.dateTime));

  // Explore filter
  void setHomeFilter(String? specialty) {
    homeFilterSpecialty = specialty;
    currentTabIndex = 0;
    notifyListeners();
  }

  void clearHomeFilter() {
    homeFilterSpecialty = null;
    notifyListeners();
  }

  List<Stylist> get filteredStylists {
    if (homeFilterSpecialty == null) return stylists;
    return stylists.where((s) => s.specialties.contains(homeFilterSpecialty)).toList();
  }

  int get currentTab => currentTabIndex;

  void setCurrentTab(int index) {
    currentTabIndex = index;
    notifyListeners();
  }
}