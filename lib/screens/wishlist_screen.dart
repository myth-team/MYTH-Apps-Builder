import 'package:flutter/material.dart';
import 'package:shopify_modern_app/utils/colors.dart'; 
import 'package:shopify_modern_app/utils/state_manager.dart'; 
import 'package:shopify_modern_app/screens/product_detail_screen.dart'; 

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stateManager = StateManagerProvider.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'My Wishlist',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          if (stateManager.wishlistItems.isNotEmpty)
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    title: Text('Clear Wishlist'),
                    content: Text('Are you sure you want to remove all items from your wishlist?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          stateManager.clearWishlist();
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Clear All',
                          style: TextStyle(color: AppColors.error),
                        ),
                      ),
                    ],
                  ),
                );
              },
              child: Text(
                'Clear All',
                style: TextStyle(color: AppColors.error),
              ),
            ),
        ],
      ),
      body: stateManager.wishlistItems.isEmpty
          ? _buildEmptyState()
          : _buildWishlistContent(context, stateManager),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppColors.secondary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.favorite_outline,
              size: 80,
              color: AppColors.secondary,
            ),
          ),
          SizedBox(height: 24),
          Text(
            'Your wishlist is empty',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Save items you love by tapping the heart icon',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 32),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              'Start Shopping',
              style: TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWishlistContent(BuildContext context, StateManager stateManager) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${stateManager.wishlistItems.length} items',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.sort, color: AppColors.primary, size: 16),
                      SizedBox(width: 8),
                      Text(
                        'Sort',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
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
              childAspectRatio: 0.65,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final item = stateManager.wishlistItems[index];
                return _buildWishlistItem(context, item, stateManager);
              },
              childCount: stateManager.wishlistItems.length,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(height: 100),
        ),
      ],
    );
  }

  Widget _buildWishlistItem(BuildContext context, WishlistItem item, StateManager stateManager) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(
              product: {
                'name': item.name,
                'price': item.price,
                'oldPrice': item.oldPrice,
                'rating': item.rating,
                'reviews': item.reviews,
                'image': item.image,
                'tag': item.tag,
              },
            ),
          ),
        );
      },
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
                      child: Image.network(
                        item.image,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Icon(Icons.image, color: AppColors.grey300, size: 40),
                          );
                        },
                      ),
                    ),
                  ),
                  if (item.tag != null)
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: _getTagColor(item.tag!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          item.tag!,
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
                          id: item.id,
                          name: item.name,
                          price: item.price,
                          oldPrice: item.oldPrice,
                          rating: item.rating,
                          reviews: item.reviews,
                          image: item.image,
                          tag: item.tag,
                        );
                      },
                      child: Container(
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
                          Icons.favorite,
                          color: AppColors.secondary,
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
                      item.name,
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
                          item.rating.toString(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(width: 4),
                        Text(
                          '(${item.reviews})',
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
                          '\$${item.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        if (item.oldPrice != null) ...[
                          SizedBox(width: 8),
                          Text(
                            '\$${item.oldPrice!.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.grey400,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        stateManager.addToCart(
                          id: '${item.id}_M_0',
                          name: item.name,
                          price: item.price,
                          image: item.image,
                          quantity: 1,
                          selectedSize: 1,
                          selectedColor: 0,
                        );
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
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.shopping_cart_outlined, color: AppColors.white, size: 16),
                            SizedBox(width: 6),
                            Text(
                              'Add to Cart',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
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