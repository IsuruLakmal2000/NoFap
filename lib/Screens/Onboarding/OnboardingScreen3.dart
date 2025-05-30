import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:FapFree/Theme/colors.dart';
import 'package:FapFree/Widgets/CustomButton.dart';
import 'package:FapFree/routes.dart';

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
                    value: 0.80,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.darkGray,
                    ),
                  ),
                  Text("80%"),
                ],
              ),
            ),
            SizedBox(height: 20),
            Lottie.asset(
              "Assets/Lottie/onboard1.json",
              height: MediaQuery.of(context).size.height * 0.2,
              width: 200,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 10),
            Text(
              'How FapFree Helps You',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: AppColors.darkGray,
              ),
              textAlign: TextAlign.center,
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 10),
                  buildBox("Streak Counter", Icons.track_changes),
                  SizedBox(height: 10),
                  buildBox("Urge Manager", Icons.flag),
                  SizedBox(height: 10),
                  buildBox("Insights", Icons.group),
                  SizedBox(height: 10),
                  buildBox("Access Resources and Tips", Icons.book),
                ],
              ),
            ),
            Spacer(),

            //create scrollable list of 4 boxes .
            // Expanded(
            //   child: GridView.count(
            //     crossAxisCount: 1,
            //     crossAxisSpacing: 10,
            //     mainAxisSpacing: 10,
            //     children: [
            //       buildBox("Streak Counter", Icons.track_changes),
            //       buildBox("Urge Manager", Icons.flag),
            //       buildBox("Insights", Icons.group),
            //       buildBox("Access Resources and Tips", Icons.book),
            //     ],
            //   ),
            // ),
            CustomButton(
              text: 'Next',
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.onboarding5);
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
