import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nofap/Models/TaslModel.dart';
import 'package:nofap/Providers/AuthProvider.dart';
import 'package:nofap/Providers/FirebaseSignInAuthProvider.dart';
import 'package:nofap/Screens/PanicScreen.dart';
import 'package:nofap/Theme/colors.dart';
import 'package:nofap/Widgets/HomeScreen/RelapseChart.dart';
import 'package:nofap/Widgets/HomeScreen/SetStreakDialog.dart';
import 'package:nofap/Widgets/HomeScreen/TimeWidget.dart';
import 'package:nofap/Widgets/HomeScreen/WeeklyPointChart.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nofap/Widgets/CustomAppBar.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Task>> taskList;
  int currentStreak = 0;
  int streakDays = 0;
  int userPoints = 0;
  late String username = '';
  String relapseChartKey = UniqueKey().toString(); // Add and initialize the key

  @override
  void initState() {
    super.initState();
    _checkFirstTimeUser();
    _loadUserPoints();
  }

  Future<void> _loadUserPoints() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    setState(() {
      userPoints = authProvider.currentUserPoints;
    });
  }

  Future<void> _checkFirstTimeUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('isFirstTime') ?? true;
    print("check first time -" + isFirstTime.toString());
    username = prefs.getString('userName') ?? 'Guest';
    if (isFirstTime) {
      print("yes first time");
      _showStreakPopup();
    } else {
      // Calculate current streak based on saved start date
      String? startDateString = prefs.getString('streakStartDate');
      if (startDateString != null) {
        DateTime startDate = DateTime.parse(startDateString);
        setState(() {
          currentStreak = DateTime.now().difference(startDate).inDays;
        });
      }
    }
  }

  void _showStreakPopup() {
    showDialog(
      context: context,
      builder: (context) {
        return SetStreakDialog(
          initialStreak: streakDays,
          onSave: (selectedStreak) {
            setState(() {
              currentStreak = selectedStreak;
              relapseChartKey = UniqueKey().toString();
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Timewidget(),
            SizedBox(height: 20),
            RelapseChart(
              key: Key(relapseChartKey),
            ), // Pass the Key to RelapseChart
            SizedBox(height: 20),
            WeeklyPointsChart(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PanicScreen()),
          );
        },
        backgroundColor: AppColors.red,
        child: Icon(Icons.warning_rounded, color: Colors.white),
      ),
    );
  }
}
