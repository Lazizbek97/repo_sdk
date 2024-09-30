class CatalogProductMd {
  final String id;
  final String name;
  final String description;
  final String price;
  final String image;

  CatalogProductMd({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
  });

  factory CatalogProductMd.fromJson(Map<String, dynamic> json) {
    return CatalogProductMd(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      image: json['image'],
    );
  }
  
}