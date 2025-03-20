import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nofap/theme/colors.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  List<dynamic> tasks = [];
  Map<int, bool> taskCompleted = {};

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final String response = await rootBundle.loadString('Assets/task.json');
    final List<dynamic> data = json.decode(response);
    setState(() {
      tasks = data;
    });
    _checkTaskProgress();
  }

  Future<void> _checkTaskProgress() async {
    final prefs = await SharedPreferences.getInstance();
    for (var task in tasks) {
      int progress = 0;
      if (task['id'] == 1) {
        // Example: Fetch progress for "Stay strong for 5 minutes"
        String? startDateString = prefs.getString('streakStartDate');
        DateTime startDate = DateTime.parse(startDateString!);
        print(startDate);
        progress = DateTime.now().difference(startDate).inMinutes;
      } else if (task['id'] == 2) {
        String? startDateString = prefs.getString('streakStartDate');
        DateTime startDate = DateTime.parse(startDateString!);
        print(startDate);
        progress = DateTime.now().difference(startDate).inMinutes;
      } else if (task['id'] == 3) {
        // Example: Fetch progress for "Daily Login"
        final lastLogin = prefs.getBool('dailyLogin') ?? false;
        progress = lastLogin ? 1 : 0;
      }
      setState(() {
        task['progress'] = progress;
        taskCompleted[task['id']] = progress >= task['goal'];
      });
    }
  }

  Future<void> _collectReward(int taskId) async {
    final prefs = await SharedPreferences.getInstance();
    final task = tasks.firstWhere((t) => t['id'] == taskId);
    if (taskCompleted[taskId] == true) {
      // Example: Add reward logic
      if (task['rewardType'] == 'points') {
        int currentPoints = prefs.getInt('userPoints') ?? 0;
        prefs.setInt(
          'userPoints',
          currentPoints + (task['rewardAmount'] as int),
        );
      }
      setState(() {
        taskCompleted[taskId] = false; // Mark reward as collected
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          tasks.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return Card(
                    color: AppColors.lightGray,
                    margin: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    task['title'],
                                    style: const TextStyle(
                                      color: AppColors.darkGray,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    task['description'],
                                    style: TextStyle(
                                      color: AppColors.darkGray2,
                                    ),
                                  ),
                                ],
                              ),
                              if (taskCompleted[task['id']] == true)
                                ElevatedButton(
                                  onPressed: () => _collectReward(task['id']),
                                  child: const Text('Collect'),
                                ),
                            ],
                          ),
                          if (task['showProgress']) ...[
                            const SizedBox(height: 8),
                            LinearProgressIndicator(
                              minHeight: 8,
                              value: (task['progress'] / task['goal']).clamp(
                                0.0,
                                1.0,
                              ),
                              backgroundColor: AppColors.mediumGray,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Color.fromARGB(255, 6, 184, 0),
                              ),
                            ),
                            Text(
                              'Progress: ${task['progress']} / ${task['goal']}',
                              style: TextStyle(color: AppColors.darkGray2),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
