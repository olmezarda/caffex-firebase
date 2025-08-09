import 'package:caffex_firebase/data/models/caffe_model.dart';

class OrderItem {
  final CaffeModel caffe;
  final int quantity;

  OrderItem({required this.caffe, required this.quantity});
}

class OrderManager {
  OrderManager._privateConstructor();
  static final OrderManager _instance = OrderManager._privateConstructor();
  factory OrderManager() => _instance;

  final List<OrderItem> _orders = [];

  List<OrderItem> get orderItems => List.unmodifiable(_orders);

  void addOrder(CaffeModel caffe, int quantity) {
    _orders.add(OrderItem(caffe: caffe, quantity: quantity));
  }

  void clear() {
    _orders.clear();
  }
}
