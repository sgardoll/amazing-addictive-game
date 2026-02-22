import 'bottle.dart';

class GameStateData {
  final int levelId;
  final List<Bottle> bottles;
  final int moves;
  final int parMoves;
  final bool isWon;
  final Bottle? selectedBottle;
  final List<List<Bottle>> history;

  const GameStateData({
    required this.levelId,
    required this.bottles,
    required this.moves,
    required this.parMoves,
    required this.isWon,
    this.selectedBottle,
    this.history = const [],
  });

  GameStateData copyWith({
    int? levelId,
    List<Bottle>? bottles,
    int? moves,
    int? parMoves,
    bool? isWon,
    Bottle? selectedBottle,
    List<List<Bottle>>? history,
  }) {
    return GameStateData(
      levelId: levelId ?? this.levelId,
      bottles: bottles ?? this.bottles,
      moves: moves ?? this.moves,
      parMoves: parMoves ?? this.parMoves,
      isWon: isWon ?? this.isWon,
      selectedBottle: selectedBottle,
      history: history ?? this.history,
    );
  }

  bool get canUndo => history.isNotEmpty;
  int get completeBottles => bottles.where((b) => b.isComplete).length;
  int get totalBottles => bottles.length;
  double get progress => totalBottles > 0 ? completeBottles / totalBottles : 0;
}
