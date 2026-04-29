import 'package:zee_luxury_jewels_app/models/jewelry_item.dart'; 

class CartItem {
  final JewelryItem item;
  int quantity;
  String? selectedSize;

  CartItem({
    required this.item,
    this.quantity = 1,
    this.selectedSize,
  });

  double get totalPrice => item.price * quantity;
}