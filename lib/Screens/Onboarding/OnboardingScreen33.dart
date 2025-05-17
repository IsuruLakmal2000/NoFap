import 'package:FapFree/Routes.dart';
import 'package:FapFree/Theme/colors.dart';
import 'package:FapFree/Widgets/CustomButton.dart';
import 'package:flutter/material.dart';

class OnboardingScreen33 extends StatelessWidget {
  const OnboardingScreen33({super.key});

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
                    value: 0.6,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.darkGray,
                    ),
                  ),
                  Text("60%"),
                ],
              ),
            ),

            SizedBox(height: 50),
            Text(
              'Understanding the Impact',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: AppColors.darkGray,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 50),

            // i want to add 4 boxes , 2 in each row
            Column(
              children: [
                buildBox(
                  "Decreased Concentration & Focus",
                  Icons.arrow_drop_down_circle_sharp,
                ),
                SizedBox(height: 20),
                buildBox(
                  "Feeling Tired All the Time",
                  Icons.battery_1_bar_outlined,
                ),
                SizedBox(height: 20),
                buildBox("Lower Self-Esteem", Icons.assist_walker_sharp),
                SizedBox(height: 20),
                buildBox(
                  "Relationship Difficulties",
                  Icons.accessibility_new_outlined,
                ),
              ],
            ),
            //add text
            // Text(
            //   'Your brain is a complex organ that can be trained to resist urges and cravings.',
            //   style: TextStyle(fontSize: 18, color: AppColors.darkGray),
            //   textAlign: TextAlign.center,
            // ),
            Spacer(),
            CustomButton(
              text: 'Next',
              onPressed: () {
                // Navigate to the home screen
                Navigator.pushNamed(context, AppRoutes.onboarding4);
              },
            ),
          ],
        ),
      ),
    );
  }

  //add reusable widget for the boxes
  Widget buildBox(String text, IconData icon) {
    return Container(
      height: 80,
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
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              //  backgroundColor: AppColors.darkGray,
              child: Icon(icon, color: Colors.redAccent),
            ),
            SizedBox(width: 10),
            Flexible(
              child: Text(
                text,
                style: TextStyle(fontSize: 18, color: AppColors.darkGray),
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
