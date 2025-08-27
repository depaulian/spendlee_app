import 'package:flutter/material.dart';

class HomePageShimmerLoading extends StatefulWidget {
  const HomePageShimmerLoading({super.key});

  @override
  State<HomePageShimmerLoading> createState() => _HomePageShimmerLoadingState();
}

class _HomePageShimmerLoadingState extends State<HomePageShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Balance Card Shimmer
              _buildBalanceCardShimmer(),

              const SizedBox(height: 24),

              // Action Buttons Shimmer
              _buildActionButtonsShimmer(),

              const SizedBox(height: 24),

              // Budget Section Shimmer
              _buildBudgetSectionShimmer(),

              const SizedBox(height: 24),

              // Recent Transactions Shimmer
              _buildRecentTransactionsShimmer(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBalanceCardShimmer() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.grey[300]!,
            Colors.grey[200]!,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Current Balance Label
          _buildShimmerContainer(
            width: 120,
            height: 16,
          ),

          const SizedBox(height: 8),

          // Balance Amount with Icon
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildShimmerContainer(
                width: 20,
                height: 20,
                borderRadius: 10,
              ),
              const SizedBox(width: 8),
              _buildShimmerContainer(
                width: 180,
                height: 36,
              ),
            ],
          ),

          const SizedBox(height: 4),

          // Balance Status
          _buildShimmerContainer(
            width: 80,
            height: 14,
          ),

          const SizedBox(height: 24),

          // Income and Expenses Row
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    _buildShimmerContainer(
                      width: 20,
                      height: 20,
                      borderRadius: 10,
                    ),
                    const SizedBox(height: 4),
                    _buildShimmerContainer(
                      width: 60,
                      height: 14,
                    ),
                    const SizedBox(height: 4),
                    _buildShimmerContainer(
                      width: 100,
                      height: 18,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  children: [
                    _buildShimmerContainer(
                      width: 20,
                      height: 20,
                      borderRadius: 10,
                    ),
                    const SizedBox(height: 4),
                    _buildShimmerContainer(
                      width: 70,
                      height: 14,
                    ),
                    const SizedBox(height: 4),
                    _buildShimmerContainer(
                      width: 100,
                      height: 18,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtonsShimmer() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildShimmerContainer(
                  width: 18,
                  height: 18,
                  borderRadius: 9,
                ),
                const SizedBox(width: 6),
                _buildShimmerContainer(
                  width: 90,
                  height: 13,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildShimmerContainer(
                  width: 18,
                  height: 18,
                  borderRadius: 9,
                ),
                const SizedBox(width: 6),
                _buildShimmerContainer(
                  width: 80,
                  height: 13,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBudgetSectionShimmer() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildShimmerContainer(
                width: 120,
                height: 18,
              ),
              Row(
                children: [
                  _buildShimmerContainer(
                    width: 60,
                    height: 28,
                    borderRadius: 6,
                  ),
                  const SizedBox(width: 8),
                  _buildShimmerContainer(
                    width: 70,
                    height: 28,
                    borderRadius: 6,
                  ),
                  const SizedBox(width: 12),
                  _buildShimmerContainer(
                    width: 28,
                    height: 28,
                    borderRadius: 6,
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Progress Bar
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: 0.6,
              child: _buildShimmerContainer(
                width: double.infinity,
                height: 8,
                borderRadius: 4,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Budget Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBudgetStatShimmer(),
              _buildBudgetStatShimmer(),
              _buildBudgetStatShimmer(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetStatShimmer() {
    return Column(
      children: [
        _buildShimmerContainer(
          width: 50,
          height: 12,
        ),
        const SizedBox(height: 4),
        _buildShimmerContainer(
          width: 70,
          height: 14,
        ),
      ],
    );
  }

  Widget _buildRecentTransactionsShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildShimmerContainer(
              width: 160,
              height: 20,
            ),
            _buildShimmerContainer(
              width: 60,
              height: 30,
              borderRadius: 20,
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Transaction Items
        ...List.generate(3, (index) => Padding(
          padding: EdgeInsets.only(bottom: index < 2 ? 12 : 0),
          child: _buildTransactionItemShimmer(),
        )),
      ],
    );
  }

  Widget _buildTransactionItemShimmer() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon Container
          _buildShimmerContainer(
            width: 40,
            height: 40,
            borderRadius: 8,
          ),

          const SizedBox(width: 12),

          // Transaction Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildShimmerContainer(
                  width: 120,
                  height: 16,
                ),
                const SizedBox(height: 4),
                _buildShimmerContainer(
                  width: 100,
                  height: 12,
                ),
              ],
            ),
          ),

          // Amount and Delete Button
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildShimmerContainer(
                width: 80,
                height: 16,
              ),
              const SizedBox(height: 4),
              _buildShimmerContainer(
                width: 20,
                height: 20,
                borderRadius: 10,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerContainer({
    required double width,
    required double height,
    double? borderRadius,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius ?? 4),
        gradient: LinearGradient(
          begin: Alignment(-1.0 + _animation.value, 0.0),
          end: Alignment(-0.5 + _animation.value, 0.0),
          colors: [
            Colors.grey[300]!,
            Colors.grey[100]!,
            Colors.grey[300]!,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
    );
  }
}