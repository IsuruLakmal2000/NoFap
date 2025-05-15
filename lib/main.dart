import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:FapFree/Providers/AuthProvider.dart';
import 'package:FapFree/Providers/AvatarAndFrameProvider.dart';
import 'package:FapFree/Providers/ChartPointsProvider.dart';
import 'package:FapFree/Providers/FirebaseSignInAuthProvider.dart'; // Import the FirebaseSignInAuthProvider
import 'package:firebase_core/firebase_core.dart';
import 'package:FapFree/Providers/UserProvider.dart';
import 'package:FapFree/Reposoteries/FirebaseSignInAuthRepo.dart';
import 'package:provider/provider.dart';
import 'routes.dart';
import 'theme/theme.dart'; // Import the theme
import 'firebase_options.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:FapFree/Services/AdMobService.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(fileName: ".env");
  final userProvider = UserProvider();
  await userProvider.loadUserData();

  final adMobService = AdMobService();
  adMobService.initialize(); // Initialize AdMob

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
