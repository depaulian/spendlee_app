import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense_tracker/src/constants/colors.dart';
import 'package:expense_tracker/src/repository/authentication_repository/authentication_repository.dart';
import 'package:url_launcher/url_launcher.dart';

class DeleteAccountModal extends StatelessWidget {
  const DeleteAccountModal({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepo = AuthenticationRepository.instance;
    final user = authRepo.appUser;

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
            // Warning Icon
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.warning_outlined,
                color: Colors.red,
                size: 32,
              ),
            ),

            const SizedBox(height: 16),

            // Title
            const Text(
              'Delete Account',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: tDarkColor,
              ),
            ),

            const SizedBox(height: 8),

            // Description
            Text(
              'This action requires administrative oversight',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            // Content
            Text(
              'By clicking "Yes", an email will be generated with your credentials which you can then send to our support team.\n\nA follow-up email might be sent by our admin team to confirm the process.\n\nPlease note that this process might take a while.',
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
                      Get.back();
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
                    onPressed: () {
                      Get.back();
                      _sendDeleteAccountEmail(user);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Yes, Continue'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _sendDeleteAccountEmail(user) {
    String emailBody = '''Hi Support Team,

I would like to request the deletion of my account. Please find my account details below:

Account Information:
• Account ID: ${user?.id ?? 'N/A'}
• Email: ${user?.email ?? 'N/A'}
• Username: ${user?.username ?? 'N/A'}

Please process my account deletion request and confirm once completed.

Thank you for your assistance.

Best regards,
${user?.firstName ?? 'User'}''';

    final String subject = 'Account Deletion Request';
    
    // Manually construct the mailto URL to avoid encoding issues
    final String mailtoUrl = 'mailto:nyumav@gmail.com?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(emailBody)}';
    final Uri emailUri = Uri.parse(mailtoUrl);
    
    launchUrl(emailUri);
  }
}