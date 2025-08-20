import 'package:expense_tracker/src/constants/colors.dart';
import 'package:expense_tracker/src/features/core/screens/paywall/widgets/feature_item.dart';
import 'package:flutter/material.dart';

class PaywallContent extends StatelessWidget {
  const PaywallContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Headline
        const Text(
          'Crush Debt. Build Wealth. Let AI Guide You.',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: tDarkColor),
        ),
        const SizedBox(height: 16),

        // Value Proposition
        const Text(
          'Take control of your financial future — without doing it alone...',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 24),

        // Premium features
        const Text('Premium Features:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        const FeatureItem(text: 'Smart budget recommendations tailored to your spending habits'),
        const FeatureItem(text: 'Daily and weekly saving goals that actually stick'),
        const FeatureItem(text: 'Debt payoff planner to help you get out of debt faster'),
        const FeatureItem(text: 'Expense categorization & insights to stop leaks in your wallet'),
        const FeatureItem(text: 'Pro tips & financial coaching to boost your money mindset'),
        const FeatureItem(text: 'Priority alerts so you\'re always one step ahead'),
        const SizedBox(height: 24),

        // Social Proof
        const Center(
          child: Text(
            '🌟 Join 100,000+ smart savers who’ve taken back control',
            style: TextStyle(fontStyle: FontStyle.italic),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 16),

        // CTA Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              // Handle purchase
            },
            child: const Text('Start 7-Day Free Trial', style: TextStyle(fontSize: 18)),
          ),
        ),
        const SizedBox(height: 12),
        const Center(child: Text('No commitment. Cancel anytime.', style: TextStyle(color: Colors.black54))),
        const SizedBox(height: 24),
      ],
    );
  }
}
