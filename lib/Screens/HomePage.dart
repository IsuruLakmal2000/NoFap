import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'package:nofap/Screens/NavBar%20Screens/CommunityScreen.dart';
import 'package:nofap/Screens/NavBar%20Screens/HomeScreen.dart';

import 'package:nofap/Screens/NavBar%20Screens/LeaderboardScreen.dart';
import 'package:nofap/Screens/NavBar%20Screens/ProfileScreen.dart';
import 'package:nofap/theme/colors.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    LeaderboardScreen(),
    CommunityScreen(),
    ProfileScreen(),
  ];

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: GNav(
        rippleColor: Colors.grey[300]!,
        hoverColor: Colors.grey[100]!,
        gap: 8,
        activeColor: AppColors.lightGray,
        iconSize: 24,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        duration: Duration(milliseconds: 400),
        tabBackgroundColor: AppColors.darkGray,
        tabBorderRadius: 0,

        color: Colors.black,
        tabs: [
          GButton(icon: Icons.home, text: 'Home'),
          GButton(icon: Icons.leaderboard, text: 'Leaderboard'),
          GButton(icon: Icons.group, text: 'Community'),
          GButton(icon: Icons.account_circle, text: 'Profile'),
        ],
        selectedIndex: _selectedIndex,
        onTabChange: _onTabSelected,
      ),
    );
  }
}
