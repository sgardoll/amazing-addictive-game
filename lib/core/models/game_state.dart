import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'emotion.dart';
import 'bottle.dart';

part 'game_state.freezed.dart';

@freezed
class GameState with _$GameState {
  const factory GameState({
    required int levelId,
    required List<Bottle> bottles,
    required int moves,
    required int parMoves,
    required bool isWon,
    required Bottle? selectedBottle,
    required List<List<Bottle>> history,
    @Default(0) int hintsUsed,
    @Default(false) bool showHint,
    @Default(-1) int hintFromBottle,
    @Default(-1) int hintToBottle,
  }) = _GameState;

  factory GameState.initial() => const GameState(
    levelId: 1,
    bottles: [],
    moves: 0,
    parMoves: 10,
    isWon: false,
    selectedBottle: null,
    history: [],
  );
}

extension GameStateX on GameState {
  bool get canUndo => history.isNotEmpty;
  int get completeBottles => bottles.where((b) => b.isComplete).length;
  int get totalBottles => bottles.length;
  double get progress => totalBottles > 0 ? completeBottles / totalBottles : 0;
}
