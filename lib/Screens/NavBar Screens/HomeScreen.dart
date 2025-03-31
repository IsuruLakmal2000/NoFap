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
    username = prefs.getString('username') ?? '';
    if (isFirstTime) {
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
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.lightGray,
        toolbarHeight: 100,
        title: Consumer<FirebaseSignInAuthProvider>(
          builder: (context, authProvider, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.local_fire_department_sharp,
                      size: 60,
                      color: AppColors.red,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          username ?? 'Guest',
                          style: TextStyle(
                            color: AppColors.darkGray,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          "$currentStreak Days",
                          style: TextStyle(
                            color: AppColors.darkGray,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return Row(
                      children: [
                        Text(
                          "${authProvider.currentUserPoints}",
                          style: TextStyle(
                            color: AppColors.darkGray,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Icon(
                          Icons.star_outlined,
                          size: 30,
                          color: AppColors.darkGray,
                        ),
                      ],
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Timewidget(),
            SizedBox(height: 20),
            RelapseChart(),
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
