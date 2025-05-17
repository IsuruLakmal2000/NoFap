import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:FapFree/Theme/colors.dart';
import 'package:FapFree/Widgets/CustomButton.dart';
import 'package:FapFree/routes.dart';

class OnboardingScreen22 extends StatelessWidget {
  const OnboardingScreen22({super.key});
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
                    value: 0.4,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.darkGray,
                    ),
                  ),
                  Text("40%"),
                ],
              ),
            ),
            SizedBox(height: 50),
            Text(
              'Understanding Your Brain\'s Patterns',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: AppColors.darkGray,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 50),
            Stack(
              //add background box'
              alignment: Alignment.center,
              children: [
                //add background box
                Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    // add gradient color
                    gradient: LinearGradient(
                      colors: [
                        const Color.fromARGB(255, 247, 247, 247),
                        const Color.fromARGB(255, 253, 245, 245),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                Positioned(
                  top: 50,
                  left: 0,
                  right: 0,
                  child: Lottie.asset(
                    "Assets/Lottie/brain.json",
                    height: MediaQuery.of(context).size.height * 0.12,
                    width: 10,
                    fit: BoxFit.contain,
                  ),
                ),
                Positioned(
                  top: 20,
                  left: 0,
                  right: 0,

                  child: Image.asset(
                    "Assets/habbitcycle.png",
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: 100,
                    fit: BoxFit.contain,
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
                //add text on bottom of the box.
                Positioned(
                  bottom: 40,
                  left: 0,
                  right: 0,
                  child: Text(
                    'Breaking the cycle isn\'t about willpower alone—it\'s about understanding and redirecting your brain\'s reward system.',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),

            SizedBox(height: 50),

            Spacer(),

            CustomButton(
              text: 'Next',
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.onboarding3);
              },
            ),
          ],
        ),
      ),
    );
  }
}
