import 'package:flutter/material.dart';
import 'package:nofap/Models/CommunityPost.dart';
import 'package:nofap/Widgets/Community%20screen/CommentScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nofap/Theme/colors.dart';
import 'package:nofap/Services/FirebaseDatabaseService.dart';

class PostWidget extends StatefulWidget {
  final CommunityPost post;
  final String timeAgo;
  final VoidCallback onDelete;
  final VoidCallback onComment;

  PostWidget({
    required this.post,
    required this.timeAgo,
    required this.onDelete,
    required this.onComment,
  });

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  bool isLiked = false; // Track the like status
  final FirebaseDatabaseService _firebaseService = FirebaseDatabaseService();

  void _toggleLike() async {
    setState(() {
      isLiked = !isLiked;
      if (isLiked) {
        widget.post.likeCount++;
      } else {
        widget.post.likeCount--;
      }
    });

    try {
      // Update the like count in the database
      await _firebaseService.updatePostLikeCount(
        postId: widget.post.id,
        likeCount: widget.post.likeCount,
      );
    } catch (e) {
      print('Error updating like count: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Card(
      margin: EdgeInsets.all(10),
      elevation: 0.0, // Remove shadow by setting elevation to 0.0
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage(
                        "Assets/Avatars/${widget.post.avatarUrl}.jpg",
                      ),
                    ),
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: Colors.transparent,
                      backgroundImage:
                          widget.post.frameUrl != "none"
                              ? AssetImage(
                                "Assets/Frames/${widget.post.frameUrl}.png",
                              )
                              : null,
                    ),
                  ],
                ),
              ],
            ),
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.post.username,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkGray2,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      widget.timeAgo,
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),

                if (currentUser != null &&
                    currentUser.uid == widget.post.userId)
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: widget.onDelete,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
