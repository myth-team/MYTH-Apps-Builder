import 'package:flutter/material.dart';
import 'package:gilded_stays_app/utils/colors.dart'; 

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              SizedBox(height: 24),
              _buildSearchBar(),
              SizedBox(height: 24),
              _buildSectionTitle('Featured Stays'),
              SizedBox(height: 16),
              _buildFeaturedHotels(),
              SizedBox(height: 24),
              _buildSectionTitle('Popular Destinations'),
              SizedBox(height: 16),
              _buildDestinations(),
              SizedBox(height: 24),
              _buildSectionTitle('Browse by Category'),
              SizedBox(height: 16),
              _buildCategories(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, Traveler',
              style: TextStyle(
                color: AppColors.grey,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Find Your
Gilded Stay',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
          ),
          child: Icon(
            Icons.notifications_outlined,
            color: AppColors.gold,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: AppColors.gold),
          SizedBox(width: 12),
          Expanded(
            child: TextField(
              style: TextStyle(color: AppColors.white),
              decoration: InputDecoration(
                hintText: 'Search hotels, cities...',
                hintStyle: TextStyle(color: AppColors.grey),
                border: InputBorder.none,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.gold,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.tune,
              color: AppColors.background,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppColors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'View All',
          style: TextStyle(
            color: AppColors.gold,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedHotels() {
    return SizedBox(
      height: 260,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildFeaturedCard(
            imageUrl: 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400',
            name: 'The Grand Palace',
            location: 'Paris, France',
            price: '450',
            rating: '4.9',
          ),
          SizedBox(width: 16),
          _buildFeaturedCard(
            imageUrl: 'https://images.unsplash.com/photo-1582719508461-905c673771fd?w=400',
            name: 'Azure Resort',
            location: 'Maldives',
            price: '680',
            rating: '4.8',
          ),
          SizedBox(width: 16),
          _buildFeaturedCard(
            imageUrl: 'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?w=400',
            name: 'Skyline Heights',
            location: 'Dubai, UAE',
            price: '520',
            rating: '4.7',
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedCard({
    required String imageUrl,
    required String name,
    required String location,
    required String price,
    required String rating,
  }) {
    return Container(
      width: 240,
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,\: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.star, color: AppColors.gold, size: 14),
                          SizedBox(width: 2),
                          Text(
                            rating,
                            style: TextStyle(
                              color: AppColors.gold,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
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
        ],
      ),
    );
  }

  Widget _buildDestinations() {
    return SizedBox(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildDestinationCard(
            imageUrl: 'https://images.unsplash.com/photo-1499856871958-5b9627545d1a?w=300',
            name: 'Paris',
            hotels: '234 Hotels',
          ),
          SizedBox(width: 12),
          _buildDestinationCard(
            imageUrl: 'https://images.unsplash.com/photo-1512453979798-5ea266f8880c?w=300',
            name: 'Dubai',
            hotels: '189 Hotels',
          ),
          SizedBox(width: 12),
          _buildDestinationCard(
            imageUrl: 'https://images.unsplash.com/photo-1508009603889-70babde01fff?w=300',
            name: 'London',
            hotels: '312 Hotels',
          ),
          SizedBox(width: 12),
          _buildDestinationCard(
            imageUrl: 'https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=300',
            name: 'Tokyo',
            hotels: '156 Hotels',
          ),
        ],
      ),
    );
  }

  Widget _buildDestinationCard({
    required String imageUrl,
    required String name,
    required String hotels,
  }) {
    return Container(
      width: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.2)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.8),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 12,
              left: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    hotels,
                    style: TextStyle(
                      color: AppColors.gold,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategories() {
    final categories = [
      {'icon': Icons.villa, 'name': 'Resort', 'count': '45'},
      {'icon': Icons.apartment, 'name': 'Apartment', 'count': '120'},
      {'icon': Icons.business_center, 'name': 'Business', 'count': '67'},
      {'icon': Icons.beach_access, 'name': 'Beach', 'count': '38'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.7,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return Container(
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.gold.withValues(alpha: 0.2)),
          ),
          child: Padding(
            padding: EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    category['icon'] as IconData,
                    color: AppColors.gold,
                    size: 24,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category['name'] as String,
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '${category['count']} properties',
                      style: TextStyle(
                        color: AppColors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}