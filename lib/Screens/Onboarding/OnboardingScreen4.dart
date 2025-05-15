import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:FapFree/Providers/FirebaseSignInAuthProvider.dart';
import 'package:FapFree/Providers/UserProvider.dart';
import 'package:FapFree/Widgets/CustomButton.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:FapFree/theme/colors.dart';
import 'package:FapFree/routes.dart';
import 'package:provider/provider.dart';
import 'package:FapFree/Widgets/CustomInputField.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:FapFree/Services/FirebaseDatabaseService.dart';

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

  bool isLoading = false;
  Future<void> _saveUserData(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final firebaseDatabaseService = FirebaseDatabaseService();

    final userData = await firebaseDatabaseService.getUserDataById(userId);

    if (userData != null) {
      // User already exists, fetch data and save to SharedPreferences
      await prefs.setString('userId', userId);
      await prefs.setBool('isSignedIn', true);
      await prefs.setString('userName', userData['displayUsername'] ?? '');
      await prefs.setString('currentAvatar', userData['avatarId'] ?? 'none');
      await prefs.setString('currentFrame', userData['frameId'] ?? 'none');
      await prefs.setInt('currentPoints', userData['currentPoints'] ?? 0);
      await prefs.setInt('currentStreak', userData['streakDays'] ?? 0);
      await prefs.setBool('isFirstTime', false);
      await prefs.setBool(
        'isPremiumPurchased',
        userData['isPerchasePremium'] ?? false,
      );
      if (userData['streakStartDay'] != null) {
        await prefs.setString('streakStartDate', userData['streakStartDay']);
      }
    } else {
      // User does not exist, save new data
      final username = _nameController.text.trim();
      await prefs.setString('userId', userId);
      await prefs.setBool('isSignedIn', true);
      await prefs.setString('userName', username);
      await userProvider.saveUserData(username, "none", "none", 0, 0, false);
    }
  }

  void _onNextPressed(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return; // Exit if the form is invalid
    }
    setState(() {
      isLoading = true;
    });
    final authProvider = Provider.of<FirebaseSignInAuthProvider>(
      context,
      listen: false,
    );

    await authProvider.signInWithGoogle();

    if (authProvider.user != null) {
      await _saveUserData(authProvider.user!.uid);
      setState(() {
        isLoading = false;
      });
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.home,
        (Route<dynamic> route) => false,
      );
      print("signed in");
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          true, // Ensures the screen adjusts for the keyboard
      body: Stack(
        children: [
          SingleChildScrollView(
            // Makes the content scrollable
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: 0,
                      top: 40,
                      right: 0,
                      bottom: 0,
                    ),
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
                  Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(height: 60),
                        Lottie.asset(
                          "Assets/Lottie/onboard5.json",
                          height: MediaQuery.of(context).size.height * 0.2,
                          width: 300,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(height: 20),
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
                        SizedBox(height: 20),
                        Form(
                          key: _formKey,
                          child: CustomInputField(
                            controller: _nameController,
                            labelText: 'Enter your username',
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Username is required';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 20),
                        CustomButton(
                          text: 'Continue with Google',
                          onPressed: () => _onNextPressed(context),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          isLoading
              ? Center(
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(child: CircularProgressIndicator()),
                ),
              )
              : Container(),
        ],
      ),
    );
  }
}
