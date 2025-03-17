import 'package:flutter/material.dart';
import 'package:nofap/Theme/colors.dart';
import 'package:nofap/Widgets/CustomButton.dart';
import 'package:nofap/routes.dart';

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
            Image.asset('Assets/sit.png', height: 400),
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
                    Icon(
                      Icons.align_vertical_bottom_rounded,
                      size: 36,
                      color: AppColors.darkGray2,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: RichText(
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
                    Icon(Icons.hail, size: 36, color: AppColors.darkGray2),
                    SizedBox(width: 8),
                    Expanded(
                      child: RichText(
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
                    Icon(
                      Icons.monitor_heart_rounded,
                      size: 36,
                      color: AppColors.darkGray2,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Research shows that breaking free can',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.darkGray2,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: ' improve mental clarity and focus.',
                              style: TextStyle(
                                fontSize: 16,
                                color: const Color.fromARGB(255, 27, 169, 54),
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
