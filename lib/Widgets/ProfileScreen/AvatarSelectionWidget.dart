import 'package:flutter/material.dart';
import 'package:FapFree/Theme/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AvatarSelectionSheet extends StatelessWidget {
  final Function(String) onAvatarSelected;

  AvatarSelectionSheet({required this.onAvatarSelected});

  @override
  Widget build(BuildContext context) {
    final List<String> avatars = [
      'Assets/Avatars/avatar1.jpg',
      'Assets/Avatars/avatar2.jpg',
      'Assets/Avatars/avatar3.jpg',
      'Assets/Avatars/avatar4.jpg',
      'Assets/Avatars/avatar5.jpg',
      'Assets/Avatars/avatar6.jpg',
      'Assets/Avatars/avatar7.jpg',
    ];

    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Select an Avatar',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.darkGray,
            ),
          ),
          SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 20,
            ),
            itemCount: avatars.length,
            itemBuilder: (context, index) {
              String avatarKey =
                  'is_unlock_${avatars[index].split('/').last.split('.').first}';
              String avatarName =
                  avatars[index].split('/').last.split('.').first;

              return FutureBuilder<bool>(
                future: SharedPreferences.getInstance().then(
                  (prefs) => prefs.getBool(avatarKey) ?? false,
                ),
                builder: (context, snapshot) {
                  bool isUnlocked = snapshot.data ?? false;

                  return GestureDetector(
                    onTap: () {
                      if (isUnlocked) {
                        onAvatarSelected(avatarName);
                      } else {
                        String message;
                        switch (avatarName) {
                          case 'avatar1':
                            message =
                                'You can unlock this avatar by complete task, Stay strong for 1 day.';
                            break;
                          case 'avatar2':
                            message =
                                'You can unlock this avatar by complete task, Stay strong for 1 hour.';
                            break;
                          case 'avatar3':
                            message =
                                'Avatar is locked. You can unlock this by purchasing premium version';
                            break;
                          case 'avatar4':
                            message =
                                'Avatar is locked. You can unlock this by purchasing premium version.';
                            break;
                          case 'avatar5':
                            message =
                                'You can unlock this avatar by Earn 15000 points.';
                            break;
                          case 'avatar6':
                            message =
                                'Avatar is locked. You can unlock this avatar by reaction to 120 times.';
                            break;
                          case 'avatar7':
                            message =
                                'Avatar is locked. You can unlock this by purchasing premium version.';
                            break;
                          default:
                            message = 'This avatar is locked.';
                        }

                        showDialog(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                title: Text('Locked Avatar'),
                                content: Text(message),
                                actions: [
                                  TextButton(
                                    onPressed:
                                        () => Navigator.of(context).pop(),
                                    child: Text('OK'),
                                  ),
                                ],
                              ),
                        );
                      }
                    },
                    child:
                        isUnlocked
                            ? CircleAvatar(
                              backgroundImage: AssetImage(avatars[index]),
                              radius: 40,
                            )
                            : CircleAvatar(
                              child: Icon(Icons.lock, color: Colors.white),
                              backgroundColor: Colors.grey[300],
                              backgroundImage: AssetImage(avatars[index]),
                              radius: 40,
                            ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
