class CommunityPost {
  final String id;
  final String username;
  final String avatarUrl;
  final String frameUrl;
  final String content;
  final String userId;
  int likeCount; // Remove 'final' to make it mutable
  final String timestamp;
  final List<Comment> comments;

  CommunityPost({
    required this.id,
    required this.username,
    required this.userId,
    required this.avatarUrl,
    required this.frameUrl,
    required this.content,
    this.likeCount = 0, // Default value
    required this.timestamp,
    this.comments = const [],
  });
}

class Comment {
  final String username;
  final String content;

  Comment({required this.username, required this.content});
}
