import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nofap/Services/FirebaseDatabaseService.dart';

class UserProvider extends ChangeNotifier {
  String displayUsername = '';
  String avatarId = 'none';
  String frameId = 'none';
  int currentPoints = 0;

  final FirebaseDatabaseService _dbService = FirebaseDatabaseService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoaded = false; // To prevent multiple unnecessary calls

  Future<void> loadUserData() async {
    if (_isLoaded) return; // Prevents multiple fetches

    if (_auth.currentUser?.uid != null) {
      final event = await _dbService.getUserData().first; // Fetch only once
      if (event.snapshot.value != null) {
        final data = Map<String, dynamic>.from(event.snapshot.value as Map);
        displayUsername = data['displayUsername'];
        avatarId = data['avatarId'];
        frameId = data['frameId'];
        currentPoints = data['currentPoints'];
        notifyListeners();
        _isLoaded = true;
      }
    } else {
      return;
    }
  }

  Future<void> saveUserData(
    String username,
    String avatar,
    String frame,
    int points,
    int streakDays,
  ) async {
    print("inside save data---");
    displayUsername = username;
    avatarId = avatar;
    frameId = frame;
    currentPoints = points;
    await _dbService.saveUserData(username, avatar, frame, points, streakDays);
    print("user data saved00000000000000");
    notifyListeners();
  }
}
