import 'package:flutter/material.dart';

// Custom illustration for empty cart state
class EmptyCartIllustration extends StatelessWidget {
  final double size;

  const EmptyCartIllustration({super.key, this.size = 200});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: EmptyCartPainter(),
      ),
    );
  }
}

class EmptyCartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = const Color(0xFF6366F1);

    final Paint fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFF6366F1).withOpacity(0.1);

    // Cart body
    final Rect cartRect = Rect.fromLTWH(size.width * 0.2, size.height * 0.4, size.width * 0.6, size.height * 0.4);
    canvas.drawRRect(RRect.fromRectAndRadius(cartRect, const Radius.circular(8)), fillPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(cartRect, const Radius.circular(8)), paint);

    // Cart wheels
    canvas.drawCircle(Offset(size.width * 0.35, size.height * 0.85), size.width * 0.08, fillPaint);
    canvas.drawCircle(Offset(size.width * 0.35, size.height * 0.85), size.width * 0.08, paint);

    canvas.drawCircle(Offset(size.width * 0.65, size.height * 0.85), size.width * 0.08, fillPaint);
    canvas.drawCircle(Offset(size.width * 0.65, size.height * 0.85), size.width * 0.08, paint);

    // Cart handle
    final Path handlePath = Path()
      ..moveTo(size.width * 0.8, size.height * 0.4)
      ..quadraticBezierTo(
        size.width * 0.9, size.height * 0.2,
        size.width * 0.85, size.height * 0.1,
      );
    canvas.drawPath(handlePath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Shopping bag illustration
class ShoppingBagIllustration extends StatelessWidget {
  final double size;

  const ShoppingBagIllustration({super.key, this.size = 150});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: ShoppingBagPainter(),
      ),
    );
  }
}

class ShoppingBagPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = const Color(0xFFEC4899);

    final Paint fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFFEC4899).withOpacity(0.1);

    // Bag body
    final Path bagPath = Path()
      ..moveTo(size.width * 0.3, size.height * 0.9)
      ..lineTo(size.width * 0.7, size.height * 0.9)
      ..lineTo(size.width * 0.8, size.height * 0.3)
      ..lineTo(size.width * 0.2, size.height * 0.3)
      ..close();

    canvas.drawPath(bagPath, fillPaint);
    canvas.drawPath(bagPath, paint);

    // Bag handles
    canvas.drawLine(
      Offset(size.width * 0.4, size.height * 0.3),
      Offset(size.width * 0.4, size.height * 0.1),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.6, size.height * 0.3),
      Offset(size.width * 0.6, size.height * 0.1),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.4, size.height * 0.1),
      Offset(size.width * 0.6, size.height * 0.1),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Decorative background pattern
class BackgroundPattern extends StatelessWidget {
  final Color color;

  const BackgroundPattern({super.key, this.color = const Color(0xFF6366F1)});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: PatternPainter(color: color),
      child: Container(),
    );
  }
}

class PatternPainter extends CustomPainter {
  final Color color;

  PatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color.withOpacity(0.05);

    // Draw geometric patterns
    for (int i = 0; i < 20; i++) {
      for (int j = 0; j < 10; j++) {
        if ((i + j) % 2 == 0) {
          canvas.drawCircle(
            Offset(i * 50.0, j * 50.0),
            2,
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Animated gradient background
class AnimatedGradientBackground extends StatefulWidget {
  final Widget child;

  const AnimatedGradientBackground({super.key, required this.child});

  @override
  State<AnimatedGradientBackground> createState() => _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState extends State<AnimatedGradientBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _color1Animation;
  late Animation<Color?> _color2Animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat(reverse: true);

    _color1Animation = ColorTween(
      begin: const Color(0xFF6366F1),
      end: const Color(0xFFEC4899),
    ).animate(_controller);

    _color2Animation = ColorTween(
      begin: const Color(0xFFEC4899),
      end: const Color(0xFF10B981),
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _color1Animation.value!.withOpacity(0.1),
                _color2Animation.value!.withOpacity(0.1),
              ],
            ),
          ),
          child: widget.child,
        );
      },
    );
  }
}