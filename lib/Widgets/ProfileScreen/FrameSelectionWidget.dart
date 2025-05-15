import 'package:flutter/material.dart';
import 'package:FapFree/Theme/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Frameselectionwidget extends StatelessWidget {
  final Function(String) onFrameSelected;

  Frameselectionwidget({required this.onFrameSelected});

  @override
  Widget build(BuildContext context) {
    final List<String> frames = [
      'Assets/Frames/frame1.png',
      'Assets/Frames/frame2.png',
      'Assets/Frames/frame3.png',
      'Assets/Frames/frame4.png',
      'Assets/Frames/frame5.png',
      'Assets/Frames/frame6.png',
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
            itemCount: frames.length,
            itemBuilder: (context, index) {
              String frameKey =
                  'is_unlock_${frames[index].split('/').last.split('.').first}';
              String frameName = frames[index].split('/').last.split('.').first;

              return FutureBuilder<bool>(
                future: SharedPreferences.getInstance().then(
                  (prefs) => prefs.getBool(frameKey) ?? false,
                ),
                builder: (context, snapshot) {
                  bool isUnlocked = snapshot.data ?? false;

                  return GestureDetector(
                    onTap: () {
                      if (isUnlocked) {
                        onFrameSelected(frameName);
                      } else {
                        String message;
                        switch (frameName) {
                          case 'frame1':
                            message =
                                'You can unlock this frame by purchasing the premium version.';
                            break;
                          case 'frame2':
                            message =
                                'You can unlock this frame by Earn 25000 points';
                            break;
                          case 'frame3':
                            message =
                                'You can unlock this frame by Accumulate a total of 1500 points.';
                            break;
                          case 'frame4':
                            message =
                                'You can unlock this frame by purchasing the premium version.';
                            break;
                          case 'frame5':
                            message =
                                'You can unlock this frame by Stay strong for 2 days';
                            break;
                          case 'frame6':
                            message =
                                'You can unlock this frame by purchasing the premium version.';
                            break;
                          default:
                            message =
                                'You can unlock this frame by purchasing the premium version.';
                        }

                        showDialog(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                title: Text('Locked Frame'),
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
                              backgroundImage: AssetImage(frames[index]),
                              radius: 40,
                            )
                            : CircleAvatar(
                              child: Icon(Icons.lock, color: Colors.white),
                              backgroundColor: Colors.grey[300],
                              backgroundImage: AssetImage(frames[index]),
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
