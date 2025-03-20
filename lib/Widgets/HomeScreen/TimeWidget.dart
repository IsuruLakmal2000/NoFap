import 'package:flutter/material.dart';
import 'package:nofap/Theme/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'dart:async';

class Timewidget extends StatefulWidget {
  const Timewidget({super.key});

  @override
  State<Timewidget> createState() => _TimewidgetState();
}

class _TimewidgetState extends State<Timewidget> {
  final PageController _pageController = PageController(); // Page controller
  int _currentPage = 0;
  DateTime? _streakStartDate;
  Duration _elapsedTime = Duration.zero;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _loadStreakStartDate();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _loadStreakStartDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? startDateString = prefs.getString('streakStartDate');
    if (startDateString != null) {
      setState(() {
        _streakStartDate = DateTime.parse(startDateString);
      });
    }
  }

  Future<void> _ResetStreak() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime now = DateTime.now();
    await prefs.setString('streakStartDate', now.toIso8601String());
    String? startDateString = prefs.getString('streakStartDate');
    if (startDateString != null) {
      setState(() {
        _streakStartDate = DateTime.parse(startDateString);
      });
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_streakStartDate != null) {
        setState(() {
          _elapsedTime = DateTime.now().difference(_streakStartDate!);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 0),
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: PageView(
              controller: _pageController,
              physics: ScrollPhysics(),
              scrollDirection: Axis.horizontal, // Enable horizontal scrolling
              children: [
                __buildStreak(context, AppColors.lightGray),
                _buildNextMilestone(context, AppColors.lightGray),
              ],
            ),
          ),
          SizedBox(height: 10),
          SmoothPageIndicator(
            controller: _pageController, // Connect to PageView
            count: 2, // Number of pages
            effect: ExpandingDotsEffect(
              dotHeight: 10,
              dotWidth: 10,
              activeDotColor: Colors.black, // Active dot color
              dotColor: Colors.grey, // Inactive dot color
            ),
          ),
        ],
      ),
    );
  }

  Widget __buildStreak(BuildContext context, Color color) {
    double screenWidth = MediaQuery.of(context).size.width * 0.9;
    int days = _elapsedTime.inDays;
    int hours = _elapsedTime.inHours % 24;
    int minutes = _elapsedTime.inMinutes % 60;
    int seconds = _elapsedTime.inSeconds % 60;

    return Container(
      height: 200,
      width: screenWidth, // Adjust as needed
      margin: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Keep Pushing. Stay strong!",
            style: TextStyle(
              color: AppColors.darkGray2,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTimeColumn("Days", days),
              _buildTimeColumn("Hours", hours),
              _buildTimeColumn("Mins", minutes),
              _buildTimeColumn("Sec", seconds),
            ],
          ),
          SizedBox(height: 10),
          TextButton(
            onPressed: () async {
              bool? confirmReset = await showDialog<bool>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Reset Streak"),
                    content: Text(
                      "Are you sure you want to reset your streak?",
                    ),
                    actions: [
                      TextButton(
                        onPressed:
                            () => Navigator.of(context).pop(false), // Cancel
                        child: Text("Cancel"),
                      ),
                      TextButton(
                        onPressed:
                            () => Navigator.of(context).pop(true), // Confirm
                        child: Text("Yes"),
                      ),
                    ],
                  );
                },
              );

              if (confirmReset == true) {
                await _ResetStreak();
              }
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero, // Remove padding around the button
              minimumSize: Size(0, 0), // Remove minimum size constraints
              tapTargetSize:
                  MaterialTapTargetSize.shrinkWrap, // Shrink tap area
            ),
            child: Text(
              "did you relapse?",
              style: TextStyle(
                color: AppColors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextMilestone(BuildContext context, Color color) {
    double screenWidth = MediaQuery.of(context).size.width * 0.9;

    // Define milestones in seconds
    List<int> milestones = [
      5 * 60, // 5 minutes
      10 * 60, // 10 minutes
      30 * 60, // 30 minutes
      1 * 60 * 60, // 1 hour
      5 * 60 * 60, // 5 hours
      10 * 60 * 60, // 10 hours
      1 * 24 * 60 * 60, // 1 day
      2 * 24 * 60 * 60, // 2 days
      5 * 24 * 60 * 60, // 5 days
      10 * 24 * 60 * 60, // 10 days
      20 * 24 * 60 * 60, // 20 days
      30 * 24 * 60 * 60, // 30 days
      50 * 24 * 60 * 60, // 50 days
      100 * 24 * 60 * 60, // 100 days
    ];

    // Calculate elapsed time in seconds
    int elapsedSeconds = _elapsedTime.inSeconds;

    // Find the next milestone
    int? nextMilestone = milestones.firstWhere(
      (milestone) => milestone > elapsedSeconds,
      orElse: () => 0,
    );

    // Calculate time remaining for the next milestone
    Duration timeRemaining =
        nextMilestone != null
            ? Duration(seconds: nextMilestone - elapsedSeconds)
            : Duration.zero;

    int days = timeRemaining.inDays;
    int hours = timeRemaining.inHours % 24;
    int minutes = timeRemaining.inMinutes % 60;
    int seconds = timeRemaining.inSeconds % 60;

    return Container(
      height: 200,
      width: screenWidth, // Adjust as needed
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            nextMilestone != null
                ? "Next Milestone in:"
                : "Congratulations! You've reached the highest milestone!",
            style: TextStyle(
              color: AppColors.darkGray2,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 10),
          if (nextMilestone != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTimeColumn("Days", days),
                _buildTimeColumn("Hours", hours),
                _buildTimeColumn("Mins", minutes),
                _buildTimeColumn("Sec", seconds),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildTimeColumn(String label, int value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 70,
          width: 70,
          decoration: BoxDecoration(
            color: AppColors.darkGray,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.all(8),
          child: Center(
            child: Text(
              "$value",
              style: TextStyle(
                fontSize: 44,
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Text(label, style: TextStyle(fontSize: 16, color: AppColors.darkGray)),
      ],
    );
  }
}
