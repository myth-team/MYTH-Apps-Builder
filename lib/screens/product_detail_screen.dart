import 'package:flutter/material.dart';
import 'package:shopify_modern_app/utils/colors.dart'; 
import 'package:shopify_modern_app/utils/state_manager.dart'; 
import 'package:shopify_modern_app/screens/cart_screen.dart'; 

class ProductDetailScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int quantity = 1;
  int selectedSize = 0;
  int selectedColor = 0;
  bool isAddedToCart = false;

  final List<String> sizes = ['S', 'M', 'L', 'XL', 'XXL'];
  final List<Color> colors = [
    AppColors.primary,
    AppColors.secondary,
    AppColors.accent,
    AppColors.black,
    AppColors.grey400,
  ];

  String _generateProductId() {
    return '${widget.product['name']}_${selectedSize}_${selectedColor}';
  }

  void _addToCart(StateManager stateManager) {
    stateManager.addToCart(
      id: _generateProductId(),
      name: widget.product['name'],
      price: widget.product['price'],
      image: widget.product['image'],
      quantity: quantity,
      selectedSize: selectedSize,
      selectedColor: selectedColor,
    );
    
    setState(() {
      isAddedToCart = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: AppColors.white),
            SizedBox(width: 12),
            Text('Added to cart!'),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.all(16),
      ),
    );

    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          isAddedToCart = false;
        });
      }
    });
  }

  void _toggleWishlist(StateManager stateManager) {
    final isInWishlist = stateManager.isInWishlist(widget.product['name']);
    
    stateManager.toggleWishlist(
      id: widget.product['name'],
      name: widget.product['name'],
      price: widget.product['price'],
      oldPrice: widget.product['oldPrice'],
      rating: widget.product['rating'],
      reviews: widget.product['reviews'],
      image: widget.product['image'],
      tag: widget.product['tag'],
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isInWishlist ? Icons.favorite_border : Icons.favorite,
              color: AppColors.white,
            ),
            SizedBox(width: 12),
            Text(
              isInWishlist ? 'Removed from wishlist' : 'Added to wishlist!',
            ),
          ],
        ),
        backgroundColor: isInWishlist ? AppColors.grey500 : AppColors.secondary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final stateManager = StateManagerProvider.of(context);
    final isInWishlist = stateManager.isInWishlist(widget.product['name']);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 350,
            pinned: true,
            backgroundColor: AppColors.white,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Icon(Icons.arrow_back, color: AppColors.textPrimary),
              ),
            ),
            actions: [
              Container(
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isInWishlist ? AppColors.secondary : AppColors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: IconButton(
                  icon: Icon(
                    isInWishlist ? Icons.favorite : Icons.favorite_border,
                    color: isInWishlist ? AppColors.white : AppColors.textPrimary,
                  ),
                  onPressed: () => _toggleWishlist(stateManager),
                ),
              ),
              Container(
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: IconButton(
                  icon: Icon(Icons.share_outlined, color: AppColors.textPrimary),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            Icon(Icons.share, color: AppColors.white),
                            SizedBox(width: 12),
                            Text('Share link copied!'),
                          ],
                        ),
                        backgroundColor: AppColors.primary,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        margin: EdgeInsets.all(16),
                      ),
                    );
                  },
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  Container(
                    color: AppColors.grey100,
                    child: Center(
                      child: Hero(
                        tag: 'product_${widget.product['name']}',
                        child: Image.network(
                          widget.product['image'],
                          width: 280,
                          height: 280,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  if (widget.product['tag'] != null)
                    Positioned(
                      top: 100,
                      left: 20,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: _getTagColor(widget.product['tag']),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          widget.product['tag'],
                          style: TextStyle(
                            color: AppColors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.product['name'],
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.star, color: AppColors.accent, size: 18),
                              SizedBox(width: 4),
                              Text(
                                widget.product['rating'].toString(),
                                style: TextStyle(
                                  fontAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Size Guide',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    _buildSizeGuideRow('S', 'Small', '80-85 cm'),
                                    _buildSizeGuideRow('M', 'Medium', '85-90 cm'),
                                    _buildSizeGuideRow('L', 'Large', '90-95 cm'),
                                    _buildSizeGuideRow('XL', 'Extra Large', '95-100 cm'),
                                    _buildSizeGuideRow('XXL', 'Double XL', '100-105 cm'),
                                    SizedBox(height: 16),
                                  ],
                                ),
                              ),
                            );
                          },
                          child: Text(
                            'Size Guide',
                            style: TextStyle
                            child: Center(
                              child: Text(
                                sizes[index],
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: isSelected ? AppColors.white : AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Select Color',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: List.generate(colors.length, (index) {
                        final isSelected = selectedColor == index;
                        return GestureDetector(
                          onTap: () => setState(() => selectedColor = index),
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 200),
                            margin: EdgeInsets.only(right: 16),
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: colors[index],
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected ? AppColors.textPrimary : Colors.transparent,
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: colors[index].withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                          ),
                        ) Icon(Icons.verified_outlined, color: AppColors.success),
                          SizedBox(width: 8),
                          Text(
                            'Authentic',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.success,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    Row(
                      children: [
                        Text(
                          'Quantity',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Spacer(),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.grey100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                icon: ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 20,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _addToCart(stateManager),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: isAddedToCart ? AppColors.success : AppColors.grey100,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isAddedToCart ? Icons.check : Icons.shopping_cart_outlined,
: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryLight],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'Buy Now',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _calculateDiscount(double oldPrice, double newPrice) {
    final discount = ((oldPrice - newPrice) / oldPrice * 100).round();
    return '-$discount%';
  }

  Color _getTagColor(String tag) {
    switch (tag) {
      case 'New':
        return AppColors.success;
      case 'Hot':
        return AppColors.secondary;
      case 'Sale':
        return AppColors.error;
      case 'Popular':
        return AppColors.accent;
      default:
        if (tag.startsWith('-')) {
          return AppColors.secondary;
        }
        return AppColors.primary;
    }
  }

  Widget _buildSizeGuideRow(String size, String name, String measurement) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.grey100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                size,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Text(
            measurement,
            style: TextStyle(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}