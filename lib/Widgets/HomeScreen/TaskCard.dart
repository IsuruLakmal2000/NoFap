import 'package:flutter/material.dart';
import 'package:nofap/Models/TaslModel.dart';

class TaskCard extends StatelessWidget {
  final Task task;

  const TaskCard({required this.task});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              task.description,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            if (task.showProgress) ...[
              SizedBox(height: 8),
              LinearProgressIndicator(
                value: task.progress / task.goal,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
              SizedBox(height: 4),
              Text("${task.progress} / ${task.goal} completed"),
            ],
          ],
        ),
      ),
    );
  }
}
