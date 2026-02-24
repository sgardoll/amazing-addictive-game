import 'tray.dart';

class GameStateData {
  final int levelId;
  final List<Tray> trays;
  final int moves;
  final int parMoves;
  final bool isWon;
  final Tray? selectedTray;
  final List<List<Tray>> history;

  const GameStateData({
    required this.levelId,
    required this.trays,
    required this.moves,
    required this.parMoves,
    required this.isWon,
    this.selectedTray,
    this.history = const [],
  });

  GameStateData copyWith({
    int? levelId,
    List<Tray>? trays,
    int? moves,
    int? parMoves,
    bool? isWon,
    Tray? selectedTray,
    List<List<Tray>>? history,
  }) {
    return GameStateData(
      levelId: levelId ?? this.levelId,
      trays: trays ?? this.trays,
      moves: moves ?? this.moves,
      parMoves: parMoves ?? this.parMoves,
      isWon: isWon ?? this.isWon,
      selectedTray: selectedTray,
      history: history ?? this.history,
    );
  }

  bool get canUndo => history.isNotEmpty;
  int get completeTrays => trays.where((b) => b.isComplete).length;
  int get totalTrays => trays.length;
  double get progress => totalTrays > 0 ? completeTrays / totalTrays : 0;
}
