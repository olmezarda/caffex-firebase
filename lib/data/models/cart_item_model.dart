import 'package:caffex_firebase/data/models/caffe_model.dart';

class CartItem {
  final CaffeModel caffe;
  int quantity;

  CartItem({required this.caffe, this.quantity = 1});
}
