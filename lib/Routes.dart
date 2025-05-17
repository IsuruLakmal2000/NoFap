import 'package:FapFree/Screens/Onboarding/OnboardingScreen22.dart';
import 'package:FapFree/Screens/Onboarding/OnboardingScreen33.dart';
import 'package:flutter/material.dart';
import 'package:FapFree/Screens/HomePage.dart';
import 'package:FapFree/Screens/Onboarding/OnboardingScreen1.dart';
import 'package:FapFree/Screens/Onboarding/OnboardingScreen2.dart';
import 'package:FapFree/Screens/Onboarding/OnboardingScreen3.dart';
import 'package:FapFree/Screens/Onboarding/OnboardingScreen4.dart';
import 'package:FapFree/Screens/Onboarding/OnboardingScreen5.dart';

class AppRoutes {
  static const String onboarding1 = '/onboarding1';
  static const String onboarding2 = '/onboarding22';
  static const String onboarding3 = '/onboarding33';
  static const String onboarding4 = '/onboarding4';
  static const String onboarding5 = '/onboarding5';
  static const String home = '/home';

  static Map<String, WidgetBuilder> routes = {
    onboarding1: (context) => OnboardingScreen1(),
    onboarding2: (context) => OnboardingScreen22(),
    onboarding3: (context) => OnboardingScreen33(),
    onboarding4: (context) => OnboardingScreen3(),
    onboarding5: (context) => OnboardingScreen4(),
    home: (context) => HomePage(),
  };
}
