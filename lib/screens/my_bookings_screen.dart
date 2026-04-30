import 'package:flutter/material.dart';
import 'package:new_project_app/utils/colors.dart'; 

class MyBookingsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> bookings = [
    {
      'hotel': 'Grand Ocean Resort',
      'location': 'Maldives',
      'date': 'Oct 15 - Oct 20, 2024',
      'status': 'Upcoming',
      'image': 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800&q=80',
      'price': 1750,
    },
    {
      'hotel': 'Urban Skyline Hotel',
      'location': 'Tokyo, Japan',
      'date': 'Sep 01 - Sep 05, 2024',
      'status': 'Completed',
      'image': 'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?w=800&q=80',
      'price': 1120,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'My Bookings',
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(20),
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];
          final isUpcoming = booking['status'] == 'Upcoming';

          return Container(
            margin: EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  child: Image.network(
                    booking['image'],
                    height: 160,
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
                              booking['hotel'],
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: isUpcoming
                                  ? AppColors.gold.withOpacity(0.15)
                                  : AppColors.darkGrey,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              booking['status'],
                              style: TextStyle(
                                color: isUpcoming
                                    ? AppColors.gold
                                    : AppColors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
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
                            booking['location'],
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
                              Icon(
                                Icons.calendar_today,
                                color: AppColors.gold,
                                size: 16,
                              ),
                              SizedBox(width: 6),
                              Text(
                                booking['date'],
                                style: TextStyle(
                                  color: AppColors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '\$${booking['price']}',
                            style: TextStyle(
                              color: AppColors.gold,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
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
        },
      ),
    );
  }
}