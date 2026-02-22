// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$GameControllerState {
  GameState get gameState => throw _privateConstructorUsedError;
  List<Level> get levels => throw _privateConstructorUsedError;
  Level? get currentLevel => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isGameOver => throw _privateConstructorUsedError;
  bool get isWon => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  /// Create a copy of GameControllerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GameControllerStateCopyWith<GameControllerState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameControllerStateCopyWith<$Res> {
  factory $GameControllerStateCopyWith(
    GameControllerState value,
    $Res Function(GameControllerState) then,
  ) = _$GameControllerStateCopyWithImpl<$Res, GameControllerState>;
  @useResult
  $Res call({
    GameState gameState,
    List<Level> levels,
    Level? currentLevel,
    bool isLoading,
    bool isGameOver,
    bool isWon,
    String? error,
  });

  $GameStateCopyWith<$Res> get gameState;
}

/// @nodoc
class _$GameControllerStateCopyWithImpl<$Res, $Val extends GameControllerState>
    implements $GameControllerStateCopyWith<$Res> {
  _$GameControllerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GameControllerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gameState = null,
    Object? levels = null,
    Object? currentLevel = freezed,
    Object? isLoading = null,
    Object? isGameOver = null,
    Object? isWon = null,
    Object? error = freezed,
  }) {
    return _then(
      _value.copyWith(
            gameState: null == gameState
                ? _value.gameState
                : gameState // ignore: cast_nullable_to_non_nullable
                      as GameState,
            levels: null == levels
                ? _value.levels
                : levels // ignore: cast_nullable_to_non_nullable
                      as List<Level>,
            currentLevel: freezed == currentLevel
                ? _value.currentLevel
                : currentLevel // ignore: cast_nullable_to_non_nullable
                      as Level?,
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            isGameOver: null == isGameOver
                ? _value.isGameOver
                : isGameOver // ignore: cast_nullable_to_non_nullable
                      as bool,
            isWon: null == isWon
                ? _value.isWon
                : isWon // ignore: cast_nullable_to_non_nullable
                      as bool,
            error: freezed == error
                ? _value.error
                : error // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of GameControllerState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GameStateCopyWith<$Res> get gameState {
    return $GameStateCopyWith<$Res>(_value.gameState, (value) {
      return _then(_value.copyWith(gameState: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GameControllerStateImplCopyWith<$Res>
    implements $GameControllerStateCopyWith<$Res> {
  factory _$$GameControllerStateImplCopyWith(
    _$GameControllerStateImpl value,
    $Res Function(_$GameControllerStateImpl) then,
  ) = __$$GameControllerStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    GameState gameState,
    List<Level> levels,
    Level? currentLevel,
    bool isLoading,
    bool isGameOver,
    bool isWon,
    String? error,
  });

  @override
  $GameStateCopyWith<$Res> get gameState;
}

/// @nodoc
class __$$GameControllerStateImplCopyWithImpl<$Res>
    extends _$GameControllerStateCopyWithImpl<$Res, _$GameControllerStateImpl>
    implements _$$GameControllerStateImplCopyWith<$Res> {
  __$$GameControllerStateImplCopyWithImpl(
    _$GameControllerStateImpl _value,
    $Res Function(_$GameControllerStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GameControllerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gameState = null,
    Object? levels = null,
    Object? currentLevel = freezed,
    Object? isLoading = null,
    Object? isGameOver = null,
    Object? isWon = null,
    Object? error = freezed,
  }) {
    return _then(
      _$GameControllerStateImpl(
        gameState: null == gameState
            ? _value.gameState
            : gameState // ignore: cast_nullable_to_non_nullable
                  as GameState,
        levels: null == levels
            ? _value._levels
            : levels // ignore: cast_nullable_to_non_nullable
                  as List<Level>,
        currentLevel: freezed == currentLevel
            ? _value.currentLevel
            : currentLevel // ignore: cast_nullable_to_non_nullable
                  as Level?,
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        isGameOver: null == isGameOver
            ? _value.isGameOver
            : isGameOver // ignore: cast_nullable_to_non_nullable
                  as bool,
        isWon: null == isWon
            ? _value.isWon
            : isWon // ignore: cast_nullable_to_non_nullable
                  as bool,
        error: freezed == error
            ? _value.error
            : error // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$GameControllerStateImpl implements _GameControllerState {
  const _$GameControllerStateImpl({
    required this.gameState,
    required final List<Level> levels,
    required this.currentLevel,
    required this.isLoading,
    required this.isGameOver,
    required this.isWon,
    required this.error,
  }) : _levels = levels;

  @override
  final GameState gameState;
  final List<Level> _levels;
  @override
  List<Level> get levels {
    if (_levels is EqualUnmodifiableListView) return _levels;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_levels);
  }

  @override
  final Level? currentLevel;
  @override
  final bool isLoading;
  @override
  final bool isGameOver;
  @override
  final bool isWon;
  @override
  final String? error;

  @override
  String toString() {
    return 'GameControllerState(gameState: $gameState, levels: $levels, currentLevel: $currentLevel, isLoading: $isLoading, isGameOver: $isGameOver, isWon: $isWon, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameControllerStateImpl &&
            (identical(other.gameState, gameState) ||
                other.gameState == gameState) &&
            const DeepCollectionEquality().equals(other._levels, _levels) &&
            (identical(other.currentLevel, currentLevel) ||
                other.currentLevel == currentLevel) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isGameOver, isGameOver) ||
                other.isGameOver == isGameOver) &&
            (identical(other.isWon, isWon) || other.isWon == isWon) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    gameState,
    const DeepCollectionEquality().hash(_levels),
    currentLevel,
    isLoading,
    isGameOver,
    isWon,
    error,
  );

  /// Create a copy of GameControllerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GameControllerStateImplCopyWith<_$GameControllerStateImpl> get copyWith =>
      __$$GameControllerStateImplCopyWithImpl<_$GameControllerStateImpl>(
        this,
        _$identity,
      );
}

abstract class _GameControllerState implements GameControllerState {
  const factory _GameControllerState({
    required final GameState gameState,
    required final List<Level> levels,
    required final Level? currentLevel,
    required final bool isLoading,
    required final bool isGameOver,
    required final bool isWon,
    required final String? error,
  }) = _$GameControllerStateImpl;

  @override
  GameState get gameState;
  @override
  List<Level> get levels;
  @override
  Level? get currentLevel;
  @override
  bool get isLoading;
  @override
  bool get isGameOver;
  @override
  bool get isWon;
  @override
  String? get error;

  /// Create a copy of GameControllerState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameControllerStateImplCopyWith<_$GameControllerStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
