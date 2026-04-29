import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zee_luxury_jewels_app/utils/colors.dart'; 
import 'package:zee_luxury_jewels_app/providers/wishlist_provider.dart';
import 'package:zee_luxury_jewels_app/providers/cart_provider.dart';
import 'package:zee_luxury_jewels_app/screens/product_detail_screen.dart'; 
import 'package:zee_luxury_jewels_app/screens/main_screen.dart'; 

class WishlistScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepBlack,
      appBar: AppBar(
        backgroundColor: AppColors.deepBlack,
        elevation: 0,
        title: Text(
          'My Wishlist',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w300,
            color: AppColors.pureWhite,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<WishlistProvider>(
        builder: (context, wishlist, child) {
          if (wishlist.items.isEmpty) {
            return _buildEmptyWishlist(context);
          }
          return ListView.builder(
            padding: EdgeInsets.all(20),
            itemCount: wishlist.items.length,
            itemBuilder: (context, index) {
              final item = wishlist.items[index];
              return _buildWishlistItem(context, item, wishlist);
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyWishlist(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_outline,
            size: 80,
            color: AppColors.softGray,
          ),
          SizedBox(height: 24),
          Text(
            'Your wishlist is empty',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w300,
              color: AppColors.pureWhite,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Save your favorite pieces here',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.lightGray,
            ),
          ),
          SizedBox(height: 32),
          GestureDetector(
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => MainScreen()),
                (route) => false,
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.primaryGold,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                'EXPLORE',
                style: TextStyle(
                  color: AppColors.deepBlack,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWishlistItem(BuildContext context, dynamic item, WishlistProvider wishlist) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.charcoal,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.softGray,
          width: 0.5,
        ),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailScreen(item: item),
                ),
              );
            },
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.horizontal(left: Radius.circular(16)),
                  child: Image.network(
                    item.images[0],
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.category,
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.primaryGold,
                          letterSpacing: 1,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        item.name,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: AppColors.pureWhite,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: AppColors.primaryGold,
                            size: 14,
                          ),
                          SizedBox(width: 4),
                          Text(
                            '${item.rating}',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.lightGray,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            '(${item.reviews})',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.lightGray.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        '\$${item.price.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryGold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: AppColors.softGray,
                  width: 0.5,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      final cart = Provider.of<CartProvider>(context, listen: false);
                      cart.addToCart(item);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Added to cart'),
                          backgroundColor: AppColors.successGreen,
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.primaryGold,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_shopping_cart,
                            color: AppColors.deepBlack,
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'ADD TO CART',
                            style: TextStyle(
                              color: AppColors.deepBlack,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                GestureDetector(
                  onTap: () => wishlist.removeFromWishlist(item.id),
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.softGray,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.delete_outline,
                      color: AppColors.errorRed,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}