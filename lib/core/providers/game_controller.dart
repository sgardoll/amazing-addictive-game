import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindsort/core/models/bottle.dart';
import 'package:mindsort/core/models/level.dart';
import 'package:mindsort/core/services/level_generator.dart';

class GameStateData {
  final int levelId;
  final List<Bottle> bottles;
  final int moves;
  final int parMoves;
  final bool isWon;
  final int? selectedBottleIndex;
  final List<List<Bottle>> history;
  final int hintsUsed;
  final bool showHint;

  const GameStateData({
    required this.levelId,
    required this.bottles,
    required this.moves,
    required this.parMoves,
    required this.isWon,
    this.selectedBottleIndex,
    this.history = const [],
    this.hintsUsed = 0,
    this.showHint = false,
  });

  GameStateData copyWith({
    int? levelId,
    List<Bottle>? bottles,
    int? moves,
    int? parMoves,
    bool? isWon,
    int? selectedBottleIndex,
    bool clearSelection = false,
    List<List<Bottle>>? history,
    int? hintsUsed,
    bool? showHint,
  }) {
    return GameStateData(
      levelId: levelId ?? this.levelId,
      bottles: bottles ?? this.bottles,
      moves: moves ?? this.moves,
      parMoves: parMoves ?? this.parMoves,
      isWon: isWon ?? this.isWon,
      selectedBottleIndex: clearSelection
          ? null
          : (selectedBottleIndex ?? this.selectedBottleIndex),
      history: history ?? this.history,
      hintsUsed: hintsUsed ?? this.hintsUsed,
      showHint: showHint ?? this.showHint,
    );
  }

  bool get canUndo => history.isNotEmpty;
  int get completeBottles =>
      bottles.where((b) => b.isComplete || b.isEmpty).length;
  int get totalBottles => bottles.length;
}

class GameControllerState {
  final GameStateData gameState;
  final List<Level> levels;
  final Level? currentLevel;
  final bool isLoading;
  final bool isWon;
  final String? error;

  const GameControllerState({
    required this.gameState,
    this.levels = const [],
    this.currentLevel,
    this.isLoading = false,
    this.isWon = false,
    this.error,
  });

  factory GameControllerState.initial() => const GameControllerState(
    gameState: GameStateData(
      levelId: 1,
      bottles: [],
      moves: 0,
      parMoves: 10,
      isWon: false,
    ),
  );

  GameControllerState copyWith({
    GameStateData? gameState,
    List<Level>? levels,
    Level? currentLevel,
    bool? isLoading,
    bool? isWon,
    String? error,
  }) {
    return GameControllerState(
      gameState: gameState ?? this.gameState,
      levels: levels ?? this.levels,
      currentLevel: currentLevel ?? this.currentLevel,
      isLoading: isLoading ?? this.isLoading,
      isWon: isWon ?? this.isWon,
      error: error ?? this.error,
    );
  }
}

class GameController extends StateNotifier<GameControllerState> {
  GameController() : super(GameControllerState.initial());

  void initializeGame() {
    state = GameControllerState(isLoading: true, gameState: state.gameState);

    final levels = LevelGenerator.generateLevels(count: 120);
    final currentLevel = levels.first;

    state = GameControllerState(
      levels: levels,
      currentLevel: currentLevel,
      gameState: state.gameState.copyWith(
        levelId: currentLevel.id,
        bottles: currentLevel.bottles,
        parMoves: currentLevel.parMoves,
      ),
      isLoading: false,
    );
  }

  void selectBottle(int bottleIndex) {
    final currentSelection = state.gameState.selectedBottleIndex;
    final bottles = state.gameState.bottles;

    if (currentSelection == bottleIndex) {
      state = state.copyWith(
        gameState: state.gameState.copyWith(clearSelection: true),
      );
      return;
    }

    final selectedBottle = bottles[bottleIndex];

    if (currentSelection == null) {
      state = state.copyWith(
        gameState: state.gameState.copyWith(selectedBottleIndex: bottleIndex),
      );
      return;
    }

    final fromBottle = bottles[currentSelection];
    final toBottle = selectedBottle;

    if (fromBottle.canPourTo(toBottle)) {
      final pourableAmount = fromBottle.pourableAmount(toBottle);
      if (pourableAmount > 0) {
        final newFrom = _pour(fromBottle, -pourableAmount);
        final newTo = _pour(toBottle, pourableAmount);

        final newBottles = bottles.asMap().entries.map((entry) {
          if (entry.key == currentSelection) return newFrom;
          if (entry.key == bottleIndex) return newTo;
          return entry.value;
        }).toList();

        final newHistory = [...state.gameState.history, bottles];

        state = state.copyWith(
          gameState: state.gameState.copyWith(
            bottles: newBottles,
            clearSelection: true,
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
      final newHistory = state.gameState.history.sublist(
        0,
        state.gameState.history.length - 1,
      );

      state = state.copyWith(
        gameState: state.gameState.copyWith(
          bottles: lastState,
          clearSelection: true,
          moves: state.gameState.moves - 1,
          history: newHistory,
        ),
      );
    }
  }

  void restartLevel() {
    if (state.currentLevel != null) {
      state = state.copyWith(
        gameState: GameStateData(
          levelId: state.currentLevel!.id,
          bottles: state.currentLevel!.bottles,
          moves: 0,
          parMoves: state.currentLevel!.parMoves,
          isWon: false,
        ),
        isWon: false,
      );
    }
  }

  void nextLevel() {
    Level? nextLevel;
    try {
      nextLevel = state.levels.firstWhere(
        (level) => level.id == state.gameState.levelId + 1,
      );
    } catch (_) {
      nextLevel = null;
    }

    if (nextLevel != null) {
      state = state.copyWith(
        gameState: GameStateData(
          levelId: nextLevel.id,
          bottles: nextLevel.bottles,
          moves: 0,
          parMoves: nextLevel.parMoves,
          isWon: false,
        ),
        currentLevel: nextLevel,
        isWon: false,
      );
    }
  }

  void useHint() {
    final bottles = state.gameState.bottles;
    final hintsUsed = state.gameState.hintsUsed;
    for (int from = 0; from < bottles.length; from++) {
      if (bottles[from].isEmpty) {
        continue;
      }
      for (int to = 0; to < bottles.length; to++) {
        if (from == to) {
          continue;
        }
        if (bottles[from].canPourTo(bottles[to])) {
          selectBottle(from);
          selectBottle(to);
          state = state.copyWith(
            gameState: state.gameState.copyWith(hintsUsed: hintsUsed + 1),
          );
          return;
        }
      }
    }
  }

  void onBottleTap(int bottleIndex) {
    selectBottle(bottleIndex);
  }

  void addBottle() {
    final bottles = state.gameState.bottles;
    final newBottle = Bottle(id: bottles.length + 1, capacity: 4);
    state = state.copyWith(
      gameState: state.gameState.copyWith(bottles: [...bottles, newBottle]),
    );
  }

  Bottle _pour(Bottle bottle, int amount) {
    if (amount == 0) return bottle;

    final newContents = bottle.contents.toList();
    if (amount > 0) {
      final topColor = bottle.top;
      if (topColor == null) return bottle;
      for (int i = 0; i < amount; i++) {
        newContents.add(topColor);
      }
    } else {
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
}

final gameControllerProvider =
    StateNotifierProvider<GameController, GameControllerState>((ref) {
      return GameController();
    });
