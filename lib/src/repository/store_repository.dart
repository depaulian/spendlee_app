import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:expense_tracker/src/features/core/models/store.dart';

class StoreRepository extends GetxController {
  // List of all expense_tracker stores
  final List<Store> _stores = [
    Store(
      name: 'expense_tracker Kawempe',
      address: 'Plot 145, Kawempe-Tula Road, Kiiza Zone',
      lat: 0.3825,
      lng: 32.5700,
    ),
    Store(
      name: 'expense_tracker Namuwongo',
      address: 'Plot 177/179, Bukasa Rd, Namuwongo, Kampala',
      lat: 0.3089,
      lng: 32.6086,
    ),
    Store(
      name: 'expense_tracker Ggaba',
      address: 'Plot 145, Ggaba road',
      lat: 0.2500,
      lng: 32.6394,
    ),
    Store(
      name: 'expense_tracker Kamwokya',
      address: 'Plot 37, Bukoto Steet',
      lat: 0.3439,
      lng: 32.5903,
    ),
    Store(
      name: 'expense_tracker Bugolobi',
      address: 'Plot 8, Butabika road',
      lat: 0.3222,
      lng: 32.6156,
    ),
    Store(
      name: 'expense_tracker Kireka',
      address: 'Plot 230, Kamuli Ndugwa road',
      lat: 0.3564,
      lng: 32.6522,
    ),
    Store(
      name: 'expense_tracker Ntinda',
      address: 'Plot 101, Martyrs Way, Ministers Village',
      lat: 0.3525,
      lng: 32.6108,
    ),
    Store(
      name: 'expense_tracker Downtown',
      address: 'Plot 50, Rashid Khamis Road, Kampala, Uganda',
      lat: 0.3136,
      lng: 32.5825,
    ),
    Store(
      name: 'expense_tracker Mbarara I',
      address: 'Plot 55, Buremba road Kakoba',
      lat: -0.6178,
      lng: 30.6569,
    ),
    Store(
      name: 'expense_tracker Kabuusu',
      address: 'Plot 915, Block 17, Rubaga Road',
      lat: 0.2981,
      lng: 32.5553,
    ),
    Store(
      name: 'expense_tracker Seeta',
      address: 'Plot 1330, Bagala Zone, Namilyango road',
      lat: 0.3594,
      lng: 32.6781,
    ),
    Store(
      name: 'expense_tracker Najjanankumbi',
      address: 'Plot 269, Masanyalaze Zone, PO BOX 72672',
      lat: 0.2772,
      lng: 32.5708,
    ),
    Store(
      name: 'expense_tracker Makindye',
      address: 'Salama Road, Kirundu Zone',
      lat: 0.2897,
      lng: 32.5942,
    ),
    Store(
      name: 'expense_tracker Naalya',
      address: 'Plot 493, Shrine Lane, Naalya Housing Estate',
      lat: 0.3667,
      lng: 32.6317,
    ),
    Store(
      name: 'expense_tracker Mbarara II',
      address: 'Kokonjeru cell, Ntare Road, Kamukuzi division',
      lat: -0.6133,
      lng: 30.6458,
    ),
    Store(
      name: 'expense_tracker Kasubi',
      address: 'Hoima Road, Namugoona Zone, Lubaga Division, Kampala, P.O BOX 29619',
      lat: 0.3236,
      lng: 32.5483,
    ),
    Store(
      name: 'expense_tracker Jinja',
      address: 'Plot 3B, Iganga road, Jinja town',
      lat: 0.4428,
      lng: 33.2028,
    ),
    Store(
      name: 'expense_tracker Mbale',
      address: 'Plot 13, Bugwere Road, Muyembe Cell, Malukhu Parish, Industrial Borough',
      lat: 1.0789,
      lng: 34.1750,
    ),
    Store(
      name: 'expense_tracker Bushenyi',
      address: 'P.O Box 121, Tankhill, Ishaka, Bushenyi',
      lat: -0.5536,
      lng: 30.1389,
    ),
    Store(
      name: 'expense_tracker Masaka',
      address: 'Plot 20, Kumbu 7 Road, Masaka',
      lat: -0.3333,
      lng: 31.7333,
    ),
    Store(
      name: 'expense_tracker Hoima',
      address: 'Hoima Mainstreet, Opposite MTN office and KCB Bank',
      lat: 1.4350,
      lng: 31.3506,
    ),
    Store(
      name: 'expense_tracker Fort Portal',
      address: 'Plot 20/22, Kiboga Road, Fort Portal',
      lat: 0.6683,
      lng: 30.2731,
    ),
    Store(
      name: 'expense_tracker Tororo',
      address: 'Plot 32, Tagore Road',
      lat: 0.7033,
      lng: 34.1731,
    ),
    Store(
      name: 'expense_tracker Lira',
      address: 'Junior Quarters, Plot 20 Otim Tom Road',
      lat: 2.2499,
      lng: 32.8994,
    ),
    Store(
      name: 'expense_tracker Gulu II',
      address: 'Plot 23, Martin Obalim road, Labour line Road Zone, Nakasero',
      lat: 2.7747,
      lng: 32.2992,
    ),
  ];

  // Get all stores
  List<Store> get allStores => _stores;

  // Get stores in Kampala city center as fallback
  List<Store> getKampalaCenterStores() {
    // Default to stores in central Kampala area (approximate coordinates)
    const kampalaCenterLat = 0.3136;
    const kampalaCenterLng = 32.5825;

    // Calculate distances from Kampala center
    for (var store in _stores) {
      double distanceInMeters = Geolocator.distanceBetween(
        kampalaCenterLat,
        kampalaCenterLng,
        store.lat,
        store.lng,
      );

      // Convert to kilometers and round to 1 decimal place
      store.distance = double.parse((distanceInMeters / 1000).toStringAsFixed(1));
    }

    // Sort by distance from Kampala center
    final sortedStores = List<Store>.from(_stores);
    sortedStores.sort((a, b) => a.distance.compareTo(b.distance));

    // Return 3 closest stores to Kampala center
    return sortedStores.take(3).toList();
  }

  // Get nearby stores based on current position
  Future<List<Store>> getNearbyStores(Position? position) async {
    if (position == null) {
      return getKampalaCenterStores();
    }

    // Make a copy of the stores list to avoid modifying the original sorting
    final workingStores = List<Store>.from(_stores);

    // Calculate distances from user's position to each store
    for (var store in workingStores) {
      double distanceInMeters = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        store.lat,
        store.lng,
      );

      // Convert to kilometers and round to 1 decimal place
      store.distance = double.parse((distanceInMeters / 1000).toStringAsFixed(1));
    }

    // Sort by distance
    workingStores.sort((a, b) => a.distance.compareTo(b.distance));

    // Return 3 closest stores
    return workingStores.take(3).toList();
  }

  // Check and request location permissions
  Future<bool> checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  // Get current position
  Future<Position?> getCurrentPosition() async {
    try {
      if (!await checkLocationPermission()) {
        return null;
      }

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      print('Error getting location: $e');
      return null;
    }
  }
}