import 'package:flutter/material.dart';
import 'dart:async';
import 'package:lottie/lottie.dart';
import 'package:FapFree/Widgets/CustomButton.dart';
import 'package:FapFree/theme/colors.dart'; // Import Lottie package

class BreathingExerciseScreen extends StatefulWidget {
  @override
  _BreathingExerciseScreenState createState() =>
      _BreathingExerciseScreenState();
}

class _BreathingExerciseScreenState extends State<BreathingExerciseScreen> {
  int countdown = 60; // Countdown in seconds
  Timer? timer;
  String breathingInstruction = "Get ready to start!";
  String lottieAnimation =
      "Assets/Lottie/heart.json"; // Default Lottie animation
  bool isExerciseRunning = false; // Track if the exercise is running

  void startBreathingExercise() {
    setState(() {
      countdown = 60;
      breathingInstruction = "Inhale deeply...";
      lottieAnimation = "Assets/Lottie/heartbeat.json"; // Set inhale animation
      isExerciseRunning = true; // Hide the button
    });

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (countdown > 0) {
          countdown--;

          // Update breathing instructions and animations based on time
          if (countdown % 6 == 0) {
            breathingInstruction = "Inhale deeply...";
            lottieAnimation = "Assets/Lottie/heartbeat.json";
          } else if (countdown % 6 == 3) {
            breathingInstruction = "Exhale slowly...";
            lottieAnimation = "Assets/Lottie/heartbeat.json";
          }
        } else {
          breathingInstruction = "Well done! Exercise complete.";
          lottieAnimation = "Assets/Lottie/done.json"; // Completion animation
          timer.cancel();
          isExerciseRunning = false; // Show the button again
        }
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Breathing Exercise",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.darkGray2,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.lightGray,
      ),
      body: Center(
        // Wrap with Center widget
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Adjust size to center content
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Follow the breathing instructions below:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              // Lottie animation widget
              Lottie.asset(
                lottieAnimation,
                height: 300,
                width: 300,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 20),
              Text(
                breathingInstruction,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                "Time Remaining: $countdown seconds",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              if (!isExerciseRunning) // Show button only if exercise is not running
                CustomButton(text: "Start", onPressed: startBreathingExercise),
            ],
          ),
        ),
      ),
    );
  }
}
