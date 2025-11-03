import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense_tracker/src/constants/colors.dart';
import 'package:expense_tracker/src/features/core/screens/settings/widgets/security/delete_account_modal.dart';
import 'package:url_launcher/url_launcher.dart';

class SecurityBottomSheet extends StatelessWidget {
  const SecurityBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: tWhiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.security, color: tPrimaryColor, size: 28),
                    const SizedBox(width: 12),
                    Text(
                      'Security Settings',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: tDarkColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Manage your account security and privacy settings',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: tDarkColor.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Divider(color: Colors.grey[200], thickness: 1),

          // Security Options
          Column(
            children: [
              _buildSecurityOption(
                context,
                icon: Icons.lock_outline,
                title: 'Change Password',
                subtitle: 'Update your account password',
                onTap: () {
                  Get.back();
                  _openChangePasswordEmail();
                },
              ),
              
              Divider(color: Colors.grey[100], thickness: 1, indent: 16, endIndent: 16),
              
              _buildSecurityOption(
                context,
                icon: Icons.delete_forever_outlined,
                title: 'Delete Account',
                subtitle: 'Permanently remove your account',
                isDestructive: true,
                onTap: () {
                  Get.back();
                  _showDeleteAccountModal(context);
                },
              ),
            ],
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSecurityOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final iconColor = isDestructive ? Colors.red[600] : tPrimaryColor;
    final titleColor = isDestructive ? Colors.red[600] : tDarkColor;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor!.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: iconColor, size: 24),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: titleColor,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: tDarkColor.withOpacity(0.6),
          fontSize: 14,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: tDarkColor.withOpacity(0.4),
      ),
      onTap: onTap,
    );
  }

  void _openChangePasswordEmail() {
    final String subject = 'Password Change Request';
    final String body = '''Hi,

I would like to change my password for my expense tracker account.

Please assist me with this process.

Thank you!''';

    // Manually construct the mailto URL to avoid encoding issues
    final String mailtoUrl = 'mailto:nyumav@gmail.com?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}';
    final Uri emailUri = Uri.parse(mailtoUrl);
    
    launchUrl(emailUri);
  }

  void _showDeleteAccountModal(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const DeleteAccountModal(),
    );
  }
}