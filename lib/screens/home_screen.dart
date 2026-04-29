import 'package:flutter/material.dart';
import 'package:shopify_pro_app/utils/colors.dart'; 
import 'package:shopify_pro_app/screens/product_detail_screen.dart'; 
import 'package:shopify_pro_app/screens/cart_screen.dart'; 
import 'package:shopify_pro_app/screens/profile_screen.dart'; 
import 'package:shopify_pro_app/screens/categories_screen.dart'; 
import 'package:shopify_pro_app/widgets/product_card.dart'; 
import 'package:shopify_pro_app/widgets/category_chip.dart'; 
import 'package:shopify_pro_app/widgets/featured_banner.dart'; 

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Women', 'Men', 'Shoes', 'Bags', 'Accessories'];

  final List<Map<String, dynamic>> _featuredProducts = [
    {'name': 'Premium Leather Bag', 'price': 299.99, 'rating': 4.8, 'image': 'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=400', 'discount': 20},
    {'name': 'Classic Sneakers', 'price': 189.99, 'rating': 4.9, 'image': 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400', 'discount': 15},
    {'name': 'Designer Watch', 'price': 459.99, 'rating': 4.7, 'image': 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400', 'discount': 0},
  ];

  final List<Map<String, dynamic>> _products = [
    {'name': 'Summer Dress', 'price': 89.99, 'oldPrice': 129.99, 'rating': 4.5, 'image': 'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=400', 'discount': 30},
    {'name': 'Casual T-Shirt', 'price': 39.99, 'oldPrice': 59.99, 'rating': 4.3, 'image': 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400', 'discount': 33},
    {'name': 'Denim Jacket', 'price': 149.99, 'oldPrice': 199.99, 'rating': 4.6, 'image': 'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=400', 'discount': 25},
    {'name': 'Running Shoes', 'price': 129.99, 'oldPrice': 159.99, 'rating': 4.8, 'image': 'https://images.unsplash.com/photo-1460353581641-37baddab0fa2?w=400', 'discount': 18},
    {'name': 'Leather Belt', 'price': 49.99, 'oldPrice': 69.99, 'rating': 4.4, 'image': 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=400', 'discount': 28},
    {'name': 'Sunglasses', 'price': 79.99, 'oldPrice': 99.99, 'rating': 4.7, 'image': 'https://images.unsplash.com/photo-1572635196237-14b3f281503f?w=400', 'discount': 20},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: [
            _buildHomeContent(),
            CategoriesScreen(),
            CartScreen(),
            ProfileScreen(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 20,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.surface,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textLight,
          elevation: 0,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
          unselectedLabelStyle: TextStyle(fontSize: 12),
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: 'Categories'),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag_outlined),
              activeIcon: Icon(Icons.shopping_bag_rounded),
              label: 'Cart',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeContent() {
    return CustomScrollView(
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
                          'Hello, Sarah 👋',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Find Your Style',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.cardShadow,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(Icons.notifications_outlined, color: AppColors.textPrimary),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  height: 54,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.cardShadow,
                        blurRadius: 15,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search products...',
                      hintStyle: TextStyle(color: AppColors.textLight),
                      prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
                      suffixIcon: Container(
                        margin: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppColors.gradientStart, AppColors.gradientEnd],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.tune, color: AppColors.surface, size: 20),
                          onPressed: () {},
                        ),
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: FeaturedBanner(products: _featuredProducts),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 24),
                Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _categories.map((category) {
                      return CategoryChip(
                        label: category,
                        isSelected: _selectedCategory == category,
                        onTap: () => setState(() => _selectedCategory = category),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Popular Products',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'See All',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.all(20),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final product = _products[index];
                return ProductCard(
                  product: product,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailScreen(product: product),
                      ),
                    );
                  },
                );
              },
              childCount: _products.length,
            ),
          ),
        ),
      ],
    );
  }
}