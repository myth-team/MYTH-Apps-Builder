import 'package:flutter/material.dart';
import 'package:ruby_rose_jewels_app/utils/colors.dart'; 

class CategoryProductsScreen extends StatelessWidget {
  const CategoryProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String category = ModalRoute.of(context)?.settings.arguments as String? ?? 'Rings';
    final products = _getProductsForCategory(category);

    return Scaffold(
      appBar: AppBar(
        title: Text(category),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return _ProductGridCard(
            name: product['name']!,
            price: product['price']!,
            image: product['image']!,
            onTap: () => Navigator.pushNamed(
              context,
              '/detail',
              arguments: product,
            ),
          );
        },
      ),
    );
  }

  List<Map<String, String>> _getProductsForCategory(String category) {
    final allProducts = {
      'Rings': [
        {'name': 'Ruby Heart Ring', 'price': '\$299', 'image': 'https://images.unsplash.com/photo-1605100804763-247f67b3557e?w=400', 'id': '101'},
        {'name': 'Gold Band Ring', 'price': '\$199', 'image': 'https://images.unsplash.com/photo-1603561596112-0a132908c1d8?w=400', 'id': '102'},
        {'name': 'Diamond Halo Ring', 'price': '\$499', 'image': 'https://images.unsplash.com/photo-1602751584552-8ba73aad10e1?w=400', 'id': '103'},
        {'name': 'Rose Gold Stack', 'price': '\$159', 'image': 'https://images.unsplash.com/photo-1617038260897-41a1f14a8ca0?w=400', 'id': '104'},
      ],
      'Necklaces': [
        {'name': 'Ruby Pendant', 'price': '\$349', 'image': 'https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?w=400', 'id': '201'},
        {'name': 'Pearl Strand', 'price': '\$279', 'image': 'https://images.unsplash.com/photo-1599643477877-530eb83abc8e?w=400', 'id': '202'},
        {'name': 'Gold Chain', 'price': '\$189', 'image': 'https://images.unsplash.com/photo-1611652022419-a9419f74343d?w=400', 'id': '203'},
        {'name': 'Diamond Necklace', 'price': '\$599', 'image': 'https://images.unsplash.com/photo-1602173574767-37ac01994b2a?w=400', 'id': '204'},
      ],
      'Earrings': [
        {'name': 'Diamond Studs', 'price': '\$149', 'image': 'https://images.unsplash.com/photo-1535632066927-ab7c9ab60908?w=400', 'id': '301'},
        {'name': 'Gold Hoops', 'price': '\$89', 'image': 'https://images.unsplash.com/photo-1589128777073-263566ae5e4d?w=400', 'id': '302'},
        {'name': 'Ruby Drops', 'price': '\$199', 'image': 'https://images.unsplash.com/photo-1617038260897-41a1f14a8ca0?w=400', 'id': '303'},
        {'name': 'Pearl Drops', 'price': '\$129', 'image': 'https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?w=400', 'id': '304'},
      ],
      'Bracelets': [
        {'name': 'Pearl Bracelet', 'price': '\$179', 'image': 'https://images.unsplash.com/photo-1611591437281-460bfbe1220a?w=400', 'id': '401'},
        {'name': 'Gold Bangle', 'price': '\$129', 'image': 'https://images.unsplash.com/photo-1603561596112-0a132908c1d8?w=400', 'id': '402'},
        {'name': 'Diamond Tennis', 'price': '\$399', 'image': 'https://images.unsplash.com/photo-1602751584552-8ba73aad10e1?w=400', 'id': '403'},
        {'name': 'Rose Gold Cuff', 'price': '\$159', 'image': 'https://images.unsplash.com/photo-1605100804763-247f67b3557e?w=400', 'id': '404'},
      ],
    };
    return allProducts[category] ?? [];
  }
}

class _ProductGridCard extends StatelessWidget {
  final String name;
  final String price;
  final String image;
  final VoidCallback onTap;

  const _ProductGridCard({
    required this.name,
    required this.price,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: AppColors.cardBackground,
                      child: const Icon(Icons.image, size: 48, color: AppColors.textLight),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    price,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
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