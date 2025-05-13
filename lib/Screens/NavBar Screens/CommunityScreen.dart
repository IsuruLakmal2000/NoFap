import 'package:flutter/material.dart';
import 'package:nofap/Models/CommunityPost.dart';
import 'package:nofap/Widgets/CustomAppBar.dart';
import 'package:nofap/Widgets/Community%20screen/PostWidget.dart';
import 'package:nofap/Services/FirebaseDatabaseService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'dart:convert'; // For JSON encoding/decoding
import 'package:http/http.dart' as http;

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

  void _showAddPostDialog() async {
    final TextEditingController controller = TextEditingController();
    String selectedPost = ''; // Track the selected example post
    int currentStreak = 0;
    int nextMilestone = 0;

    // Fetch the current streak from SharedPreferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    currentStreak = prefs.getInt('currentStreak') ?? 0;
    nextMilestone =
        currentStreak + 5; // Add 5 days to calculate the next milestone

    // Example posts with dynamic streak and milestone
    final examplePosts = [
      "Day $currentStreak Completed! Next milestone is $nextMilestone days. Feeling good!",
      "Feeling motivated today! Let's keep going!",
    ];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Add Post'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Choose an example post or write your own:',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  SizedBox(height: 10),
                  // Example Post 1
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedPost = examplePosts[0];
                        controller.text = selectedPost;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color:
                              selectedPost == examplePosts[0]
                                  ? Colors.blue
                                  : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              examplePosts[0],
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          if (selectedPost == examplePosts[0])
                            Icon(Icons.check, color: Colors.blue),
                        ],
                      ),
                    ),
                  ),
                  // Example Post 2
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedPost = examplePosts[1];
                        controller.text = selectedPost;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color:
                              selectedPost == examplePosts[1]
                                  ? Colors.blue
                                  : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              examplePosts[1],
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          if (selectedPost == examplePosts[1])
                            Icon(Icons.check, color: Colors.blue),
                        ],
                      ),
                    ),
                  ),
                  // Custom Post TextField
                  TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: 'Write your custom post here...',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    if (controller.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Post content cannot be empty!'),
                        ),
                      );
                      return;
                    }

                    // Filter post content using Gemini API
                    bool isContentAllowed = await _filterPostContent(
                      controller.text.trim(),
                    );
                    if (!isContentAllowed) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Your post was rejected due to inappropriate content. Please revise and try again.',
                          ),
                        ),
                      );
                      return;
                    }

                    // Proceed with saving the post
                    String todayKey =
                        "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}_communityPosts";
                    bool isPremiumUser =
                        prefs.getBool("isPremiumPurchased") ?? false;

                    if (isPremiumUser) {
                      _addPost(controller.text.trim());
                    } else if (prefs.getInt(todayKey) == null ||
                        (prefs.getInt(todayKey) ?? 0) <= 3) {
                      _addPost(controller.text.trim());
                      prefs.setInt(todayKey, 1);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'You can only post 3 times a day. Upgrade to premium for unlimited posts!',
                          ),
                          duration: Duration(seconds: 3),
                        ),
                      );
                    }

                    Navigator.pop(context);
                  },
                  child: Text('Post'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<bool> _filterPostContent(String content) async {
    final String apiKey =
        "AIzaSyBLK-6gfPj_aVuHUG_iPX-KVkRG1zx5aVE"; // Replace with your API key
    final String geminiApiUrl =
        "https://generativelanguage.googleapis.com/v1beta2/models/text-bison-001:generateText?key=$apiKey"; // Replace with the correct endpoint

    try {
      print("Filtering post content: $content");
      final response = await http.post(
        Uri.parse(geminiApiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "instances": [
            {
              "content": content,
              "parameters": {
                "prompt":
                    "Does the post content make sense? Yes or No. "
                    "Does this content include bad words? Yes or No. "
                    "This is a NoFap app, so does this content demotivate users? Yes or No.",
              },
            },
          ],
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final predictions = jsonResponse['predictions'][0];
        final isMeaningful = predictions['isMeaningful'] == "Yes";
        final hasBadWords = predictions['hasBadWords'] == "No";
        final isMotivational = predictions['isMotivational'] == "Yes";

        print("JSON response from Gemini: $jsonResponse");
        print(
          "isMeaningful: $isMeaningful, hasBadWords: $hasBadWords, isMotivational: $isMotivational",
        );

        // Allow post only if all conditions are met
        return isMeaningful && hasBadWords && isMotivational;
      } else {
        print("Error: ${response.statusCode} - ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error filtering post content: $e");
      return false;
    }
  }
}
