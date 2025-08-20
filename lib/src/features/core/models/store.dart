import 'dart:convert';

class Store {
  final String name;
  final String address;
  final double lat;
  final double lng;
  double distance;
  final bool isOpen;

  Store({
    required this.name,
    required this.address,
    required this.lat,
    required this.lng,
    this.distance = 0.0,
    this.isOpen = true,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'lat': lat,
      'lng': lng,
      'distance': distance,
      'isOpen': isOpen,
    };
  }

  // Create from JSON
  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      name: json['name'],
      address: json['address'],
      lat: json['lat'],
      lng: json['lng'],
      distance: json['distance'] ?? 0.0,
      isOpen: json['isOpen'] ?? true,
    );
  }

  // For storing a list of stores in SharedPreferences
  static String encodeStores(List<Store> stores) {
    return jsonEncode(stores.map((store) => store.toJson()).toList());
  }

  // For retrieving a list of stores from SharedPreferences
  static List<Store> decodeStores(String encodedStores) {
    final List<dynamic> decodedList = jsonDecode(encodedStores);
    return decodedList.map((json) => Store.fromJson(json)).toList();
  }

  // For easy string representation
  @override
  String toString() {
    return 'Store{name: $name, address: $address, distance: $distance}';
  }
}