import 'package:expense_tracker/src/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaywallScreen extends StatefulWidget {
  const PaywallScreen({super.key});

  @override
  PaywallScreenState createState() => PaywallScreenState();
}

class PaywallScreenState extends State<PaywallScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _onStartFreeTrial() {
    setState(() {
      isLoading = true;
    });

    // Simulate loading
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        // TODO: Implement purchase logic
        Get.snackbar(
          'Coming Soon!',
          'Purchase integration will be implemented next',
          backgroundColor: Colors.blue[600],
          colorText: Colors.white,
          borderRadius: 12,
          margin: const EdgeInsets.all(16),
          icon: const Icon(Icons.info, color: Colors.white, size: 20),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tPrimaryColor,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Header with close button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 40),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 32,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: tWhiteColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.close,
                            color: tWhiteColor,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Title
                  const Text(
                    'Upgrade to Premium',
                    style: TextStyle(
                      color: tWhiteColor,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 16),

                  // Subtitle message
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: tWhiteColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: tWhiteColor.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: const Text(
                      "You've reached your free scan limit of 5. Upgrade to Premium for unlimited scanning and advanced features!",
                      style: TextStyle(
                        color: tWhiteColor,
                        fontSize: 16,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Free Trial Banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.amber.shade400, Colors.orange.shade500],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.amber.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text(
                          '7-DAY FREE TRIAL',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Cancel anytime during your trial',
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.7),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Premium Features List
                  Column(
                    children: [
                      _buildFeatureItem(
                        icon: Icons.document_scanner,
                        title: 'Unlimited Receipt Scanning',
                        description: 'Scan and organize all your receipts without limits',
                      ),
                      _buildFeatureItem(
                        icon: Icons.insights,
                        title: 'Advanced Insights & Analytics',
                        description: 'Get detailed spending patterns and smart recommendations',
                      ),
                      _buildFeatureItem(
                        icon: Icons.account_balance_wallet,
                        title: 'Smart Budget Management',
                        description: 'Create multiple budgets with intelligent tracking',
                      ),
                      _buildFeatureItem(
                        icon: Icons.cloud_sync,
                        title: 'Automatic Cloud Backup',
                        description: 'Secure your data across all devices automatically',
                      ),
                      _buildFeatureItem(
                        icon: Icons.support_agent,
                        title: 'Priority Support',
                        description: 'Get help faster with premium customer support',
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // CTA Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _onStartFreeTrial,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        disabledBackgroundColor: Colors.amber.withOpacity(0.5),
                      ),
                      child: isLoading
                          ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.black.withOpacity(0.7)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Starting Trial...',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black.withOpacity(0.7),
                            ),
                          ),
                        ],
                      )
                          : const Text(
                        'Start 7-Day Free Trial',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Secondary CTA - Maybe Later
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () => Get.back(),
                      style: TextButton.styleFrom(
                        foregroundColor: tWhiteColor.withOpacity(0.8),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: tWhiteColor.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                      ),
                      child: const Text(
                        'Maybe Later',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Terms
                  Text(
                    'By continuing, you agree to our Terms of Service and Privacy Policy. Your subscription will automatically renew unless cancelled.',
                    style: TextStyle(
                      color: tWhiteColor.withOpacity(0.6),
                      fontSize: 12,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: tWhiteColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: tWhiteColor.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Colors.amber,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: tWhiteColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: tWhiteColor.withOpacity(0.7),
                    fontSize: 14,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}