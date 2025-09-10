class PricingPlan {
  final String id;
  final String name;
  final double price;
  final double? pricePerMonth;
  final String billing;
  final bool popular;
  final String? savings;
  final String? badge;
  final String description;
  final List<String> features;

  PricingPlan({
    required this.id,
    required this.name,
    required this.price,
    this.pricePerMonth,
    required this.billing,
    required this.popular,
    this.savings,
    this.badge,
    required this.description,
    required this.features,
  });

  factory PricingPlan.fromJson(Map<String, dynamic> json) {
    return PricingPlan(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(),
      pricePerMonth: json['price_per_month']?.toDouble(),
      billing: json['billing'],
      popular: json['popular'] ?? false,
      savings: json['savings'],
      badge: json['badge'],
      description: json['description'],
      features: List<String>.from(json['features']),
    );
  }
}