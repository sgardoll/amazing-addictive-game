import 'ingredient.dart';

class Tray {
  Tray({required this.id, required this.capacity, List<Ingredient>? contents})
    : contents = contents ?? [];

  final int id;
  final int capacity;
  final List<Ingredient> contents;

  bool get isEmpty => contents.isEmpty;
  bool get isFull => contents.length >= capacity;
  Ingredient? get top => isEmpty ? null : contents.last;
  int get spaceAvailable => capacity - contents.length;

  bool get isComplete {
    if (isEmpty) return true;
    final firstIngredient = contents.first;
    return contents.length == capacity &&
        contents.every((e) => e == firstIngredient);
  }

  Tray copyWith({int? id, int? capacity, List<Ingredient>? contents}) {
    return Tray(
      id: id ?? this.id,
      capacity: capacity ?? this.capacity,
      contents: contents ?? List.from(this.contents),
    );
  }

  bool canMoveTo(Tray target) {
    if (isEmpty || target.isFull) return false;
    if (target.isEmpty) return true;
    return top == target.top;
  }

  int movableAmount(Tray target) {
    if (!canMoveTo(target)) return 0;
    int sameFromTop = 0;
    for (int i = contents.length - 1; i >= 0; i--) {
      if (contents[i] == top) {
        sameFromTop++;
      } else {
        break;
      }
    }
    return sameFromTop.clamp(0, target.spaceAvailable);
  }
}
