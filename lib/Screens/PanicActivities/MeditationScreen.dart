import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:FapFree/Widgets/CustomButton.dart';
import 'package:FapFree/theme/colors.dart';

class MeditationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Meditation",
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Follow the meditation instructions below:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Lottie.asset(
                "Assets/Lottie/meditation.json",
                height: 300,
                width: 300,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 20),
              Text(
                "Close your eyes and focus on your breath. Let go of all distractions.",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.blue.shade900,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              CustomButton(
                text: "Start Meditation",
                onPressed: () {
                  // Add functionality if needed
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
