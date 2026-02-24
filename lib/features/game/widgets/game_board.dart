import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindsort/core/providers/game_controller.dart';
import 'package:flutter/services.dart';
import 'package:mindsort/core/providers/iap_controller.dart';
import 'package:mindsort/core/providers/settings_controller.dart';
import 'package:mindsort/features/game/widgets/ingredient_tray.dart';
import 'package:mindsort/features/game/widgets/customer_view.dart';

class GameBoard extends ConsumerWidget {
  const GameBoard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameControllerProvider);
    final settings = ref.watch(settingsControllerProvider);
    final trays = state.gameState.trays;
    final customers = state.gameState.activeCustomers;

    if (trays.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (customers.isNotEmpty)
          Container(
            height: 100,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: customers
                      .map((c) => CustomerView(customer: c))
                      .toList(),
                ),
              ),
            ),
          )
        else
          const SizedBox(height: 100),
        const SizedBox(height: 20),
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFB0BEC5), // Steel-like background
                border: Border.all(
                  color: const Color(0xFF37474F),
                  width: 6,
                ), // Rigid, dark border
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 10,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Wrap(
                spacing: 8, // Tighter spacing for cluttered feel
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: List.generate(trays.length, (index) {
                  final tray = trays[index];
                  final isSelected = state.gameState.selectedTrayIndex == index;

                  return IngredientTray(
                    tray: tray,
                    isSelected: isSelected,
                    onTap: () {
                      if (settings.hapticsEnabled) {
                        HapticFeedback.selectionClick();
                      }
                      if (settings.soundEnabled) {
                        SystemSound.play(SystemSoundType.click);
                      }

                      if (tray.isComplete) {
                        ref
                            .read(gameControllerProvider.notifier)
                            .serveTray(index);
                      } else {
                        ref
                            .read(gameControllerProvider.notifier)
                            .onTrayTap(index);
                      }
                    },
                  );
                }),
              ),
            ),
          ),
        ),
      ],
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
      child: Wrap(
        alignment: WrapAlignment.spaceEvenly,
        spacing: 8,
        runSpacing: 8,
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
            icon: Icons.people,
            label: 'Served',
            value: '${gameState.customersServed}/${gameState.targetCustomers}',
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
        color: const Color(0xFF263238), // Dark industrial grey
        border: Border.all(
          color: const Color(0xFFE53935),
          width: 2,
        ), // Urgent red border
        borderRadius: BorderRadius.circular(4), // Rigid corners
        boxShadow: const [
          BoxShadow(color: Colors.black26, offset: Offset(0, 2), blurRadius: 4),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: const Color(0xFFFFB300),
          ), // Warning yellow icons
          const SizedBox(width: 6),
          Text(
            '$label: $value',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2, // Digital feel
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
            label: 'Add Tray',
            onPressed: () {
              _runFeedback(settings);
              if (iapState.hasWeeklyPass ||
                  ref.read(iapControllerProvider.notifier).spendGems(50)) {
                ref.read(gameControllerProvider.notifier).addTray();
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
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF37474F), // Industrial grey button
            border: Border.all(
              color: onPressed != null
                  ? const Color(0xFFFFB300)
                  : Colors.grey, // Warning yellow if active
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                color: Colors.black45,
                offset: Offset(0, 4),
                blurRadius: 4,
              ),
            ],
          ),
          child: IconButton(
            icon: Icon(icon),
            onPressed: onPressed,
            iconSize: 28,
            color: onPressed != null ? Colors.white : Colors.white38,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: onPressed != null ? Colors.white70 : Colors.white24,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
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
