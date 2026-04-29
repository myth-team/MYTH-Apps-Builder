import 'package:flutter/foundation.dart';
import 'package:zee_luxury_jewels_app/models/jewelry_item.dart'; 
import 'package:zee_luxury_jewels_app/models/cart_item.dart'; 

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get totalAmount => _items.fold(0, (sum, item) => sum + item.totalPrice);

  bool isInCart(JewelryItem item) {
    return _items.any((cartItem) => cartItem.item.id == item.id);
  }

  void addToCart(JewelryItem item, {String? size}) {
    final existingIndex = _items.indexWhere((cartItem) => cartItem.item.id == item.id);
    if (existingIndex >= 0) {
      _items[existingIndex].quantity++;
    } else {
      _items.add(CartItem(item: item, selectedSize: size));
    }
    notifyListeners();
  }

  void removeFromCart(String itemId) {
    _items.removeWhere((item) => item.item.id == itemId);
    notifyListeners();
  }

  void updateQuantity(String itemId, int quantity) {
    final index = _items.indexWhere((item) => item.item.id == itemId);
    if (index >= 0) {
      if (quantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = quantity;
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}