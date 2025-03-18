import 'package:flutter/material.dart';
import 'package:nofap/Services/SharedPreferences.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthProvider with ChangeNotifier {
  bool _isOnboardingSeen = false;
  final SharedPreferencesService _sharedPreferencesService =
      SharedPreferencesService();

  User? _user;
  User? get user => _user;
  bool get isOnboardingSeen => _isOnboardingSeen;
  bool get isSignedIn => _user != null;

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
