import 'package:flutter/material.dart';
import 'package:ridesync_app/utils/colors.dart'; 
import 'package:ridesync_app/widgets/primary_button.dart'; 
import 'package:google_fonts/google_fonts.dart';

class RiderSearchScreen extends StatefulWidget {
  final String? initialQuery;
  final Function(String) onDestinationSelected;
  final VoidCallback onCancel;

  const RiderSearchScreen({
    super.key,
    this.initialQuery,
    required this.onDestinationSelected,
    required this.onCancel,
  });

  @override
  State<RiderSearchScreen> createState() => _RiderSearchScreenState();
}

class _RiderSearchScreenState extends State<RiderSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearching = false;
  List<SearchResult> _searchResults = [];
  List<SearchResult> _recentSearches = [];
  String _selectedCategory = 'all';

  final List<Map<String, dynamic>> _savedPlaces = [
    {'name': 'Home', 'address': '123 Main Street', 'icon': Icons.home},
    {'name': 'Work', 'address': '456 Office Blvd', 'icon': Icons.work},
    {'name': 'Gym', 'address': '789 Fitness Ave', 'icon': Icons.fitness_center},
    {'name': 'School', 'address': '321 Education Lane', 'icon': Icons.school},
  ];

  final List<String> _categories = ['all', 'restaurant', 'gas', 'shopping', 'hotel'];

  @override
  void initState() {
    super.initState();
    if (widget.initialQuery != null) {
      _searchController.text = widget.initialQuery!;
      _performSearch(widget.initialQuery!);
    }
    _loadRecentSearches();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  void _loadRecentSearches() {
    _recentSearches = [
      SearchResult(
        id: '1',
        name: 'San Francisco International Airport',
        address: 'San Francisco, CA',
        type: SearchResultType.airport,
      ),
      SearchResult(
        id: '2',
        name: 'Golden Gate Bridge',
        address: 'San Francisco, CA',
        type: SearchResultType.landmark,
      ),
      SearchResult(
        id: '3',
        name: 'Union Square',
        address: 'San Francisco, CA',
        type: SearchResultType.shopping,
      ),
    ];
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _searchResults = [
            SearchResult(
              id: 's1',
              name: '$query Location 1',
              address: '123 ${query} Street, San Francisco, CA',
              type: SearchResultType.address,
            ),
            SearchResult(
              id: 's2',
              name: '$query Location 2',
              address: '456 ${query} Avenue, San Francisco, CA',
              type: SearchResultType.address,
            ),
            SearchResult(
              id: 's3',
              name: '$query Plaza',
              address: '789 ${query} Plaza, San Francisco, CA',
              type: SearchResultType.landmark,
            ),
            SearchResult(
              id: 's4',
              name: '$query Station',
              address: '321 ${query} Station, San Francisco, CA',
              type: SearchResultType.transit,
            ),
          ];
          _isSearching = false;
        });
      }
    });
  }

  void _onResultSelected(SearchResult result) {
    widget.onDestinationSelected(result.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchHeader(),
            Expanded(
              child: _searchController.text.isNotEmpty && _searchResults.isNotEmpty
                  ? _buildSearchResults()
                  : _buildRecentAndSavedPlaces(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.grey300.withAlpha(51),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: widget.onCancel,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.grey100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.arrow_back,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.grey100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.primary.withAlpha(51)),
                  ),
                  child: TextField(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: AppColors.textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Where to?',
                      hintStyle: GoogleFonts.poppins(
                        color: AppColors.textSecondary,
                        fontSize: 16,
                      ),
                      border: InputBorder.none,
                      icon: Icon(
                        Icons.search,
                        color: AppColors.textSecondary,
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? GestureDetector(
                              onTap: () {
                                _searchController.clear();
                                setState(() {
                                  _searchResults = [];
                                });
                              },
                              child: Icon(
                                Icons.close,
                                color: AppColors.textSecondary,
                              ),
                            )
                          : null,
                    ),
                    onChanged: (value) {
                      _performSearch(value);
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildQuickActions(),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildQuickActionChip(Icons.home, 'Home', () {
            _searchController.text = 'Home';
            _performSearch('Home');
          }),
          const SizedBox(width: 8),
          _buildQuickActionChip(Icons.work, 'Work', () {
            _searchController.text = 'Work';
            _performSearch('Work');
          }),
          const SizedBox(width: 8),
          _buildQuickActionChip(Icons.restaurant, 'Eat', () {
            _searchController.text = 'Restaurant';
            _performSearch('Restaurant');
          }),
          const SizedBox(width: 8),
          _buildQuickActionChip(Icons.shopping_bag, 'Shop', () {
            _searchController.text = 'Shopping';
            _performSearch('Shopping');
          }),
          const SizedBox(width: 8),
          _buildQuickActionChip(Icons.local_gas_station, 'Gas', () {
            _searchController.text = 'Gas Station';
            _performSearch('Gas Station');
          }),
        ],
      ),
    );
  }

  Widget _buildQuickActionChip(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.grey100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: AppColors.primary),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_isSearching) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: AppColors.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Searching...',
              style: GoogleFonts.poppins(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final result = _searchResults[index];
        return _buildSearchResultItem(result);
      },
    );
  }

  Widget _buildSearchResultItem(SearchResult result) {
    return InkWell(
      onTap: () => _onResultSelected(result),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withAlpha(26),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getIconForType(result.type),
                color: AppColors.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    result.name,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    result.address,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.north_west,
              color: AppColors.grey400,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentAndSavedPlaces() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_recentSearches.isNotEmpty) ...[
            _buildSectionHeader('Recent Searches', onSeeAll: () {}),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _recentSearches.length,
              itemBuilder: (context, index) {
                final result = _recentSearches[index];
                return _buildSearchResultItem(result);
              },
            ),
          ],
          const SizedBox(height: 16),
          _buildSectionHeader('Saved Places', onSeeAll: () {}),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.5,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: _savedPlaces.length,
              itemBuilder: (context, index) {
                final place = _savedPlaces[index];
                return _buildSavedPlaceCard(place);
              },
            ),
          ),
          const SizedBox(height: 16),
          _buildCategoriesSection(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onSeeAll}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          if (onSeeAll != null)
            GestureDetector(
              onTap: onSeeAll,
              child: Text(
                'See all',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSavedPlaceCard(Map<String, dynamic> place) {
    return GestureDetector(
      onTap: () {
        _searchController.text = place['name'];
        _performSearch(place['name']);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.grey300.withAlpha(51),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              place['icon'],
              color: AppColors.primary,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              place['name'],
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              place['address'],
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Explore Categories', onSeeAll: () {}),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildCategoryChip('all', 'All', Icons.apps),
                const SizedBox(width: 8),
                _buildCategoryChip('restaurant', 'Food', Icons.restaurant),
                const SizedBox(width: 8),
                _buildCategoryChip('gas', 'Gas', Icons.local_gas_station),
                const SizedBox(width: 8),
                _buildCategoryChip('shopping', 'Shopping', Icons.shopping_bag),
                const SizedBox(width: 8),
                _buildCategoryChip('hotel', 'Hotel', Icons.hotel),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _getCategoryPlaces().map((place) {
              return _buildExplorePlaceCard(place);
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryChip(String category, String label, IconData icon) {
    final isSelected = _selectedCategory == category;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = category;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderLight,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? AppColors.textOnPrimary : AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: isSelected ? AppColors.textOnPrimary : AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getCategoryPlaces() {
    if (_selectedCategory == 'all') {
      return [
        {'name': 'Whole Foods', 'distance': '0.3 km', 'icon': Icons.restaurant},
        {'name': 'Target', 'distance': '0.8 km', 'icon': Icons.shopping_bag},
        {'name': 'Chevron', 'distance': '1.2 km', 'icon': Icons.local_gas_station},
        {'name': 'Hilton', 'distance': '1.5 km', 'icon': Icons.hotel},
      ];
    }
    
    final places = <String, List<Map<String, dynamic>>>{
      'restaurant': [
        {'name': 'Whole Foods', 'distance': '0.3 km', 'icon': Icons.restaurant},
        {'name': 'Chipotle', 'distance': '0.5 km', 'icon': Icons.restaurant},
        {'name': 'Starbucks', 'distance': '0.7 km', 'icon': Icons.local_cafe},
      ],
      'gas': [
        {'name': 'Chevron', 'distance': '1.2 km', 'icon': Icons.local_gas_station},
        {'name': 'Shell', 'distance': '1.8 km', 'icon': Icons.local_gas_station},
      ],
      'shopping': [
        {'name': 'Target', 'distance': '0.8 km', 'icon': Icons.shopping_bag},
        {'name': 'Walmart', 'distance': '2.1 km', 'icon': Icons.shopping_cart},
      ],
      'hotel': [
        {'name': 'Hilton', 'distance': '1.5 km', 'icon': Icons.hotel},
        {'name': 'Marriott', 'distance': '2.0 km', 'icon': Icons.hotel},
      ],
    };

    return places[_selectedCategory] ?? [];
  }

  Widget _buildExplorePlaceCard(Map<String, dynamic> place) {
    return GestureDetector(
      onTap: () {
        _searchController.text = place['name'];
        _performSearch(place['name']);
      },
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.grey300.withAlpha(51),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              place['icon'],
              color: AppColors.secondary,
              size: 24,
            ),
            const Spacer(),
            Text(
              place['name'],
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              place['distance'],
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForType(SearchResultType type) {
    switch (type) {
      case SearchResultType.address:
        return Icons.location_on;
      case SearchResultType.landmark:
        return Icons.place;
      case SearchResultType.airport:
        return Icons.flight;
      case SearchResultType.transit:
        return Icons.train;
      case SearchResultType.restaurant:
        return Icons.restaurant;
      case SearchResultType.shopping:
        return Icons.shopping_bag;
      case SearchResultType.gas:
        return Icons.local_gas_station;
      case SearchResultType.hotel:
        return Icons.hotel;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }
}

enum SearchResultType {
  address,
  landmark,
  airport,
  transit,
  restaurant,
  shopping,
  gas,
  hotel,
}

class SearchResult {
  final String id;
  final String name;
  final String address;
  final SearchResultType type;

  SearchResult({
    required this.id,
    required this.name,
    required this.address,
    required this.type,
  });
}