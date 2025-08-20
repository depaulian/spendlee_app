import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense_tracker/src/constants/colors.dart';
import 'package:expense_tracker/src/features/core/screens/settings/widgets/section_header.dart';
import 'package:expense_tracker/src/utils/theme/theme_controller.dart';

class PreferencesSection extends StatelessWidget {
  final ThemeMode selectedTheme;  // Using Flutter's ThemeMode
  final ValueChanged<ThemeMode?> onThemeChanged;
  final bool notificationsEnabled;
  final ValueChanged<bool> onNotificationChanged;

  const PreferencesSection({
    super.key,
    required this.selectedTheme,
    required this.onThemeChanged,
    required this.notificationsEnabled,
    required this.onNotificationChanged,
  });

  @override
  Widget build(BuildContext context) {
    final themeController = Get.put(ThemeController());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: 'Preferences'),
        SwitchListTile(
          secondary: Icon(Icons.notifications, color: tPrimaryColor,),
          activeColor: tPrimaryColor,
          title: Text('Notifications', style: TextStyle(color: tDarkColor),),
          value: notificationsEnabled,
          onChanged: onNotificationChanged,
        ),
      ],
    );
  }
}