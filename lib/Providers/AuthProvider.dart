import 'package:flutter/material.dart';
import 'package:nofap/Services/SharedPreferences.dart';

class AuthProvider with ChangeNotifier {
  bool _isOnboardingSeen = false;
  final SharedPreferencesService _sharedPreferencesService =
      SharedPreferencesService();

  bool get isOnboardingSeen => _isOnboardingSeen;

  AuthProvider() {
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    _isOnboardingSeen = await _sharedPreferencesService.isOnboardingSeen();
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    await _sharedPreferencesService.setOnboardingSeen();
    _isOnboardingSeen = true;
    notifyListeners();
  }
}
