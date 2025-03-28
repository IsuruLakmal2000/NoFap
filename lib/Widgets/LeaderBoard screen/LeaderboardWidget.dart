import 'package:flutter/material.dart';
import 'package:nofap/Providers/AvatarAndFrameProvider.dart';
import 'package:nofap/theme/colors.dart';
import 'package:nofap/Models/LeaderboardUser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'package:nofap/Providers/AuthProvider.dart' as LocalAuthProvider;

class Leaderboardwidget extends StatelessWidget {
  final List<LeaderboardUser> leaderboardUsers;

  const Leaderboardwidget({Key? key, required this.leaderboardUsers})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      body: ListView.builder(
        itemCount: leaderboardUsers.length,
        itemBuilder: (context, index) {
          final user = leaderboardUsers[index];
          final isCurrentUser = user.userId == currentUserId;

          return Card(
            shadowColor: Colors.transparent,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                          color: index < 3 ? AppColors.red : AppColors.darkGray,
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
                            radius: 20,
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
                            radius: 30,
                            backgroundColor: Colors.transparent, // Frame color
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
              title: Text(
                user.username,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Streak: ${user.currentStreakStartDate.isNotEmpty ? DateTime.now().difference(DateTime.tryParse(user.currentStreakStartDate) ?? DateTime(1970, 1, 1)).inDays : '0'} days',
              ),
            ),
          );
        },
      ),
    );
  }
}
