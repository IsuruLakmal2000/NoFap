import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nofap/Providers/AvatarAndFrameProvider.dart';
import 'package:nofap/Providers/FirebaseSignInAuthProvider.dart';
import 'package:nofap/Screens/Onboarding/OnboardingScreen1.dart';
import 'package:nofap/Theme/colors.dart' show AppColors;
import 'package:nofap/Providers/AuthProvider.dart' as LocalAuthProvider;
import 'package:nofap/Widgets/ProfileScreen/AvatarSelectionWidget.dart';
import 'package:nofap/Widgets/ProfileScreen/FrameSelectionWidget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        flexibleSpace: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(70),
            bottomRight: Radius.circular(70),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromARGB(255, 255, 255, 255),
                  const Color.fromARGB(255, 245, 245, 245),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),
        toolbarHeight:
            MediaQuery.of(context).size.height * 0.25, // Dynamic height
        title: Consumer<FirebaseSignInAuthProvider>(
          builder: (context, authProvider, child) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min, // Prevent overflow
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Consumer<AvatarAndFrameProvider>(
                    builder: (context, avatarProvider, child) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: AppColors.lightGray,
                            backgroundImage:
                                avatarProvider.currentAvatar != null
                                    ? AssetImage(
                                      "Assets/Avatars/${avatarProvider.currentAvatar}.jpg",
                                    )
                                    : null,
                            child:
                                avatarProvider.currentAvatar == null
                                    ? Icon(
                                      Icons.person, // Dummy icon for avatar
                                      color: AppColors.darkGray,
                                    )
                                    : null,
                          ),
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.transparent,
                            backgroundImage:
                                avatarProvider.currentAvatar != null
                                    ? AssetImage(
                                      "Assets/Frames/${avatarProvider.currentFrame}.png",
                                    )
                                    : null,
                            // backgroundColor: AppColors.darkGray, // Frame color
                          ),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: 5),
                  Text(
                    '${authProvider.user?.displayName ?? 'Guest'}',
                    style: TextStyle(
                      fontSize: 20,
                      color: AppColors.darkGray,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Consumer<LocalAuthProvider.AuthProvider>(
                    builder: (context, authProvider, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${authProvider.currentUserPoints}",
                            style: TextStyle(
                              color: AppColors.darkGray,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Icon(
                            Icons.star_outlined,
                            size: 20,
                            color: AppColors.yellow,
                          ),
                        ],
                      );
                    },
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();

                      await prefs.remove('currentStreak');
                      await prefs.remove('streakStartDate');
                      await prefs.remove('isFirstTime');
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OnboardingScreen1(),
                        ),
                      );
                    },
                    child: Text('Log Out'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color.fromARGB(255, 253, 145, 3),
                    const Color.fromARGB(255, 252, 206, 2),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: InkWell(
                splashColor: AppColors.mediumGray.withOpacity(0.2),
                highlightColor: AppColors.mediumGray.withOpacity(0.1),
                onTap: () {},
                child: ListTile(
                  title: Text(
                    "Premium",
                    style: TextStyle(
                      color: AppColors.darkGray,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.darkGray,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          _buildProfileOption(
            title: 'Change Profile Avatar',
            onTap: () {
              showModalBottomSheet(
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder:
                    (context) => AvatarSelectionSheet(
                      onAvatarSelected: (String avatar) {
                        Provider.of<AvatarAndFrameProvider>(
                          context,
                          listen: false,
                        ).updateAvatar(avatar);
                        Navigator.pop(context);
                      },
                    ),
              );
            },
          ),
          SizedBox(height: 10),
          _buildProfileOption(
            title: 'Change Profile Frame',
            onTap: () {
              showModalBottomSheet(
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder:
                    (context) => Frameselectionwidget(
                      onFrameSelected: (String avatar) {
                        Provider.of<AvatarAndFrameProvider>(
                          context,
                          listen: false,
                        ).updateFrame(avatar);
                        Navigator.pop(context);
                      },
                    ),
              );
            },
          ),
          SizedBox(height: 10),
          _buildProfileOption(
            title: 'Notification Setting',
            onTap: () {
              // Navigate to Notification Setting screen
            },
          ),
          SizedBox(height: 10),
          Divider(color: AppColors.mediumGray),
          SizedBox(height: 10),
          _buildProfileOption(
            title: 'Help & Support',
            leadingIcon: Icons.help_outline,
            onTap: () {
              // Navigate to Help & Support screen
            },
          ),
          SizedBox(height: 10),
          _buildProfileOption(
            title: 'Rate Us',
            leadingIcon: Icons.star,
            onTap: () {
              // Navigate to Help & Support screen
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption({
    required String title,
    IconData? leadingIcon,
    required VoidCallback onTap,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Material(
        color: AppColors.lightGray,
        child: InkWell(
          splashColor: AppColors.mediumGray.withOpacity(0.2),
          highlightColor: AppColors.mediumGray.withOpacity(0.1),
          onTap: onTap,
          child: ListTile(
            leading:
                leadingIcon != null
                    ? Icon(leadingIcon, color: AppColors.darkGray)
                    : null,
            title: Text(
              title,
              style: TextStyle(
                color: AppColors.darkGray2,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: AppColors.darkGray,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
