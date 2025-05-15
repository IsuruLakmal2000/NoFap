import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:FapFree/Widgets/CustomButton.dart';
import 'package:FapFree/theme/colors.dart';

class StretchingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Stretching",
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
                "Follow the stretching instructions below:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Lottie.asset(
                "Assets/Lottie/stretching.json",
                height: 300,
                width: 300,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 20),
              Text(
                "Perform gentle stretches to loosen up your body and relax your muscles.",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              CustomButton(
                text: "Start Stretching",
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
