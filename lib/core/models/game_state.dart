import 'tray.dart';

class GameStateData {
  final int levelId;
  final List<Tray> trays;
  final int moves;
  final int parMoves;
  final bool isWon;
  final Tray? selectedTray;
  final int? selectedTrayIndex;
  final List<List<Tray>> history;
  final int hintsUsed;
  final bool showHint;

  const GameStateData({
    required this.levelId,
    required this.trays,
    required this.moves,
    required this.parMoves,
    required this.isWon,
    this.selectedTray,
    this.selectedTrayIndex,
    this.history = const [],
    this.hintsUsed = 0,
    this.showHint = false,
  });

  GameStateData copyWith({
    int? levelId,
    List<Tray>? trays,
    int? moves,
    int? parMoves,
    bool? isWon,
    Tray? selectedTray,
    int? selectedTrayIndex,
    bool? clearSelection,
    List<List<Tray>>? history,
    int? hintsUsed,
    bool? showHint,
  }) {
    return GameStateData(
      levelId: levelId ?? this.levelId,
      trays: trays ?? this.trays,
      moves: moves ?? this.moves,
      parMoves: parMoves ?? this.parMoves,
      isWon: isWon ?? this.isWon,
      selectedTray: clearSelection == true
          ? null
          : (selectedTray ?? this.selectedTray),
      selectedTrayIndex: clearSelection == true
          ? null
          : (selectedTrayIndex ?? this.selectedTrayIndex),
      history: history ?? this.history,
      hintsUsed: hintsUsed ?? this.hintsUsed,
      showHint: showHint ?? this.showHint,
    );
  }

  bool get canUndo => history.isNotEmpty;
  int get completeTrays => trays.where((b) => b.isComplete).length;
  int get totalTrays => trays.length;
  double get progress => totalTrays > 0 ? completeTrays / totalTrays : 0;
}
