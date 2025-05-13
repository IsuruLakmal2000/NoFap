class LeaderboardUser {
  final String username;
  final String currentStreakStartDate;
  final int currentPoints;
  final String avatarId;
  final String frameId;
  final bool isPerchasePremium;
  String? userId; // Added userId field

  LeaderboardUser({
    required this.username,
    required this.currentStreakStartDate,
    required this.currentPoints,
    required this.avatarId,
    required this.frameId,
    required this.isPerchasePremium,
    this.userId,
  });

  factory LeaderboardUser.fromMap(Map<dynamic, dynamic> data) {
    return LeaderboardUser(
      username: data['displayUsername'] ?? '',
      currentStreakStartDate: data['streakStartDay'] ?? '',
      currentPoints: data['currentPoints'] ?? 0,
      avatarId: data['avatarId'] ?? '',
      frameId: data['frameId'] ?? '',

      isPerchasePremium: data['isPerchasePremium'] ?? false,
    );
  }
}
