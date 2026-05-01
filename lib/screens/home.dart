import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_project_app/models/hotel.dart'; 
import 'package:new_project_app/models/room.dart'; 
import 'package:new_project_app/models/booking.dart'; 
import 'package:new_project_app/utils/colors.dart'; 
import 'package:new_project_app/widgets/hotel_card.dart'; 
import 'package:new_project_app/widgets/search_bar.dart' as custom;
import 'package:new_project_app/screens/detail.dart'; 
import 'package:cached_network_image/cached_network_image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> categories = ['All', 'Luxury', 'Resort', 'City View', 'Beach', 'Mountain'];
  String selectedCategory = 'All';

  final List<Hotel> featuredHotels = [
    Hotel(
      id: '1',
      name: 'The Grand Palace',
      location: 'Paris, France',
      rating: 4.9,
      reviewCount: 1250,
      pricePerNight: 450,
      imageUrl: 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800',
      gallery: [
        'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800',
        'https://images.unsplash.com/photo-1582719508461-905c673771fd?w=800',
      ],
      description: 'Experience luxury at its finest in the heart of Paris.',
      amenities: ['wifi', 'pool', 'spa', 'restaurant', 'gym'],
      rooms: [
        Room(id: '1', name: 'Deluxe Suite', pricePerNight: 450, maxGuests: 2, imageUrl: 'https://images.unsplash.com/photo-1590490360182-c33d57733427?w=400', amenities: ['wifi', 'ac']),
        Room(id: '2', name: 'Presidential Suite', pricePerNight: 850, maxGuests: 4, imageUrl: 'https://images.unsplash.com/photo-1631049307264-da0ec9d70304?w=400', amenities: ['wifi', 'ac', 'balcony']),
      ],
    ),
    Hotel(
      id: '2',
      name: 'Azure Resort & Spa',
      location: 'Maldives',
      rating: 4.8,
      reviewCount: 890,
      pricePerNight: 650,
      imageUrl: 'https://images.unsplash.com/photo-1573843981267-be1999ff37cd?w=800',
      gallery: [
        'https://images.unsplash.com/photo-1573843981267-be1999ff37cd?w=800',
      ],
      description: 'Paradise awaits you with pristine beaches and crystal waters.',
      amenities: ['wifi', 'pool', 'spa', 'restaurant', 'beach'],
      rooms: [
        Room(id: '3', name: 'Beach Villa', pricePerNight: 650, maxGuests: 2, imageUrl: 'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=400', amenities: ['wifi', 'ac']),
      ],
    ),
    Hotel(
      id: '3',
      name: 'Skyline Tower',
      location: 'New York, USA',
      rating: 4.7,
      reviewCount: 2100,
      pricePerNight: 380,
      imageUrl: 'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?w=800',
      gallery: [
        'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?w=800',
      ],
      description: 'Modern luxury with breathtaking city views.',
      amenities: ['wifi', 'gym', 'restaurant', 'bar', 'parking'],
      rooms: [
        Room(id: '4', name: 'City View Room', pricePerNight: 380, maxGuests: 2, imageUrl: 'https://images.unsplash.com/photo-1611892440504-42a792e24d32?w=400', amenities: ['wifi', 'ac']),
      ],
    ),
    Hotel(
      id: '4',
      name: 'Royal Garden Hotel',
      location: 'London, UK',
      rating: 4.6,
      reviewCount: 750,
      pricePerNight: 320,
      imageUrl: 'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?w=800',
      gallery: [
        'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?w=800',
      ],
      description: 'Classic elegance meets modern comfort.',
      amenities: ['wifi', 'pool', 'spa', 'restaurant', 'garden'],
      rooms: [
        Room(id: '5', name: 'Garden Room', pricePerNight: 320, maxGuests: 2, imageUrl: 'https://images.unsplash.com/photo-1566665797739-1674de7a421a?w=400', amenities: ['wifi', 'ac']),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceBlack,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _buildHeader(),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: custom.AppSearchBar(),
              ),
            ),
            SliverToBoxAdapter(
              child: _buildCategories(),
            ),
            SliverToBoxAdapter(
              child: _buildFeaturedSection(),
            ),
            SliverPadding(
              padding: EdgeInsets.all(20),
              sliver: _buildHotelsGrid(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
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
                    'Welcome Back',
                    style: GoogleFonts.poppins(
                      color: AppColors.grey500,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Find Your Perfect Stay',
                    style: GoogleFonts.poppins(
                      color: AppColors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.cardBlack,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.goldShadow, width: 1),
                ),
                padding: EdgeInsets.all(12),
                child: Icon(
                  Icons.notifications_outlined,
                  color: AppColors.primaryGold,
                  size: 24,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    return Container(
      height: 50,
      margin: EdgeInsets.only(top: 20),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == selectedCategory;
          return GestureDetector(
            onTap: () => setState(() => selectedCategory = category),
            child: Container(
              margin: EdgeInsets.only(right: 12),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                gradient: isSelected ? AppColors.goldGradient : null,
                color: isSelected ? null : AppColors.cardBlack,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: isSelected ? Colors.transparent : AppColors.grey700,
                  width: 1,
                ),
              ),
              child: Text(
                category,
                style: GoogleFonts.poppins(
                  color: isSelected ? AppColors.primaryBlack : AppColors.grey300,
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeaturedSection() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Featured Hotels',
                style: GoogleFonts.poppins(
                  color: AppColors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'See All',
                style: GoogleFonts.poppins(
                  color: AppColors.primaryGold,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: featuredHotels.length,
              itemBuilder: (context, index) {
                final hotel = featuredHotels[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(hotel: hotel),
                      ),
                    );
                  },
                  child: Container(
                    width: 280,
                    margin: EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(
                      color: AppColors.cardBlack,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.goldShadow, width: 0.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                          child: CachedNetworkImage(
                            imageUrl: hotel.imageUrl,
                            height: 130,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: AppColors.secondaryBlack,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primaryGold,
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: AppColors.secondaryBlack,
                              child: Icon(Icons.hotel, color: AppColors.grey700, size: 40),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                hotel.name,
                                style: GoogleFonts.poppins(
                                  color: AppColors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.location_on, color: AppColors.primaryGold, size: 14),
                                  SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      hotel.location,
                                      style: GoogleFonts.poppins(
                                        color: AppColors.grey500,
                                        fontSize: 12,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.star, color: AppColors.primaryGold, size: 16),
                                      SizedBox(width: 4),
                                      Text(
                                        hotel.rating.toString(),
                                        style: GoogleFonts.poppins(
                                          color: AppColors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '\$${hotel.pricePerNight}',
                                    style: GoogleFonts.poppins(
                                      color: AppColors.primaryGold,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHotelsGrid() {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final hotel = featuredHotels[index];
          return HotelCard(
            hotel: hotel,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen(hotel: hotel),
                ),
              );
            },
          );
        },
        childCount: featuredHotels.length,
      ),
    );
  }
}