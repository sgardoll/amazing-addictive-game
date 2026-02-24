// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Customer {
  String get id => throw _privateConstructorUsedError;
  Ingredient get order => throw _privateConstructorUsedError;
  int get maxPatience => throw _privateConstructorUsedError;
  int get currentPatience => throw _privateConstructorUsedError;

  /// Create a copy of Customer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CustomerCopyWith<Customer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomerCopyWith<$Res> {
  factory $CustomerCopyWith(Customer value, $Res Function(Customer) then) =
      _$CustomerCopyWithImpl<$Res, Customer>;
  @useResult
  $Res call({
    String id,
    Ingredient order,
    int maxPatience,
    int currentPatience,
  });
}

/// @nodoc
class _$CustomerCopyWithImpl<$Res, $Val extends Customer>
    implements $CustomerCopyWith<$Res> {
  _$CustomerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Customer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? order = null,
    Object? maxPatience = null,
    Object? currentPatience = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            order: null == order
                ? _value.order
                : order // ignore: cast_nullable_to_non_nullable
                      as Ingredient,
            maxPatience: null == maxPatience
                ? _value.maxPatience
                : maxPatience // ignore: cast_nullable_to_non_nullable
                      as int,
            currentPatience: null == currentPatience
                ? _value.currentPatience
                : currentPatience // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CustomerImplCopyWith<$Res>
    implements $CustomerCopyWith<$Res> {
  factory _$$CustomerImplCopyWith(
    _$CustomerImpl value,
    $Res Function(_$CustomerImpl) then,
  ) = __$$CustomerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    Ingredient order,
    int maxPatience,
    int currentPatience,
  });
}

/// @nodoc
class __$$CustomerImplCopyWithImpl<$Res>
    extends _$CustomerCopyWithImpl<$Res, _$CustomerImpl>
    implements _$$CustomerImplCopyWith<$Res> {
  __$$CustomerImplCopyWithImpl(
    _$CustomerImpl _value,
    $Res Function(_$CustomerImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Customer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? order = null,
    Object? maxPatience = null,
    Object? currentPatience = null,
  }) {
    return _then(
      _$CustomerImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        order: null == order
            ? _value.order
            : order // ignore: cast_nullable_to_non_nullable
                  as Ingredient,
        maxPatience: null == maxPatience
            ? _value.maxPatience
            : maxPatience // ignore: cast_nullable_to_non_nullable
                  as int,
        currentPatience: null == currentPatience
            ? _value.currentPatience
            : currentPatience // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$CustomerImpl implements _Customer {
  const _$CustomerImpl({
    required this.id,
    required this.order,
    required this.maxPatience,
    required this.currentPatience,
  }) : assert(maxPatience > 0, 'maxPatience must be greater than 0'),
       assert(currentPatience >= 0, 'currentPatience cannot be negative'),
       assert(
         currentPatience <= maxPatience,
         'currentPatience cannot exceed maxPatience',
       );

  @override
  final String id;
  @override
  final Ingredient order;
  @override
  final int maxPatience;
  @override
  final int currentPatience;

  @override
  String toString() {
    return 'Customer(id: $id, order: $order, maxPatience: $maxPatience, currentPatience: $currentPatience)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomerImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.maxPatience, maxPatience) ||
                other.maxPatience == maxPatience) &&
            (identical(other.currentPatience, currentPatience) ||
                other.currentPatience == currentPatience));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, order, maxPatience, currentPatience);

  /// Create a copy of Customer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomerImplCopyWith<_$CustomerImpl> get copyWith =>
      __$$CustomerImplCopyWithImpl<_$CustomerImpl>(this, _$identity);
}

abstract class _Customer implements Customer {
  const factory _Customer({
    required final String id,
    required final Ingredient order,
    required final int maxPatience,
    required final int currentPatience,
  }) = _$CustomerImpl;

  @override
  String get id;
  @override
  Ingredient get order;
  @override
  int get maxPatience;
  @override
  int get currentPatience;

  /// Create a copy of Customer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomerImplCopyWith<_$CustomerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
