import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsState {
  const SettingsState({
    this.soundEnabled = true,
    this.hapticsEnabled = true,
    this.darkMode = true,
    this.loading = false,
  });

  final bool soundEnabled;
  final bool hapticsEnabled;
  final bool darkMode;
  final bool loading;

  SettingsState copyWith({
    bool? soundEnabled,
    bool? hapticsEnabled,
    bool? darkMode,
    bool? loading,
  }) {
    return SettingsState(
      soundEnabled: soundEnabled ?? this.soundEnabled,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
      darkMode: darkMode ?? this.darkMode,
      loading: loading ?? this.loading,
    );
  }
}

class SettingsController extends StateNotifier<SettingsState> {
  SettingsController() : super(const SettingsState());

  static const _kSoundEnabled = 'settings_sound_enabled';
  static const _kHapticsEnabled = 'settings_haptics_enabled';
  static const _kDarkMode = 'settings_dark_mode';

  Future<void> initialize() async {
    state = state.copyWith(loading: true);
    final prefs = await SharedPreferences.getInstance();
    state = SettingsState(
      soundEnabled: prefs.getBool(_kSoundEnabled) ?? true,
      hapticsEnabled: prefs.getBool(_kHapticsEnabled) ?? true,
      darkMode: prefs.getBool(_kDarkMode) ?? true,
      loading: false,
    );
  }

  Future<void> setSoundEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kSoundEnabled, value);
    state = state.copyWith(soundEnabled: value);
  }

  Future<void> setHapticsEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kHapticsEnabled, value);
    state = state.copyWith(hapticsEnabled: value);
  }

  Future<void> setDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kDarkMode, value);
    state = state.copyWith(darkMode: value);
  }
}

final settingsControllerProvider =
    StateNotifierProvider<SettingsController, SettingsState>(
      (ref) => SettingsController(),
    );
