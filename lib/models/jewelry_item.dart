class JewelryItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final List<String> images;
  final String category;
  final double rating;
  final int reviews;
  final bool isNew;
  final bool isBestseller;
  final String material;
  final String gemstone;
  final double weight;

  JewelryItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.images,
    required this.category,
    this.rating = 0.0,
    this.reviews = 0,
    this.isNew = false,
    this.isBestseller = false,
    required this.material,
    required this.gemstone,
    required this.weight,
  });
}