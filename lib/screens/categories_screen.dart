import 'package:flutter/material.dart';
import 'package:shopify_modern_app/utils/colors.dart'; 
import 'package:shopify_modern_app/widgets/product_card.dart'; 

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final List<Map<String, dynamic>> categories = [
    {'name': 'Clothing', 'icon': Icons.checkroom, 'count': 234, 'color': AppColors.primary},
    {'name': 'Shoes', 'icon': Icons.sports_handball, 'count': 189, 'color': AppColors.secondary},
    {'name': 'Electronics', 'icon': Icons.devices, 'count': 156, 'color': AppColors.accent},
    {'name': 'Accessories', 'icon': Icons.watch, 'count': 98, 'color': AppColors.success},
    {'name': 'Beauty', 'icon': Icons.spa, 'count': 145, 'color': AppColors.warning},
    {'name': 'Home', 'icon': Icons.home, 'count': 167, 'color': AppColors.error},
    {'name': 'Sports', 'icon': Icons.fitness_center, 'count': 112, 'color': AppColors.primary},
    {'name': 'Books', 'icon': Icons.menu_book, 'count': 203, 'color': AppColors.secondary},
  ];

  int selectedCategory = 0;

  final List<Map<String, dynamic>> products = [
    {'name': 'Organic Cotton T-Shirt', 'price': 39.99, 'oldPrice': 59.99, 'rating': 4.4, 'reviews': 678, 'image': 'https://picsum.photos/seed/6/300/300', 'tag': 'Sale'},
    {'name': 'Denim Jacket', 'price': 89.99, 'oldPrice': null, 'rating': 4.7, 'reviews': 234, 'image': 'https://picsum.photos/seed/7/300/300', 'tag': 'New'},
    {'name': 'Classic White Sneakers', 'price': 79.99, 'oldPrice': 99.99, 'rating': 4.6, 'reviews': 456, 'image': 'https://picsum.photos/seed/8/300/300', 'tag': '-20%'},
    {'name': 'Leather Belt', 'price': 29.99, 'oldPrice': null, 'rating': 4.3, 'reviews': 189, 'image': 'https://picsum.photos/seed/9/300/300', 'tag': null},
  ];

  @override
  Widget build(BuildContext context) {
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
                    Text(
                      'Categories',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Browse by category',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.2,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final category = categories[index];
                    final isSelected = selectedCategory == index;
                    return GestureDetector(
                      onTap: () => setState(() => selectedCategory = index),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: isSelected ? category['color'] : AppColors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: isSelected
                                  ? category['color'].withOpacity(0.3)
                                  : AppColors.shadow,
                              blurRadius: isSelected ? 15 : 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.white.withOpacity(0.2)
                                    : category['color'].withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                category['icon'],
                                size: 32,
                                color: isSelected ? AppColors.white : category['color'],
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              category['name'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: isSelected ? AppColors.white : AppColors.textPrimary,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '${category['count']} items',
                              style: TextStyle(
                                fontSize: 12,
                                color: isSelected
                                    ? AppColors.white.withOpacity(0.8)
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: categories.length,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Popular in ${categories[selectedCategory]['name']}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'See All',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.7,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final product = products[index];
                    return ProductCard(
                      name: product['name'],
                      price: product['price'],
                      oldPrice: product['oldPrice'],
                      rating: product['rating'],
                      reviews: product['reviews'],
                      image: product['image'],
                      tag: product['tag'],
                      onTap: () {},
                    );
                  },
                  childCount: products.length,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: 20),
            ),
          ],
        ),
      ),
    );
  }
}