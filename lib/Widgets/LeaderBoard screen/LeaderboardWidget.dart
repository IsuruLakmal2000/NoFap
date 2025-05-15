import 'package:flutter/material.dart';
import 'package:FapFree/Providers/AvatarAndFrameProvider.dart';
import 'package:FapFree/theme/colors.dart';
import 'package:FapFree/Models/LeaderboardUser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'package:FapFree/Providers/AuthProvider.dart' as LocalAuthProvider;

class Leaderboardwidget extends StatefulWidget {
  final List<LeaderboardUser> leaderboardUsers;

  const Leaderboardwidget({Key? key, required this.leaderboardUsers})
    : super(key: key);

  @override
  _LeaderboardwidgetState createState() => _LeaderboardwidgetState();
}

class _LeaderboardwidgetState extends State<Leaderboardwidget> {
  bool isLoading = true; // Add loading state

  @override
  void initState() {
    super.initState();
    _loadLeaderboardData();
  }

  Future<void> _loadLeaderboardData() async {
    // Simulate a delay or fetch data logic
    await Future.delayed(
      Duration(seconds: 2),
    ); // Replace with actual data fetch
    setState(() {
      isLoading = false; // Set loading to false after data is loaded
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      body:
          isLoading
              ? Center(
                child: CircularProgressIndicator(),
              ) // Show loading indicator
              : ListView.builder(
                itemCount: widget.leaderboardUsers.length,
                itemBuilder: (context, index) {
                  final user = widget.leaderboardUsers[index];
                  final isCurrentUser = user.userId == currentUserId;

                  return Card(
                    shadowColor: Colors.transparent,
                    margin: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    color:
                        isCurrentUser
                            ? const Color.fromARGB(255, 255, 238, 186)
                            : AppColors.lightGray, // Highlight current user
                    child: ListTile(
                      trailing: SizedBox(
                        width: 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Consumer<LocalAuthProvider.AuthProvider>(
                              builder: (context, authProvider, child) {
                                return Text(
                                  isCurrentUser
                                      ? "${authProvider.currentUserPoints}"
                                      : "${user.currentPoints}",
                                  style: TextStyle(
                                    color: AppColors.darkGray,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                );
                              },
                            ),

                            Icon(
                              Icons.star_outlined,
                              size: 24,
                              color: AppColors.yellow,
                            ),
                          ],
                        ),
                      ),
                      leading: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 0,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Center(
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color:
                                      index < 3
                                          ? AppColors.red
                                          : AppColors.darkGray,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Consumer<AvatarAndFrameProvider>(
                            builder: (context, avatarProvider, child) {
                              return Stack(
                                alignment: Alignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 25,
                                    backgroundColor: AppColors.lightGray,
                                    backgroundImage:
                                        isCurrentUser
                                            ? AssetImage(
                                              "Assets/Avatars/${avatarProvider.currentAvatar}.jpg",
                                            )
                                            : AssetImage(
                                              "Assets/Avatars/${user.avatarId}.jpg",
                                            ),
                                  ),
                                  CircleAvatar(
                                    radius: 33,
                                    backgroundColor:
                                        Colors.transparent, // Frame color
                                    backgroundImage:
                                        isCurrentUser
                                            ? AssetImage(
                                              "Assets/Frames/${avatarProvider.currentFrame}.png",
                                            )
                                            : AssetImage(
                                              "Assets/Frames/${user.frameId}.png",
                                            ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                      dense: false,
                      title: Row(
                        children: [
                          Text(
                            user.username,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (user.isPerchasePremium)
                            Icon(
                              Icons.verified,
                              size: 16,
                              color: AppColors.blue,
                            ),
                        ],
                      ),
                      subtitle: Row(
                        children: [
                          Icon(
                            Icons.local_fire_department,
                            size: 16,
                            color: AppColors.red,
                          ),
                          Text(
                            '${user.currentStreakStartDate.isNotEmpty ? DateTime.now().difference(DateTime.tryParse(user.currentStreakStartDate) ?? DateTime(1970, 1, 1)).inDays : '0'} days',
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
