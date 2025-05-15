import 'package:FapFree/Services/IAPService.dart';
import 'package:flutter/material.dart';
import 'package:FapFree/Providers/AvatarAndFrameProvider.dart';
import 'package:FapFree/Providers/FirebaseSignInAuthProvider.dart';
import 'package:FapFree/Screens/Premium/Premium.dart';
import 'package:FapFree/Screens/PrivacyPolicyScreen.dart';
import 'package:FapFree/Services/FirebaseDatabaseService.dart';
import 'package:FapFree/Theme/colors.dart' show AppColors;
import 'package:FapFree/Providers/AuthProvider.dart' as LocalAuthProvider;
import 'package:FapFree/Widgets/ProfileScreen/AvatarSelectionWidget.dart';
import 'package:FapFree/Widgets/ProfileScreen/FrameSelectionWidget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? username;
  bool isPremiumPurchased = false;
  int currentStreak = 0;

  @override
  void initState() {
    super.initState();
    _loadUsername();
    fetchProducts();
  }

  void fetchProducts() async {
    final iapService = IAPService();
    final products = await iapService.queryAllProducts();
    for (final product in products) {
      print('Product: ${product.title}, Price: ${product.price}');
    }
  }

  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('userName') ?? 'Guest';
      isPremiumPurchased = prefs.getBool('isPremiumPurchased') ?? false;
      String? startDateString = prefs.getString('streakStartDate');
      if (startDateString != null) {
        DateTime startDate = DateTime.parse(startDateString);
        currentStreak = DateTime.now().difference(startDate).inDays;
      }
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
              gradient: RadialGradient(
                colors: [
                  const Color.fromARGB(255, 255, 231, 195),
                  const Color.fromARGB(255, 255, 255, 255),
                ],
                center: Alignment.center,
                radius: 1.0,
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
                                avatarProvider.currentFrame != "none"
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
                      isPremiumPurchased
                          ? Icon(Icons.verified, color: Colors.blue, size: 20)
                          : SizedBox.shrink(),
                    ],
                  ),
                  SizedBox(height: 5),

                  Consumer<LocalAuthProvider.AuthProvider>(
                    builder: (context, authProvider, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.local_fire_department,
                                size: 20,
                                color: AppColors.red,
                              ),
                              Text(
                                '${currentStreak} days',
                                style: TextStyle(
                                  color: AppColors.darkGray,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            isPremiumPurchased ? "Premium user" : "Free user",
                            style: TextStyle(
                              color:
                                  isPremiumPurchased
                                      ? const Color.fromARGB(255, 255, 153, 1)
                                      : AppColors.darkGray2,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Row(
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
                  title:
                      isPremiumPurchased
                          ? Row(
                            children: [
                              Text(
                                "You are a Premium User",
                                style: TextStyle(
                                  color: AppColors.darkGray,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(width: 10),
                              Icon(
                                Icons.verified,
                                color: Colors.blue,
                                size: 20,
                              ),
                            ],
                          )
                          : Text(
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
          _buildProfileOption(
            title: 'Disable Ads',
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              bool hasDisabledAds = prefs.getBool('hasDisabledAds') ?? false;
              showDialog(
                context: context,
                builder: (context) {
                  bool switchValue = hasDisabledAds;
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return AlertDialog(
                        title: Text(
                          'Disable Ads',
                          style: TextStyle(
                            color: AppColors.darkGray,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: AppColors.darkGray,
                                ), // Default style for the entire text
                                children: <TextSpan>[
                                  const TextSpan(
                                    text:
                                        'You can turn off ads for free!\n\n'
                                        'If you enjoy using this app, please consider supporting us by ',
                                  ),
                                  TextSpan(
                                    text: 'purchasing Premium',
                                    style: TextStyle(
                                      color:
                                          Colors
                                              .blue, // Change this color as needed
                                      fontWeight:
                                          FontWeight
                                              .bold, // You can also add other style properties
                                    ),
                                  ),
                                  const TextSpan(
                                    text:
                                        '. Your support is highly appreciated.',
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Disable Ads'),
                                Switch(
                                  value: switchValue,
                                  onChanged: (value) async {
                                    setState(() {
                                      switchValue = value;
                                    });
                                    await prefs.setBool(
                                      'hasDisabledAds',
                                      value,
                                    );
                                    if (value) {
                                      // Show a message or perform an action
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Ads disabled successfully!',
                                          ),
                                        ),
                                      );
                                      Navigator.pop(context);
                                      MaterialPageRoute route =
                                          MaterialPageRoute(
                                            builder: (context) => Premium(),
                                          );

                                      Navigator.push(context, route);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Close'),
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
          ),

          SizedBox(height: 10),
          Divider(color: AppColors.mediumGray),
          SizedBox(height: 10),
          _buildProfileOption(
            title: 'Privacy Policy',
            leadingIcon: Icons.privacy_tip_outlined,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PrivacyPolicyScreen()),
              );
            },
          ),
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
