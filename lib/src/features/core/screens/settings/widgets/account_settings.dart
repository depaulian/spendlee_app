import 'package:expense_tracker/src/features/core/screens/settings/widgets/currency_selection_sheet.dart';
import 'package:expense_tracker/src/features/core/screens/settings/widgets/premium_upgrade.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense_tracker/src/constants/colors.dart';
import 'package:expense_tracker/src/features/core/screens/settings/widgets/section_header.dart';
import 'package:expense_tracker/src/repository/authentication_repository/authentication_repository.dart';

class AccountSettingsSection extends StatelessWidget {
  const AccountSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepo = AuthenticationRepository.instance;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Premium upgrade section (only shows if not premium)
        const PremiumUpgradeSection(),

        // Regular account settings
        const SectionHeader(title: 'Account Settings'),
        Obx(() {
          return ListTile(
            leading: Icon(Icons.currency_exchange, color: tPrimaryColor),
            title: Text('Currency', style: TextStyle(color: tDarkColor)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  authRepo.currentCurrency.code,
                  style: TextStyle(
                    color: tDarkColor.withOpacity(0.7),
                  ),
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
            onTap: () => _showCurrencySelection(context),
          );
        }),

        // You can add more account settings here
        ListTile(
          leading: Icon(Icons.person, color: tPrimaryColor),
          title: Text('Edit Profile', style: TextStyle(color: tDarkColor)),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // Navigate to profile edit screen
          },
        ),

        ListTile(
          leading: Icon(Icons.security, color: tPrimaryColor),
          title: Text('Security', style: TextStyle(color: tDarkColor)),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // Navigate to security settings
          },
        ),
      ],
    );
  }

  void _showCurrencySelection(BuildContext context) {
    final authRepo = AuthenticationRepository.instance;
    final currentCurrency = authRepo.currentCurrency;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return CurrencySelectionSheet(
          authRepo: authRepo,
          currentCurrency: currentCurrency,
        );
      },
    );
  }
}