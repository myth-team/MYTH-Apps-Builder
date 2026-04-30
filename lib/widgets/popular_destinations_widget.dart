import 'package:flutter/material.dart';
import 'package:gilded_stays_app/utils/colors.dart'; 

class PopularDestinationsWidget extends StatelessWidget {
  const PopularDestinationsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final destinations = [
      {'name': 'Dubai', 'country': 'UAE', 'icon': Icons.location_city},
      {'name': 'Maldives', 'country': 'Paradise', 'icon': Icons.beach_access},
      {'name': 'Bali', 'country': 'Indonesia', 'icon': Icons.park},
      {'name': 'Tokyo', 'country': 'Japan', 'icon': Icons.temple_buddhist},
    ];

    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: destinations.length,
        itemBuilder: (context, index) {
          final destination = destinations[index];
          return Container(
            width: 100,
            margin: const EdgeInsets.only(right: 14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: index == 0
                    ? [AppColors.gold, AppColors.goldDark]
                    : [AppColors.surface, AppColors.surfaceLight],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: index == 0 ? AppColors.gold : AppColors.divider,
                width: 1.5,
              ),
              boxShadow: index == 0
                  ? [
                      BoxShadow(
                        color: AppColors.gold.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ]
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: index == 0
                        ? AppColors.black.withOpacity(0.2)
                        : AppColors.gold.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    destination['icon'] as IconData,
                    color: index == 0 ? AppColors.black : AppColors.gold,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  destination['name'] as String,
                  style: TextStyle(
                    color: index == 0 ? AppColors.black : AppColors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  destination['country'] as String,
                  style: TextStyle(
                    color: index == 0
                        ? AppColors.black.withOpacity(0.7)
                        : AppColors.grey,
                    fontSize: 10,
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