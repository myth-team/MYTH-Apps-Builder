import 'package:flutter/material.dart';
import 'package:new_project_app/utils/colors.dart'; 
import 'package:new_project_app/screens/hotel_detail_screen.dart'; 

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = 'All';
  final List<String> categories = ['All', 'Beach', 'Mountain', 'City', 'Resort'];

  final List<Map<String, dynamic>> hotels = [
    {
      'name': 'Grand Ocean Resort',
      'location': 'Maldives',
      'price': 350,
      'rating': 4.9,
      'image': 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800&q=80',
      'category': 'Beach',
      'reviews': 128,
    },
    {
      'name': 'Alpine Luxury Lodge',
      'location': 'Swiss Alps',
      'price': 420,
      'rating': 4.8,
      'image': 'https://images.unsplash.com/photo-1582719508461-905c673771fd?w=800&q=80',
      'category': 'Mountain',
      'reviews': 96,
    },
    {
      'name': 'Urban Skyline Hotel',
      'location': 'Tokyo, Japan',
      'price': 280,
      'rating': 4.7,
      'image': 'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?w=800&q=80',
      'category': 'City',
      'reviews': 215,
    },
    {
      'name': 'Golden Palm Resort',
      'location': 'Bali, Indonesia',
      'price': 180,
      'rating': 4.6,
      'image': 'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=800&q=80',
      'category': 'Resort',
      'reviews': 340,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredHotels = selectedCategory == 'All'
        ? hotels
        : hotels.where((h) => h['category'] == selectedCategory).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(20),
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
                              'Find Your Stay',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Discover luxury hotels worldwide',
                              style: TextStyle(
                                color: AppColors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: AppColors.gold.withOpacity(0.2),
                          child: Icon(
                            Icons.person,
                            color: AppColors.gold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TextField(
                        style: TextStyle(color: AppColors.white),
                        decoration: InputDecoration(
                          hintText: 'Search destination...',
                          hintStyle: TextStyle(color: AppColors.grey),
                          prefixIcon: Icon(Icons.search, color: AppColors.gold),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Categories',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      height: 44,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final cat = categories[index];
                          final isSelected = cat == selectedCategory;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedCategory = cat;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 12),
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.gold
                                    : AppColors.card,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Text(
                                cat,
                                style: TextStyle(
                                  color: isSelected
                                      ? AppColors.background
                                      : AppColors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Popular Hotels',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final hotel = filteredHotels[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HotelDetailScreen(hotel: hotel),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                              child: Image.network(
                                hotel['image'],
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          hotel['name'],
                                          style: TextStyle(
                                            color: AppColors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.gold.withOpacity(0.15),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.star,
                                              color: AppColors.gold,
                                              size: 16,
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              '${hotel['rating']}',
                                              style: TextStyle(
                                                color: AppColors.gold,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        color: AppColors.grey,
                                        size: 16,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        hotel['location'],
                                        style: TextStyle(
                                          color: AppColors.grey,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            '\$${hotel['price']}',
                                            style: TextStyle(
                                              color: AppColors.gold,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            ' /night',
                                            style: TextStyle(
                                              color: AppColors.grey,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        '${hotel['reviews']} reviews',
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
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: filteredHotels.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}