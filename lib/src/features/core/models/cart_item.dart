import 'package:expense_tracker/src/features/core/models/product_category.dart';

class CartItem {
  final ProductCategory product;
  int quantity;
  final bool isRefill;

  CartItem({
    required this.product,
    this.quantity = 1,
    required this.isRefill,
  });

  // Get unit price based on whether this is a refill or new product
  double get unitPrice => isRefill ? product.refillPrice : product.newPrice;

  // Get total price for this item (unit price * quantity)
  double get totalPrice => unitPrice * quantity;

  // Convert CartItem to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
      'isRefill': isRefill,
    };
  }

  // Create CartItem from JSON
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: ProductCategory.fromJson(json['product']),
      quantity: json['quantity'],
      isRefill: json['isRefill'],
    );
  }
}