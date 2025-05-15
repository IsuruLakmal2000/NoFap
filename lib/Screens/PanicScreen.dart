import 'package:flutter/material.dart';
import 'package:FapFree/Screens/PanicActivities/JournalingScreen.dart';
import 'package:FapFree/Screens/PanicActivities/MeditationScreen.dart';
import 'package:FapFree/Screens/PanicActivities/MusicScreen.dart';
import 'package:FapFree/Screens/PanicActivities/StretchingScreen.dart';
import 'package:FapFree/Theme/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'PanicActivities/BreathingExerciseScreen.dart'; // Import the new widget

class PanicScreen extends StatelessWidget {
  final List<Map<String, String>> activities = [
    {
      "title": "Meditation",
      "description": "Relax your mind.",
      "premium": "false",
    },
    {
      "title": "Breathing Exercise",
      "description": "Focus on your breath.",
      "premium": "false",
    },
    {
      "title": "Stretching",
      "description": "Loosen up your body.",
      "premium": "true",
    },
    {
      "title": "Journaling",
      "description": "Write your thoughts.",
      "premium": "false",
    },
    {
      "title": "Listen to Music",
      "description": "Calm your soul.",
      "premium": "false",
    },
  ];

  Future<bool> isPremiumUnlocked() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isPremium') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        toolbarHeight: MediaQuery.of(context).size.height * 0.12,
        title: Text("Panic Mode"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 209, 64, 56),
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<bool>(
        future: isPremiumUnlocked(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final isPremium = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: activities.length,
              itemBuilder: (context, index) {
                final activity = activities[index];
                final isLocked = activity["premium"] == "true" && !isPremium;
                return Container(
                  decoration: BoxDecoration(
                    color: AppColors.lightGray,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            activity["title"]!,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkGray,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 10),
                          Text(
                            activity["description"]!,
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.darkGray2,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          if (!isLocked)
                            SizedBox(
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 16,
                                  right: 16,
                                ),
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (activity["title"] ==
                                        "Breathing Exercise") {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) =>
                                                  BreathingExerciseScreen(),
                                        ),
                                      );
                                    } else if (activity["title"] ==
                                        "Meditation") {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => MeditationScreen(),
                                        ),
                                      );
                                    } else if (activity["title"] ==
                                        "Stretching") {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => StretchingScreen(),
                                        ),
                                      );
                                    } else if (activity["title"] ==
                                        "Journaling") {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => JournalingScreen(),
                                        ),
                                      );
                                    } else if (activity["title"] ==
                                        "Listen to Music") {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MusicScreen(),
                                        ),
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.darkGray,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                  ),
                                  child: Text("Start"),
                                ),
                              ),
                            ),
                        ],
                      ),
                      if (isLocked)
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Icon(
                              Icons.lock,
                              size: 20,
                              color: AppColors.darkGray2,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
