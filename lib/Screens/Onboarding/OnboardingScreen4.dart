import 'package:flutter/material.dart';
import 'package:nofap/Widgets/CustomButton.dart';

import 'package:nofap/theme/colors.dart';
import 'package:nofap/routes.dart';

class OnboardingScreen4 extends StatefulWidget {
  const OnboardingScreen4({super.key});

  @override
  _OnboardingScreen4State createState() => _OnboardingScreen4State();
}

class _OnboardingScreen4State extends State<OnboardingScreen4> {
  final TextEditingController _nameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _onNextPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      String userName = _nameController.text;
      // Use the userName variable as needed
      Navigator.pushNamed(context, AppRoutes.home, arguments: userName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 0, top: 40, right: 0, bottom: 0),
                child: Column(
                  children: [
                    LinearProgressIndicator(
                      value: 1,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.darkGray,
                      ),
                    ),
                    Text("100%"),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Spacer(),
              Column(
                children: [
                  Text(
                    'Join Us',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkGray,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Log in with Google to start your journey.',
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
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Enter your name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'You should need to enter name';
                      }
                      return null;
                    },
                  ),
                ],
              ),
              Spacer(),
              CustomButton(
                text: 'Continue with google',
                onPressed: _onNextPressed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
