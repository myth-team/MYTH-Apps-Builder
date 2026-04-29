import 'package:flutter/material.dart';
import 'package:shopify_pro_app/utils/colors.dart'; 
import 'package:shopify_pro_app/screens/product_detail_screen.dart'; 

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  String _selectedCategory = 'All';

  final Map<String, List<Map<String, dynamic>>> _categoryProducts = {
    'All': [
      {'name': 'Summer Dress', 'price': 89.99, 'image': 'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=400', 'discount': 30},
      {'name': 'Casual T-Shirt', 'price': 39.99, 'image': 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400', 'discount': 33},
      {'name': 'Running Shoes', 'price': 129.99, 'image': 'https://images.unsplash.com/photo-1460353581641-37baddab0fa2?w=400', 'discount': 18},
      {'name': 'Leather Bag', 'price': 299.99, 'image': 'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=400', 'discount': 20},
    ],
    'Women': [
      {'name': 'Elegant Dress', 'price': 159.99, 'image': 'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=400', 'discount': 25},
      {'name': 'Designer Heels', 'price': 199.99, 'image': 'https://images.unsplash.com/photo-1543163521-1bf539c55dd2?w=400', 'discount': 15},
      {'name': 'Designer Bag', 'price': 349.99, 'image': 'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=400', 'discount': 10},
    ],
    'Men': [
      {'name': 'Casual Jacket', 'price': 129.99, 'image': 'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=400', 'discount': 20},
      {'name': 'Oxford Shirt', 'price': 79.99, 'image': 'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=400', 'discount': 15},
      {'name': 'Chelsea Boots', 'price': 189.99, 'image': 'https://images.unsplash.com/photo-1638247025967-b4e38f787b76?w=400', 'discount': 25},
    ],
    'Shoes': [
      {'name': 'Running Sneakers', 'price': 149.99, 'image': 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400', 'discount': 20},
      {'name': 'Classic Loafers', 'price': 119.99, 'image': 'https://images.unsplash.com/photo-1614252369475-531eba835eb1?w=400', 'discount': 15},
    ],
    'Bags': [
      {'name': 'Leather Backpack', 'price': 179.99, 'image': 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=400', 'discount': 25},
      {'name': 'Clutch Purse', 'price': 89.99, 'image': 'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=400', 'discount': 30},
    ],
    'Accessories': [
      {'name': 'Luxury Watch', 'price': 459.99, 'image': 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400', 'discount': 10},
      {'name': 'Designer Sunglasses', 'price': 199.99, 'image': 'https://images.unsplash.com/photo-1572635196237-14b3f281503f?w=400', 'discount': 20},
    ],
  };

  final List<Map<String, dynamic>> _categories = [
    {'name': 'All', 'icon': Icons.apps, 'color': AppColors.primary},
    {'name': 'Women', 'icon': Icons.face, 'color': AppColors.secondary},
    {'name': 'Men', 'icon': Icons.face_3, 'color': Color(0xFF3498DB)},
    {'name': 'Shoes', 'icon': Icons.directions_run, 'color': Color(0xFF9B59B6)},
    {'name': 'Bags', 'icon': Icons.shopping_bag, 'color': Color(0xFFE67E22)},
    {'name': 'Accessories', 'icon': Icons.watch, 'color': Color(0xFF1ABC9C)},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Categories',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 100,
            padding: EdgeInsets.symmetric(vertical: 12),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category['name'];
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = category['name']),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    margin: EdgeInsets.symmetric(horizontal: 6),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? category['color'] : AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: isSelected
                              ? category['color'].withOpacity(0.3)
                              : AppColors.cardShadow,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          category['icon'],
                          color: isSelected ? AppColors.surface : category['color'],
                          size: 28,
                        ),
                        SizedBox(height: 6),
                        Text(
                          category['name'],
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? AppColors.surface : AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(20),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: _categoryProducts[_selectedCategory]!.length,
              itemBuilder: (context, index) {
                final product = _categoryProducts[_selectedCategory]![index];
                return _buildProductCard(product);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 15,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      child: Image.network(
                        product['image'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  if (product['discount'] > 0)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '-${product['discount']}%',
                          style: TextStyle(
                            color: AppColors.surface,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.cardShadow,
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.favorite_border,
                        size: 16,
                        color: AppColors.secondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product['name'],
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${product['price'].toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.primary,
                          ),
                        ),
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [AppColors.gradientStart, AppColors.gradientEnd],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.add,
                            size: 16,
                            color: AppColors.surface,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}