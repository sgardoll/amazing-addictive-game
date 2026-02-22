import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_state.freezed.dart';

@freezed
class UserState with _$UserState {
  const factory UserState({
    @Default(0) int gems,
    @Default(0) int coins,
    @Default(1) int currentLevel,
    @Default(0) int totalStars,
    @Default(0) int dailyStreak,
    @Default(false) bool hasRemovedAds,
    @Default(false) bool hasWeeklyPass,
    @Default(0) int lastDailyChallengeDay,
    @Default(false) bool soundEnabled,
    @Default(true) bool hapticsEnabled,
    @Default(false) bool darkMode,
  }) = _UserState;

  factory UserState.initial() => const UserState();
}
