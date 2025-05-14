import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:nofap/Models/CommunityPost.dart';
import 'package:nofap/Widgets/CustomAppBar.dart';
import 'package:nofap/Widgets/Community%20screen/PostWidget.dart';
import 'package:nofap/Services/FirebaseDatabaseService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'dart:convert'; // For JSON encoding/decoding

class CommunityScreen extends StatefulWidget {
  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final FirebaseDatabaseService _firebaseService = FirebaseDatabaseService();

  List<CommunityPost> posts = [];
  bool isLoading = true; // Add loading state

  final List<String> inappropriateWords = [
    "fuck",
    "fucked",
    "bitch",
    "nigga",
    "motherfucker",
    "asshole",
    "suck",

    // Add more inappropriate words here
  ];

  bool _containsInappropriateWords(String content) {
    for (String word in inappropriateWords) {
      if (content.toLowerCase().contains(word)) {
        return true;
      }
    }
    return false;
  }

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

      // Sort posts by timestamp in descending order
      loadedPosts.sort(
        (a, b) =>
            DateTime.parse(b.timestamp).compareTo(DateTime.parse(a.timestamp)),
      );

      setState(() {
        posts = loadedPosts;
        isLoading = false; // Set loading to false after posts are loaded
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body:
          isLoading
              ? Center(
                child: CircularProgressIndicator(),
              ) // Show loading indicator
              : ListView.builder(
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
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            String todayKey =
                "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}_communityPosts";
            bool isPremiumUser = prefs.getBool("isPremiumPurchased") ?? false;
            if (isPremiumUser ||
                prefs.getInt(todayKey) == null ||
                (prefs.getInt(todayKey) ?? 0) <= 3) {
              _showAddPostDialog();
            } else {
              _showAddPostDialog();
              // ScaffoldMessenger.of(context).showSnackBar(
              //   SnackBar(
              //     content: Text(
              //       'You can only post 3 times a day. Upgrade to premium for unlimited posts!',
              //     ),
              //     backgroundColor: Colors.red,
              //     duration: Duration(seconds: 3),
              //   ),
              // );
            }
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
    const int maxCharacters = 300; // Set max character limit
    int currentCharacterCount = 0;

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
                        currentCharacterCount = selectedPost.length;
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
                        currentCharacterCount = selectedPost.length;
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
                    maxLength: maxCharacters, // Set max length
                    onChanged: (value) {
                      setState(() {
                        currentCharacterCount = value.length;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Write your custom post here...',
                      border: OutlineInputBorder(),
                      counterText:
                          '$currentCharacterCount/$maxCharacters characters used', // Show character count
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
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    // Check for inappropriate words
                    if (_containsInappropriateWords(controller.text.trim())) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Your post contains inappropriate words. Please revise and try again.',
                          ),
                          backgroundColor: Colors.red,
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
                            'Your post was rejected due to invalid or not related content. Please revise and try again.',
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                    _addPost(controller.text.trim());
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
    final String apiKey = dotenv.env['PITBULL_X'] ?? '';

    final model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: apiKey,
    );

    // Check if the model is initialized

    try {
      final prompt =
          "Analyze the following text and determine if it is suitable for a NoFap community forum. Provide your response as a JSON object.\n\n"
          "Text: '$content'\n\n"
          "Your response should be a JSON object with the following keys and values:\n"
          "- 'isMeaningful': (true/false) -  Is the text coherent and relevant to nofap community?\n"
          // "- 'hasBadWords': (true/false) - Does the text contain profanity or offensive language?\n"
          "Example Response:\n"
          "{\n"
          "  \"isMeaningful\": true,\n"
          // "  \"hasBadWords\": false,\n"
          "}\n"
          "Ensure the JSON response is on a single line, without any extra text before or after the JSON structure."; //Improved prompt

      final response = await model.generateContent([Content.text(prompt)]);

      if (response.text == null) {
        print("Error: Gemini API returned null response text.");
        return false; // Or handle the null case as appropriate for your app
      }

      print("Raw response text: ${response.text}"); // Print the raw response

      // Attempt to decode the response.text
      try {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.text!);

        // Extract values from the JSON response.  Handle nulls.
        final bool isMeaningful = jsonResponse['isMeaningful'] ?? false;
        // final bool hasBadWords =
        //     !(jsonResponse['hasBadWords'] ?? true); // Corrected logic
        // final bool isMotivational = jsonResponse['isMotivational'] ?? false;

        print("isMeaningful: $isMeaningful");

        return isMeaningful;
      } catch (e) {
        print("Error decoding JSON: $e");
        print(
          "Full response: ${response.text}",
        ); // Print full response to debug
        return false; // Handle JSON decoding errors
      }
    } catch (e) {
      print("Error filtering post content: $e");
      return false;
    }
  }
}
