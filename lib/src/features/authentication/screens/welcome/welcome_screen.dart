import 'package:expense_tracker/src/features/authentication/screens/email_verification/email_verification_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense_tracker/src/constants/colors.dart';
import 'package:expense_tracker/src/constants/image_strings.dart';
import 'package:expense_tracker/src/constants/sizes.dart';
import 'package:expense_tracker/src/constants/text_strings.dart';
import '../login/login_screen.dart' as login;
import '../register/register_screen.dart';
import 'dart:math' as math;

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _floatingController;
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late AnimationController _particleController;

  @override
  void initState() {
    super.initState();

    _floatingController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    _rotationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _particleController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _floatingController.dispose();
    _rotationController.dispose();
    _pulseController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var height = mediaQuery.size.height;
    var width = mediaQuery.size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: tPrimaryColor,
        body: Stack(
          children: [
            // Animated Background
            AnimatedBackground(
              floatingController: _floatingController,
              rotationController: _rotationController,
              pulseController: _pulseController,
              particleController: _particleController,
            ),

            // Content
            Container(
              padding: const EdgeInsets.all(tDefaultSize),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(height: 20),

                  // Logo with pulse animation
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: 1.0 + (_pulseController.value * 0.05),
                        child: Hero(
                          tag: 'app_logo',
                          child: Image(
                            image: const AssetImage(tLogo),
                            height: height * 0.25,
                          ),
                        ),
                      );
                    },
                  ),

                  // Title and Subtitle Section
                  Column(
                    children: [
                      Text(
                        tWelcomeTitle,
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: tWhiteColor,
                          letterSpacing: 0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),

                      // Feature highlights with icons - NOW STATIC
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            _buildStaticFeatureRow(
                              context,
                              Icons.camera_alt_rounded,
                              "Snap receipts instantly",
                            ),
                            const SizedBox(height: 12),
                            _buildStaticFeatureRow(
                              context,
                              Icons.insights_rounded,
                              "Track every expense",
                            ),
                            const SizedBox(height: 12),
                            _buildStaticFeatureRow(
                              context,
                              Icons.trending_up_rounded,
                              "Achieve your savings goals",
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Compelling tagline - STATIC
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          tWelcomeSubTitle,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: tWhiteColor.withOpacity(0.9),
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),

                  // Action Buttons
                  Column(
                    children: [
                      // Sign Up Button (Primary CTA)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: tSuccessColor,
                            side: BorderSide.none,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            elevation: 8,
                            shadowColor: tSecondaryColor.withOpacity(0.5),
                          ),
                          onPressed: () => Get.to(() => const EmailVerificationScreen()),
                          child: Text(
                            tSignup.toUpperCase(),
                            style: const TextStyle(
                              color: tWhiteColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Login Button (Secondary CTA)
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: tPrimaryDarkColor,
                            side: BorderSide.none,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          onPressed: () => Get.to(() => const login.LoginScreen()),
                          child: Text(
                            tLogin.toUpperCase(),
                            style: TextStyle(
                              color: tWhiteColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Static feature row without animation
  Widget _buildStaticFeatureRow(BuildContext context, IconData icon, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: tSecondaryColor.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: tSecondaryColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: tWhiteColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class AnimatedBackground extends StatelessWidget {
  final AnimationController floatingController;
  final AnimationController rotationController;
  final AnimationController pulseController;
  final AnimationController particleController;

  const AnimatedBackground({
    super.key,
    required this.floatingController,
    required this.rotationController,
    required this.pulseController,
    required this.particleController,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        // Gradient circles representing growth
        ...List.generate(3, (index) {
          return AnimatedBuilder(
            animation: rotationController,
            builder: (context, child) {
              final angle = (rotationController.value * 2 * math.pi) + (index * 2 * math.pi / 3);
              final radius = size.width * 0.3;
              final centerX = size.width / 2;
              final centerY = size.height * 0.3;

              return Positioned(
                left: centerX + (math.cos(angle) * radius) - 40,
                top: centerY + (math.sin(angle) * radius) - 40,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        tSecondaryColor.withOpacity(0.2),
                        tSecondaryColor.withOpacity(0.0),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }),

        // Floating particles
        ...List.generate(10, (index) {
          return _FloatingParticle(
            controller: particleController,
            startX: (index * 0.1 + 0.05) * size.width,
            startY: (index * 0.08 + 0.2) * size.height,
            index: index,
          );
        }),

        // Floating money symbols
        ...List.generate(5, (index) {
          return _FloatingIcon(
            icon: _getMoneyIcon(index),
            controller: floatingController,
            startX: (index * 0.2 + 0.1) * size.width,
            startY: (index * 0.15 + 0.2) * size.height,
            index: index,
          );
        }),
      ],
    );
  }

  IconData _getMoneyIcon(int index) {
    final icons = [
      Icons.attach_money,
      Icons.savings_outlined,
      Icons.account_balance_wallet_outlined,
      Icons.trending_up,
      Icons.pie_chart_outline,
    ];
    return icons[index % icons.length];
  }
}

class _FloatingParticle extends StatelessWidget {
  final AnimationController controller;
  final double startX;
  final double startY;
  final int index;

  const _FloatingParticle({
    required this.controller,
    required this.startX,
    required this.startY,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final progress = (controller.value + (index * 0.1)) % 1.0;
        final offsetY = progress * MediaQuery.of(context).size.height * -0.4;
        final offsetX = math.sin(progress * 3 * math.pi) * 20;
        final opacity = (1 - progress) * 0.5;

        return Positioned(
          left: startX + offsetX,
          top: startY + offsetY,
          child: Opacity(
            opacity: opacity,
            child: Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: tSecondaryColor,
                boxShadow: [
                  BoxShadow(
                    color: tSecondaryColor.withOpacity(0.5),
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _FloatingIcon extends StatelessWidget {
  final IconData icon;
  final AnimationController controller;
  final double startX;
  final double startY;
  final int index;

  const _FloatingIcon({
    required this.icon,
    required this.controller,
    required this.startX,
    required this.startY,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final offsetY = math.sin((controller.value * 2 * math.pi) + (index * 0.5)) * 20;
        final offsetX = math.cos((controller.value * 2 * math.pi) + (index * 0.3)) * 15;
        final opacity = 0.1 + (math.sin(controller.value * 2 * math.pi) * 0.1);

        return Positioned(
          left: startX + offsetX,
          top: startY + offsetY,
          child: Opacity(
            opacity: opacity,
            child: Icon(
              icon,
              color: tWhiteColor,
              size: 30 + (index * 5).toDouble(),
            ),
          ),
        );
      },
    );
  }
}