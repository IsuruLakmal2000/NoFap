import 'package:flutter/material.dart';
import 'package:nofap/theme/colors.dart';

class Leaderboardwidget extends StatefulWidget {
  const Leaderboardwidget({super.key});

  @override
  State<Leaderboardwidget> createState() => _LeaderboardwidgetState();
}

class _LeaderboardwidgetState extends State<Leaderboardwidget> {
  // Dummy data for leaderboard
  final List<Map<String, dynamic>> leaderboardData = [
    {'username': 'User1', 'points': 1200, 'streakDays': 15},
    {'username': 'User2', 'points': 1100, 'streakDays': 10},
    {'username': 'User3', 'points': 900, 'streakDays': 8},
    {'username': 'User4', 'points': 850, 'streakDays': 5},
    {'username': 'User5', 'points': 800, 'streakDays': 3},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: leaderboardData.length,
        itemBuilder: (context, index) {
          final item = leaderboardData[index];
          return Card(
            shadowColor: Colors.transparent,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              trailing: SizedBox(
                width: 80, // Define a fixed width for the trailing widget
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "232",
                      style: TextStyle(
                        color: AppColors.darkGray,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Icon(
                      Icons.star_outlined,
                      size: 24,
                      color: AppColors.darkGray,
                    ),
                  ],
                ),
              ),
              leading: CircleAvatar(
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    color: AppColors.red,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              dense: false,
              title: Text(item['username']),
              subtitle: Text('Streak: ${item['streakDays']} days'),
            ),
          );
        },
      ),
    );
  }
}
