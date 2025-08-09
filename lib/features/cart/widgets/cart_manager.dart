import 'package:caffex_firebase/data/models/caffe_model.dart';
import 'package:caffex_firebase/data/models/cart_item_model.dart';

class CartManager {
  CartManager._privateConstructor();
  static final CartManager _instance = CartManager._privateConstructor();
  factory CartManager() => _instance;

  final List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => List.unmodifiable(_cartItems);

  void addItem(CaffeModel item, {int quantity = 1}) {
    final index = _cartItems.indexWhere(
      (element) => element.caffe.id == item.id,
    );
    if (index >= 0) {
      _cartItems[index].quantity += quantity;
    } else {
      _cartItems.add(CartItem(caffe: item, quantity: quantity));
    }
  }

  void removeItem(CaffeModel item) {
    _cartItems.removeWhere((element) => element.caffe.id == item.id);
  }

  void clear() {
    _cartItems.clear();
  }
}
