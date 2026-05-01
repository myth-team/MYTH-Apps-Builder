import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gilded_stays_app/utils/colors.dart'; 
import 'package:gilded_stays_app/widgets/hotel_card.dart'; 
import 'package:gilded_stays_app/models/hotel.dart'; 

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final featuredHotels = [
      Hotel(
        id: '1',
        name: 'Royal Grand Palace',
        location: 'Paris, France',
        rating: 4.9,
        price: 450,
        image: 'https://images.unsplash.com/photo-1566073771259-6a8506099945',
        amenities: ['Pool', 'Spa', 'Restaurant', 'Free Wi-Fi'],
      ),
      Hotel(
        id: '2',
        name: 'Golden Serenity Resort',
        location: 'Bali, Indonesia',
        rating: 4.8,
        price: 320,
        image: 'https://images.unsplash.com/photo-1590523277543-a10444d920a3',
        amenities: ['Beachfront', 'Private Villa', 'Gym', 'Concierge'],
      ),
      Hotel(
        id: '3',
        name: 'Imperial Sky Suites',
        location: 'Dubai, UAE',
        rating: 4.7,
        price: 580,
        image: 'https://images.unsplash.com/photo-1560185049-7765b179a5d8',
        amenities: ['Infinity Pool', 'Sky Bar', 'Helipad', '24/7 Service'],
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.backgroundGradientStart,
              AppColors.backgroundGradientEnd,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  style: GoogleFonts.lato(color: AppColors.textGold),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.cardBackground,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(Icons.search, color: AppColors.primaryGold),
                    hintText: 'Search destinations...',
                    hintStyle: GoogleFonts.lato(color: AppColors.textGold.withOpacity(0.7)),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        child: Text(
                          'Featured Hotels',
                          style: GoogleFonts.lato(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryGold,
                          ),
                        ),
                      ),
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        childAspectRatio: 0.8,
                        children: featuredHotels.map((hotel) {
                          return HotelCard(hotel: hotel);
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}