import 'dart:io';

import 'package:expense_tracker/src/constants/api_keys.dart';
import 'package:expense_tracker/src/features/core/screens/summary/summary_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:expense_tracker/src/features/core/screens/home/home_screen.dart';
import 'package:expense_tracker/src/features/core/screens/settings/settings_screen.dart';
import 'package:expense_tracker/src/repository/authentication_repository/authentication_repository.dart';
import 'package:expense_tracker/src/utils/app_bindings.dart';
import 'package:expense_tracker/src/utils/theme/theme.dart';
import 'package:expense_tracker/src/utils/theme/theme_controller.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: WidgetsFlutterBinding.ensureInitialized());

  try {
    // Initialize Firebase
    // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    // Initialize Authentication
    if (Platform.isAndroid) {
      await Purchases.configure(PurchasesConfiguration(tRevenueCatApiKeyAndroid));
    }
    else if (Platform.isIOS) {
      await Purchases.configure(PurchasesConfiguration(tRevenueCatApiKeyiOS));
    }
    Get.put(AuthenticationRepository());

    // Remove splash screen after initialization
    FlutterNativeSplash.remove();
  } catch (e) {
    Get.snackbar("Error", "Failed to initialize Firebase", snackPosition: SnackPosition.BOTTOM);
  }

  runApp(App(navigatorKey: navigatorKey));
}

class App extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const App({super.key, required this.navigatorKey});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GetMaterialApp(
        navigatorKey: widget.navigatorKey,
        initialBinding: AppBinding(),
        themeMode: themeController.themeMode.value,
        theme: TAppTheme.lightTheme,
        darkTheme: TAppTheme.darkTheme,
        debugShowCheckedModeBanner: false,
        defaultTransition: Transition.noTransition,
        transitionDuration: const Duration(milliseconds: 500),
        home: const Scaffold(body: Center(child: CircularProgressIndicator())),
        getPages: [
          GetPage(name: '/home', page: () => const HomeScreenPage()),
          GetPage(name: '/summary', page: () => const SummaryScreenPage()),
          GetPage(name: '/settings', page: () => const SettingsScreenPage()),
        ],
      );
    });
  }
}