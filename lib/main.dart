import 'package:flutter/material.dart';
import 'package:nofap/Providers/AuthProvider.dart';
import 'package:provider/provider.dart';
import 'routes.dart';
import 'theme/theme.dart'; // Import the theme

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme, // Use the custom theme
            initialRoute:
                authProvider.isOnboardingSeen
                    ? AppRoutes.home
                    : AppRoutes.onboarding1,
            routes: AppRoutes.routes,
          );
        },
      ),
    );
  }
}
