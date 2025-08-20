class ProductCategory {
  final String name;
  final String imagePath;
  final String label;
  final double refillPrice;
  final double newPrice;
  final bool hasRefill;

  ProductCategory({
    required this.name,
    required this.imagePath,
    required this.label,
    required this.refillPrice,
    required this.newPrice,
    required this.hasRefill,
  });

  // Convert ProductCategory to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'imagePath': imagePath,
      'label': label,
      'refillPrice': refillPrice,
      'newPrice': newPrice,
      'hasRefill': hasRefill,
    };
  }

  // Create ProductCategory from JSON
  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      name: json['name'],
      imagePath: json['imagePath'],
      label: json['label'],
      refillPrice: json['refillPrice'],
      newPrice: json['newPrice'],
      hasRefill: json['hasRefill'],
    );
  }
}