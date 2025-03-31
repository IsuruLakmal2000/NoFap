import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nofap/Widgets/CustomButton.dart';
import 'package:nofap/theme/colors.dart';

class JournalingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Journaling",
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
                "Follow the journaling instructions below:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Lottie.asset(
                "Assets/Lottie/journaling.json",
                height: 300,
                width: 300,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 20),
              Text(
                "Write down your thoughts and feelings. Reflect on your day.",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.brown.shade700,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              CustomButton(
                text: "Start Journaling",
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
