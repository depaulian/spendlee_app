import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:expense_tracker/src/features/core/models/cart_item.dart';
import 'package:expense_tracker/src/features/core/models/product_category.dart';

class CartController extends GetxController {
  // Observable list of cart items
  final RxList<CartItem> _cartItems = <CartItem>[].obs;
  final RxDouble _deliveryFee = 5000.0.obs;

  // Key for shared preferences
  static const String _cartStorageKey = 'expense_tracker_cart_items';

  // Singleton instance
  static CartController get instance => Get.find<CartController>();

  @override
  void onInit() {
    super.onInit();
    // Load cart items from local storage when controller initializes
    loadCartFromStorage();
  }

  // Getters for cart data
  List<CartItem> get cartItems => _cartItems;
  double get deliveryFee => _deliveryFee.value;

  // Calculate subtotal
  double get subtotal => _cartItems.fold(0, (sum, item) => sum + item.totalPrice);

  // Calculate total (subtotal + delivery fee)
  double get total => subtotal + _deliveryFee.value;

  // Add item to cart
  void addToCart(ProductCategory product, bool isRefill) {
    // For products without refill option, always use "new"
    final effectiveIsRefill = product.hasRefill ? isRefill : false;

    // Check if the product is already in the cart
    int existingIndex = _cartItems.indexWhere(
            (item) => item.product.name == product.name && item.isRefill == effectiveIsRefill
    );

    if (existingIndex >= 0) {
      // Increment quantity if already in cart
      _cartItems[existingIndex].quantity++;
      _cartItems.refresh(); // Notify observers of the change
    } else {
      // Add new item to cart
      _cartItems.add(CartItem(
        product: product,
        quantity: 1,
        isRefill: effectiveIsRefill,
      ));
    }

    // Save updated cart to storage
    saveCartToStorage();
  }

  // Remove item from cart
  void removeFromCart(int index) {
    if (index >= 0 && index < _cartItems.length) {
      _cartItems.removeAt(index);
      saveCartToStorage();
    }
  }

  // Update item quantity
  void updateQuantity(int index, int change) {
    if (index >= 0 && index < _cartItems.length) {
      _cartItems[index].quantity = (_cartItems[index].quantity + change).clamp(1, 99);
      _cartItems.refresh(); // Notify observers of the change
      saveCartToStorage();
    }
  }

  // Clear cart
  void clearCart() {
    _cartItems.clear();
    saveCartToStorage();
  }

  // Set delivery fee
  void setDeliveryFee(double fee) {
    _deliveryFee.value = fee;
  }

  // Save cart to local storage
  Future<void> saveCartToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Convert cart items to JSON
      final List<Map<String, dynamic>> cartItemsJson = _cartItems.map((item) => item.toJson()).toList();

      // Save as string
      await prefs.setString(_cartStorageKey, jsonEncode(cartItemsJson));
    } catch (e) {
      print('Error saving cart to storage: $e');
    }
  }

  // Load cart from local storage
  Future<void> loadCartFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      if (prefs.containsKey(_cartStorageKey)) {
        final String? cartJson = prefs.getString(_cartStorageKey);

        if (cartJson != null && cartJson.isNotEmpty) {
          final List<dynamic> decoded = jsonDecode(cartJson);

          // Clear current cart and add loaded items
          _cartItems.clear();

          for (var itemJson in decoded) {
            // Create CartItem from JSON
            final CartItem item = CartItem.fromJson(itemJson);
            _cartItems.add(item);
          }
        }
      }
    } catch (e) {
      print('Error loading cart from storage: $e');
    }
  }
}