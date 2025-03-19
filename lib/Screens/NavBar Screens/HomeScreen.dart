// home_screen.dart
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nofap/Models/TaslModel.dart';
import 'package:nofap/Providers/ChartPointsProvider.dart';
import 'package:nofap/Providers/FirebaseSignInAuthProvider.dart';
import 'package:nofap/Services/TaskService.dart';
import 'package:nofap/Theme/colors.dart';
import 'package:nofap/Widgets/HomeScreen/RelapseChart.dart';
import 'package:nofap/Widgets/HomeScreen/TaskCard.dart';
import 'package:nofap/Widgets/HomeScreen/TimeWidget.dart';
import 'package:nofap/Widgets/HomeScreen/WeeklyPointChart.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Task>> taskList;

  @override
  void initState() {
    super.initState();
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
                          "16Days",
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
                Row(
                  children: [
                    Text(
                      "543",
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
            RelapseChart(
              relapseData: {
                DateTime(2025, 3, 1): false, // Green
                DateTime(2025, 3, 2): true, // Red
                DateTime(2025, 3, 3): false, // Green
                DateTime(2025, 3, 4): true,
                DateTime(2025, 3, 10): false,

                DateTime(2025, 2, 20): false, // Red
              },
            ),
            SizedBox(height: 20),
            WeeklyPointsChart(),
          ],
        ),
      ),
    );
  }
}
