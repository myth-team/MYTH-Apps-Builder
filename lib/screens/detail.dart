import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gilded_stays_app/utils/colors.dart'; 
import 'package:gilded_stays_app/models/hotel.dart'; 

class DetailScreen extends StatelessWidget {
  final Hotel hotel;

  const DetailScreen({super.key, required this.hotel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: PageView(
                    children: hotel.image.split(',').map((imgUrl) {
                      return Image.network(
                        imgUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          return loadingProgress == null
                              ? child
                              : const Center(child: CircularProgressIndicator(color: AppColors.primaryGold));
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(24),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Text(
                      hotel.name,
                      style: GoogleFonts.lato(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryGold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.location_on, color: AppColors.primaryGold),
                        const SizedBox(width: 4),
                        Text(
                          hotel.location,
                          style: GoogleFonts.lato(color: AppColors.textGold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${hotel.price}',
                          style: GoogleFonts.lato(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryGold,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.star, color: AppColors.primaryGold),
                            Text(
                              hotel.rating.toString(),
                              style: GoogleFonts.lato(color: AppColors.textGold),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Amenities',
                      style: GoogleFonts.lato(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryGold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...hotel.amenities.map((amenity) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Icon(Icons.check_circle, color: AppColors.primaryGold, size: 16),
                            const SizedBox(width: 8),
                            Text(
                              amenity,
                              style: GoogleFonts.lato(color: AppColors.textGold),
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 40),
                  ]),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 80,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primaryBlack, AppColors.secondaryBlack],
                ),
                border: Border(
                  top: BorderSide(color: AppColors.dividerColor),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGold,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Book Now',
                    style: GoogleFonts.lato(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBlack,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}