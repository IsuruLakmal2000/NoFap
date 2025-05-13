import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nofap/Theme/colors.dart';
import 'package:nofap/Widgets/CustomButton.dart';
import 'package:nofap/routes.dart';

class OnboardingScreen3 extends StatelessWidget {
  const OnboardingScreen3({super.key});

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
                    value: 0.75,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.darkGray,
                    ),
                  ),
                  Text("75%"),
                ],
              ),
            ),
            Lottie.asset(
              "Assets/Lottie/onboard1.json",
              height: MediaQuery.of(context).size.height * 0.4,
              width: 300,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 10),
            Text(
              'Our Solution',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: AppColors.darkGray,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            Text(
              'Our solution provides structured support through a vibrant community, where members uplift each other daily. You\'ll receive motivating tips and guidance tailored to your journey, along with tools to track your progress and celebrate your milestones. Together, we can create lasting change and foster personal growth.',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.mediumGray,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Spacer(),

            CustomButton(
              text: 'Next',
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.onboarding4);
              },
            ),
          ],
        ),
      ),
    );
  }
}
