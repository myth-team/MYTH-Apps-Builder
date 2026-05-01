import 'package:flutter/material.dart';
import 'package:golden_stay_app/utils/colors.dart'; 
import 'package:golden_stay_app/models/hotel.dart'; 
import 'package:golden_stay_app/widgets/hotel_card.dart'; 
import 'package:golden_stay_app/services/hotel_service.dart'; 

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final HotelService _hotelService = HotelService();
  List<Hotel> _hotels = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _page = 1;
  String _selectedFilter = 'All';
  String _sortBy = 'rating';

  final List<String> _filters = [
    'All',
    'Luxury',
    'Business',
    'Resort',
    'Beach',
    'Mountain',
    'City',
  ];

  final List<Map<String, String>> _sortOptions = [
    {'key': 'rating', 'label': 'Top Rated'},
    {'key': 'price_low', 'label': 'Price: Low to High'},
    {'key': 'price_high', 'label': 'Price: High to Low'},
    {'key': 'distance', 'label': 'Distance'},
  ];

  @override
  void initState() {
    super.initState();
    _loadHotels();
  }

  Future<void> _loadHotels() async {
    if (_isLoading) return;
    
    setState(() {
      _isLoading = true;
    });

    try {
      final newHotels = await _hotelService.getHotels(
        page: _page,
        filter: _selectedFilter,
        sortBy: _sortBy,
      );

      setState(() {
        if (newHotels.isEmpty) {
          _hasMore = false;
        } else {
          _hotels.addAll(newHotels);
          _page++;
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshHotels() async {
    setState(() {
      _hotels = [];
      _page = 1;
      _hasMore = true;
    });
    await _loadHotels();
  }

  void _onFilterChanged(String filter) {
    setState(() {
      _selectedFilter = filter;
      _hotels = [];
      _page = 1;
      _hasMore = true;
    });
    _loadHotels();
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
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
                color: AppColors.textMuted,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              'Sort By',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            ..._sortOptions.map((option) => ListTile(
              title: Text(
                option['label']!,
                style: TextStyle(
                  color: _sortBy == option['key'] 
                    ? AppColors.primary 
                    : AppColors.textSecondary,
                ),
              ),
              trailing: _sortBy == option['key']
                ? Icon(Icons.check, color: AppColors.primary)
                : null,
              onTap: () {
                setState(() {
                  _sortBy = option['key']!;
                  _hotels = [];
                  _page = 1;
                  _hasMore = true;
                });
                Navigator.pop(context);
                _loadHotels();
              },
            )),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildFilterChips(),
            _buildListHeader(),
            Expanded(
              child: _buildHotelList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                style: TextStyle(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Search hotels...',
                  hintStyle: TextStyle(color: AppColors.textMuted),
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppColors.textMuted,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 12),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(
                Icons.tune,
                color: AppColors.primary,
              ),
              onPressed: _showSortOptions,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 56,
      padding: EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = filter == _selectedFilter;
          return Padding(
            padding: EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(
                filter,
                style: TextStyle(
                  color: isSelected 
                    ? AppColors.background 
                    : AppColors.textSecondary,
                  fontWeight: isSelected 
                    ? FontWeight.bold 
                    : FontWeight.normal,
                ),
              ),
              backgroundColor: AppColors.surface,
              selectedColor: AppColors.primary,
              checkmarkColor: AppColors.background,
              showCheckmark: false,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected 
                    ? AppColors.primary 
                    : AppColors.surfaceLight,
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              onSelected: (selected) {
                _onFilterChanged(filter);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildListHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${_hotels.length} hotels found',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Showing results for "$_selectedFilter"',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'List',
                        style: TextStyle(
                          color: AppColors.background,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Icon(
                        Icons.map_outlined,
                        color: AppColors.textMuted,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHotelList() {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (scrollInfo.metrics.pixels >= 
            scrollInfo.metrics.maxScrollExtent - 200) {
          if (_hasMore && !_isLoading) {
            _loadHotels();
          }
        }
        return false;
      },
      child: RefreshIndicator(
        onRefresh: _refreshHotels,
        color: AppColors.primary,
        backgroundColor: AppColors.surface,
        child: _hotels.isEmpty && !_isLoading
          ? _buildEmptyState()
          : ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: _hotels.length + (_hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _hotels.length) {
                  return _buildLoadingIndicator();
                }
                return Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: HotelCard(
                    hotel: _hotels[index],
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/detail',
                        arguments: {
                          'hotelId': _hotels[index].id,
                          'hotel': _hotels[index],
                        },
                      );
                    },
                  ),
                );
              },
            ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: AppColors.textMuted,
          ),
          SizedBox(height: 16),
          Text(
            'No hotels found',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Try adjusting your filters',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 24),
          TextButton(
            onPressed: _refreshHotels,
            child: Text(
              'Clear Filters',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Center(
        child: _isLoading
          ? CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.primary,
              ),
            )
          : SizedBox.shrink(),
      ),
    );
  }
}