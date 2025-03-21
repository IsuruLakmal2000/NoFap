import 'package:flutter/material.dart';
import 'package:nofap/Theme/colors.dart';
import 'package:nofap/Widgets/CustomButton.dart';
import 'package:nofap/routes.dart';

class OnboardingScreen1 extends StatelessWidget {
  const OnboardingScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 0, top: 40, right: 0, bottom: 0),
              child: Column(
                children: [
                  LinearProgressIndicator(
                    value: 0.25,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.darkGray,
                    ),
                  ),
                  Text("25%"),
                ],
              ),
            ),
            SizedBox(height: 20),

            Image.asset('Assets/skating.png', height: 400),
            SizedBox(height: 20),
            Text(
              'Welcome to NoFap',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.darkGray,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              'The journey of a thousand miles begins with a single step.',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.mediumGray,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              'Take the first step towards a better you.',
              style: TextStyle(fontSize: 14, color: AppColors.mediumGray),
              textAlign: TextAlign.center,
            ),
            Spacer(),
            CustomButton(
              text: 'Next',
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.onboarding2);
              },
            ),
          ],
        ),
      ),
    );
  }
}
