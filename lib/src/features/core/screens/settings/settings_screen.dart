import 'package:expense_tracker/src/repository/authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense_tracker/src/common_widgets/navbar/curved_navigation_bar.dart';
import 'package:expense_tracker/src/constants/colors.dart';
import 'package:expense_tracker/src/constants/image_strings.dart';
import 'package:expense_tracker/src/features/core/controllers/cart_controller.dart';
import 'package:expense_tracker/src/features/core/screens/settings/widgets/about.dart';
import 'package:expense_tracker/src/features/core/screens/settings/widgets/account_settings.dart';
import 'package:expense_tracker/src/features/core/screens/settings/widgets/preferences.dart';
import 'package:expense_tracker/src/features/core/screens/settings/widgets/profile_card.dart';
import 'package:expense_tracker/src/features/core/screens/settings/widgets/support.dart';
import 'package:expense_tracker/src/utils/tab_handler.dart';
import 'package:expense_tracker/src/utils/theme/theme_controller.dart';

class SettingsScreenPage extends StatefulWidget {
  const SettingsScreenPage({super.key});

  @override
  SettingsScreenPageState createState() => SettingsScreenPageState();
}

class SettingsScreenPageState extends State<SettingsScreenPage> {
  int currentPage = 2;
  final tabHandler = TabHandler();
  ThemeMode selectedTheme = ThemeMode.system;  // Using Flutter's ThemeMode
  bool notificationsEnabled = true;
  final cartController = Get.put(CartController.instance);
  final authRepo = AuthenticationRepository.instance;
  @override
  Widget build(BuildContext context) {
    final tabHandler = TabHandler();
    final themeController = Get.put(ThemeController());
    final isDark = themeController.isDarkMode(context);
    final txtTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: tWhiteColor,
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(color: tWhiteColor),),
        backgroundColor: tPrimaryColor,
        elevation: 0,
        leading: Builder(
          builder: (context) => Image.asset(
            tLogo,
            fit: BoxFit.contain,
          ),
        )
      ),
      body: SafeArea(
        child: ListView(
          children: [
            ProfileCard(
              name: authRepo.getUserFullName,
              email: authRepo.getUserEmail,
              isDark: isDark,
              txtTheme: txtTheme,
              onEdit: () {
                // Handle edit profile
              },
            ),
            AccountSettingsSection(),
            SupportSection(),
            AboutSection(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPage,
        onTap: (index) {
          setState(() {
            currentPage = index;
          });
          tabHandler.handleTabChange(index);
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: tTertiaryColor,
        unselectedItemColor: tWhiteColor,
        backgroundColor: tPrimaryColor,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Summary',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}