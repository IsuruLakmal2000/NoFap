import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:FapFree/Theme/colors.dart';
import 'package:FapFree/Widgets/CustomButton.dart';
import 'package:FapFree/routes.dart';

class OnboardingScreen2 extends StatelessWidget {
  const OnboardingScreen2({super.key});

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
                    value: 0.5,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.darkGray,
                    ),
                  ),
                  Text("50%"),
                ],
              ),
            ),
            SizedBox(height: 50),
            Lottie.asset(
              "Assets/Lottie/onboard4.json",
              height: MediaQuery.of(context).size.height * 0.3,
              width: 300,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 20),
            Text(
              'The Challenge We Face',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: AppColors.darkGray,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Row(
                  children: [
                    // Icon(
                    //   Icons.align_vertical_bottom_rounded,
                    //   size: 36,
                    //   color: AppColors.darkGray2,
                    // ),
                    SizedBox(width: 8),
                    Expanded(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Over ',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.darkGray2,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: '70% of people',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: ' report struggling with self-control.',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.darkGray2,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    // Icon(Icons.hail, size: 36, color: AppColors.darkGray2),
                    SizedBox(width: 8),
                    Expanded(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Excessive habits can lead to ',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.darkGray2,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: 'anxiety and depression.',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    // Icon(
                    //   Icons.monitor_heart_rounded,
                    //   size: 36,
                    //   color: AppColors.darkGray2,
                    // ),
                    SizedBox(width: 10),
                    Expanded(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Breaking free from these habits can ',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.darkGray2,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: 'boost your confidence and self-esteem.',
                              style: TextStyle(
                                fontSize: 20,
                                color: const Color.fromARGB(255, 34, 179, 58),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
