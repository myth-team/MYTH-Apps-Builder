import 'package:flutter/material.dart';
import 'package:shopswift_prototype_app/utils/colors.dart'; 
import 'package:shopswift_prototype_app/screens/product_detail_screen.dart'; 

class ExploreScreen extends StatefulWidget {
  final bool isDarkMode;

  ExploreScreen({required this.isDarkMode});

  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';
  
  final List<String> filters = ['All', 'New Arrivals', 'Best Sellers', 'On Sale', 'Trending'];
  
  final List<Map<String, dynamic>> exploreProducts = [
    {'name': 'Wireless Earbuds Pro', 'price': 149.99, 'originalPrice': 199.99, 'image': 'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?w=400', 'rating': 4.8, 'discount': 25},
    {'name': 'Designer Sunglasses', 'price': 89.99, 'originalPrice': 129.99, 'image': 'https://images.unsplash.com/photo-1572635196237-14b3f281503f?w=400', 'rating': 4.6, 'discount': 31},
    {'name': 'Leather Belt', 'price': 39.99, 'originalPrice': 59.99, 'image': 'https://images.unsplash.com/photo-1624222247344-550fb60583dc?w=400', 'rating': 4.7, 'discount': 33},
    {'name': 'Smart Watch', 'price': 299.99, 'originalPrice': 399.99, 'image': 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400', 'rating': 4.9, 'discount': 25},
    {'name': 'Wireless Speaker', 'price': 79.99, 'originalPrice': 109.99, 'image': 'https://images.unsplash.com/photo-1608043152269-423dbba4e7e1?w=400', 'rating': 4.5, 'discount': 27},
    {'name': 'Backpack', 'price': 59.99, 'originalPrice': 89.99, 'image': 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=400', 'rating': 4.8, 'discount': 33},
  ];

  Color get _bgColor => widget.isDarkMode ? AppColors.darkBackground : AppColors.background;
  Color get _surfaceColor => widget.isDarkMode ? AppColors.darkSurface : AppColors.surface;
  Color get _cardColor => widget.isDarkMode ? AppColors.darkCardBackground : AppColors.background;
  Color get _textPrimary => widget.isDarkMode ? AppColors.darkTextPrimary : AppColors.textPrimary;
  Color get _textSecondary => widget.isDarkMode ? AppColors.darkTextSecondary : AppColors.textSecondary;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildSearchBar(),
            _buildFilters(),
            Expanded(child: _buildProductGrid()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Explore',
            style: TextStyle(
              color: _textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Discover amazing products',
            style: TextStyle(
              color: _textSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: _surfaceColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(widget.isDarkMode ? 0.2 : 0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.search, color: _textSecondary),
            SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _searchController,
                style: TextStyle(color: _textPrimary),
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  hintStyle: TextStyle(color: _textSecondary),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.tune,
                color: AppColors.primary,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: SizedBox(
        height: 40,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16),
          itemCount: filters.length,
          itemBuilder: (context, index) {
            bool isSelected = _selectedFilter == filters[index];
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedFilter = filters[index];
                });
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 4),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : _surfaceColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: isSelected ? AppColors.primary.withOpacity(0.2) : Colors.black.withOpacity(widget.isDarkMode ? 0.1 : 0.03),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  filters[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : _textSecondary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    fontSize: 13,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProductGrid() {
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.72,
      ),
      itemCount: exploreProducts.length,
      itemBuilder: (context, index) {
        return _buildExploreCard(exploreProducts[index]);
      },
    );
  }

  Widget _buildExploreCard(Map<String, dynamic> product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product, isDarkMode: widget.isDarkMode),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _surfaceColor,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(widget.isDarkMode ? 0.2 : 0.04),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: _cardColor,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      product['image'],
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: _surfaceColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.favorite_border,
                      color: AppColors.secondary,
                      size: 16,
                    ),
                  ),
                ),
                Positioned(
                  top: 6,
                  left: 6,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'NEW',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              product['name'],
              style: TextStyle(
                color: _textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber, size: 12),
                SizedBox(width: 3),
                Text(
                  '${product['rating']}',
                  style: TextStyle(
                    color: _textSecondary,
                    fontSize: 11,
                  ),
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.saleColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '-${product['discount']}%',
                    style: TextStyle(
                      color: AppColors.saleColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Spacer(),
            Row(
              children: [
                Text(
                  '\$${product['price']}',
                  style: TextStyle(
                    color: AppColors.priceColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                SizedBox(width: 4),
                Text(
                  '\$${product['originalPrice']}',
                  style: TextStyle(
                    color: _textSecondary,
                    fontSize: 11,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}