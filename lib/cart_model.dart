
import 'package:flutter/foundation.dart';

class Product {
  final String name, imageUrl;

  Product(this.name, this.imageUrl);
}

class CartItem {
  final Product product;
  int quantity;

  CartItem(this.product, this.quantity);
}

class CartModel extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  int get totalItems =>
      _items.fold(0, (sum, item) => sum + item.quantity);

  void add(Product product) {
    final index = _items.indexWhere(
      (item) => item.product.name == product.name,
    );

    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(product, 1));
    }

    notifyListeners();
  }

  // Fungsi menghapus produk dari keranjang
  void remove(Product product) {
    _items.removeWhere(
      (item) => item.product.name == product.name,
    );

    notifyListeners();
  }
}
