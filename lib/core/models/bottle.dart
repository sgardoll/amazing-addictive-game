import 'emotion.dart';

class Bottle {
  Bottle({required this.id, required this.capacity, List<Emotion>? contents})
    : contents = contents ?? [];

  final int id;
  final int capacity;
  final List<Emotion> contents;

  bool get isEmpty => contents.isEmpty;
  bool get isFull => contents.length >= capacity;
  Emotion? get top => isEmpty ? null : contents.last;
  int get spaceAvailable => capacity - contents.length;

  bool get isComplete {
    if (isEmpty) return true;
    final firstColor = contents.first;
    return contents.length == capacity &&
        contents.every((e) => e == firstColor);
  }

  Bottle copyWith({int? id, int? capacity, List<Emotion>? contents}) {
    return Bottle(
      id: id ?? this.id,
      capacity: capacity ?? this.capacity,
      contents: contents ?? List.from(this.contents),
    );
  }

  bool canPourTo(Bottle target) {
    if (isEmpty || target.isFull) return false;
    if (target.isEmpty) return true;
    return top == target.top;
  }

  int pourableAmount(Bottle target) {
    if (!canPourTo(target)) return 0;
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
