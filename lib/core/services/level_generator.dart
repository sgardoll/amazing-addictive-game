import 'dart:math';
import 'package:mindsort/core/models/bottle.dart';
import 'package:mindsort/core/models/emotion.dart';
import 'package:mindsort/core/models/level.dart';

class LevelGenerator {
  static List<Level> generateLevels({int count = 100}) {
    return List.generate(count, (index) => _generateLevel(index + 1));
  }

  static Level _generateLevel(int levelId) {
    final difficulty = _getDifficulty(levelId);
    final emotionCount = difficulty['emotions'] as int;
    final emptyBottles = difficulty['empty'] as int;
    final capacity = difficulty['capacity'] as int;
    final parMoves = difficulty['par'] as int;

    final emotions = Emotion.values.take(emotionCount).toList();
    final bottles = _createSolvedPuzzle(emotions, emptyBottles, capacity);
    final shuffled = _shuffleBottles(bottles, levelId);

    return Level(id: levelId, bottles: shuffled, parMoves: parMoves);
  }

  static Map<String, int> _getDifficulty(int levelId) {
    if (levelId <= 10) {
      return {'emotions': 3, 'empty': 2, 'capacity': 4, 'par': 8 + levelId};
    } else if (levelId <= 30) {
      return {'emotions': 4, 'empty': 2, 'capacity': 4, 'par': 12 + levelId};
    } else if (levelId <= 50) {
      return {'emotions': 5, 'empty': 2, 'capacity': 4, 'par': 15 + levelId};
    } else if (levelId <= 70) {
      return {'emotions': 5, 'empty': 1, 'capacity': 4, 'par': 18 + levelId};
    } else if (levelId <= 90) {
      return {'emotions': 6, 'empty': 2, 'capacity': 4, 'par': 20 + levelId};
    } else {
      return {'emotions': 6, 'empty': 1, 'capacity': 4, 'par': 25 + levelId};
    }
  }

  static List<Bottle> _createSolvedPuzzle(
    List<Emotion> emotions,
    int emptyBottles,
    int capacity,
  ) {
    final bottles = <Bottle>[];
    int bottleId = 1;

    for (final emotion in emotions) {
      final contents = List.generate(capacity, (_) => emotion);
      bottles.add(
        Bottle(id: bottleId++, capacity: capacity, contents: contents),
      );
    }

    for (int i = 0; i < emptyBottles; i++) {
      bottles.add(Bottle(id: bottleId++, capacity: capacity));
    }

    return bottles;
  }

  static List<Bottle> _shuffleBottles(List<Bottle> bottles, int seed) {
    final random = Random(seed);
    final allContents = <Emotion>[];

    for (final bottle in bottles) {
      allContents.addAll(bottle.contents);
    }
    allContents.shuffle(random);

    final newBottles = <Bottle>[];
    int contentIndex = 0;

    for (final bottle in bottles) {
      if (bottle.isEmpty) {
        newBottles.add(Bottle(id: bottle.id, capacity: bottle.capacity));
      } else {
        final count = bottle.capacity;
        final contents = allContents.sublist(
          contentIndex,
          contentIndex + count,
        );
        contentIndex += count;
        newBottles.add(
          Bottle(id: bottle.id, capacity: bottle.capacity, contents: contents),
        );
      }
    }

    return newBottles;
  }
}
