import 'package:expense_tracker/src/constants/colors.dart';
import 'package:expense_tracker/src/features/core/controllers/paywall_controller.dart';
import 'package:expense_tracker/src/features/core/screens/paywall/paywall.dart';
import 'package:expense_tracker/src/features/core/screens/settings/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PremiumUpgradeSection extends StatelessWidget {
  const PremiumUpgradeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final PaywallController paywallController = Get.find<PaywallController>();

    return Obx(() {
      final premiumStatus = paywallController.premiumStatus.value;

      // Don't show section if user is already premium
      if (premiumStatus?.isPremium == true) {
        return const SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Premium upgrade card
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.amber.shade100, Colors.orange.shade50],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.withOpacity(0.3)),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.star,
                  color: Colors.black,
                  size: 24,
                ),
              ),
              title: const Text(
                'Upgrade to Premium',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: tDarkColor,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    premiumStatus?.trialActive == true
                        ? 'Trial active • Unlock unlimited features'
                        : 'Enjoy all benefits without any restrictions',
                    style: TextStyle(
                      color: tDarkColor.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (premiumStatus != null && !premiumStatus.isPremium) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        premiumStatus.trialActive
                            ? 'Free trial active'
                            : '${premiumStatus.freeScansRemaining} free scans left',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              onTap: () => _showUpgradeScreen(context),
            ),
          ),

          // Premium status tile (if user has some premium status)
          if (premiumStatus != null && premiumStatus.trialActive) ...[
            ListTile(
              leading: Icon(Icons.schedule, color: tPrimaryColor),
              title: Text('Trial Status', style: TextStyle(color: tDarkColor)),
              subtitle: Text(
                'Trial ends ${_formatDate(premiumStatus.trialEndDate)}',
                style: TextStyle(color: tDarkColor.withOpacity(0.7)),
              ),
              trailing: TextButton(
                onPressed: () => _showUpgradeScreen(context),
                child: const Text('Upgrade', style: TextStyle(color: Colors.amber)),
              ),
            ),
          ],

          // Feature comparison
          const SizedBox(height: 16),
        ],
      );
    });
  }

  Widget _buildFeatureComparison(String feature, String description, bool isActive) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            isActive ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 16,
            color: isActive ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              feature,
              style: TextStyle(
                fontSize: 14,
                color: tDarkColor.withOpacity(0.8),
              ),
            ),
          ),
          Text(
            description,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? Colors.green : tDarkColor.withOpacity(0.6),
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'Unknown';

    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = date.difference(now).inDays;

      if (difference <= 0) {
        return 'Today';
      } else if (difference == 1) {
        return 'Tomorrow';
      } else if (difference <= 7) {
        return 'in $difference days';
      } else {
        return '${date.day}/${date.month}/${date.year}';
      }
    } catch (e) {
      return 'Unknown';
    }
  }

  void _showUpgradeScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PaywallScreen(
          source: 'settings',
        ),
      ),
    ).then((upgraded) {
      if (upgraded == true) {
        // Refresh premium status after successful upgrade
        final PaywallController paywallController = Get.find<PaywallController>();
        paywallController.refresh();

        // Show success message
        Get.snackbar(
          'Welcome to Premium!',
          'You now have access to all premium features',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
      }
    });
  }
}