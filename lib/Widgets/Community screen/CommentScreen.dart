import 'package:flutter/material.dart';
import 'package:FapFree/Models/CommunityPost.dart';
import 'package:FapFree/Services/FirebaseDatabaseService.dart';
import 'package:FapFree/theme/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentScreen extends StatefulWidget {
  final CommunityPost post;

  CommentScreen({required this.post});

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final FirebaseDatabaseService _firebaseService = FirebaseDatabaseService();
  final TextEditingController _controller = TextEditingController();
  List<Comment> _comments = [];

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  void _loadComments() {
    _firebaseService.getComments(widget.post.id).listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>? ?? {};
      final List<Comment> loadedComments =
          data.entries.map((entry) {
            final commentData = entry.value as Map<dynamic, dynamic>;
            return Comment(
              username: commentData['username'],
              content: commentData['content'],
            );
          }).toList();

      setState(() {
        _comments = loadedComments;
      });
    });
  }

  Future<void> _addComment(String content) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      await _firebaseService.addComment(
        postId: widget.post.id,
        username:
            prefs.getString("userName") ??
            "user", // Replace with actual username
        content: content,
      );
      _controller.clear();
    } catch (e) {
      print('Error adding comment: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Details', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200], // Background color
                borderRadius: BorderRadius.circular(15), // Circular border
              ),
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundImage: AssetImage(
                              "Assets/Avatars/${widget.post.avatarUrl}.jpg",
                            ),
                          ),
                          CircleAvatar(
                            radius: 34,
                            backgroundColor: Colors.transparent,
                            backgroundImage: AssetImage(
                              "Assets/Frames/${widget.post.frameUrl}.png",
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.post.username,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: AppColors.darkGray2,
                            ),
                          ),
                          Text(
                            timeago.format(
                              DateTime.parse(widget.post.timestamp),
                            ),
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                      Spacer(),
                      Row(
                        children: [
                          Icon(Icons.favorite, color: Colors.red),
                          SizedBox(width: 5),
                          Text(
                            '${widget.post.likeCount}',
                            style: TextStyle(
                              color: AppColors.darkGray2,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    widget.post.content,
                    style: TextStyle(
                      color: AppColors.darkGray2,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
          Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: _comments.length,
              itemBuilder: (context, index) {
                final comment = _comments[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 10,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft, // Align to the left
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200], // Background color
                        borderRadius: BorderRadius.circular(
                          20,
                        ), // Circular border
                      ),
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize:
                            MainAxisSize.min, // Adjust size to content
                        children: [
                          Text(
                            comment.username,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkGray2,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            comment.content,
                            style: TextStyle(
                              color: AppColors.mediumGray,
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(hintText: 'Add a comment'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      _addComment(_controller.text);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
