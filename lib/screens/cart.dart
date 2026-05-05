import 'package:flutter/material.dart';
import 'package:ruby_rose_jewels_app/utils/colors.dart'; 

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: _CartBody(),
      floatingActionButton: _CheckoutButton(),
    );
  }
}

class _CartBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = _sampleCartItems;
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart_outlined, size: 80, color: AppColors.textLight),
            const SizedBox(height: 16),
            Text('Your cart is empty', style: TextStyle(fontSize: 18, color: AppColors.textSecondary)),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) => _CartItemCard(item: items[index]),
    );
  }

  List<Map<String, dynamic>> get _sampleCartItems => [
    {'id': 1, 'name': 'Rose Gold Diamond Ring', 'price': 299.99, 'image': 'https://images.unsplash.com/photo-1605100804763-247f67b3557e?w=400', 'quantity': 1},
    {'id': 2, 'name': 'Pearl Necklace', 'price': 149.99, 'image': 'https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?w=400', 'quantity': 2},
  ];
}

class _CartItemCard extends StatelessWidget {
  final Map<String, dynamic> item;
  const _CartItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: AppColors.surface,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(item['image'], width: 80, height: 80, fit: BoxFit.cover),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item['name'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  const SizedBox(height: 4),
                  Text('\$${(item['price'] as double).toStringAsFixed(2)}', style: TextStyle(fontSize: 14, color: AppColors.primary, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _QtyButton(icon: Icons.remove, onTap: () {}),
                      Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Text('${item['quantity']}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
                      _QtyButton(icon: Icons.add, onTap: () {}),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(icon: Icon(Icons.delete_outline, color: AppColors.error), onPressed: () {}),
          ],
        ),
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QtyButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(color: AppColors.cardBackground, borderRadius: BorderRadius.circular(4)),
        child: Icon(icon, size: 20, color: AppColors.primary),
      ),
    );
  }
}

class _CheckoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => Navigator.pushNamed(context, '/checkout'),
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      icon: const Icon(Icons.shopping_bag),
      label: const Text('Checkout'),
    );
  }
}