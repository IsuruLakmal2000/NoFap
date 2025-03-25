import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static const String onboardingKey = 'onboardingSeen';
  static const String currentUserPoints = 'userPoints';

  Future<void> setOnboardingSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(onboardingKey, true);
  }

  Future<bool> isOnboardingSeen() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(onboardingKey) ?? false;
  }

  Future<int> getUserPoints() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(currentUserPoints) ?? 0;
  }

  Future<void> addPoints(int x) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
      currentUserPoints,
      (prefs.getInt(currentUserPoints) ?? 0) + x,
    );
  }
}
