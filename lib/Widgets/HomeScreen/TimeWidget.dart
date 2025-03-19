import 'package:flutter/material.dart';
import 'package:nofap/Theme/colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Timewidget extends StatefulWidget {
  const Timewidget({super.key});

  @override
  State<Timewidget> createState() => _TimewidgetState();
}

class _TimewidgetState extends State<Timewidget> {
  final PageController _pageController = PageController(); // Page controller
  int _currentPage = 0; // Track current page index
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
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.darkGray,
                      borderRadius: BorderRadius.circular(
                        10,
                      ), // Rounded corners
                    ),

                    padding: EdgeInsets.all(8),
                    child: Text(
                      "10",
                      style: TextStyle(
                        fontSize: 44,
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    "Days",
                    style: TextStyle(fontSize: 16, color: AppColors.darkGray),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.darkGray,
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                  ),

                  padding: EdgeInsets.all(8),
                  child: Text(
                    "10",
                    style: TextStyle(
                      fontSize: 44,
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  "Hours",
                  style: TextStyle(fontSize: 16, color: AppColors.darkGray),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.darkGray,
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                  ),

                  padding: EdgeInsets.all(8),
                  child: Text(
                    "10",
                    style: TextStyle(
                      fontSize: 44,
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  "Mins",
                  style: TextStyle(fontSize: 16, color: AppColors.darkGray),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.darkGray,
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                  ),

                  padding: EdgeInsets.all(8),
                  child: Text(
                    "44",
                    style: TextStyle(
                      fontSize: 44,
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  "Sec",
                  style: TextStyle(fontSize: 16, color: AppColors.darkGray),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}
