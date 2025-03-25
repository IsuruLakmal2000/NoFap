import 'package:flutter/material.dart';
import 'package:nofap/Services/SharedPreferences.dart';
import 'package:nofap/Services/FirebaseDatabaseService.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthProvider with ChangeNotifier {
  bool _isOnboardingSeen = false;
  int currentUserPoints = 0;
  final SharedPreferencesService _sharedPreferencesService =
      SharedPreferencesService();
  final FirebaseDatabaseService _firebaseDatabaseService =
      FirebaseDatabaseService();

  User? _user;
  User? get user => _user;
  bool get isOnboardingSeen => _isOnboardingSeen;
  bool get isSignedIn => _user != null;

  AuthProvider() {
    _checkOnboardingStatus();
    _getUserPoints();
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

  Future<void> _getUserPoints() async {
    currentUserPoints = await _sharedPreferencesService.getUserPoints();
    await _updatePointsInDatabase(); // Update points in the database
    notifyListeners();
  }

  Future<void> AddPoints(int point) async {
    await _sharedPreferencesService.addPoints(point);
    currentUserPoints = await _sharedPreferencesService.getUserPoints();
    await _updatePointsInDatabase(); // Update points in the database
    notifyListeners();
  }

  Future<void> _updatePointsInDatabase() async {
    final user = _firebaseDatabaseService.getCurrentUser();
    if (user != null) {
      await _firebaseDatabaseService.updateUserPoints(currentUserPoints);
    }
  }
}
