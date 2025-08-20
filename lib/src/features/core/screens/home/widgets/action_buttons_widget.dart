import 'package:expense_tracker/src/constants/colors.dart';
import 'package:expense_tracker/src/features/core/screens/paywall/paywall.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense_tracker/src/features/core/screens/home/add_transaction_screen.dart';

class ActionButtons extends StatelessWidget {
  const ActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            title: 'Add Transaction',
            icon: Icons.add,
            color: tSecondaryColor,
            onTap: () {
              Get.to(() => const AddTransactionScreen());
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionButton(
            title: 'Scan Receipt',
            icon: Icons.camera_alt,
            color: Colors.white,
            textColor: tSecondaryColor,
              onTap: () {
                Get.bottomSheet(
                  const PaywallScreen(), // Use a modified version of PaywallScreen
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent, // To allow rounded corners or custom UI
                );
              }
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String title,
    required IconData icon,
    required Color color,
    Color? textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          border: color == Colors.white
              ? Border.all(color: tSecondaryColor)
              : null,
          boxShadow: [
            BoxShadow(
              color: color == Colors.white
                  ? Colors.black.withOpacity(0.05)
                  : color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: textColor ?? Colors.white,
              size: 18,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                title,
                style: TextStyle(
                  color: textColor ?? Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}