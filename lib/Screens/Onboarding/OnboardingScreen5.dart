import 'package:flutter/material.dart';
import 'package:FapFree/Widgets/CustomButton.dart';

import '../../routes.dart';

class OnboardingScreen5 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Onboarding Screen 5'),
            SizedBox(height: 20),
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
