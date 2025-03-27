import 'package:flutter/material.dart';
import 'package:nofap/Providers/AuthProvider.dart';
import 'package:nofap/Providers/FirebaseSignInAuthProvider.dart';
import 'package:nofap/Theme/colors.dart';
import 'package:nofap/Widgets/LeaderBoard%20screen/LeaderboardWidget.dart';
import 'package:nofap/Widgets/LeaderBoard%20screen/TaskScreen.dart';
import 'package:nofap/Services/FirebaseDatabaseService.dart';
import 'package:nofap/Models/LeaderboardUser.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LeaderboardScreen extends StatefulWidget {
  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen>
    with SingleTickerProviderStateMixin {
  int currentStreak = 0;
  late TabController _tabController;
  int userPoints = 0;
  List<LeaderboardUser> leaderboardUsers = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _checkFirstTimeUser();
    _loadUserPoints();
    _fetchLeaderboardData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadUserPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userPoints = prefs.getInt("userPoints") ?? 0;
    });
  }

  Future<void> _checkFirstTimeUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? startDateString = prefs.getString('streakStartDate');
    if (startDateString != null) {
      DateTime startDate = DateTime.parse(startDateString);
      setState(() {
        currentStreak = DateTime.now().difference(startDate).inDays;
      });
    }
  }

  Future<void> _fetchLeaderboardData() async {
    final firebaseService = FirebaseDatabaseService();
    final users = await firebaseService.getLeaderboardData();
    setState(() {
      leaderboardUsers = users;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_tabController == null) {
      return Center(
        child: CircularProgressIndicator(),
      ); // Fallback if not initialized
    }
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
                          authProvider.user?.displayName?.toString() ?? 'Guest',
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
        bottom: TabBar(
          controller: _tabController,
          tabs: [Tab(text: "Task Page"), Tab(text: "Leaderboard")],
          labelColor: AppColors.darkGray,
          indicatorColor: AppColors.red,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          TaskScreen(),
          Leaderboardwidget(leaderboardUsers: leaderboardUsers),
        ],
      ),
    );
  }
}
