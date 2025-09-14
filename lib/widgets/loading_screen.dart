import 'package:flutter/material.dart';
import 'animated_widgets.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated logo or icon
            PulseAnimation(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFFEC4899)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6366F1).withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.shopping_bag,
                  color: Colors.white,
                  size: 60,
                ),
              ),
            ),
            const SizedBox(height: 32),
            // App title with animation
            AnimatedProductCard(
              delay: const Duration(milliseconds: 300),
              child: Text(
                'Mini E-commerce',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: const Color(0xFF6366F1),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Loading text
            AnimatedProductCard(
              delay: const Duration(milliseconds: 600),
              child: Text(
                'Loading amazing products...',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: const Color(0xFF64748B),
                ),
              ),
            ),
            const SizedBox(height: 48),
            // Loading indicator
            const ShimmerLoading(
              width: 200,
              height: 4,
              borderRadius: BorderRadius.all(Radius.circular(2)),
            ),
          ],
        ),
      ),
    );
  }
}