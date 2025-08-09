class CaffeOrderModel {
  final String id;
  final String name;
  final double price;
  final String imagePath;
  final int quantity;
  final String address;

  CaffeOrderModel({
    required this.id,
    required this.name,
    required this.price,
    required this.imagePath,
    required this.quantity,
    required this.address,
  });
}
