import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nofap/Models/LeaderboardUser.dart';

class FirebaseDatabaseService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> saveUserData(
    String displayUsername,
    String avatarId,
    String frameId,
    int currentPoints,
    int streakDays,
  ) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        print("Authenticated user found: UID = ${user.uid}");
        print("Attempting to save user data...");
        await _dbRef.child('users/${user.uid}').set({
          'displayUsername': displayUsername,
          'avatarId': avatarId,
          'frameId': frameId,
          'currentPoints': currentPoints,
          'streakDays': streakDays,
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

  Future<void> updateCurrentStreaStartDay(String day) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        print("Updating points for UID: ${user.uid}");
        await _dbRef.child('users/${user.uid}/streakStartDay').set(day);
        print("Points updated successfully for UID: ${user.uid}");
      } else {
        print("Error: No authenticated user found.");
      }
    } catch (e) {
      print("Error updating points: $e");
    }
  }

  Future<void> updateUserAvatar(String avatarId) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        print("Updating avatar for UID: ${user.uid}");
        await _dbRef.child('users/${user.uid}/avatarId').set(avatarId);
        print("Avatar updated successfully for UID: ${user.uid}");
      } else {
        print("Error: No authenticated user found.");
      }
    } catch (e) {
      print("Error updating avatar: $e");
    }
  }

  Future<void> updateUserFrame(String frameId) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        print("Updating frame for UID: ${user.uid}");
        await _dbRef.child('users/${user.uid}/frameId').set(frameId);
        print("Frame updated successfully for UID: ${user.uid}");
      } else {
        print("Error: No authenticated user found.");
      }
    } catch (e) {
      print("Error updating frame: $e");
    }
  }

  Future<void> updateUserName(String displayUsername) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        print("Updating username for UID: ${user.uid}");
        await _dbRef
            .child('users/${user.uid}/displayUsername')
            .set(displayUsername);
        print("Username updated successfully for UID: ${user.uid}");
      } else {
        print("Error: No authenticated user found.");
      }
    } catch (e) {
      print("Error updating username: $e");
    }
  }

  Future<void> addComment({
    required String postId,
    required String username,
    required String content,
  }) async {
    try {
      final String commentId = DateTime.now().millisecondsSinceEpoch.toString();
      print("Adding comment to post ID: $postId");
      await _dbRef.child('posts/$postId/comments/$commentId').set({
        'username': username,
        'content': content,
        'timestamp': DateTime.now().toIso8601String(),
      });
      print("Comment added successfully to post ID: $postId");
    } catch (e) {
      print("Error adding comment: $e");
      throw e;
    }
  }

  Future<void> addPost({
    required String postId,
    required String userName,
    required String content,
    required String userAvatar,
    required String userFrame,
    int likeCount = 0,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        print("Adding post with ID: $postId");
        await _dbRef.child('posts/$postId').set({
          'postId': postId,
          'userId': user.uid,
          'content': content,
          'userAvatar': userAvatar,
          'userName': userName,
          'userFrame': userFrame,
          'likeCount': likeCount,
          'timestamp': DateTime.now().toIso8601String(),
        });
        print("Post added successfully with ID: $postId");
      } else {
        print("Error: No authenticated user found.");
      }
    } catch (e) {
      print("Error adding post: $e");
      throw e;
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      print("Deleting post with ID: $postId");
      await _dbRef.child('posts/$postId').remove();
      print("Post deleted successfully with ID: $postId");
    } catch (e) {
      print("Error deleting post: $e");
      throw e;
    }
  }

  Stream<DatabaseEvent> getPosts() {
    try {
      print("Fetching posts from database...");
      return _dbRef.child('posts').orderByChild('timestamp').onValue;
    } catch (e) {
      print("Error fetching posts: $e");
      throw e;
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

  Future<List<LeaderboardUser>> getLeaderboardData() async {
    try {
      final snapshot = await _dbRef.child('users').get();
      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        return data.entries.map((entry) {
            final userData = entry.value as Map<dynamic, dynamic>;
            final userId = entry.key; // Get the user ID
            return LeaderboardUser.fromMap(userData)..userId = userId;
          }).toList()
          ..sort((a, b) => b.currentPoints.compareTo(a.currentPoints))
          ..take(50).toList();
      } else {
        print("No leaderboard data found.");
        return [];
      }
    } catch (e) {
      print("Error fetching leaderboard data: $e");
      return [];
    }
  }

  Stream<DatabaseEvent> getComments(String postId) {
    try {
      print("Fetching comments for post ID: $postId");
      return _dbRef.child('posts/$postId/comments').onValue;
    } catch (e) {
      print("Error fetching comments: $e");
      throw e;
    }
  }
}
