import 'dart:math';
import 'package:mindsort/core/models/tray.dart';
import 'package:mindsort/core/models/ingredient.dart';
import 'package:mindsort/core/models/level.dart';

class LevelGenerator {
  static List<Level> generateLevels({int count = 100}) {
    return List.generate(count, (index) => _generateLevel(index + 1));
  }

  static Level _generateLevel(int levelId) {
    final difficulty = _getDifficulty(levelId);
    final ingredientCount = difficulty['ingredients'] as int;
    final emptyTrays = difficulty['empty'] as int;
    final capacity = difficulty['capacity'] as int;
    final parMoves = difficulty['par'] as int;

    final ingredients = Ingredient.values.take(ingredientCount).toList();
    final trays = _createSolvedPuzzle(ingredients, emptyTrays, capacity);
    final shuffled = _shuffleTrays(trays, levelId);

    return Level(id: levelId, trays: shuffled, parMoves: parMoves);
  }

  static Map<String, int> _getDifficulty(int levelId) {
    if (levelId <= 10) {
      return {'ingredients': 3, 'empty': 2, 'capacity': 4, 'par': 8 + levelId};
    } else if (levelId <= 30) {
      return {'ingredients': 4, 'empty': 2, 'capacity': 4, 'par': 12 + levelId};
    } else if (levelId <= 50) {
      return {'ingredients': 5, 'empty': 2, 'capacity': 4, 'par': 15 + levelId};
    } else if (levelId <= 70) {
      return {'ingredients': 5, 'empty': 1, 'capacity': 4, 'par': 18 + levelId};
    } else if (levelId <= 90) {
      return {'ingredients': 6, 'empty': 2, 'capacity': 4, 'par': 20 + levelId};
    } else {
      return {'ingredients': 6, 'empty': 1, 'capacity': 4, 'par': 25 + levelId};
    }
  }

  static List<Tray> _createSolvedPuzzle(
    List<Ingredient> ingredients,
    int emptyTrays,
    int capacity,
  ) {
    final trays = <Tray>[];
    int trayId = 1;

    for (final ingredient in ingredients) {
      final contents = List.generate(capacity, (_) => ingredient);
      trays.add(Tray(id: trayId++, capacity: capacity, contents: contents));
    }

    for (int i = 0; i < emptyTrays; i++) {
      trays.add(Tray(id: trayId++, capacity: capacity));
    }

    return trays;
  }

  static List<Tray> _shuffleTrays(List<Tray> trays, int seed) {
    final random = Random(seed);
    final allContents = <Ingredient>[];

    for (final tray in trays) {
      allContents.addAll(tray.contents);
    }
    allContents.shuffle(random);

    final newTrays = <Tray>[];
    int contentIndex = 0;

    for (final tray in trays) {
      if (tray.isEmpty) {
        newTrays.add(Tray(id: tray.id, capacity: tray.capacity));
      } else {
        final count = tray.capacity;
        final contents = allContents.sublist(
          contentIndex,
          contentIndex + count,
        );
        contentIndex += count;
        newTrays.add(
          Tray(id: tray.id, capacity: tray.capacity, contents: contents),
        );
      }
    }

    return newTrays;
  }
}
