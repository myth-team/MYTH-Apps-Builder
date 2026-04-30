import 'package:flutter/material.dart';
import 'package:shopify_modern_app/utils/colors.dart'; 

class CartItem {
  final String id;
  final String name;
  final double price;
  final String image;
  int quantity;
  int selectedSize;
  int selectedColor;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    this.quantity = 1,
    this.selectedSize = 0,
    this.selectedColor = 0,
  });
}

class WishlistItem {
  final String id;
  final String name;
  final double price;
  final double? oldPrice;
  final double rating;
  final int reviews;
  final String image;
  final String? tag;

  WishlistItem({
    required this.id,
    required this.name,
    required this.price,
    this.oldPrice,
    required this.rating,
    required this.reviews,
    required this.image,
    this.tag,
  });
}

class StateManager extends ChangeNotifier {
  List<CartItem> _cartItems = [];
  List<WishlistItem> _wishlistItems = [];
  List<String> _sizeOptions = ['S', 'M', 'L', 'XL', 'XXL'];
  List<Color> _colorOptions = [
    AppColors.primary,
    AppColors.secondary,
    AppColors.accent,
    AppColors.black,
    AppColors.grey400,
  ];

  List<CartItem> get cartItems => _cartItems;
  List<WishlistItem> get wishlistItems => _wishlistItems;
  List<String> get sizeOptions => _sizeOptions;
  List<Color> get colorOptions => _colorOptions;

  int get cartItemCount => _cartItems.fold(0, (sum, item) => sum + item.quantity);

  double get cartSubtotal => _cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
  double get cartShipping => _cartItems.isEmpty ? 0 : 9.99;
  double get cartTotal => cartSubtotal + cartShipping;

  bool isInWishlist(String productId) {
    return _wishlistItems.any((item) => item.id == productId);
  }

  void addToCart({
    required String id,
    required String name,
    required double price,
    required String image,
    int quantity = 1,
    int selectedSize = 0,
    int selectedColor = 0,
  }) {
    final existingIndex = _cartItems.indexWhere((item) => item.id == id);
    
    if (existingIndex >= 0) {
      _cartItems[existingIndex].quantity += quantity;
    } else {
      _cartItems.add(CartItem(
        id: id,
        name: name,
        price: price,
        image: image,
        quantity: quantity,
        selectedSize: selectedSize,
        selectedColor: selectedColor,
      ));
    }
    notifyListeners();
  }

  void removeFromCart(String id) {
    _cartItems.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void updateCartQuantity(String id, int quantity) {
    final index = _cartItems.indexWhere((item) => item.id == id);
    if (index >= 0) {
      if (quantity <= 0) {
        _cartItems.removeAt(index);
      } else {
        _cartItems[index].quantity = quantity;
      }
      notifyListeners();
    }
  }

  void toggleWishlist({
    required String id,
    required String name,
    required double price,
    double? oldPrice,
    required double rating,
    required int reviews,
    required String image,
    String? tag,
  }) {
    final existingIndex = _wishlistItems.indexWhere((item) => item.id == id);
    
    if (existingIndex >= 0) {
      _wishlistItems.removeAt(existingIndex);
    } else {
      _wishlistItems.add(WishlistItem(
        id: id,
        name: name,
        price: price,
        oldPrice: oldPrice,
        rating: rating,
        reviews: reviews,
        image: image,
        tag: tag,
      ));
    }
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  void clearWishlist() {
    _wishlistItems.clear();
    notifyListeners();
  }
}

class StateManagerProvider extends InheritedWidget {
  final StateManager stateManager;

  StateManagerProvider({
    super.key,
    required this.stateManager,
    required super.child,
  });

  static StateManager of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<StateManagerProvider>();
    return provider!.stateManager;
  }

  @override
  bool updateShouldNotify(StateManagerProvider oldWidget) {
    return stateManager != oldWidget.stateManager;
  }
}