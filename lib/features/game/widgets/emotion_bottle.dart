import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:mindsort/core/models/bottle.dart';
import 'package:mindsort/core/models/emotion.dart';

class EmotionBottle extends StatefulWidget {
  const EmotionBottle({
    super.key,
    required this.bottle,
    required this.isSelected,
    required this.onTap,
    this.isHinted = false,
  });

  final Bottle bottle;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isHinted;

  @override
  State<EmotionBottle> createState() => _EmotionBottleState();
}

class _EmotionBottleState extends State<EmotionBottle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _selectionAnimation;
  late Animation<double> _pourAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _selectionAnimation = Tween<double>(
      begin: 0,
      end: -20,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _pourAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void didUpdateWidget(EmotionBottle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected != oldWidget.isSelected) {
      if (widget.isSelected) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
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
        return Transform.translate(
          offset: Offset(0, _selectionAnimation.value),
          child: child,
        );
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          width: 60,
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.isSelected
                  ? Colors.white
                  : (widget.isHinted ? Colors.yellow : Colors.white54),
              width: widget.isSelected ? 3 : 2,
            ),
            boxShadow: widget.isSelected
                ? [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.3),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CustomPaint(
              painter: _LiquidPainter(
                contents: widget.bottle.contents,
                capacity: widget.bottle.capacity,
              ),
              size: const Size(60, 200),
            ),
          ),
        ),
      ),
    );
  }
}

class _LiquidPainter extends CustomPainter {
  _LiquidPainter({required this.contents, required this.capacity});

  final List<Emotion> contents;
  final int capacity;

  @override
  void paint(Canvas canvas, Size size) {
    if (contents.isEmpty) return;

    final layerHeight = size.height / capacity;
    final glassWidth = size.width;
    final cornerRadius = 10.0;

    int colorGroupStart = 0;
    Emotion currentColor = contents[0];

    for (int i = 0; i < contents.length; i++) {
      final emotion = contents[i];
      if (emotion != currentColor || i == contents.length - 1) {
        final endIndex = (emotion != currentColor) ? i : contents.length;
        final startY = (capacity - endIndex) * layerHeight;
        final height = (endIndex - colorGroupStart) * layerHeight;

        final paint = Paint()
          ..color = currentColor.color.withOpacity(0.9)
          ..style = PaintingStyle.fill;

        final rect = RRect.fromRectAndRadius(
          Rect.fromLTWH(4, startY, glassWidth - 8, height),
          Radius.circular(cornerRadius),
        );
        canvas.drawRRect(rect, paint);

        currentColor = emotion;
        colorGroupStart = i;
      }
    }

    _drawGlassHighlight(canvas, size, cornerRadius);
  }

  void _drawGlassHighlight(Canvas canvas, Size size, double cornerRadius) {
    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();
    path.moveTo(8, 20);
    path.lineTo(8, size.height - cornerRadius);
    path.quadraticBezierTo(8, size.height, cornerRadius, size.height);
    path.lineTo(size.width - cornerRadius, size.height);
    path.quadraticBezierTo(
      size.width - 8,
      size.height,
      size.width - 8,
      size.height - cornerRadius,
    );
    path.lineTo(size.width - 8, 20);

    canvas.drawPath(path, highlightPaint);
  }

  @override
  bool shouldRepaint(_LiquidPainter oldDelegate) {
    return contents != oldDelegate.contents || capacity != oldDelegate.capacity;
  }
}

class BottleCompleteEffect extends StatefulWidget {
  const BottleCompleteEffect({
    super.key,
    required this.child,
    required this.isComplete,
  });

  final Widget child;
  final bool isComplete;

  @override
  State<BottleCompleteEffect> createState() => _BottleCompleteEffectState();
}

class _BottleCompleteEffectState extends State<BottleCompleteEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);
    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 0.8,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isComplete) return widget.child;

    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.cyan.withOpacity(_glowAnimation.value),
                blurRadius: 16,
                spreadRadius: 4,
              ),
            ],
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
