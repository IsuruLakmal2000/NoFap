import 'package:flutter/material.dart';
import 'package:nofap/Models/CommunityPost.dart';
import 'package:nofap/Widgets/CustomAppBar.dart';
import 'package:nofap/Widgets/Community%20screen/PostWidget.dart';
import 'package:nofap/Services/FirebaseDatabaseService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommunityScreen extends StatefulWidget {
  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final FirebaseDatabaseService _firebaseService = FirebaseDatabaseService();

  List<CommunityPost> posts = [];

  Future<void> _addPost(String content) async {
    final String postId = DateTime.now().millisecondsSinceEpoch.toString();
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String userAvatar = prefs.getString('currentAvatar') ?? "none";
    final String userFrame = prefs.getString('currentFrame') ?? "none";
    final String userName = prefs.getString('userName') ?? "Guest";

    try {
      await _firebaseService.addPost(
        postId: postId,
        userFrame: userFrame,
        content: content,
        userAvatar: userAvatar,
        userName: userName,
      );

      setState(() {
        // posts.add(
        //   CommunityPost(
        //     id: postId,
        //     username: userName,
        //     avatarUrl: userAvatar,
        //     content: content,
        //   ),
        // );
      });
    } catch (e) {
      print('Error adding post: $e');
    }
  }

  Future<void> _deletePost(String id) async {
    try {
      await _firebaseService.deletePost(id);
      setState(() {
        posts.removeWhere((post) => post.id == id);
      });
    } catch (e) {
      print('Error deleting post: $e');
    }
  }

  Future<void> _addComment(String postId, String content) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userName = prefs.getString('userName') ?? "Guest";

    try {
      await _firebaseService.addComment(
        postId: postId,
        username: userName,
        content: content,
      );
    } catch (e) {
      print('Error adding comment: $e');
    }
  }

  void _showCommentsDialog(String postId) {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Comment'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Enter your comment'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _addComment(postId, controller.text);
                Navigator.pop(context);
              },
              child: Text('Comment'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  void _loadPosts() {
    _firebaseService.getPosts().listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>? ?? {};
      final List<CommunityPost> loadedPosts =
          data.entries.map((entry) {
            final postData = entry.value as Map<dynamic, dynamic>;
            final commentsData =
                postData['comments'] as Map<dynamic, dynamic>? ?? {};
            final List<Comment> comments =
                commentsData.entries.map((commentEntry) {
                  final commentData =
                      commentEntry.value as Map<dynamic, dynamic>;
                  return Comment(
                    username: commentData['username'],
                    content: commentData['content'],
                  );
                }).toList();

            return CommunityPost(
              id: postData['postId'],
              username: postData['userName'],
              userId: postData['userId'],
              avatarUrl: postData['userAvatar'],
              frameUrl: postData['userFrame'],
              content: postData['content'],
              likeCount: postData['likeCount'] ?? 0,
              timestamp: postData['timestamp'],
              comments: comments, // Populate the comments field
            );
          }).toList();

      setState(() {
        posts = loadedPosts;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          final timeAgo = timeago.format(
            DateTime.parse(post.timestamp),
          ); // Use timestamp
          return PostWidget(
            post: post,
            timeAgo: timeAgo,
            onDelete: () => _deletePost(post.id),
            onComment: () => _showCommentsDialog(post.id),
          );
        },
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 105, 105, 105),
              const Color.fromARGB(255, 27, 27, 27),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: FloatingActionButton(
          onPressed: () {
            _showAddPostDialog();
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  void _showAddPostDialog() {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Post'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Enter your post content'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _addPost(controller.text);
                Navigator.pop(context);
              },
              child: Text('Post'),
            ),
          ],
        );
      },
    );
  }
}
