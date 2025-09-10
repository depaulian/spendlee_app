import 'package:expense_tracker/src/repository/authentication_repository/authentication_repository.dart';
import 'package:expense_tracker/src/features/core/controllers/paywall_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense_tracker/src/constants/colors.dart';
import 'package:expense_tracker/src/constants/image_strings.dart';
import 'package:expense_tracker/src/features/core/screens/settings/widgets/about.dart';
import 'package:expense_tracker/src/features/core/screens/settings/widgets/account_settings.dart';
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
  ThemeMode selectedTheme = ThemeMode.system;
  bool notificationsEnabled = true;
  final authRepo = AuthenticationRepository.instance;
  final paywallController = Get.put(PaywallController.instance);

  @override
  Widget build(BuildContext context) {
    final tabHandler = TabHandler();
    final themeController = Get.put(ThemeController());// Use Get.find since it's in AppBinding
    final isDark = themeController.isDarkMode(context);
    final txtTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: tWhiteColor,
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(color: tWhiteColor)),
        backgroundColor: tPrimaryColor,
        elevation: 0,
        leading: Builder(
          builder: (context) => Image.asset(
            tLogo,
            fit: BoxFit.contain,
          ),
        ),
        actions: [
          // Show premium status indicator in app bar
          Obx(() {
            final premiumStatus = paywallController.premiumStatus.value;
            if (premiumStatus?.isPremium == true) {
              return Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, size: 16, color: Colors.black),
                        const SizedBox(width: 4),
                        const Text(
                          'Premium',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else if (premiumStatus?.trialActive == true) {
              return Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Trial',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            // Refresh premium status when user pulls to refresh
            await paywallController.refresh();
          },
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
              const AccountSettingsSection(),
              const SupportSection(),
              const AboutSection(),

              // Add some bottom padding
              const SizedBox(height: 100),
            ],
          ),
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