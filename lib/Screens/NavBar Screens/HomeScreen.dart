// home_screen.dart
import 'package:flutter/material.dart';
import 'package:nofap/Providers/FirebaseSignInAuthProvider.dart';
import 'package:nofap/Theme/colors.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController(); // Page controller
  int _currentPage = 0; // Track current page index
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 200,
                child: PageView(
                  controller: _pageController,
                  physics: ScrollPhysics(),
                  scrollDirection:
                      Axis.horizontal, // Enable horizontal scrolling
                  children: [
                    _buildContainer(context, AppColors.lightGray),
                    _buildContainer(context, AppColors.lightGray),
                    _buildContainer(context, AppColors.lightGray),
                  ],
                ),
              ),
              SizedBox(height: 10),
              SmoothPageIndicator(
                controller: _pageController, // Connect to PageView
                count: 3, // Number of pages
                effect: ExpandingDotsEffect(
                  dotHeight: 10,
                  dotWidth: 10,
                  activeDotColor: Colors.black, // Active dot color
                  dotColor: Colors.grey, // Inactive dot color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildContainer(BuildContext context, Color color) {
  double screenWidth = MediaQuery.of(context).size.width * 0.9;
  return Container(
    height: 200,
    width: screenWidth, // Adjust as needed
    margin: EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Text(
                "10",
                style: TextStyle(
                  fontSize: 44,
                  color: AppColors.darkGray,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "days",
                style: TextStyle(fontSize: 20, color: AppColors.darkGray),
              ),
            ],
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "10",
              style: TextStyle(
                fontSize: 44,
                color: AppColors.darkGray,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "days",
              style: TextStyle(fontSize: 20, color: AppColors.darkGray),
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "10",
              style: TextStyle(
                fontSize: 44,
                color: AppColors.darkGray,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "days",
              style: TextStyle(fontSize: 20, color: AppColors.darkGray),
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "10",
              style: TextStyle(
                fontSize: 44,
                color: AppColors.darkGray,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "days",
              style: TextStyle(fontSize: 20, color: AppColors.darkGray),
            ),
          ],
        ),
      ],
    ),
  );
}
