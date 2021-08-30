import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final String address;
  final String image;

  CartItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.address,
    required this.image,
  });
}

class Cart with ChangeNotifier {
  late Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  void addItem(String productId, String title, String address, String image) {
    if (_items.containsKey(productId)) {
      //change quantity...
      _items.update(
          productId,
          (existingCartItem) => CartItem(
                id: existingCartItem.id,
                title: existingCartItem.title,
                address: existingCartItem.address,
                quantity: existingCartItem.quantity + 1,
                image: existingCartItem.image,
              ));
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          address: address,
          quantity: 1,
          image: image,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId]!.quantity > 1) {
      _items.update(
          productId,
          (exitingCartItem) => CartItem(
                id: exitingCartItem.id,
                address: exitingCartItem.address,
                image: exitingCartItem.image,
                quantity: exitingCartItem.quantity - 1,
                title: exitingCartItem.title,
              ));
    } 
    else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
