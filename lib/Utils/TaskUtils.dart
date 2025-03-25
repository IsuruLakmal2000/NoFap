import 'package:shared_preferences/shared_preferences.dart';

class TaskUtils {
  static Future<int> calculateTaskProgress(Map<String, dynamic> task) async {
    final prefs = await SharedPreferences.getInstance();
    int progress = 0;

    switch (task['id']) {
      case 1: // Stay strong for 5 minutes
        progress = await GetStreakProgress();
        break;
      case 2: // Stay strong for 30 minutes
        progress = await GetStreakProgress();
        break;

      case 4: // Stay strong for 1 hour
        progress = (await GetStreakProgress() / 60).floor();
        break;
      case 5: // Stay strong for 2 hours
        progress = (await GetStreakProgress() / 60).floor();
        break;
      case 6: // Stay strong for 5 hours
        progress = (await GetStreakProgress() / 60).floor();
        break;
      case 7: // Stay strong for 15 hours
        progress = (await GetStreakProgress() / 60).floor();
        break;
      case 8: // Stay strong for 1 day
        progress = (await GetStreakProgress() / (60 * 24)).floor();
        break;
      case 9: // Stay strong for 2 days
        progress = (await GetStreakProgress() / (60 * 24)).floor();
        break;
      case 10: // Stay strong for 5 days
        progress = (await GetStreakProgress() / (60 * 24)).floor();
        break;
      case 11: // Stay strong for 10 days
        progress = (await GetStreakProgress() / (60 * 24)).floor();
        break;
      case 12: // Stay strong for 20 days
        progress = (await GetStreakProgress() / (60 * 24)).floor();
        break;
      case 13: // Stay strong for 30 days
        progress = (await GetStreakProgress() / (60 * 24)).floor();
        break;
      case 14: // Stay strong for 50 days
        progress = (await GetStreakProgress() / (60 * 24)).floor();
        break;
      case 15: // Stay strong for 75 days
        progress = (await GetStreakProgress() / (60 * 24)).floor();
        break;
      case 16: // Stay strong for 100 days
        progress = (await GetStreakProgress() / (60 * 24)).floor();
        break;
      case 17: // Stay strong for 200 days
        progress = (await GetStreakProgress() / (60 * 24)).floor();
        break;
      case 18: // Stay strong for 300 days
        progress = (await GetStreakProgress() / (60 * 24)).floor();
        break;

      case 3: // Daily Login
        final String today = DateTime.now().toIso8601String().split('T')[0];
        final String? lastLoginDate = prefs.getString('lastLoginDate');
        if (lastLoginDate == today) {
          progress = 1; // Task completed for today
        }
        break;

      case 19: // Post 1 time in the community
      case 20: // Post 3 times in the community
      case 21: // Post 5 times in the community
      case 22: // Post 10 times in the community
      case 23: // Post 50 times in the community
        progress = prefs.getInt('communityPosts') ?? 0;
        break;

      case 24: // Earn 100 points
      case 25: // Earn 500 points
      case 26: // Earn 1500 points
      case 27: // Earn 2500 points
      case 28: // Earn 5000 points
      case 29: // Earn 10000 points
      case 30: // Earn 15000 points
      case 31: // Earn 25000 points
        progress = prefs.getInt('totalPoints') ?? 0;
        break;

      case 32: // React to 1 post
      case 33: // React to 5 posts
      case 34: // React to 10 posts
      case 35: // React to 20 posts
      case 36: // React to 40 posts
      case 37: // React to 70 posts
      case 38: // React to 120 posts
      case 39: // React to 175 posts
      case 40: // React to 250 posts
      case 41: // React to 500 posts
      case 42: // React to 1000 posts
        progress = prefs.getInt('postReactions') ?? 0;
        break;

      default:
        break;
    }

    return progress;
  }

  static Future<int> GetStreakProgress() async {
    final prefs = await SharedPreferences.getInstance();
    String? startDateString = prefs.getString('streakStartDate');
    if (startDateString != null) {
      DateTime startDate = DateTime.parse(startDateString);
      return DateTime.now().difference(startDate).inMinutes;
    }
    return 0;
  }
}
