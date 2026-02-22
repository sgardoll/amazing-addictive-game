// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$GameState {
  int get levelId => throw _privateConstructorUsedError;
  List<Bottle> get bottles => throw _privateConstructorUsedError;
  int get moves => throw _privateConstructorUsedError;
  int get parMoves => throw _privateConstructorUsedError;
  bool get isWon => throw _privateConstructorUsedError;
  Bottle? get selectedBottle => throw _privateConstructorUsedError;
  List<List<Bottle>> get history => throw _privateConstructorUsedError;
  int get hintsUsed => throw _privateConstructorUsedError;
  bool get showHint => throw _privateConstructorUsedError;
  int get hintFromBottle => throw _privateConstructorUsedError;
  int get hintToBottle => throw _privateConstructorUsedError;

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GameStateCopyWith<GameState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameStateCopyWith<$Res> {
  factory $GameStateCopyWith(GameState value, $Res Function(GameState) then) =
      _$GameStateCopyWithImpl<$Res, GameState>;
  @useResult
  $Res call({
    int levelId,
    List<Bottle> bottles,
    int moves,
    int parMoves,
    bool isWon,
    Bottle? selectedBottle,
    List<List<Bottle>> history,
    int hintsUsed,
    bool showHint,
    int hintFromBottle,
    int hintToBottle,
  });
}

/// @nodoc
class _$GameStateCopyWithImpl<$Res, $Val extends GameState>
    implements $GameStateCopyWith<$Res> {
  _$GameStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? levelId = null,
    Object? bottles = null,
    Object? moves = null,
    Object? parMoves = null,
    Object? isWon = null,
    Object? selectedBottle = freezed,
    Object? history = null,
    Object? hintsUsed = null,
    Object? showHint = null,
    Object? hintFromBottle = null,
    Object? hintToBottle = null,
  }) {
    return _then(
      _value.copyWith(
            levelId: null == levelId
                ? _value.levelId
                : levelId // ignore: cast_nullable_to_non_nullable
                      as int,
            bottles: null == bottles
                ? _value.bottles
                : bottles // ignore: cast_nullable_to_non_nullable
                      as List<Bottle>,
            moves: null == moves
                ? _value.moves
                : moves // ignore: cast_nullable_to_non_nullable
                      as int,
            parMoves: null == parMoves
                ? _value.parMoves
                : parMoves // ignore: cast_nullable_to_non_nullable
                      as int,
            isWon: null == isWon
                ? _value.isWon
                : isWon // ignore: cast_nullable_to_non_nullable
                      as bool,
            selectedBottle: freezed == selectedBottle
                ? _value.selectedBottle
                : selectedBottle // ignore: cast_nullable_to_non_nullable
                      as Bottle?,
            history: null == history
                ? _value.history
                : history // ignore: cast_nullable_to_non_nullable
                      as List<List<Bottle>>,
            hintsUsed: null == hintsUsed
                ? _value.hintsUsed
                : hintsUsed // ignore: cast_nullable_to_non_nullable
                      as int,
            showHint: null == showHint
                ? _value.showHint
                : showHint // ignore: cast_nullable_to_non_nullable
                      as bool,
            hintFromBottle: null == hintFromBottle
                ? _value.hintFromBottle
                : hintFromBottle // ignore: cast_nullable_to_non_nullable
                      as int,
            hintToBottle: null == hintToBottle
                ? _value.hintToBottle
                : hintToBottle // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GameStateImplCopyWith<$Res>
    implements $GameStateCopyWith<$Res> {
  factory _$$GameStateImplCopyWith(
    _$GameStateImpl value,
    $Res Function(_$GameStateImpl) then,
  ) = __$$GameStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int levelId,
    List<Bottle> bottles,
    int moves,
    int parMoves,
    bool isWon,
    Bottle? selectedBottle,
    List<List<Bottle>> history,
    int hintsUsed,
    bool showHint,
    int hintFromBottle,
    int hintToBottle,
  });
}

/// @nodoc
class __$$GameStateImplCopyWithImpl<$Res>
    extends _$GameStateCopyWithImpl<$Res, _$GameStateImpl>
    implements _$$GameStateImplCopyWith<$Res> {
  __$$GameStateImplCopyWithImpl(
    _$GameStateImpl _value,
    $Res Function(_$GameStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? levelId = null,
    Object? bottles = null,
    Object? moves = null,
    Object? parMoves = null,
    Object? isWon = null,
    Object? selectedBottle = freezed,
    Object? history = null,
    Object? hintsUsed = null,
    Object? showHint = null,
    Object? hintFromBottle = null,
    Object? hintToBottle = null,
  }) {
    return _then(
      _$GameStateImpl(
        levelId: null == levelId
            ? _value.levelId
            : levelId // ignore: cast_nullable_to_non_nullable
                  as int,
        bottles: null == bottles
            ? _value._bottles
            : bottles // ignore: cast_nullable_to_non_nullable
                  as List<Bottle>,
        moves: null == moves
            ? _value.moves
            : moves // ignore: cast_nullable_to_non_nullable
                  as int,
        parMoves: null == parMoves
            ? _value.parMoves
            : parMoves // ignore: cast_nullable_to_non_nullable
                  as int,
        isWon: null == isWon
            ? _value.isWon
            : isWon // ignore: cast_nullable_to_non_nullable
                  as bool,
        selectedBottle: freezed == selectedBottle
            ? _value.selectedBottle
            : selectedBottle // ignore: cast_nullable_to_non_nullable
                  as Bottle?,
        history: null == history
            ? _value._history
            : history // ignore: cast_nullable_to_non_nullable
                  as List<List<Bottle>>,
        hintsUsed: null == hintsUsed
            ? _value.hintsUsed
            : hintsUsed // ignore: cast_nullable_to_non_nullable
                  as int,
        showHint: null == showHint
            ? _value.showHint
            : showHint // ignore: cast_nullable_to_non_nullable
                  as bool,
        hintFromBottle: null == hintFromBottle
            ? _value.hintFromBottle
            : hintFromBottle // ignore: cast_nullable_to_non_nullable
                  as int,
        hintToBottle: null == hintToBottle
            ? _value.hintToBottle
            : hintToBottle // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$GameStateImpl implements _GameState {
  const _$GameStateImpl({
    required this.levelId,
    required final List<Bottle> bottles,
    required this.moves,
    required this.parMoves,
    required this.isWon,
    required this.selectedBottle,
    required final List<List<Bottle>> history,
    this.hintsUsed = 0,
    this.showHint = false,
    this.hintFromBottle = -1,
    this.hintToBottle = -1,
  }) : _bottles = bottles,
       _history = history;

  @override
  final int levelId;
  final List<Bottle> _bottles;
  @override
  List<Bottle> get bottles {
    if (_bottles is EqualUnmodifiableListView) return _bottles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_bottles);
  }

  @override
  final int moves;
  @override
  final int parMoves;
  @override
  final bool isWon;
  @override
  final Bottle? selectedBottle;
  final List<List<Bottle>> _history;
  @override
  List<List<Bottle>> get history {
    if (_history is EqualUnmodifiableListView) return _history;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_history);
  }

  @override
  @JsonKey()
  final int hintsUsed;
  @override
  @JsonKey()
  final bool showHint;
  @override
  @JsonKey()
  final int hintFromBottle;
  @override
  @JsonKey()
  final int hintToBottle;

  @override
  String toString() {
    return 'GameState(levelId: $levelId, bottles: $bottles, moves: $moves, parMoves: $parMoves, isWon: $isWon, selectedBottle: $selectedBottle, history: $history, hintsUsed: $hintsUsed, showHint: $showHint, hintFromBottle: $hintFromBottle, hintToBottle: $hintToBottle)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameStateImpl &&
            (identical(other.levelId, levelId) || other.levelId == levelId) &&
            const DeepCollectionEquality().equals(other._bottles, _bottles) &&
            (identical(other.moves, moves) || other.moves == moves) &&
            (identical(other.parMoves, parMoves) ||
                other.parMoves == parMoves) &&
            (identical(other.isWon, isWon) || other.isWon == isWon) &&
            (identical(other.selectedBottle, selectedBottle) ||
                other.selectedBottle == selectedBottle) &&
            const DeepCollectionEquality().equals(other._history, _history) &&
            (identical(other.hintsUsed, hintsUsed) ||
                other.hintsUsed == hintsUsed) &&
            (identical(other.showHint, showHint) ||
                other.showHint == showHint) &&
            (identical(other.hintFromBottle, hintFromBottle) ||
                other.hintFromBottle == hintFromBottle) &&
            (identical(other.hintToBottle, hintToBottle) ||
                other.hintToBottle == hintToBottle));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    levelId,
    const DeepCollectionEquality().hash(_bottles),
    moves,
    parMoves,
    isWon,
    selectedBottle,
    const DeepCollectionEquality().hash(_history),
    hintsUsed,
    showHint,
    hintFromBottle,
    hintToBottle,
  );

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GameStateImplCopyWith<_$GameStateImpl> get copyWith =>
      __$$GameStateImplCopyWithImpl<_$GameStateImpl>(this, _$identity);
}

abstract class _GameState implements GameState {
  const factory _GameState({
    required final int levelId,
    required final List<Bottle> bottles,
    required final int moves,
    required final int parMoves,
    required final bool isWon,
    required final Bottle? selectedBottle,
    required final List<List<Bottle>> history,
    final int hintsUsed,
    final bool showHint,
    final int hintFromBottle,
    final int hintToBottle,
  }) = _$GameStateImpl;

  @override
  int get levelId;
  @override
  List<Bottle> get bottles;
  @override
  int get moves;
  @override
  int get parMoves;
  @override
  bool get isWon;
  @override
  Bottle? get selectedBottle;
  @override
  List<List<Bottle>> get history;
  @override
  int get hintsUsed;
  @override
  bool get showHint;
  @override
  int get hintFromBottle;
  @override
  int get hintToBottle;

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameStateImplCopyWith<_$GameStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
