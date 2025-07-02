import 'package:flutter/foundation.dart';

class CartService extends ChangeNotifier {
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  final List<Map<String, dynamic>> _cartItems = [];
  final Map<String, bool> _checkedItems = {};

  List<Map<String, dynamic>> get cartItems => List.unmodifiable(_cartItems);
  Map<String, bool> get checkedItems => Map.unmodifiable(_checkedItems);

  void addToCart(Map<String, dynamic> product) {
    // Check if product already exists
    final existingIndex = _cartItems.indexWhere(
      (item) => item['id'] == product['id'],
    );

    if (existingIndex == -1) {
      _cartItems.add(product);
      _checkedItems[product['id'].toString()] = true;
      notifyListeners();
    }
  }

  void removeFromCart(String productId) {
    _cartItems.removeWhere((item) => item['id'].toString() == productId);
    _checkedItems.remove(productId);
    notifyListeners();
  }

  void toggleItemCheck(String productId) {
    _checkedItems[productId] = !(_checkedItems[productId] ?? false);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    _checkedItems.clear();
    notifyListeners();
  }

  int getTotalPrice() {
    int total = 0;
    for (var item in _cartItems) {
      final productId = item['id'].toString();
      if (_checkedItems[productId] == true) {
        final price = _parsePrice(item['price']);
        total += price;
      }
    }
    return total;
  }

  List<Map<String, dynamic>> getSelectedItems() {
    return _cartItems.where((item) {
      return _checkedItems[item['id'].toString()] == true;
    }).toList();
  }

  int get itemCount => _cartItems.length;
  int get selectedItemCount => _checkedItems.values.where((checked) => checked).length;

  int _parsePrice(dynamic price) {
    if (price is int) return price;
    if (price is double) return price.toInt();
    if (price is String) return int.tryParse(price.replaceAll('.', '')) ?? 0;
    return 0;
  }
}
