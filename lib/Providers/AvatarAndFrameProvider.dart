import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:FapFree/Services/FirebaseDatabaseService.dart';

class AvatarAndFrameProvider with ChangeNotifier {
  String _currentAvatar = "none"; // Default avatar
  String _currentFrame = "none";
  String get currentAvatar => _currentAvatar;
  String get currentFrame => _currentFrame;

  AvatarAndFrameProvider() {
    _loadAvatarFromPrefs();
    _loadFrameFromPrefs();
  }

  Future<void> _loadAvatarFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _currentAvatar = prefs.getString('currentAvatar') ?? "none";
    notifyListeners();
  }

  Future<void> _loadFrameFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _currentFrame = prefs.getString('a') ?? "none";
    notifyListeners();
  }

  Future<void> updateAvatar(String newAvatar) async {
    print("inside usssp");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('currentAvatar', newAvatar);
    _currentAvatar = newAvatar;
    notifyListeners();

    // Save to Firebase
    final firebaseService = FirebaseDatabaseService();
    await firebaseService.updateUserAvatar(newAvatar);
  }

  Future<void> updateFrame(String newFrame) async {
    print("inside up");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('currentFrame', newFrame);
    _currentFrame = newFrame;
    notifyListeners();

    // Save to Firebase
    final firebaseService = FirebaseDatabaseService();
    await firebaseService.updateUserFrame(newFrame);
  }
}
