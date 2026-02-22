import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mindsort/core/models/game_state.dart';
import 'package:mindsort/core/models/level.dart';

part 'game_controller.freezed.dart';

@freezed
class GameControllerState with _$GameControllerState {
  const factory GameControllerState({
    required GameState gameState,
    required List<Level> levels,
    required Level? currentLevel,
    required bool isLoading,
    required bool isGameOver,
    required bool isWon,
    required String? error,
  }) = _GameControllerState;

  factory GameControllerState.initial() => const GameControllerState(
    gameState: GameState.initial(),
    levels: [],
    currentLevel: null,
    isLoading: false,
    isGameOver: false,
    isWon: false,
    error: null,
  );
}

class GameController extends RiverpodNotifier<GameControllerState> {
  GameController(Ref ref) : super(const GameControllerState.initial());

  void initializeGame() {
    state = state.copyWith(isLoading: true);

    final levels = _generateLevels();
    final currentLevel = levels.firstWhere(
      (level) => level.id == state.gameState.levelId,
    );

    state = state.copyWith(
      levels: levels,
      currentLevel: currentLevel,
      gameState: state.gameState.copyWith(
        bottles: currentLevel.bottles,
        parMoves: currentLevel.parMoves,
      ),
      isLoading: false,
    );
  }

  void selectBottle(int bottleId) {
    final currentSelection = state.gameState.selectedBottle;
    final bottles = state.gameState.bottles;

    if (currentSelection == bottleId) {
      // Deselect same bottle
      state = state.copyWith(
        gameState: state.gameState.copyWith(selectedBottle: null),
      );
      return;
    }

    final selectedBottle = bottles.firstWhere((b) => b.id == bottleId);

    if (currentSelection == null) {
      // First selection - just select
      state = state.copyWith(
        gameState: state.gameState.copyWith(selectedBottle: bottleId),
      );
      return;
    }

    final fromBottle = bottles.firstWhere((b) => b.id == currentSelection);
    final toBottle = selectedBottle;

    if (fromBottle.canPourTo(toBottle)) {
      final pourableAmount = fromBottle.pourableAmount(toBottle);
      if (pourableAmount > 0) {
        final newFrom = _pour(fromBottle, -pourableAmount);
        final newTo = _pour(toBottle, pourableAmount);

        final newBottles = bottles
            .map((b) => b.id == fromBottle.id ? newFrom : b)
            .map((b) => b.id == toBottle.id ? newTo : b)
            .toList();

        final newHistory = [...state.gameState.history, bottles];

        state = state.copyWith(
          gameState: state.gameState.copyWith(
            bottles: newBottles,
            selectedBottle: null,
            moves: state.gameState.moves + 1,
            history: newHistory,
          ),
        );

        if (_checkWin(newBottles)) {
          _handleWin();
        }
      }
    }
  }

  void undo() {
    if (state.gameState.history.isNotEmpty) {
      final lastState = state.gameState.history.last;
      final newHistory = state.gameState.history
          .take(state.gameState.history.length - 1)
          .toList();

      state = state.copyWith(
        gameState: state.gameState.copyWith(
          bottles: lastState,
          selectedBottle: null,
          moves: state.gameState.moves - 1,
          history: newHistory,
        ),
      );
    }
  }

  void restartLevel() {
    if (state.currentLevel != null) {
      state = state.copyWith(
        gameState: GameState.initial().copyWith(
          levelId: state.currentLevel!.id,
          bottles: state.currentLevel!.bottles,
          parMoves: state.currentLevel!.parMoves,
        ),
        isWon: false,
      );
    }
  }

  void nextLevel() {
    final nextLevel = state.levels.firstWhereOrNull(
      (level) => level.id == state.gameState.levelId + 1,
    );

    if (nextLevel != null) {
      state = state.copyWith(
        gameState: GameState.initial().copyWith(
          levelId: nextLevel.id,
          bottles: nextLevel.bottles,
          parMoves: nextLevel.parMoves,
        ),
        currentLevel: nextLevel,
        isWon: false,
      );
    }
  }

  void useHint() {
    // TODO: Implement hint system
  }

  void toggleHintVisibility() {
    state = state.copyWith(
      gameState: state.gameState.copyWith(showHint: !state.gameState.showHint),
    );
  }

  void setHintMove(int fromBottle, int toBottle) {
    state = state.copyWith(
      gameState: state.gameState.copyWith(
        hintFromBottle: fromBottle,
        hintToBottle: toBottle,
      ),
    );
  }

  Bottle _pour(Bottle bottle, int amount) {
    if (amount == 0) return bottle;

    final newContents = bottle.contents.toList();
    if (amount > 0) {
      // Adding liquid
      final topColor = bottle.top!;
      for (int i = 0; i < amount; i++) {
        newContents.add(topColor);
      }
    } else {
      // Removing liquid
      newContents.removeRange(newContents.length + amount, newContents.length);
    }

    return bottle.copyWith(contents: newContents);
  }

  bool _checkWin(List<Bottle> bottles) {
    return bottles.every((bottle) => bottle.isComplete || bottle.isEmpty);
  }

  void _handleWin() {
    state = state.copyWith(
      isWon: true,
      gameState: state.gameState.copyWith(isWon: true),
    );
  }

  List<Level> _generateLevels() {
    return [
      Level(
        id: 1,
        bottles: [
          Bottle(
            id: 1,
            capacity: 4,
            contents: [
              Emotion.anger,
              Emotion.anger,
              Emotion.anger,
              Emotion.anger,
            ],
          ),
          Bottle(
            id: 2,
            capacity: 4,
            contents: [Emotion.joy, Emotion.joy, Emotion.joy, Emotion.joy],
          ),
          Bottle(
            id: 3,
            capacity: 4,
            contents: [Emotion.calm, Emotion.calm, Emotion.calm, Emotion.calm],
          ),
          Bottle(
            id: 4,
            capacity: 4,
            contents: [Emotion.love, Emotion.love, Emotion.love, Emotion.love],
          ),
          Bottle(id: 5, capacity: 4),
          Bottle(id: 6, capacity: 4),
        ],
        parMoves: 10,
      ),
      // Add more levels...
    ];
  }
}

final gameControllerProvider =
    StateNotifierProvider<GameController, GameControllerState>((ref) {
      return GameController(ref);
    });
