import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:FapFree/Services/FirebaseDatabaseService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetStreakDialog extends StatefulWidget {
  final int initialStreak;
  final Function(int) onSave;

  const SetStreakDialog({
    required this.initialStreak,
    required this.onSave,
    Key? key,
  }) : super(key: key);

  @override
  _SetStreakDialogState createState() => _SetStreakDialogState();
}

class _SetStreakDialogState extends State<SetStreakDialog> {
  late int streakDays;
  bool isLoading = false; // Add loading state

  @override
  void initState() {
    super.initState();
    streakDays = widget.initialStreak; // Set initial value
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AlertDialog(
          title: Text("Set Your Current Streak"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isLoading) ...[
                Text("Drag the slider to set your current streak days."),
                Slider(
                  value: streakDays.toDouble(),
                  min: 0,
                  max: 30, // Allow up to 1 year of streak days
                  divisions: 30,
                  label: "$streakDays Days",
                  onChanged: (value) {
                    setState(() {
                      streakDays = value.toInt();
                    });
                  },
                ),
                Text("Streak Days: $streakDays"),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed:
                  isLoading
                      ? null // Disable button while loading
                      : () async {
                        setState(() {
                          isLoading = true; // Start loading
                        });
                        try {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          DateTime now = DateTime.now();

                          // Save streak data
                          await prefs.setBool('isFirstTime', false);
                          await prefs.setInt('currentStreak', streakDays);
                          await prefs.setString(
                            'streakStartDate',
                            now
                                .subtract(Duration(days: streakDays))
                                .toIso8601String(),
                          );
                          await FirebaseDatabaseService()
                              .updateCurrentStreaStartDay(
                                now
                                    .subtract(Duration(days: streakDays))
                                    .toIso8601String(),
                              );
                          widget.onSave(streakDays);
                          Navigator.of(context).pop();
                        } catch (e) {
                          print("Error saving streak data: $e");
                        } finally {
                          setState(() {
                            isLoading = false; // Stop loading
                          });
                        }
                      },
              child: Text("Save"),
            ),
          ],
        ),
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.5), // Semi-transparent overlay
            child: Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}
