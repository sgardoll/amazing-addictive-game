import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DailyChallengeState {
  const DailyChallengeState({
    this.streak = 0,
    this.loginCycleDay = 1,
    this.claimedToday = false,
    this.lastClaimEpochDay = -1,
    this.loading = false,
  });

  final int streak;
  final int loginCycleDay;
  final bool claimedToday;
  final int lastClaimEpochDay;
  final bool loading;

  DailyChallengeState copyWith({
    int? streak,
    int? loginCycleDay,
    bool? claimedToday,
    int? lastClaimEpochDay,
    bool? loading,
  }) {
    return DailyChallengeState(
      streak: streak ?? this.streak,
      loginCycleDay: loginCycleDay ?? this.loginCycleDay,
      claimedToday: claimedToday ?? this.claimedToday,
      lastClaimEpochDay: lastClaimEpochDay ?? this.lastClaimEpochDay,
      loading: loading ?? this.loading,
    );
  }
}

class DailyChallengeController extends StateNotifier<DailyChallengeState> {
  DailyChallengeController() : super(const DailyChallengeState());

  static const _kStreak = 'daily_streak';
  static const _kCycleDay = 'daily_cycle_day';
  static const _kLastClaim = 'daily_last_claim';

  int _todayEpochDay() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day).millisecondsSinceEpoch ~/
        86400000;
  }

  Future<void> initialize() async {
    state = state.copyWith(loading: true);
    final prefs = await SharedPreferences.getInstance();
    final streak = prefs.getInt(_kStreak) ?? 0;
    final cycleDay = prefs.getInt(_kCycleDay) ?? 1;
    final lastClaim = prefs.getInt(_kLastClaim) ?? -1;
    final today = _todayEpochDay();
    state = state.copyWith(
      streak: streak,
      loginCycleDay: cycleDay,
      claimedToday: lastClaim == today,
      lastClaimEpochDay: lastClaim,
      loading: false,
    );
  }

  Future<int> claimDailyReward() async {
    final today = _todayEpochDay();
    if (state.claimedToday) {
      return 0;
    }

    final wasYesterday = state.lastClaimEpochDay == today - 1;
    final newStreak = wasYesterday ? state.streak + 1 : 1;
    final newCycleDay = state.loginCycleDay == 7 ? 1 : state.loginCycleDay + 1;
    final reward = _rewardForCycleDay(state.loginCycleDay);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kStreak, newStreak);
    await prefs.setInt(_kCycleDay, newCycleDay);
    await prefs.setInt(_kLastClaim, today);

    state = state.copyWith(
      streak: newStreak,
      loginCycleDay: newCycleDay,
      claimedToday: true,
      lastClaimEpochDay: today,
    );
    return reward;
  }

  int _rewardForCycleDay(int day) {
    switch (day) {
      case 1:
        return 20;
      case 2:
        return 25;
      case 3:
        return 30;
      case 4:
        return 40;
      case 5:
        return 50;
      case 6:
        return 60;
      case 7:
        return 100;
      default:
        return 20;
    }
  }
}

final dailyChallengeProvider =
    StateNotifierProvider<DailyChallengeController, DailyChallengeState>(
      (ref) => DailyChallengeController(),
    );
