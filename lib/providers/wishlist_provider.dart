import 'package:flutter/foundation.dart';
import 'package:zee_luxury_jewels_app/models/jewelry_item.dart'; 

class WishlistProvider extends ChangeNotifier {
  final List<JewelryItem> _items = [];

  List<JewelryItem> get items => List.unmodifiable(_items);

  int get count => _items.length;

  bool isInWishlist(JewelryItem item) {
    return _items.any((wishItem) => wishItem.id == item.id);
  }

  void toggleWishlist(JewelryItem item) {
    if (isInWishlist(item)) {
      _items.removeWhere((wishItem) => wishItem.id == item.id);
    } else {
      _items.add(item);
    }
    notifyListeners();
  }

  void removeFromWishlist(String itemId) {
    _items.removeWhere((item) => item.id == itemId);
    notifyListeners();
  }
}