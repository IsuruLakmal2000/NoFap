import 'package:flutter/material.dart';

class Finalonboarding extends StatelessWidget {
  const Finalonboarding({super.key});

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
                    value: 1.0,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                  Text("100%"),
                ],
              ),
            ),
            SizedBox(height: 50),
            Text(
              'Congratulations! You\'ve Completed the Onboarding',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                // Navigate to the home screen
                Navigator.pushNamed(context, '/home');
              },
              child: Text('Go to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
