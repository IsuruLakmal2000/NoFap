import 'package:flutter/material.dart';
import 'package:nofap/Screens/HomePage.dart';
import 'package:nofap/Screens/Onboarding/OnboardingScreen1.dart';
import 'package:nofap/Screens/Onboarding/OnboardingScreen2.dart';
import 'package:nofap/Screens/Onboarding/OnboardingScreen3.dart';
import 'package:nofap/Screens/Onboarding/OnboardingScreen4.dart';
import 'package:nofap/Screens/Onboarding/OnboardingScreen5.dart';

class AppRoutes {
  static const String onboarding1 = '/onboarding1';
  static const String onboarding2 = '/onboarding2';
  static const String onboarding3 = '/onboarding3';
  static const String onboarding4 = '/onboarding4';
  static const String onboarding5 = '/onboarding5';
  static const String home = '/home';

  static Map<String, WidgetBuilder> routes = {
    onboarding1: (context) => OnboardingScreen1(),
    onboarding2: (context) => OnboardingScreen2(),
    onboarding3: (context) => OnboardingScreen3(),
    onboarding4: (context) => OnboardingScreen4(),
    onboarding5: (context) => OnboardingScreen5(),
    home: (context) => HomePage(),
  };
}
