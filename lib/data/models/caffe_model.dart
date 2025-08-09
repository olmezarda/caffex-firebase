enum CaffeCategory { hot, cold }

class CaffeModel {
  final String id;
  final String name;
  final String imagePath;
  final double price;
  final bool isTopSeller;
  final String description;
  final CaffeCategory category;

  CaffeModel({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.price,
    required this.isTopSeller,
    required this.description,
    required this.category,
  });
}
