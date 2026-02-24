import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mindsort/core/models/ingredient.dart';

part 'customer.freezed.dart';

@freezed
class Customer with _$Customer {
  @Assert('maxPatience > 0', 'maxPatience must be greater than 0')
  @Assert('currentPatience >= 0', 'currentPatience cannot be negative')
  @Assert(
    'currentPatience <= maxPatience',
    'currentPatience cannot exceed maxPatience',
  )
  const factory Customer({
    required String id,
    required Ingredient order,
    required int maxPatience,
    required int currentPatience,
  }) = _Customer;
}
