import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gilded_stays_app/utils/colors.dart'; 

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  final List<Map<String, dynamic>> featuredHotels = [
    {
      'id': 1,
      'name': 'The Grand Aurelia',
      'location': 'Paris, France',
      'price': 850,
      'rating': 4.9,
      'image': 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800',
      'featured': true,
    },
    {
      'id': 2,
      'name': 'Skyline Palace',
      'location': 'New York, USA',
      'price': 1200,
      'rating': 4.8,
      'image': 'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?w=800',
      'featured': false,
    },
    {
      'id': 3,
      'name': 'Marina Bay Resort',
      'location': 'Dubai, UAE',
      'price': 950,
      'rating': 4.7,
      'image': 'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=800',
      'featured': true,
    },
    {
      'id': 4,
      'name': 'Royal Kensington',
      'location': 'London, UK',
      'price': 750,
      'rating': 4.6,
      'image': 'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?w=800',
      'featured': false,
    },
    {
      'id': 5,
      'name': 'Santorini Cliff Suites',
      'location': 'Santorini, Greece',
      'price': 680,
      'rating': 4.9,
      'image': 'https://images.unsplash.com/photo-1571003123894-1f0594d2b5d9?w=800',
      'featured': true,
    },
    {
      'id': 6,
      'name': 'Tokyo Imperial Hotel',
      'location': 'Tokyo, Japan',
      'price': 550,
      'rating': 4.8,
      'image': 'https://images.unsplash.com/photo-1590490360182-c33d57733427?w=800',
      'featured': false,
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _buildHeroSection(),
          ),
          SliverToBoxAdapter(
            child: _buildSectionHeader('Featured Properties'),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final hotel = featuredHotels[index];
                  return _buildHotelCard(hotel);
                },
                childCount: featuredHotels.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      height: 340,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF1A1A1A),
            AppColors.background,
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome to',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Gilded Stays',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 28,
                          color: AppColors.gold,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Icon(
                      Icons.notifications_outlined,
                      color: AppColors.textPrimary,
                      size: 24,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Text(
                'Find your perfect\nluxury escape',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 36,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 24),
              _buildSearchBar(),
              const SizedBox(height: 16),
              _buildQuickFilters(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        style: GoogleFonts.inter(
          color: AppColors.textPrimary,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          hintText: 'Search destinations, hotels...',
          hintStyle: GoogleFonts.inter(
            color: AppColors.textTertiary,
            fontSize: 14,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: AppColors.gold,
            size: 24,
          ),
          suffixIcon: Container(
            margin: const EdgeInsets.all(4),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: AppColors.goldGradient,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.tune,
              color: AppColors.background,
              size: 20,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: AppColors.surface,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildQuickFilters() {
    final filters = ['Paris', 'London', 'Dubai', 'Tokyo'];
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final isSelected = index == 0;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.gold : AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? AppColors.gold : AppColors.border,
              ),
            ),
            child: Text(
              filters[index],
              style: GoogleFonts.inter(
                color: isSelected ? AppColors.background : AppColors.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.playfairDisplay(
              fontSize: 24,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.gold.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'View All',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppColors.gold,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHotelCard(Map<String, dynamic> hotel) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/detail', arguments: hotel);
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    child: Image.network(
                      hotel['image'],
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppColors.surfaceVariant,
                          child: const Center(
                            child: Icon(
                              Icons.image_not_supported,
                              color: AppColors.textTertiary,
                              size: 40,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.background.withOpacity(0.8),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite_border,
                        color: AppColors.gold,
                        size: 18,
                      ),
                    ),
                  ),
                  if (hotel['featured'] == true)
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: AppColors.goldGradient,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Featured',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            color: AppColors.background,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hotel['name'],
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 12,
                              color: AppColors.textTertiary,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                hotel['location'],
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: AppColors.textTertiary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              size: 14,
                              color: AppColors.gold,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              hotel['rating'].toString(),
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppColors.gold,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '\$${hotel['price']}',
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  color: AppColors.gold,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: ' /night',
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  color: AppColors.textTertiary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}