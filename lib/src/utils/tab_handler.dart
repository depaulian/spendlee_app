import 'package:get/get.dart';

class TabHandler {
  void handleTabChange(int index) {
    switch (index) {
      case 0:
        Get.toNamed('/home');
        break;
      case 1:
        Get.toNamed('/summary');
        break;
      case 2:
        Get.toNamed('/settings');
        break;
    }
  }
}