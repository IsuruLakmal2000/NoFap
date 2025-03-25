import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseDatabaseService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> saveUserData(
    String displayUsername,
    String avatarId,
    int currentPoints,
  ) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        print("Authenticated user found: UID = ${user.uid}");
        print("Attempting to save user data...");
        await _dbRef.child('users/${user.uid}').set({
          'displayUsername': displayUsername,
          'avatarId': avatarId,
          'currentPoints': currentPoints,
        });
        print("User data saved successfully for UID: ${user.uid}");
      } else {
        print("Error: No authenticated user found.");
      }
    } catch (e) {
      print("Error saving user data: $e");
    }
  }

  Future<void> updateUserPoints(int points) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        print("Updating points for UID: ${user.uid}");
        await _dbRef.child('users/${user.uid}/currentPoints').set(points);
        print("Points updated successfully for UID: ${user.uid}");
      } else {
        print("Error: No authenticated user found.");
      }
    } catch (e) {
      print("Error updating points: $e");
    }
  }

  Stream<DatabaseEvent> getUserData() {
    final user = _auth.currentUser;
    if (user != null) {
      print("Fetching user data for UID: ${user.uid}");
      return _dbRef.child('users/${user.uid}').onValue;
    } else {
      throw Exception("No authenticated user found.");
    }
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
