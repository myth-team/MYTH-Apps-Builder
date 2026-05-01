class Hotel {
  final String id;
  final String name;
  final String location;
  final double rating;
  final double price;
  final List<String> imageUrls;
  final String description;
  final List<String> amenities;

  Hotel({
    required this.id,
    required this.name,
    required this.location,
    required this.rating,
    required this.price,
    required this.imageUrls,
    required this.description,
    required this.amenities,
  });
}