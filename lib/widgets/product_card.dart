import 'package:flutter/material.dart';
import 'package:shopify_modern_app/utils/colors.dart'; 
import 'package:shopify_modern_app/utils/state_manager.dart'; 

class ProductCard extends StatelessWidget {
  final String name;
  final double price;
  final double? oldPrice;
  final double rating;
  final int reviews;
  final String image;
  final String? tag;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.name,
    required this.price,
    this.oldPrice,
    required this.rating,
    required this.reviews,
    required this.image,
    this.tag,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final stateManager = StateManagerProvider.of(context);
    final isInWishlist = stateManager.isInWishlist(name);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
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
                      color: AppColors.grey100,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      child: Hero(
                        tag: 'product_$name',
                        child: Image.network(
                          image,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Icon(Icons.image, color: AppColors.grey300, size: 40),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  if (tag != null)
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: _getTagColor(tag!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          tag!,
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: GestureDetector(
                      onTap: () {
                        stateManager.toggleWishlist(
                          id: name,
                          name: name,
                          price: price,
                          oldPrice: oldPrice,
                          rating: rating,
                          reviews: reviews,
                          image: image,
                          tag: tag,
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
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.shadow,
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Icon(
                          isInWishlist ? Icons.favorite : Icons.favorite_outline,
                          color: isInWishlist ? AppColors.secondary : AppColors.grey400,
                          size: 18,
                        ),
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
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Icon(Icons.star, color: AppColors.accent, size: 16),
                        SizedBox(width: 4),
                        Text(
                          rating.toString(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(width: 4),
                        Text(
                          '($reviews)',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          '\$${price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        if (oldPrice != null) ...[
                          SizedBox(width: 8),
                          Text(
                            '\$${oldPrice!.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.grey400,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
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
}