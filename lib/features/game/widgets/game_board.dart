import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindsort/core/providers/game_controller.dart';
import 'package:flutter/services.dart';
import 'package:mindsort/core/providers/iap_controller.dart';
import 'package:mindsort/core/providers/settings_controller.dart';
import 'package:mindsort/features/game/widgets/emotion_bottle.dart';

class GameBoard extends ConsumerWidget {
  const GameBoard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameControllerProvider);
    final settings = ref.watch(settingsControllerProvider);
    final bottles = state.gameState.bottles;

    if (bottles.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 16,
          runSpacing: 24,
          alignment: WrapAlignment.center,
          children: List.generate(bottles.length, (index) {
            final bottle = bottles[index];
            final isSelected = state.gameState.selectedBottleIndex == index;

            return EmotionBottle(
              bottle: bottle,
              isSelected: isSelected,
              onTap: () {
                if (settings.hapticsEnabled) {
                  HapticFeedback.selectionClick();
                }
                if (settings.soundEnabled) {
                  SystemSound.play(SystemSoundType.click);
                }
                ref.read(gameControllerProvider.notifier).onBottleTap(index);
              },
            );
          }),
        ),
      ),
    );
  }
}

class GameHUD extends ConsumerWidget {
  const GameHUD({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameControllerProvider);
    final gameState = state.gameState;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStatChip(
            icon: Icons.layers,
            label: 'Level',
            value: '${gameState.levelId}',
          ),
          _buildStatChip(
            icon: Icons.touch_app,
            label: 'Moves',
            value: '${gameState.moves}',
          ),
          _buildStatChip(
            icon: Icons.star,
            label: 'Target',
            value: '${gameState.parMoves}',
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white70),
          const SizedBox(width: 4),
          Text(
            '$label: $value',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class GameControls extends ConsumerWidget {
  const GameControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameControllerProvider);
    final iapState = ref.watch(iapControllerProvider);
    final settings = ref.watch(settingsControllerProvider);
    final canUndo = state.gameState.canUndo;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildControlButton(
            icon: Icons.undo,
            label: 'Undo',
            onPressed: canUndo
                ? () {
                    _runFeedback(settings);
                    if (iapState.hasWeeklyPass ||
                        ref
                            .read(iapControllerProvider.notifier)
                            .spendGems(10)) {
                      ref.read(gameControllerProvider.notifier).undo();
                    }
                  }
                : null,
          ),
          _buildControlButton(
            icon: Icons.refresh,
            label: 'Restart',
            onPressed: () {
              _runFeedback(settings);
              ref.read(gameControllerProvider.notifier).restartLevel();
            },
          ),
          _buildControlButton(
            icon: Icons.lightbulb_outline,
            label: 'Hint',
            onPressed: () {
              _runFeedback(settings);
              if (iapState.hasWeeklyPass ||
                  ref.read(iapControllerProvider.notifier).spendGems(25)) {
                ref.read(gameControllerProvider.notifier).useHint();
              }
            },
          ),
          _buildControlButton(
            icon: Icons.add_circle_outline,
            label: 'Add Bottle',
            onPressed: () {
              _runFeedback(settings);
              if (iapState.hasWeeklyPass ||
                  ref.read(iapControllerProvider.notifier).spendGems(50)) {
                ref.read(gameControllerProvider.notifier).addBottle();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon),
          onPressed: onPressed,
          iconSize: 32,
          color: onPressed != null ? Colors.white : Colors.white38,
        ),
        Text(
          label,
          style: TextStyle(
            color: onPressed != null ? Colors.white70 : Colors.white24,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  void _runFeedback(SettingsState settings) {
    if (settings.hapticsEnabled) {
      HapticFeedback.selectionClick();
    }
    if (settings.soundEnabled) {
      SystemSound.play(SystemSoundType.click);
    }
  }
}
