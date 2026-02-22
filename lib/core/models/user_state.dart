class UserStateData {
  final int gems;
  final int currentLevel;
  final int totalStars;
  final int dailyStreak;
  final bool hasRemovedAds;
  final bool hasWeeklyPass;
  final int lastDailyChallengeDay;
  final bool soundEnabled;
  final bool hapticsEnabled;
  final bool darkMode;

  const UserStateData({
    this.gems = 0,
    this.currentLevel = 1,
    this.totalStars = 0,
    this.dailyStreak = 0,
    this.hasRemovedAds = false,
    this.hasWeeklyPass = false,
    this.lastDailyChallengeDay = 0,
    this.soundEnabled = true,
    this.hapticsEnabled = true,
    this.darkMode = false,
  });

  UserStateData copyWith({
    int? gems,
    int? currentLevel,
    int? totalStars,
    int? dailyStreak,
    bool? hasRemovedAds,
    bool? hasWeeklyPass,
    int? lastDailyChallengeDay,
    bool? soundEnabled,
    bool? hapticsEnabled,
    bool? darkMode,
  }) {
    return UserStateData(
      gems: gems ?? this.gems,
      currentLevel: currentLevel ?? this.currentLevel,
      totalStars: totalStars ?? this.totalStars,
      dailyStreak: dailyStreak ?? this.dailyStreak,
      hasRemovedAds: hasRemovedAds ?? this.hasRemovedAds,
      hasWeeklyPass: hasWeeklyPass ?? this.hasWeeklyPass,
      lastDailyChallengeDay:
          lastDailyChallengeDay ?? this.lastDailyChallengeDay,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
      darkMode: darkMode ?? this.darkMode,
    );
  }
}
