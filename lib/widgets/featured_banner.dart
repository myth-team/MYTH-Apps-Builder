import 'package:flutter/material.dart';
import 'package:shopify_pro_app/utils/colors.dart'; 
import 'package:shopify_pro_app/screens/product_detail_screen.dart'; 

class FeaturedBanner extends StatefulWidget {
  final List<Map<String, dynamic>> products;

  const FeaturedBanner({super.key, required this.products});

  @override
  State<FeaturedBanner> createState() => _FeaturedBannerState();
}

class _FeaturedBannerState extends State<FeaturedBanner> {
  int _currentPage = 0;
  final PageController _pageController = PageController(viewportFraction: 0.85);

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      if (_pageController.page != null) {
        setState(() => _currentPage = _pageController.page!.round());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16),
        Container(
          height: 200,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.products.length,
            itemBuilder: (context, index) {
              final product = widget.products[index];
              return AnimatedContainer(
                duration: Duration(milliseconds: 300),
                margin: EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: index == 0
                        ? [Color(0xFF667eea), Color(0xFF764ba2)]
                        : index == 1
                            ? [Color(0xFFf093fb), Color(0xFFf5576c)]
                            : [Color(0xFF4facfe), Color(0xFF00f2fe)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (index == 0
                              ? Color(0xFF667eea)
                              : index == 1
                                  ? Color(0xFFf5576c)
                                  : Color(0xFF4facfe))
                          .withOpacity(0.4),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailScreen(product: product),
                      ),
                    );
                  },
                  child: Stack(
                    children: [
                      Positioned(
                        right: -20,
                        bottom: -20,
                        child: Opacity(
                          opacity: 0.3,
                          child: Icon(
                            Icons.shopping_bag_rounded,
                            size: 180,
                            color: AppColors.surface,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppColors.surface.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.star, color: AppColors.star, size: 14),
                                        SizedBox(width: 4),
                                        Text(
                                          product['rating'].toString(),
                                          style: TextStyle(
                                            color: AppColors.surface,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    product['name'],
                                    style: TextStyle(
                                      color: AppColors.surface,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Text(
                                        '\$${product['price'].toStringAsFixed(2)}',
                                        style: TextStyle(
                                          color: AppColors.surface,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      if (product['discount'] > 0) ...[
                                        SizedBox(width: 12),
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: AppColors.surface,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            '-${product['discount']}%',
                                            style: TextStyle(
                                              color: AppColors.secondary,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                product['image'],
                                width: 140,
                                height: 140,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.products.length,
            (index) => AnimatedContainer(
              duration: Duration(milliseconds: 200),
              margin: EdgeInsets.symmetric(horizontal: 4),
              width: _currentPage == index ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentPage == index ? AppColors.primary : AppColors.divider,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}