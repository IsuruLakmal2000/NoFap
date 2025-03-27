import 'package:flutter/material.dart';
import 'package:nofap/Providers/AuthProvider.dart';
import 'package:nofap/Providers/AvatarAndFrameProvider.dart';
import 'package:nofap/Providers/ChartPointsProvider.dart';
import 'package:nofap/Providers/FirebaseSignInAuthProvider.dart'; // Import the FirebaseSignInAuthProvider
import 'package:firebase_core/firebase_core.dart';
import 'package:nofap/Providers/UserProvider.dart';
import 'package:nofap/Reposoteries/FirebaseSignInAuthRepo.dart';
import 'package:provider/provider.dart';
import 'routes.dart';
import 'theme/theme.dart'; // Import the theme

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final userProvider = UserProvider();
  await userProvider.loadUserData();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(),
        ),
        ChangeNotifierProvider<UserProvider>(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider<FirebaseSignInAuthProvider>(
          create:
              (context) => FirebaseSignInAuthProvider(Firebasesigninauthrepo()),
        ),
        ChangeNotifierProvider<AvatarAndFrameProvider>(
          create: (context) => AvatarAndFrameProvider(),
        ),
      ],
      child: Consumer<FirebaseSignInAuthProvider>(
        builder: (context, authProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme, // Use the custom theme
            initialRoute:
                authProvider.user == null
                    ? AppRoutes.onboarding1
                    : AppRoutes.home,
            routes: AppRoutes.routes,
          );
        },
      ),
    );
  }
}
