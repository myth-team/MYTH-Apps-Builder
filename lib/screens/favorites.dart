import 'package:flutter/material.dart';
import 'package:golden_stay_app/models/hotel.dart'; 
import 'package:golden_stay_app/utils/colors.dart'; 
import 'package:golden_stay_app/utils/constants.dart'; 
import 'package:golden_stay_app/widgets/hotel_card.dart'; 
import 'package:golden_stay_app/widgets/golden_button.dart'; 
import 'package:golden_stay_app/widgets/custom_text_field.dart'; 

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _sortBy = 'name';
  final List<String> _sortOptions = ['name', 'price_low', 'price_high', 'rating'];

  final List<Hotel> _allFavorites = [
    Hotel(
      id: '1',
      name: 'The Grand Palace',
      description: 'Experience luxury at its finest with stunning views and impeccable service.',
      city: 'Paris',
      country: 'France',
      address: '123 Champs-Élysées, 75008 Paris',
      rating: 4.9,
      reviewCount: 1250,
      pricePerNight: 850.0,
      currency: 'USD',
      images: ['https://example.com/hotel1.jpg'],
      amenities: ['Pool', 'Spa', 'Restaurant', 'WiFi', 'Gym', 'Concierge'],
      totalRooms: 150,
      availableRooms: 12,
      isFeatured: true,
      isAvailable: true,
      latitude: 48.8698,
      longitude: 2.3078,
    ),
    Hotel(
      id: '2',
      name: 'Aurora Sky Tower',
      description: 'Modern luxury towering above the city skyline with panoramic views.',
      city: 'Dubai',
      country: 'UAE',
      address: 'Sheikh Zayed Road, Dubai',
      rating: 4.8,
      reviewCount: 890,
      pricePerNight: 1200.0,
      currency: 'USD',
      images: ['https://example.com/hotel2.jpg'],
      amenities: ['Rooftop Pool', 'Spa', 'Fine Dining', 'WiFi', 'Gym', 'Bar'],
      totalRooms: 200,
      availableRooms: 5,
      isFeatured: true,
      isAvailable: true,
      latitude: 25.1972,
      longitude: 55.2744,
    ),
    Hotel(
      id: '3',
      name: 'Serenity Beach Resort',
      description: 'Beachfront paradise with crystal clear waters and white sandy beaches.',
      city: 'Maldives',
      country: 'Maldives',
      address: 'North Malé Atoll, Malé',
      rating: 5.0,
      reviewCount: 650,
      pricePerNight: 2500.0,
      currency: 'USD',
      images: ['https://example.com/hotel3.jpg'],
      amenities: ['Private Beach', 'Diving Center', 'Spa', 'Restaurant', 'WiFi'],
      totalRooms: 50,
      availableRooms: 3,
      isFeatured: true,
      isAvailable: true,
      latitude: 4.2105,
      longitude: 73.5386,
    ),
    Hotel(
      id: '4',
      name: 'Royal Garden Hotel',
      description: 'Historic elegance meets modern comfort in the heart of London.',
      city: 'London',
      country: 'UK',
      address: '1 Buckingham Palace Road, SW1W 0AZ',
      rating: 4.7,
      reviewCount: 2100,
      pricePerNight: 650.0,
      currency: 'USD',
      images: ['https://example.com/hotel4.jpg'],
      amenities: ['Garden', 'Restaurant', 'Bar', 'WiFi', 'Room Service', 'Concierge'],
      totalRooms: 100,
      availableRooms: 20,
      isFeatured: false,
      isAvailable: true,
      latitude: 51.5014,
      longitude: -0.1419,
    ),
    Hotel(
      id: '5',
      name: 'Alpine Summit Lodge',
      description: 'Mountain retreat offering skiing, hiking, and breathtaking alpine views.',
      city: 'Zurich',
      country: 'Switzerland',
      address: 'Bahnhofstrasse 100, 8001 Zurich',
      rating: 4.6,
      reviewCount: 480,
      pricePerNight: 450.0,
      currency: 'USD',
      images: ['https://example.com/hotel5.jpg'],
      amenities: ['Skiing', 'Hiking', 'Spa', 'Restaurant', 'WiFi', 'Fireplace'],
      totalRooms: 45,
      availableRooms: 15,
      isFeatured: false,
      isAvailable: true,
      latitude: 47.3769,
      longitude: 8.5417,
    ),
  ];

  List<Hotel> get _filteredFavorites {
    List<Hotel> filtered = _allFavorites.where((hotel) {
      if (_searchQuery.isEmpty) return true;
      return hotel.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          hotel.city.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          hotel.country.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    switch (_sortBy) {
      case 'price_low':
        filtered.sort((a, b) => a.pricePerNight.compareTo(b.pricePerNight));
        break;
      case 'price_high':
        filtered.sort((a, b) => b.pricePerNight.compareTo(a.pricePerNight));
        break;
      case 'rating':
        filtered.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      default:
        filtered.sort((a, b) => a.name.compareTo(b.name));
    }

    return filtered;
  }

  void _removeFavorite(String hotelId) {
    setState(() {
      _allFavorites.removeWhere((hotel) => hotel.id == hotelId);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Removed from favorites',
          style: TextStyle(color: AppColors.pureWhite),
        ),
        backgroundColor: AppColors.lightBlack,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

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
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchAndFilter(),
            Expanded(
              child: _filteredFavorites.isEmpty
                  ? _buildEmptyState()
                  : _buildFavoritesList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.darkBlack,
        border: Border(
          bottom: BorderSide(
            color: AppColors.mutedGold.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Favorites',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.pureWhite,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 4),
              Text(
                '${_allFavorites.length} luxury hotels saved',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.mutedGold,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryGold.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.primaryGold.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Icon(
              Icons.favorite,
              color: AppColors.primaryGold,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkBlack,
        border: Border(
          bottom: BorderSide(
            color: AppColors.mutedGold.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: _searchController,
                  hintText: 'Search favorites...',
                  prefixIcon: Icons.search,
                  style: CustomTextFieldStyle.filled,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),
              SizedBox(width: 12),
              GestureDetector(
                onTap: () => _showSortOptions(),
                child: Container(
                  padding: EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.lightBlack,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.mutedGold.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Icons.sort,
                    color: AppColors.primaryGold,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
          if (_sortBy != 'name') ...[
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primaryGold.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.primaryGold.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getSortIcon(),
                    color: AppColors.primaryGold,
                    size: 16,
                  ),
                  SizedBox(width: 8),
                  Text(
                    _getSortLabel(),
                    style: TextStyle(
                      color: AppColors.primaryGold,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _sortBy = 'name';
                      });
                    },
                    child: Icon(
                      Icons.close,
                      color: AppColors.primaryGold,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  IconData _getSortIcon() {
    switch (_sortBy) {
      case 'price_low':
        return Icons.arrow_downward;
      case 'price_high':
        return Icons.arrow_upward;
      case 'rating':
        return Icons.star;
      default:
        return Icons.sort;
    }
  }

  String _getSortLabel() {
    switch (_sortBy) {
      case 'price_low':
        return 'Price: Low to High';
      case 'price_high':
        return 'Price: High to Low';
      case 'rating':
        return 'Highest Rated';
      default:
        return 'Sort';
    }
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkBlack,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: AppColors.mutedGold.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                'Sort By',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.pureWhite,
                ),
              ),
              SizedBox(height: 20),
              _buildSortOption('name', 'Name (A-Z)', Icons.sort_by_alpha),
              _buildSortOption('price_low', 'Price: Low to High', Icons.arrow_downward),
              _buildSortOption('price_high', 'Price: High to Low', Icons.arrow_upward),
              _buildSortOption('rating', 'Highest Rated', Icons.star),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSortOption(String value, String label, IconData icon) {
    bool isSelected = _sortBy == value;
    return InkWell(
      onTap: () {
        setState(() {
          _sortBy = value;
        });
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryGold.withValues(alpha: 0.2)
                    : AppColors.lightBlack,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isSelected ? AppColors.primaryGold : AppColors.mutedGold,
                size: 20,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  color: isSelected ? AppColors.primaryGold : AppColors.pureWhite,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppColors.primaryGold,
                size: 22,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primaryGold.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primaryGold.withValues(alpha: 0.2),
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.favorite_border,
                color: AppColors.primaryGold,
                size: 48,
              ),
            ),
            SizedBox(height: 24),
            Text(
              'No Favorites Yet',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.pureWhite,
                letterSpacing: 1.2,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Start exploring luxury hotels and save your favorites for easy access later.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.mutedGold,
                height: 1.5,
              ),
            ),
            SizedBox(height: 32),
            GoldenButton(
              text: 'Explore Hotels',
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icons.explore,
              width: 200,
              height: 50,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoritesList() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: _filteredFavorites.length,
      itemBuilder: (context, index) {
        final hotel = _filteredFavorites[index];
        return Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: Dismissible(
            key: Key(hotel.id),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              _removeFavorite(hotel.id);
            },
            background: Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 24),
              decoration: BoxDecoration(
                color: Colors.red.shade900,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.delete_outline,
                    color: AppColors.pureWhite,
                    size: 32,
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Remove',
                    style: TextStyle(
                      color: AppColors.pureWhite,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            child: HotelCard(
              hotel: hotel,
              isFavorite: true,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/hotel-detail',
                  arguments: hotel,
                );
              },
              onFavoriteToggle: () {
                _removeFavorite(hotel.id);
              },
            ),
          ),
        );
      },
    );
  }
}