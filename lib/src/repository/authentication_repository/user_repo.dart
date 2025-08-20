import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../features/authentication/models/user.dart';

class UserRepo with ChangeNotifier {

  static UserRepo get instance => Get.find();

  late final Rx<User?> _user;
  Rx<User?> get user => _user;

  void setUser(User user) {
    _user = user as Rx<User?>;
    notifyListeners();
  }
}