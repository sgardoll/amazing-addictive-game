import 'package:mindsort/core/models/ingredient.dart';

class Customer {
  final String id;
  final Ingredient order;
  final int maxPatience;
  final int currentPatience;

  const Customer({
    required this.id,
    required this.order,
    required this.maxPatience,
    required this.currentPatience,
  });

  Customer copyWith({
    String? id,
    Ingredient? order,
    int? maxPatience,
    int? currentPatience,
  }) {
    return Customer(
      id: id ?? this.id,
      order: order ?? this.order,
      maxPatience: maxPatience ?? this.maxPatience,
      currentPatience: currentPatience ?? this.currentPatience,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Customer &&
        other.id == id &&
        other.order == order &&
        other.maxPatience == maxPatience &&
        other.currentPatience == currentPatience;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        order.hashCode ^
        maxPatience.hashCode ^
        currentPatience.hashCode;
  }
}
