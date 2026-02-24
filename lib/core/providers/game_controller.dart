import 'dart:async';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindsort/core/models/customer.dart';
import 'package:mindsort/core/models/ingredient.dart';
import 'package:mindsort/core/models/tray.dart';
import 'package:mindsort/core/models/level.dart';
import 'package:mindsort/core/services/level_generator.dart';
import 'package:mindsort/core/services/ad_service.dart';

class GameStateData {
  final int levelId;
  final List<Tray> trays;
  final int moves;
  final int parMoves;
  final bool isWon;
  final int? selectedTrayIndex;
  final List<List<Tray>> history;
  final int hintsUsed;
  final bool showHint;
  final List<Customer> activeCustomers;
  final bool isGameOver;
  final int customersServed;
  final int targetCustomers;

  const GameStateData({
    required this.levelId,
    required this.trays,
    required this.moves,
    required this.parMoves,
    required this.isWon,
    this.selectedTrayIndex,
    this.history = const [],
    this.hintsUsed = 0,
    this.showHint = false,
    this.activeCustomers = const [],
    this.isGameOver = false,
    this.customersServed = 0,
    this.targetCustomers = 5,
  });

  GameStateData copyWith({
    int? levelId,
    List<Tray>? trays,
    int? moves,
    int? parMoves,
    bool? isWon,
    int? selectedTrayIndex,
    bool clearSelection = false,
    List<List<Tray>>? history,
    int? hintsUsed,
    bool? showHint,
    List<Customer>? activeCustomers,
    bool? isGameOver,
    int? customersServed,
    int? targetCustomers,
  }) {
    return GameStateData(
      levelId: levelId ?? this.levelId,
      trays: trays ?? this.trays,
      moves: moves ?? this.moves,
      parMoves: parMoves ?? this.parMoves,
      isWon: isWon ?? this.isWon,
      selectedTrayIndex: clearSelection
          ? null
          : (selectedTrayIndex ?? this.selectedTrayIndex),
      history: history ?? this.history,
      hintsUsed: hintsUsed ?? this.hintsUsed,
      showHint: showHint ?? this.showHint,
      activeCustomers: activeCustomers ?? this.activeCustomers,
      isGameOver: isGameOver ?? this.isGameOver,
      customersServed: customersServed ?? this.customersServed,
      targetCustomers: targetCustomers ?? this.targetCustomers,
    );
  }

  bool get canUndo => history.isNotEmpty;
  int get completeTrays => trays.where((b) => b.isComplete || b.isEmpty).length;
  int get totalTrays => trays.length;
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
      trays: [],
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
  final AdService _adService;
  Timer? _gameTicker;
  final Random _random = Random();
  int _ticksSinceLastCustomer = 0;
  bool _adShown = false;

  GameController(this._adService) : super(GameControllerState.initial());

  @override
  void dispose() {
    if (_gameTicker != null) {
      _gameTicker!.cancel();
      _gameTicker = null;
    }
    super.dispose();
  }

  void initializeGame() {
    _gameTicker?.cancel();
    state = GameControllerState(isLoading: true, gameState: state.gameState);

    final levels = LevelGenerator.generateLevels(count: 120);
    final currentLevel = levels.first;

    state = GameControllerState(
      levels: levels,
      currentLevel: currentLevel,
      gameState: state.gameState.copyWith(
        levelId: currentLevel.id,
        trays: currentLevel.trays,
        parMoves: currentLevel.parMoves,
        activeCustomers: [],
        isGameOver: false,
        customersServed: 0,
        targetCustomers: 5,
      ),
      isLoading: false,
    );

    _adShown = false;
    _adService.loadInterstitialAd();
    _startGameTicker();
  }

  void _startGameTicker() {
    _ticksSinceLastCustomer = 0;
    _gameTicker = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.isWon || state.gameState.isGameOver) {
        timer.cancel();
        return;
      }

      _tickGame();
    });
  }

  void _tickGame() {
    bool gameOver = false;
    final List<Customer> updatedCustomers = [];

    for (final customer in state.gameState.activeCustomers) {
      final clampedPatience = max(0, customer.currentPatience - 1);
      if (clampedPatience <= 0) {
        gameOver = true;
      }
      updatedCustomers.add(customer.copyWith(currentPatience: clampedPatience));
    }

    if (gameOver) {
      if (!state.gameState.isGameOver) {
        if (!_adShown) {
          _adShown = true;
          _adService.showInterstitialAd();
        }
      }
      if (_gameTicker != null) {
        _gameTicker!.cancel();
        _gameTicker = null;
      }
      state = state.copyWith(
        gameState: state.gameState.copyWith(
          activeCustomers: updatedCustomers,
          isGameOver: true,
        ),
      );
      return;
    }

    _ticksSinceLastCustomer++;

    // Spawn a new customer randomly every few seconds (e.g., 5-10 seconds) if less than 3 active
    if (updatedCustomers.length < 3) {
      if (_ticksSinceLastCustomer >= 5) {
        // 20% chance each second after 5 seconds
        if (_random.nextDouble() < 0.2 || _ticksSinceLastCustomer > 10) {
          final ingredientValues = Ingredient.values;
          final randomIngredient =
              ingredientValues[_random.nextInt(ingredientValues.length)];
          final newCustomer = Customer(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            order: randomIngredient,
            maxPatience: 30, // 30 seconds patience
            currentPatience: 30,
          );
          updatedCustomers.add(newCustomer);
          _ticksSinceLastCustomer = 0;
        }
      }
    }

    state = state.copyWith(
      gameState: state.gameState.copyWith(activeCustomers: updatedCustomers),
    );
  }

  void selectTray(int trayIndex) {
    final currentSelection = state.gameState.selectedTrayIndex;
    final trays = state.gameState.trays;

    if (currentSelection == trayIndex) {
      state = state.copyWith(
        gameState: state.gameState.copyWith(clearSelection: true),
      );
      return;
    }

    final selectedTray = trays[trayIndex];

    if (currentSelection == null) {
      state = state.copyWith(
        gameState: state.gameState.copyWith(selectedTrayIndex: trayIndex),
      );
      return;
    }

    final fromTray = trays[currentSelection];
    final toTray = selectedTray;

    if (fromTray.canMoveTo(toTray)) {
      final movableAmount = fromTray.movableAmount(toTray);
      if (movableAmount > 0) {
        final ingredientToMove = fromTray.top;
        final newFrom = _move(fromTray, -movableAmount);
        final newTo = _move(toTray, movableAmount, ingredientToMove);

        final newTrays = trays.asMap().entries.map((entry) {
          if (entry.key == currentSelection) return newFrom;
          if (entry.key == trayIndex) return newTo;
          return entry.value;
        }).toList();

        final newHistory = [...state.gameState.history, trays];

        state = state.copyWith(
          gameState: state.gameState.copyWith(
            trays: newTrays,
            clearSelection: true,
            moves: state.gameState.moves + 1,
            history: newHistory,
          ),
        );
      }
    }
  }

  void serveTray(int trayIndex) {
    if (state.isWon || state.gameState.isGameOver) return;

    final trays = state.gameState.trays;
    if (trayIndex < 0 || trayIndex >= trays.length) return;

    final tray = trays[trayIndex];
    if (!tray.isComplete || tray.isEmpty) return;

    final ingredient = tray.top!;
    final customers = state.gameState.activeCustomers.toList();

    // Selection relies on collection order. Since customers are appended to
    // the list on arrival, the first matching customer (lowest index)
    // represents the oldest matching customer waiting.
    final customerIndex = customers.indexWhere((c) => c.order == ingredient);
    if (customerIndex != -1) {
      customers.removeAt(customerIndex);

      final newTrays = List<Tray>.from(trays);
      newTrays[trayIndex] = tray.copyWith(contents: []);

      final newServed = state.gameState.customersServed + 1;

      state = state.copyWith(
        gameState: state.gameState.copyWith(
          activeCustomers: customers,
          trays: newTrays,
          customersServed: newServed,
          history:
              [], // Clear history to prevent undoing a serve and duplicating score
          clearSelection: state.gameState.selectedTrayIndex == trayIndex,
        ),
      );

      if (_checkWin()) {
        _handleWin();
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
          trays: lastState,
          clearSelection: true,
          moves: state.gameState.moves - 1,
          history: newHistory,
        ),
      );
    }
  }

  void restartLevel() {
    if (state.currentLevel != null) {
      if (_gameTicker != null) {
        _gameTicker!.cancel();
        _gameTicker = null;
      }
      _adShown = false;
      state = state.copyWith(
        gameState: GameStateData(
          levelId: state.currentLevel!.id,
          trays: state.currentLevel!.trays,
          moves: 0,
          parMoves: state.currentLevel!.parMoves,
          isWon: false,
          activeCustomers: [],
          isGameOver: false,
          customersServed: 0,
          targetCustomers: state.gameState.targetCustomers,
        ),
        isWon: false,
      );
      _adService.loadInterstitialAd();
      _startGameTicker();
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
      if (_gameTicker != null) {
        _gameTicker!.cancel();
        _gameTicker = null;
      }
      _adShown = false;
      state = state.copyWith(
        gameState: GameStateData(
          levelId: nextLevel.id,
          trays: nextLevel.trays,
          moves: 0,
          parMoves: nextLevel.parMoves,
          isWon: false,
          activeCustomers: [],
          isGameOver: false,
          customersServed: 0,
          targetCustomers: state.gameState.targetCustomers,
        ),
        currentLevel: nextLevel,
        isWon: false,
      );
      _adService.loadInterstitialAd();
      _startGameTicker();
    }
  }

  void useHint() {
    final trays = state.gameState.trays;
    final hintsUsed = state.gameState.hintsUsed;
    for (int from = 0; from < trays.length; from++) {
      if (trays[from].isEmpty) {
        continue;
      }
      for (int to = 0; to < trays.length; to++) {
        if (from == to) {
          continue;
        }
        if (trays[from].canMoveTo(trays[to])) {
          selectTray(from);
          selectTray(to);
          state = state.copyWith(
            gameState: state.gameState.copyWith(hintsUsed: hintsUsed + 1),
          );
          return;
        }
      }
    }
  }

  void onTrayTap(int trayIndex) {
    selectTray(trayIndex);
  }

  void addTray() {
    final trays = state.gameState.trays;
    final newTray = Tray(id: trays.length + 1, capacity: 4);
    state = state.copyWith(
      gameState: state.gameState.copyWith(trays: [...trays, newTray]),
    );
  }

  Tray _move(Tray tray, int amount, [Ingredient? ingredient]) {
    if (amount == 0) return tray;

    final newContents = tray.contents.toList();
    if (amount > 0) {
      final topIngredient = ingredient ?? tray.top;
      if (topIngredient == null) return tray;
      for (int i = 0; i < amount; i++) {
        newContents.add(topIngredient);
      }
    } else {
      newContents.removeRange(newContents.length + amount, newContents.length);
    }

    return tray.copyWith(contents: newContents);
  }

  bool _checkWin() {
    return state.gameState.customersServed >= state.gameState.targetCustomers;
  }

  void _handleWin() {
    if (_gameTicker != null) {
      _gameTicker!.cancel();
      _gameTicker = null;
    }
    state = state.copyWith(
      isWon: true,
      gameState: state.gameState.copyWith(isWon: true),
    );
  }
}

final gameControllerProvider =
    StateNotifierProvider<GameController, GameControllerState>((ref) {
      final adService = ref.read(adServiceProvider);
      return GameController(adService);
    });
