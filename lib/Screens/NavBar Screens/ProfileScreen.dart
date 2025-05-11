import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nofap/Providers/AvatarAndFrameProvider.dart';
import 'package:nofap/Providers/FirebaseSignInAuthProvider.dart';
import 'package:nofap/Screens/Onboarding/OnboardingScreen1.dart';
import 'package:nofap/Screens/Premium/Premium.dart';
import 'package:nofap/Services/FirebaseDatabaseService.dart';
import 'package:nofap/Theme/colors.dart' show AppColors;
import 'package:nofap/Providers/AuthProvider.dart' as LocalAuthProvider;
import 'package:nofap/Widgets/ProfileScreen/AvatarSelectionWidget.dart';
import 'package:nofap/Widgets/ProfileScreen/FrameSelectionWidget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? username;

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? 'Guest';
    });
  }

  Future<void> _updateUsername(String newUsername) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(child: CircularProgressIndicator());
      },
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', newUsername);
    setState(() {
      username = newUsername;
    });

    // Directly create an instance of FirebaseDatabaseService
    final firebaseService = FirebaseDatabaseService();
    try {
      await firebaseService.updateUserName(newUsername);
    } catch (e) {
      print("Error updating username in Firebase: $e");
    }

    Navigator.pop(context); // Close the progress indicator dialog
  }

  void _showEditUsernameDialog() {
    final TextEditingController usernameController = TextEditingController(
      text: username,
    );
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Username'),
          content: TextField(
            controller: usernameController,
            decoration: InputDecoration(hintText: 'Enter new username'),
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
                final newUsername = usernameController.text.trim();
                if (newUsername.isNotEmpty) {
                  await _updateUsername(newUsername);
                }
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

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
                                    : AssetImage("Assets/Avatars/none.jpg"),
                            child:
                                avatarProvider.currentAvatar == null
                                    ? Icon(
                                      Icons.person, // Dummy icon for avatar
                                      color: AppColors.darkGray,
                                    )
                                    : null,
                          ),
                          CircleAvatar(
                            radius: 55,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        username ?? 'Loading...', // Display username from prefs
                        style: TextStyle(
                          fontSize: 26,
                          color: AppColors.darkGray,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
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
                              fontSize: 16,
                            ),
                          ),
                          Icon(
                            Icons.star_outlined,
                            size: 22,
                            color: AppColors.yellow,
                          ),
                        ],
                      );
                    },
                  ),
                  // ElevatedButton(
                  //   onPressed: () async {
                  //     final prefs = await SharedPreferences.getInstance();

                  //     await prefs.remove('currentStreak');
                  //     await prefs.remove('streakStartDate');
                  //     await prefs.remove('isFirstTime');
                  //     await FirebaseAuth.instance.signOut();
                  //     Navigator.pushReplacement(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) => OnboardingScreen1(),
                  //       ),
                  //     );
                  //   },
                  //   child: Text('Log Out'),
                  // ),
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
                onTap: () {
                  MaterialPageRoute route = MaterialPageRoute(
                    builder: (context) => Premium(),
                  );
                  Navigator.push(context, route);
                },
                child: ListTile(
                  title: Text(
                    "Purchase Premium Version",
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
            title: 'Change Profile Name',
            onTap: () {
              _showEditUsernameDialog();
            },
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
                        print("av sel=" + avatar);
                        Provider.of<AvatarAndFrameProvider>(
                          context,
                          listen: false,
                        ).updateAvatar(avatar); // Triggers Firebase update
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
                      onFrameSelected: (String frame) {
                        print("frame sel=" + frame);
                        Provider.of<AvatarAndFrameProvider>(
                          context,
                          listen: false,
                        ).updateFrame(frame); // Triggers Firebase update
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
