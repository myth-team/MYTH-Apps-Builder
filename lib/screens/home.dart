import 'package:flutter/material.dart';
import 'package:golden_stay_app/models/hotel.dart'; 
import 'package:golden_stay_app/utils/colors.dart'; 
import 'package:golden_stay_app/utils/constants.dart'; 
import 'package:golden_stay_app/widgets/hotel_card.dart'; 
import 'package:golden_stay_app/widgets/golden_button.dart'; 

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedIndex = 0;

  final List<Hotel> _featuredHotels = [
    Hotel(
      id: '1',
      name: 'The Grand Palace',
      description: 'Experience luxury at its finest with breathtaking views and world-class amenities.',
      city: 'Paris',
      country: 'France',
      address: '123 Champs-Élysées, Paris',
      rating: 4.9,
      reviewCount: 1250,
      pricePerNight: 850.0,
      currency: 'USD',
      images: ['https://example.com/hotel1.jpg'],
      amenities: ['Spa', 'Pool', 'Restaurant', 'WiFi', 'Gym'],
      totalRooms: 150,
      availableRooms: 23,
      isFeatured: true,
      isAvailable: true,
      latitude: 48.8566,
      longitude: 2.3522,
    ),
    Hotel(
      id: '2',
      name: 'Golden Tower Resort',
      description: 'A stunning beachfront property with pristine sands and azure waters.',
      city: 'Dubai',
      country: 'UAE',
      address: 'Jumeirah Beach Road, Dubai',
      rating: 4.8,
      reviewCount: 890,
      pricePerNight: 1200.0,
      currency: 'USD',
      images: ['https://example.com/hotel2.jpg'],
      amenities: ['Beach', 'Pool', 'Spa', 'Restaurant', 'WiFi'],
      totalRooms: 200,
      availableRooms: 45,
      isFeatured: true,
      isAvailable: true,
      latitude: 25.2048,
      longitude: 55.2708,
    ),
    Hotel(
      id: '3',
      name: 'Royal Mansour',
      description: 'An iconic palace hotel offering unparalleled Moroccan hospitality.',
      city: 'Marrakech',
      country: 'Morocco',
      address: 'Avenue Houmane El Fetaoui, Marrakech',
      rating: 4.9,
      reviewCount: 720,
      pricePerNight: 950.0,
      currency: 'USD',
      images: ['https://example.com/hotel3.jpg'],
      amenities: ['Spa', 'Pool', 'Restaurant', 'WiFi', 'Concierge'],
      totalRooms: 80,
      availableRooms: 12,
      isFeatured: true,
      isAvailable: true,
      latitude: 31.6295,
      longitude: -7.9811,
    ),
  ];

  final List<Hotel> _popularHotels = [
    Hotel(
      id: '4',
      name: 'Metropolitan Hotel',
      description: 'Modern luxury in the heart of the city.',
      city: 'New York',
      country: 'USA',
      address: 'Times Square, New York',
      rating: 4.7,
      reviewCount: 2100,
      pricePerNight: 650.0,
      currency: 'USD',
      images: ['https://example.com/hotel4.jpg'],
      amenities: ['Gym', 'Restaurant', 'WiFi', 'Bar'],
      totalRooms: 300,
      availableRooms: 67,
      isFeatured: false,
      isAvailable: true,
      latitude: 40.7580,
      longitude: -73.9855,
    ),
    Hotel(
      id: '5',
      name: 'Azure Bay Resort',
      description: 'Tropical paradise with crystal clear waters.',
      city: 'Maldives',
      country: 'Maldives',
      address: 'North Malé Atoll, Maldives',
      rating: 4.9,
      reviewCount: 550,
      pricePerNight: 1500.0,
      currency: 'USD',
      images: ['https://example.com/hotel5.jpg'],
      amenities: ['Beach', 'Pool', 'Spa', 'Diving', 'Restaurant'],
      totalRooms: 50,
      availableRooms: 8,
      isFeatured: false,
      isAvailable: true,
      latitude: 4.2105,
      longitude: 73.5386,
    ),
    Hotel(
      id: '6',
      name: 'Alpine Lodge',
      description: 'Mountain retreat with stunning snow views.',
      city: 'Zurich',
      country: 'Switzerland',
      address: 'Bahnhofstrasse, Zurich',
      rating: 4.6,
      reviewCount: 430,
      pricePerNight: 480.0,
      currency: 'USD',
      images: ['https://example.com/hotel6.jpg'],
      amenities: ['Ski', 'Spa', 'Restaurant', 'WiFi', 'Fireplace'],
      totalRooms: 75,
      availableRooms: 20,
      isFeatured: false,
      isAvailable: true,
      latitude: 47.3769,
      longitude: 8.5417,
    ),
  ];

  final List<String> _destinations = [
    'Paris',
    'Dubai',
    'Maldives',
    'New York',
    'Tokyo',
    'London',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _buildHeader(),
            ),
            SliverToBoxAdapter(
              child: _buildSearchSection(),
            ),
            SliverToBoxAdapter(
              child: _buildQuickActions(),
            ),
            SliverToBoxAdapter(
              child: _buildDestinations(),
            ),
            SliverToBoxAdapter(
              child: _buildFeaturedSection(),
            ),
            SliverToBoxAdapter(
              child: _buildPopularSection(),
            ),
            SliverToBoxAdapter(
              child: _buildSpecialOffers(),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: 80),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome to',
                style: TextStyle(
                  color: AppColors.mutedGold,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 4),
              Text(
                AppConstants.appFullName,
                style: TextStyle(
                  color: AppColors.primaryGold,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.lightBlack,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: AppColors.primaryGold,
                width: 2,
              ),
            ),
            child: Icon(
              Icons.person,
              color: AppColors.primaryGold,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSection() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Find Your Perfect Stay',
            style: TextStyle(
              color: AppColors.pureWhite,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: AppColors.lightBlack,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.primaryGold.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    style: TextStyle(
                      color: AppColors.pureWhite,
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search destinations, hotels...',
                      hintStyle: TextStyle(
                        color: AppColors.mutedGold.withOpacity(0.6),
                        fontSize: 14,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: AppColors.primaryGold,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 50,
                  height: 50,
                  margin: EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGold,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.tune,
                    color: AppColors.primaryBlack,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildDateCard(
                  icon: Icons.calendar_today,
                  label: 'Check-in',
                  date: 'Select date',
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildDateCard(
                  icon: Icons.calendar_today,
                  label: 'Check-out',
                  date: 'Select date',
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildDateCard(
                  icon: Icons.person_outline,
                  label: 'Guests',
                  date: '2 Guests',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateCard({
    required IconData icon,
    required String label,
    required String date,
  }) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.lightBlack,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primaryGold.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: AppColors.primaryGold,
                size: 14,
              ),
              SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  color: AppColors.mutedGold,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(
            date,
            style: TextStyle(
              color: AppColors.pureWhite,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildQuickActionItem(
            icon: Icons.hotel,
            label: 'Hotels',
            isSelected: true,
          ),
          _buildQuickActionItem(
            icon: Icons.flight,
            label: 'Flights',
            isSelected: false,
          ),
          _buildQuickActionItem(
            icon: Icons.restaurant,
            label: 'Dining',
            isSelected: false,
          ),
          _buildQuickActionItem(
            icon: Icons.spa,
            label: 'Spa',
            isSelected: false,
          ),
          _buildQuickActionItem(
            icon: Icons.more_horiz,
            label: 'More',
            isSelected: false,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionItem({
    required IconData icon,
    required String label,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryGold : AppColors.lightBlack,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryGold
                : AppColors.primaryGold.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primaryBlack : AppColors.primaryGold,
              size: 24,
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color:
                    isSelected ? AppColors.primaryBlack : AppColors.pureWhite,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDestinations() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Popular Destinations',
                style: TextStyle(
                  color: AppColors.pureWhite,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'See All',
                style: TextStyle(
                  color: AppColors.primaryGold,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _destinations.length,
              itemBuilder: (context, index) {
                return _buildDestinationCard(_destinations[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDestinationCard(String destination) {
    return Container(
      width: 100,
      margin: EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primaryGold.withOpacity(0.8),
            AppColors.darkGold,
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 12,
            left: 12,
            right: 12,
            child: Text(
              destination,
              style: TextStyle(
                color: AppColors.primaryBlack,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.primaryBlack.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.star,
                color: AppColors.lightGold,
                size: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedSection() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.auto_awesome,
                    color: AppColors.primaryGold,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Featured Hotels',
                    style: TextStyle(
                      color: AppColors.pureWhite,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Text(
                'See All',
                style: TextStyle(
                  color: AppColors.primaryGold,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          SizedBox(
            height: 280,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _featuredHotels.length,
              itemBuilder: (context, index) {
                final hotel = _featuredHotels[index];
                return Container(
                  width: 240,
                  margin: EdgeInsets.only(right: 16),
                  child: HotelCard(
                    hotel: hotel,
                    onTap: () {},
                    isFavorite: false,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularSection() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.trending_up,
                    color: AppColors.primaryGold,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Popular Hotels',
                    style: TextStyle(
                      color: AppColors.pureWhite,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Text(
                'See All',
                style: TextStyle(
                  color: AppColors.primaryGold,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _popularHotels.length,
            itemBuilder: (context, index) {
              final hotel = _popularHotels[index];
              return Container(
                margin: EdgeInsets.only(bottom: 16),
                child: HotelCard(
                  hotel: hotel,
                  onTap: () {},
                  isFavorite: index == 0,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialOffers() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.local_offer,
                color: AppColors.primaryGold,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'Special Offers',
                style: TextStyle(
                  color: AppColors.pureWhite,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primaryGold,
                  AppColors.darkGold,
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlack,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Limited Time',
                    style: TextStyle(
                      color: AppColors.primaryGold,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Get 30% Off',
                  style: TextStyle(
                    color: AppColors.primaryBlack,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'On your first luxury booking',
                  style: TextStyle(
                    color: AppColors.primaryBlack.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 16),
                GoldenButton(
                  text: 'Book Now',
                  onPressed: () {},
                  style: GoldenButtonStyle.filled,
                  width: 120,
                  height: 40,
                  fontSize: 14,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkBlack,
        border: Border(
          top: BorderSide(
            color: AppColors.primaryGold.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Container(
          height: 60,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: Icons.home,
                label: 'Home',
                isSelected: _selectedIndex == 0,
                index: 0,
              ),
              _buildNavItem(
                icon: Icons.search,
                label: 'Search',
                isSelected: _selectedIndex == 1,
                index: 1,
              ),
              _buildNavItem(
                icon: Icons.favorite,
                label: 'Favorites',
                isSelected: _selectedIndex == 2,
                index: 2,
              ),
              _buildNavItem(
                icon: Icons.receipt_long,
                label: 'Bookings',
                isSelected: _selectedIndex == 3,
                index: 3,
              ),
              _buildNavItem(
                icon: Icons.person,
                label: 'Profile',
                isSelected: _selectedIndex == 4,
                index: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required int index,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryGold.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primaryGold : AppColors.mutedGold,
              size: 24,
            ),
            SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.primaryGold : AppColors.mutedGold,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
</widget>