import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AchievementState {
  const AchievementState({
    this.levelsCompleted = 0,
    this.purchasesMade = 0,
    this.maxStreak = 0,
    this.unlocked = const <String>{},
  });

  final int levelsCompleted;
  final int purchasesMade;
  final int maxStreak;
  final Set<String> unlocked;

  AchievementState copyWith({
    int? levelsCompleted,
    int? purchasesMade,
    int? maxStreak,
    Set<String>? unlocked,
  }) {
    return AchievementState(
      levelsCompleted: levelsCompleted ?? this.levelsCompleted,
      purchasesMade: purchasesMade ?? this.purchasesMade,
      maxStreak: maxStreak ?? this.maxStreak,
      unlocked: unlocked ?? this.unlocked,
    );
  }
}

class AchievementController extends StateNotifier<AchievementState> {
  AchievementController() : super(const AchievementState());

  static const _levelsKey = 'achievements_levels_completed';
  static const _purchasesKey = 'achievements_purchases_made';
  static const _streakKey = 'achievements_max_streak';
  static const _unlockedKey = 'achievements_unlocked';

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    state = AchievementState(
      levelsCompleted: prefs.getInt(_levelsKey) ?? 0,
      purchasesMade: prefs.getInt(_purchasesKey) ?? 0,
      maxStreak: prefs.getInt(_streakKey) ?? 0,
      unlocked: (prefs.getStringList(_unlockedKey) ?? const <String>[]).toSet(),
    );
  }

  Future<void> recordLevelComplete() async {
    final newCount = state.levelsCompleted + 1;
    final unlocked = {...state.unlocked};
    if (newCount >= 1) unlocked.add('first_harmony');
    if (newCount >= 10) unlocked.add('steady_mind');
    if (newCount >= 50) unlocked.add('fast_food_master');
    await _save(state.copyWith(levelsCompleted: newCount, unlocked: unlocked));
  }

  Future<void> recordPurchase() async {
    final newCount = state.purchasesMade + 1;
    final unlocked = {...state.unlocked};
    if (newCount >= 1) unlocked.add('supporter');
    if (newCount >= 5) unlocked.add('patron');
    await _save(state.copyWith(purchasesMade: newCount, unlocked: unlocked));
  }

  Future<void> recordStreak(int streak) async {
    final newMax = streak > state.maxStreak ? streak : state.maxStreak;
    final unlocked = {...state.unlocked};
    if (newMax >= 3) unlocked.add('habit_builder');
    if (newMax >= 7) unlocked.add('mindful_week');
    await _save(state.copyWith(maxStreak: newMax, unlocked: unlocked));
  }

  Future<void> _save(AchievementState next) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_levelsKey, next.levelsCompleted);
    await prefs.setInt(_purchasesKey, next.purchasesMade);
    await prefs.setInt(_streakKey, next.maxStreak);
    await prefs.setStringList(_unlockedKey, next.unlocked.toList());
    state = next;
  }
}

final achievementControllerProvider =
    StateNotifierProvider<AchievementController, AchievementState>(
      (ref) => AchievementController(),
    );
