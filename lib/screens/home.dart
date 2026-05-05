import 'package:flutter/material.dart';
import 'package:elite_eats_app/utils/colors.dart'; 
import 'package:elite_eats_app/screens/detail.dart'; 
import 'package:elite_eats_app/screens/cart.dart'; 
import 'package:elite_eats_app/screens/profile.dart'; 

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    const _HomeTab(),
    const _SearchTab(),
    const _OrdersTab(),
    const ProfileScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/cart'),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.shopping_cart, color: AppColors.surface),
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 200,
          floating: false,
          pinned: true,
          backgroundColor: AppColors.primary,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Hello, Food Lover!',
                        style: TextStyle(
                          color: AppColors.surface.withValues(alpha: 0.9),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'What would you like to eat?',
                        style: TextStyle(
                          color: AppColors.surface,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearchBar(),
                const SizedBox(height: 24),
                _buildCategoryChips(),
                const SizedBox(height: 24),
                _buildFeaturedSection(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search restaurants or dishes',
          hintStyle: TextStyle(color: AppColors.textSecondary),
          prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    final categories = [
      {'icon': Icons.local_pizza, 'label': 'Pizza'},
      {'icon': Icons.lunch_dining, 'label': 'Burgers'},
      {'icon': Icons.ramen_dining, 'label': 'Asian'},
      {'icon': Icons.breakfast_dining, 'label': 'Breakfast'},
      {'icon': Icons.icecream, 'label': 'Desserts'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categories',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: categories.map((cat) {
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: ActionChip(
                  avatar: Icon(cat['icon'] as IconData, size: 18, color: AppColors.primary),
                  label: Text(cat['label'] as String),
                  labelStyle: TextStyle(color: AppColors.textPrimary),
                  backgroundColor: AppColors.surface,
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedSection() {
    final restaurants = [
      {'name': 'Royal Pizza', 'rating': 4.8, 'time': '20-30 min', 'image': 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=400'},
      {'name': 'Burger Palace', 'rating': 4.6, 'time': '25-35 min', 'image': 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400'},
      {'name': 'Sushi Master', 'rating': 4.9, 'time': '30-40 min', 'image': 'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=400'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Featured Restaurants',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        ...restaurants.map((restaurant) {
          return _buildRestaurantCard(
            name: restaurant['name'] as String,
            rating: restaurant['rating'] as double,
            time: restaurant['time'] as String,
            image: restaurant['image'] as String,
          );
        }),
      ],
    );
  }

  Widget _buildRestaurantCard({
    required String name,
    required double rating,
    required String time,
    required String image,
  }) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        '/detail',
        arguments: {'name': name, 'rating': rating, 'time': time, 'image': image},
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                image,
                height: 140,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 140,
                    color: AppColors.divider,
                    child: const Icon(Icons.restaurant, size: 40),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.star, size: 18, color: AppColors.rating),
                      const SizedBox(width: 4),
                      Text(
                        rating.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.access_time, size: 18, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        time,
                        style: TextStyle(color: AppColors.textSecondary),
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
  }
}

class _SearchTab extends StatelessWidget {
  const _SearchTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 64, color: AppColors.textSecondary),
            const SizedBox(height: 16),
            Text(
              'Search for restaurants or dishes',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrdersTab extends StatelessWidget {
  const _OrdersTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long, size: 64, color: AppColors.textSecondary),
            const SizedBox(height: 16),
            Text(
              'No orders yet',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your order history will appear here',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}