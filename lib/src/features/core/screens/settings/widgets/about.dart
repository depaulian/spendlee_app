import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense_tracker/src/constants/colors.dart';
import 'package:expense_tracker/src/features/authentication/screens/login/login_screen.dart';
import 'package:expense_tracker/src/features/core/screens/settings/widgets/section_header.dart';
import 'package:expense_tracker/src/repository/authentication_repository/authentication_repository.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: 'About'),
        ListTile(
          leading: Icon(Icons.info_outline, color: tPrimaryColor),
          title: Text('About App', style: TextStyle(color: tDarkColor)),
          trailing: Icon(Icons.chevron_right),
          onTap: () {
            // Handle about tap
          },
        ),
        ListTile(
          leading: Icon(Icons.privacy_tip, color: tPrimaryColor),
          title: Text('Privacy Policy', style: TextStyle(color: tDarkColor)),
          trailing: Icon(Icons.chevron_right),
          onTap: () {
            // Handle privacy policy tap
          },
        ),
        ListTile(
          leading: Icon(Icons.description, color: tPrimaryColor),
          title: Text('Terms of Service', style: TextStyle(color: tDarkColor)),
          trailing: Icon(Icons.chevron_right),
          onTap: () {
            // Handle terms of service tap
          },
        ),
        ListTile(
          leading: Icon(Icons.logout, color: tPrimaryColor), // Changed to red for logout
          title: Text('Log Out', style: TextStyle(color: tDarkColor)), // Changed to red
          trailing: Icon(Icons.chevron_right),
          onTap: () {
            _showLogoutConfirmationDialog(context);
          },
        ),
      ],
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    final authRepo = AuthenticationRepository.instance;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: tWhiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.logout,
                    color: Colors.red,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 16),

                // Title
                const Text(
                  'Log Out',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: tDarkColor
                  ),
                ),
                const SizedBox(height: 8),

                // Content
                Text(
                  'Are you sure you want to log out? You\'ll need to sign in again to access your account.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 24),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: tPrimaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.of(context).pop();

                          try {
                            // Show loading indicator
                            Get.dialog(
                              const Center(child: CircularProgressIndicator()),
                              barrierDismissible: false,
                            );

                            // Perform logout (this already handles navigation)
                            await authRepo.logout();

                            // Close loading indicator
                            Get.back();

                            // Show success message
                            Get.snackbar(
                              'Success',
                              'You have been logged out successfully',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                              duration: Duration(seconds: 3),
                            );
                          } catch (e) {
                            // Close loading indicator if still open
                            if (Get.isDialogOpen ?? false) {
                              Get.back();
                            }

                            // Show error message
                            Get.snackbar(
                              'Error',
                              'Failed to log out. Please try again.',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                              duration: Duration(seconds: 3),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Log Out'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}