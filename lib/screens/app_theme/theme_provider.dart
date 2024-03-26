import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasklocal/constants.dart';

//1. Dark theme provider for all screens (uses Shared provider for context)
final isDarkProvider = StateNotifierProvider<DarkThemeNotifier, bool>((ref) {
  return DarkThemeNotifier(ref: ref);
});

class DarkThemeNotifier extends StateNotifier<bool> {
  DarkThemeNotifier({required this.ref}) : super(true) {
    state = ref.watch(sharedUtilityProvider).currentMode();
  }

  Ref ref;

  void toggleTheme(bool theme) {
    ref.watch(sharedUtilityProvider).setDarkModeEnabled(theme);
    //state = ref.watch(sharedUtilityProvider).isDarkModeEnabled();
    state = theme;
  }
}

//2. Shared provider for all screens (provides context for other providers)
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

final sharedUtilityProvider = Provider<SharedUtility>((ref) {
  final sharedPrefs = ref.watch(sharedPreferencesProvider);
  return SharedUtility(sharedPreferences: sharedPrefs);
});

class SharedUtility {
  SharedUtility({
    required this.sharedPreferences,
  });

  final SharedPreferences sharedPreferences;

  bool currentMode() {
    return sharedPreferences.getBool(sharedDarkModeKey) ?? false;
  }

  void setDarkModeEnabled(bool isdark) {
    sharedPreferences.setBool(sharedDarkModeKey, isdark);
  }
}
