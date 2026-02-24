import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mindsort/core/models/tray.dart';
import 'package:mindsort/core/models/ingredient.dart';

class IngredientTray extends StatefulWidget {
  const IngredientTray({
    super.key,
    required this.tray,
    required this.isSelected,
    required this.onTap,
    this.isHinted = false,
  });

  final Tray tray;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isHinted;

  @override
  State<IngredientTray> createState() => _IngredientTrayState();
}

class _IngredientTrayState extends State<IngredientTray>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _glowAnimation = Tween<double>(
      begin: 0.2,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Start animation immediately if already selected
    if (widget.isSelected) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(IngredientTray oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && !oldWidget.isSelected) {
      _controller.repeat(reverse: true);
    } else if (!widget.isSelected && oldWidget.isSelected) {
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    HapticFeedback.mediumImpact();
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Frantic visual cue: subtle shaking animation when selected
        final dx = widget.isSelected
            ? math.sin(_controller.value * math.pi * 6) * 3
            : 0.0;
        final glowAlpha = widget.isSelected
            ? (_glowAnimation.value * 255).toInt()
            : 0;

        final isFull = widget.tray.isFull;
        final isComplete = widget.tray.isComplete;

        Color borderColor = const Color(0xFF263238);
        if (widget.isSelected) {
          borderColor = Colors.yellow;
        } else if (widget.isHinted) {
          borderColor = Colors.orange;
        } else if (isComplete) {
          borderColor = Colors.greenAccent;
        } else if (isFull) {
          borderColor = const Color(
            0xFFE53935,
          ); // Harsh red if full but not complete
        }

        return Transform.translate(
          offset: Offset(dx, widget.isSelected ? -8.0 : 0.0),
          child: GestureDetector(
            onTap: _handleTap,
            child: Container(
              width: 70,
              height: 220,
              decoration: BoxDecoration(
                color: const Color(0xFF37474F), // Rigid column slot
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(8),
                  top: Radius.circular(4),
                ),
                border: Border.all(
                  color: borderColor,
                  width: widget.isSelected ? 4 : 3,
                ),
                boxShadow: widget.isSelected
                    ? [
                        BoxShadow(
                          color: Colors.yellow.withAlpha(glowAlpha),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ]
                    : null,
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: List.generate(widget.tray.capacity, (index) {
                    final itemIndex = widget.tray.capacity - 1 - index;
                    final hasItem = itemIndex < widget.tray.contents.length;
                    final Ingredient? ingredient = hasItem
                        ? widget.tray.contents[itemIndex]
                        : null;

                    return Expanded(
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 4),
                        decoration: BoxDecoration(
                          color: hasItem
                              ? ingredient!.color.withAlpha(230)
                              : const Color(0xFF263238),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: hasItem ? Colors.black54 : Colors.black12,
                            width: 2,
                          ),
                        ),
                        child: hasItem
                            ? Center(
                                child: Text(
                                  ingredient!.emoji,
                                  style: const TextStyle(fontSize: 24),
                                ),
                              )
                            : null,
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
