import 'package:flutter/material.dart';
import 'package:golden_stay_app/models/hotel.dart'; 
import 'package:golden_stay_app/utils/colors.dart'; 
import 'package:golden_stay_app/utils/constants.dart'; 
import 'package:golden_stay_app/widgets/hotel_card.dart'; 
import 'package:golden_stay_app/widgets/golden_button.dart'; 
import 'package:golden_stay_app/widgets/custom_text_field.dart'; 

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _recentSearches = [
    'Paris',
    'London',
    'Dubai',
    'New York',
  ];
  final List<Map<String, dynamic>> _popularDestinations = [
    {'name': 'Paris', 'country': 'France', 'image': 'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?w=400'},
    {'name': 'Tokyo', 'country': 'Japan', 'image': 'https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400'},
    {'name': 'New York', 'country': 'USA', 'image': 'https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=400'},
    {'name': 'Dubai', 'country': 'UAE', 'image': 'https://images.unsplash.com/photo-1512453979798-5ea266f8880c?w=400'},
  ];
  List<Hotel> _searchResults = [];
  bool _isSearching = false;
  String _selectedSortBy = 'recommended';
  double _minPrice = 0;
  double _maxPrice = 1000;
  int _selectedRating = 0;
  List<String> _selectedAmenities = [];

  final List<Hotel> _mockHotels = [
    Hotel(
      id: '1',
      name: 'The Grand Palace Hotel',
      description: 'Experience luxury at its finest with stunning views and world-class amenities.',
      city: 'Paris',
      country: 'France',
      address: '123 Champs-Élysées, Paris',
      rating: 4.8,
      reviewCount: 1250,
      pricePerNight: 450.0,
      currency: 'USD',
      images: ['https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800'],
      amenities: ['WiFi', 'Pool', 'Spa', 'Restaurant', 'Gym', 'Room Service'],
      totalRooms: 150,
      availableRooms: 23,
      isFeatured: true,
      isAvailable: true,
      latitude: 48.8566,
      longitude: 2.3522,
    ),
    Hotel(
      id: '2',
      name: 'Skyline Luxury Suites',
      description: 'Modern luxury suites with breathtaking city views and premium services.',
      city: 'New York',
      country: 'USA',
      address: '456 Manhattan Ave, New York',
      rating: 4.6,
      reviewCount: 890,
      pricePerNight: 380.0,
      currency: 'USD',
      images: ['https://images.unsplash.com/photo-1582719508461-905c673771fd?w=800'],
      amenities: ['WiFi', 'Gym', 'Bar', 'Concierge', 'Parking'],
      totalRooms: 80,
      availableRooms: 12,
      isFeatured: true,
      isAvailable: true,
      latitude: 40.7128,
      longitude: -74.0060,
    ),
    Hotel(
      id: '3',
      name: 'Desert Oasis Resort',
      description: 'A serene escape in the heart of the desert with luxurious accommodations.',
      city: 'Dubai',
      country: 'UAE',
      address: '789 Palm Jumeirah, Dubai',
      rating: 4.9,
      reviewCount: 2100,
      pricePerNight: 650.0,
      currency: 'USD',
      images: ['https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=800'],
      amenities: ['WiFi', 'Pool', 'Beach', 'Spa', 'Restaurant', 'Gym', 'Tennis'],
      totalRooms: 200,
      availableRooms: 45,
      isFeatured: true,
      isAvailable: true,
      latitude: 25.2048,
      longitude: 55.2708,
    ),
    Hotel(
      id: '4',
      name: 'Cherry Blossom Inn',
      description: 'Traditional Japanese hospitality meets modern luxury.',
      city: 'Tokyo',
      country: 'Japan',
      address: '321 Shibuya, Tokyo',
      rating: 4.7,
      reviewCount: 650,
      pricePerNight: 280.0,
      currency: 'USD',
      images: ['https://images.unsplash.com/photo-1590490360182-c33d57733427?w=800'],
      amenities: ['WiFi', 'Onsen', 'Restaurant', 'Tea Ceremony', 'Garden'],
      totalRooms: 45,
      availableRooms: 8,
      isFeatured: false,
      isAvailable: true,
      latitude: 35.6762,
      longitude: 139.6503,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _searchResults = List.from(_mockHotels);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    setState(() {
      _isSearching = true;
      if (query.isEmpty) {
        _searchResults = List.from(_mockHotels);
      } else {
        _searchResults = _mockHotels.where((hotel) {
          return hotel.name.toLowerCase().contains(query.toLowerCase()) ||
              hotel.city.toLowerCase().contains(query.toLowerCase()) ||
              hotel.country.toLowerCase().contains(query.toLowerCase()) ||
              hotel.description.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  void _applyFilters() {
    setState(() {
      _searchResults = _mockHotels.where((hotel) {
        final priceMatch = hotel.pricePerNight >= _minPrice && hotel.pricePerNight <= _maxPrice;
        final ratingMatch = _selectedRating == 0 || hotel.rating >= _selectedRating;
        return priceMatch && ratingMatch;
      }).toList();
      
      if (_selectedSortBy == 'price_low') {
        _searchResults.sort((a, b) => a.pricePerNight.compareTo(b.pricePerNight));
      } else if (_selectedSortBy == 'price_high') {
        _searchResults.sort((a, b) => b.pricePerNight.compareTo(a.pricePerNight));
      } else if (_selectedSortBy == 'rating') {
        _searchResults.sort((a, b) => b.rating.compareTo(a.rating));
      }
    });
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.primaryBlack,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return DraggableScrollableSheet(
            initialChildSize: 0.7,
            minChildSize: 0.5,
            maxChildSize: 0.9,
            expand: false,
            builder: (context, scrollController) {
              return SingleChildScrollView(
                controller: scrollController,
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.lightBlack,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Filter & Sort',
                      style: TextStyle(
                        color: AppColors.pureWhite,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Sort By',
                      style: TextStyle(
                        color: AppColors.primaryGold,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      children: [
                        _buildSortChip('recommended', 'Recommended', setModalState),
                        _buildSortChip('price_low', 'Price: Low to High', setModalState),
                        _buildSortChip('price_high', 'Price: High to Low', setModalState),
                        _buildSortChip('rating', 'Highest Rated', setModalState),
                      ],
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Price Range',
                      style: TextStyle(
                        color: AppColors.primaryGold,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 12),
                    RangeSlider(
                      values: RangeValues(_minPrice, _maxPrice),
                      min: 0,
                      max: 1000,
                      activeColor: AppColors.primaryGold,
                      inactiveColor: AppColors.lightBlack,
                      labels: RangeLabels('\$${_minPrice.toInt()}', '\$${_maxPrice.toInt()}'),
                      onChanged: (values) {
                        setModalState(() {
                          _minPrice = values.start;
                          _maxPrice = values.end;
                        });
                      },
                    ),
                    Text(
                      '\$${_minPrice.toInt()} - \$${_maxPrice.toInt()}',
                      style: TextStyle(
                        color: AppColors.pureWhite,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Minimum Rating',
                      style: TextStyle(
                        color: AppColors.primaryGold,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: List.generate(5, (index) {
                        final rating = index + 1;
                        return GestureDetector(
                          onTap: () {
                            setModalState(() {
                              _selectedRating = _selectedRating == rating ? 0 : rating;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 8),
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: _selectedRating >= rating ? AppColors.primaryGold : AppColors.lightBlack,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  '$rating',
                                  style: TextStyle(
                                    color: _selectedRating >= rating ? AppColors.primaryBlack : AppColors.pureWhite,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Icon(
                                  Icons.star,
                                  size: 16,
                                  color: _selectedRating >= rating ? AppColors.primaryBlack : AppColors.primaryGold,
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                    SizedBox(height: 32),
                    Row(
                      children: [
                        Expanded(
                          child: GoldenButton(
                            text: 'Reset',
                            style: GoldenButtonStyle.outlined,
                            onPressed: () {
                              setModalState(() {
                                _selectedSortBy = 'recommended';
                                _minPrice = 0;
                                _maxPrice = 1000;
                                _selectedRating = 0;
                              });
                            },
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: GoldenButton(
                            text: 'Apply',
                            style: GoldenButtonStyle.filled,
                            onPressed: () {
                              _applyFilters();
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSortChip(String value, String label, StateSetter setModalState) {
    final isSelected = _selectedSortBy == value;
    return GestureDetector(
      onTap: () {
        setModalState(() {
          _selectedSortBy = value;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryGold : AppColors.lightBlack,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primaryGold : AppColors.mutedGold,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.primaryBlack : AppColors.pureWhite,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Search',
                          style: TextStyle(
                            color: AppColors.pureWhite,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.lightBlack,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.tune,
                            color: AppColors.primaryGold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.lightBlack,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.mutedGold.withOpacity(0.3),
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
                                hintText: 'Search hotels, destinations...',
                                hintStyle: TextStyle(
                                  color: AppColors.mutedGold.withOpacity(0.7),
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
                              onChanged: _performSearch,
                            ),
                          ),
                          if (_searchController.text.isNotEmpty)
                            IconButton(
                              icon: Icon(
                                Icons.clear,
                                color: AppColors.mutedGold,
                              ),
                              onPressed: () {
                                _searchController.clear();
                                _performSearch('');
                              },
                            ),
                          Container(
                            margin: EdgeInsets.only(right: 8),
                            child: GoldenButton(
                              text: 'Filter',
                              style: GoldenButtonStyle.filled,
                              height: 40,
                              fontSize: 14,
                              icon: Icons.tune,
                              onPressed: _showFilterBottomSheet,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    if (!_isSearching || _searchController.text.isEmpty) ...[
                      Text(
                        'Popular Destinations',
                        style: TextStyle(
                          color: AppColors.pureWhite,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      SizedBox(
                        height: 180,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _popularDestinations.length,
                          itemBuilder: (context, index) {
                            final destination = _popularDestinations[index];
                            return GestureDetector(
                              onTap: () {
                                _searchController.text = destination['name'];
                                _performSearch(destination['name']);
                              },
                              child: Container(
                                width: 140,
                                margin: EdgeInsets.only(right: 16),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  image: DecorationImage(
                                    image: NetworkImage(destination['image']),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        AppColors.darkBlack.withOpacity(0.8),
                                      ],
                                    ),
                                  ),
                                  padding: EdgeInsets.all(12),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        destination['name'],
                                        style: TextStyle(
                                          color: AppColors.pureWhite,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        destination['country'],
                                        style: TextStyle(
                                          color: AppColors.primaryGold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Recent Searches',
                            style: TextStyle(
                              color: AppColors.pureWhite,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _recentSearches.clear();
                              });
                            },
                            child: Text(
                              'Clear All',
                              style: TextStyle(
                                color: AppColors.primaryGold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: _recentSearches.map((search) {
                          return GestureDetector(
                            onTap: () {
                              _searchController.text = search;
                              _performSearch(search);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.lightBlack,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: AppColors.mutedGold.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.history,
                                    size: 16,
                                    color: AppColors.mutedGold,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    search,
                                    style: TextStyle(
                                      color: AppColors.pureWhite,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 24),
                      Text(
                        'Featured Hotels',
                        style: TextStyle(
                          color: AppColors.pureWhite,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                    ],
                  ],
                ),
              ),
            ),
            if (_isSearching && _searchController.text.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_searchResults.length} hotels found',
                        style: TextStyle(
                          color: AppColors.mutedGold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'Sorted by: ${_selectedSortBy == 'recommended' ? 'Recommended' : _selectedSortBy == 'price_low' ? 'Price: Low to High' : _selectedSortBy == 'price_high' ? 'Price: High to Low' : 'Highest Rated'}',
                        style: TextStyle(
                          color: AppColors.mutedGold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (_isSearching && _searchController.text.isNotEmpty)
              SliverPadding(
                padding: EdgeInsets.all(16),
                sliver: _searchResults.isEmpty
                    ? SliverToBoxAdapter(
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 64,
                                color: AppColors.mutedGold,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'No hotels found',
                                style: TextStyle(
                                  color: AppColors.pureWhite,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Try adjusting your search or filters',
                                style: TextStyle(
                                  color: AppColors.mutedGold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final hotel = _searchResults[index];
                            return Padding(
                              padding: EdgeInsets.only(bottom: 16),
                              child: HotelCard(
                                hotel: hotel,
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/hotel_detail',
                                    arguments: hotel,
                                  );
                                },
                              ),
                            );
                          },
                          childCount: _searchResults.length,
                        ),
                      ),
              ),
            if (!_isSearching || _searchController.text.isEmpty)
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final hotel = _mockHotels[index];
                      return Padding(
                        padding: EdgeInsets.only(bottom: 16),
                        child: HotelCard(
                          hotel: hotel,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/hotel_detail',
                              arguments: hotel,
                            );
                          },
                        ),
                      );
                    },
                    childCount: _mockHotels.length,
                  ),
                ),
              ),
            SliverToBoxAdapter(
              child: SizedBox(height: 20),
            ),
          ],
        ),
      ),
    );
  }
}