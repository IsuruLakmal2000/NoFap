import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:nofap/Providers/AuthProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nofap/theme/colors.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import 'package:nofap/Utils/TaskUtils.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  List<dynamic> tasks = [];
  Map<int, bool> taskCompleted = {};
  Set<int> collectedTaskIds = {}; // Store collected task IDs
  late ConfettiController _confettiController; // Add ConfettiController

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    ); // Initialize controller
    _loadTasks();
  }

  @override
  void dispose() {
    _confettiController.dispose(); // Dispose controller
    super.dispose();
  }

  Future<void> _loadTasks() async {
    final String response = await rootBundle.loadString('Assets/task.json');
    final List<dynamic> data = json.decode(response);

    // Load collected task IDs from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    // prefs.remove("collectedTaskIds");
    final List<String>? collectedTaskIdsString = prefs.getStringList(
      'collectedTaskIds',
    );
    collectedTaskIds =
        collectedTaskIdsString != null
            ? collectedTaskIdsString.map((id) => int.parse(id)).toSet()
            : {};

    // Filter out collected tasks, except for the daily login task (ID 3)
    setState(() {
      tasks =
          data.where((task) {
            if (task['id'] == 3) {
              return true; // Always show the daily login task
            }
            return !collectedTaskIds.contains(task['id']);
          }).toList();
    });

    _checkTaskProgress();
  }

  Future<void> _checkTaskProgress() async {
    final prefs = await SharedPreferences.getInstance();
    for (var task in tasks) {
      bool isCollected = collectedTaskIds.contains(task['id']);
      int progress = await TaskUtils.calculateTaskProgress(task);

      if (task['id'] == 3) {
        // Reset collection status for daily login task if not completed today
        final String today = DateTime.now().toIso8601String().split('T')[0];
        final String? lastLoginDate = prefs.getString('lastLoginDate');
        if (lastLoginDate != today) {
          isCollected = false;
          collectedTaskIds.remove(task['id']);
          await prefs.setStringList(
            'collectedTaskIds',
            collectedTaskIds.map((id) => id.toString()).toList(),
          );
        }
      }

      setState(() {
        task['progress'] = progress;
        taskCompleted[task['id']] = progress >= task['goal'] && !isCollected;
      });
    }

    // Sort tasks: completed but uncollected tasks first
    setState(() {
      tasks.sort((a, b) {
        bool aCompleted = taskCompleted[a['id']] == true;
        bool bCompleted = taskCompleted[b['id']] == true;
        if (aCompleted && !collectedTaskIds.contains(a['id'])) {
          return -1; // a should come before b
        } else if (bCompleted && !collectedTaskIds.contains(b['id'])) {
          return 1; // b should come before a
        }
        return 0; // maintain relative order otherwise
      });
    });
  }

  Future<void> _collectReward(int taskId) async {
    final prefs = await SharedPreferences.getInstance();
    final task = tasks.firstWhere((t) => t['id'] == taskId);
    if (taskCompleted[taskId] == true) {
      // Example: Add reward logic
      if (task['rewardType'] == 'points') {
        final currentUserPoint = Provider.of<AuthProvider>(
          context,
          listen: false,
        );
        int rewardPoints = task['rewardAmount'] as int;
        currentUserPoint.AddPoints(rewardPoints);

        // Store today's earned points in SharedPreferences
        String todayKey =
            "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}_taskpoint";
        int currentPoints = prefs.getInt(todayKey) ?? 0;
        print("----$todayKey::$currentPoints + $rewardPoints;");
        await prefs.setInt(todayKey, currentPoints + rewardPoints);
      }

      // Mark the task as collected
      collectedTaskIds.add(taskId);
      await prefs.setStringList(
        'collectedTaskIds',
        collectedTaskIds.map((id) => id.toString()).toList(),
      );

      // If it's the daily login task, update the last login date
      if (taskId == 3) {
        final String today = DateTime.now().toIso8601String().split('T')[0];
        await prefs.setString('lastLoginDate', today);
      }

      // Play confetti animation
      _confettiController.play();

      // Reload tasks to filter out collected ones
      setState(() {
        tasks = tasks.where((t) => t['id'] != taskId).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          tasks.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return Card(
                    shadowColor: Colors.transparent,
                    color: AppColors.lightGray,
                    margin: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (taskCompleted[task['id']] == true ||
                              (task['id'] == 3 &&
                                  task['progress'] == 1 &&
                                  !collectedTaskIds.contains(task['id'])))
                            Column(
                              children: [
                                Text(
                                  'Claim your reward',
                                  style: TextStyle(
                                    color: AppColors.red,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),

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

                              if (taskCompleted[task['id']] == true ||
                                  (task['id'] == 3 &&
                                      task['progress'] == 1 &&
                                      !collectedTaskIds.contains(task['id'])))
                                Column(
                                  children: [
                                    ElevatedButton(
                                      onPressed:
                                          () => _collectReward(task['id']),
                                      child: const Text('Claim'),
                                    ),
                                  ],
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
                              backgroundColor: const Color.fromARGB(
                                255,
                                214,
                                214,
                                214,
                              ),
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
          // Add ConfettiWidget
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.red,
                Colors.orange,
                Colors.purple,
              ],
              strokeWidth: 1,
              strokeColor: Colors.white,
              particleDrag: 0.05, // apply drag to the confetti
              emissionFrequency: 0.05, // how often it should emit
              numberOfParticles: 30,
            ),
          ),
        ],
      ),
    );
  }
}
