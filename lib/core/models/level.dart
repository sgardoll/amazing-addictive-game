import 'tray.dart';
import 'ingredient.dart';

class Level {
  Level({
    required this.id,
    required this.trays,
    required this.parMoves,
    this.starThresholds = const [1.0, 0.8, 0.6],
  });

  final int id;
  final List<Tray> trays;
  final int parMoves;
  final List<double> starThresholds;

  int get trayCount => trays.length;
  int get capacity => trays.first.capacity;

  int calculateStars(int moves) {
    final ratio = moves / parMoves;
    if (ratio <= starThresholds[2]) return 3;
    if (ratio <= starThresholds[1]) return 2;
    if (ratio <= starThresholds[0]) return 1;
    return 0;
  }

  bool get isSolvable => _checkSolvable();

  bool _checkSolvable() {
    final allContents = trays.expand((b) => b.contents).toList();
    final ingredientCounts = <Ingredient, int>{};
    for (final ingredient in allContents) {
      ingredientCounts[ingredient] = (ingredientCounts[ingredient] ?? 0) + 1;
    }
    for (final count in ingredientCounts.values) {
      if (count % capacity != 0) return false;
    }
    return true;
  }
}

class LevelProgress {
  LevelProgress({
    required this.levelId,
    this.isUnlocked = false,
    this.isCompleted = false,
    this.bestMoves,
    this.bestStars = 0,
  });

  final int levelId;
  final bool isUnlocked;
  final bool isCompleted;
  final int? bestMoves;
  final int bestStars;

  LevelProgress copyWith({
    int? levelId,
    bool? isUnlocked,
    bool? isCompleted,
    int? bestMoves,
    int? bestStars,
  }) {
    return LevelProgress(
      levelId: levelId ?? this.levelId,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      isCompleted: isCompleted ?? this.isCompleted,
      bestMoves: bestMoves ?? this.bestMoves,
      bestStars: bestStars ?? this.bestStars,
    );
  }
}
