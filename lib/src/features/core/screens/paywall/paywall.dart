import 'package:expense_tracker/src/constants/colors.dart';
import 'package:expense_tracker/src/features/core/controllers/paywall_controller.dart';
import 'package:expense_tracker/src/features/core/screens/paywall/widgets/paywall_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaywallScreen extends StatefulWidget {
  final String? source;
  final Map<String, dynamic>? scanData;

  const PaywallScreen({
    super.key,
    this.source,
    this.scanData,
  });

  @override
  PaywallScreenState createState() => PaywallScreenState();
}

class PaywallScreenState extends State<PaywallScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final PaywallController _paywallController = Get.find<PaywallController>();

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadInitialData();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );

    _fadeController.forward();
  }

  void _loadInitialData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _paywallController.refresh();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _onContinue() async {
    final success = await _paywallController.startFreeTrial();
    if (success) {
      Navigator.of(context).pop(true);
    }
  }

  void _onClose() {
    Navigator.of(context).pop(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tPrimaryColor, // Your app's primary color
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Obx(() {
            if (_paywallController.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.amber),
              );
            }

            // Show error message if RevenueCat configuration fails
            if (_paywallController.errorMessage.value.isNotEmpty && 
                _paywallController.availablePackages.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.amber,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _paywallController.errorMessage.value,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          _paywallController.refresh();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          foregroundColor: Colors.black,
                        ),
                        child: const Text('Retry'),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: _onClose,
                        child: const Text(
                          'Close',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Container(
              // Add subtle mathematical background pattern like Homework AI
              decoration: BoxDecoration(
                color: tPrimaryColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // App header with close button
                    PaywallAppHeader(onClose: _onClose),

                    // Main content - evenly spaced
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Value proposition and features
                          const PaywallValueProp(),

                          // Pricing options
                          PaywallPricing(controller: _paywallController),
                        ],
                      ),
                    ),

                    // Bottom section - CTA and footer
                    Column(
                      children: [
                        ContinueButton(
                          controller: _paywallController,
                          onPressed: _onContinue,
                        ),

                        const PaywallFooter(),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}