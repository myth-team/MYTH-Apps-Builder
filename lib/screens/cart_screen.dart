import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zee_luxury_jewels_app/utils/colors.dart'; 
import 'package:zee_luxury_jewels_app/providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepBlack,
      appBar: AppBar(
        backgroundColor: AppColors.deepBlack,
        elevation: 0,
        title: Text(
          'Shopping Cart',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w300,
            color: AppColors.pureWhite,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          if (cart.items.isEmpty) {
            return _buildEmptyCart();
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(20),
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final cartItem = cart.items[index];
                    return _buildCartItem(context, cartItem, cart);
                  },
                ),
              ),
              _buildCheckoutSection(context, cart),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 80,
            color: AppColors.softGray,
          ),
          SizedBox(height: 24),
          Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w300,
              color: AppColors.pureWhite,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Discover our exquisite collection',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.lightGray,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, dynamic cartItem, CartProvider cart) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.charcoal,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.softGray,
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              cartItem.item.images[0],
              width: 90,
              height: 90,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cartItem.item.name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.pureWhite,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 6),
                Text(
                  cartItem.item.category,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.primaryGold,
                    letterSpacing: 1,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '\\$${cartItem.item.price.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryGold,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              GestureDetector(
                onTap: () => cart.removeFromCart(cartItem.item.id),
                child: Icon(
                  Icons.close,
                  color: AppColors.lightGray,
                  size: 20,
                ),
              ),
              SizedBox(height: 16),
              Container(