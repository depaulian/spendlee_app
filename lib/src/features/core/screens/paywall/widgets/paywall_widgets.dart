import 'package:expense_tracker/src/constants/colors.dart';
import 'package:expense_tracker/src/features/core/controllers/paywall_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

// Top header with app branding and close button
class PaywallAppHeader extends StatelessWidget {
  final VoidCallback onClose;

  const PaywallAppHeader({
    super.key,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: onClose,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.close,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
        Row(
          children: [
            const Text(
              'Spendlee',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'PRO',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 28), // Balance for close button
      ],
    );
  }
}

// Main value proposition section
class PaywallValueProp extends StatelessWidget {
  const PaywallValueProp({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Unlock All Features with Pro',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),

        // Feature list with checkmarks
        _buildFeatureItem('Unlimited Receipt Scanning'),
        _buildFeatureItem('AI Budget Assistant'),
        _buildFeatureItem('Advanced Spending Analytics'),
        _buildFeatureItem('Export to CSV & Excel'),
        _buildFeatureItem('Smart Budget Recommendations'),
      ],
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check,
              color: Colors.green,
              size: 16,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Homework AI style pricing cards
class PaywallPricing extends StatelessWidget {
  final PaywallController controller;

  const PaywallPricing({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final packages = controller.availablePackages;
      if (packages.isEmpty) {
        return const SizedBox.shrink();
      }

      final monthlyPackage = packages.firstWhereOrNull(
            (package) => package.packageType == PackageType.monthly,
      );
      final annualPackage = packages.firstWhereOrNull(
            (package) => package.packageType == PackageType.annual,
      );

      return Column(
        children: [
          // Most popular plan (annual) - highlighted
          if (annualPackage != null)
            _buildPackageCard(
              package: annualPackage,
              isPopular: true,
              isSelected: controller.selectedPackageId.value == annualPackage.identifier,
              onTap: () => controller.selectPackage(annualPackage.identifier),
            ),

          const SizedBox(height: 12),

          // Regular plan (monthly)
          if (monthlyPackage != null)
            _buildPackageCard(
              package: monthlyPackage,
              isPopular: false,
              isSelected: controller.selectedPackageId.value == monthlyPackage.identifier,
              onTap: () => controller.selectPackage(monthlyPackage.identifier),
            ),
        ],
      );
    });
  }

  Widget _buildPackageCard({
    required Package package,
    required bool isPopular,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isPopular
                  ? Colors.amber.withOpacity(0.1)
                  : Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isPopular ? Colors.amber : Colors.white.withOpacity(0.2),
                width: isPopular ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                // Radio button
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? Colors.amber : Colors.white.withOpacity(0.5),
                      width: 2,
                    ),
                    color: isSelected ? Colors.amber : Colors.transparent,
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : null,
                ),

                const SizedBox(width: 16),

                // Plan details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.getPackageTitle(package).toUpperCase() + ' ACCESS',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (controller.isAnnualPackage(package)) ...[
                        Text(
                          'Best Value - Save with Annual Billing',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 14,
                          ),
                        ),
                      ] else ...[
                        Text(
                          'Flexible Monthly Billing',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Price
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      controller.getFormattedPrice(package),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'per ${controller.getBillingPeriod(package)}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                    // Show savings for annual package
                    if (isPopular && controller.getSavingsText(package) != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        controller.getSavingsText(package)!,
                        style: const TextStyle(
                          color: Colors.amber,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),

        // Most popular badge - fixed positioning
        if (isPopular)
          Positioned(
            top: -10,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'MOST POPULAR',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// Continue button (Homework AI style)
class ContinueButton extends StatelessWidget {
  final PaywallController controller;
  final VoidCallback onPressed;

  const ContinueButton({
    super.key,
    required this.controller,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: controller.isPurchasing.value ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber,
          foregroundColor: Colors.black,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          disabledBackgroundColor: Colors.amber.withOpacity(0.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16), // Add padding
        ),
        child: controller.isPurchasing.value
            ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min, // Prevent overflow
          children: [
            const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              ),
            ),
            const SizedBox(width: 12),
            const Flexible(
              child: Text(
                'Processing...',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis, // Prevent overflow
              ),
            ),
          ],
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min, // Prevent overflow
          children: [
            const Flexible(
              child: Text(
                'CONTINUE',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
                overflow: TextOverflow.ellipsis, // Prevent overflow
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.arrow_forward,
              size: 18,
            ),
          ],
        ),
      ),
    ));
  }
}

// Footer with terms and auto-renewal info
class PaywallFooter extends StatelessWidget {
  const PaywallFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        Text(
          'Auto-Renewable. Cancel Anytime',
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildFooterLink('Terms'),
            Text(
              ' • ',
              style: TextStyle(
                color: Colors.white.withOpacity(0.4),
                fontSize: 12,
              ),
            ),
            _buildFooterLink('Privacy Policy'),
            Text(
              ' • ',
              style: TextStyle(
                color: Colors.white.withOpacity(0.4),
                fontSize: 12,
              ),
            ),
            _buildFooterLink('Restore'),
          ],
        ),
      ],
    );
  }

  Widget _buildFooterLink(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white.withOpacity(0.6),
        fontSize: 12,
      ),
    );
  }
}