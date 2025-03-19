import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:nofap/Models/TaslModel.dart';

class TaskService {
  static Future<List<Task>> loadTasks() async {
    String jsonString = await rootBundle.loadString('Assets/tasks.json');
    List<dynamic> jsonData = json.decode(jsonString);
    return jsonData.map((item) => Task.fromJson(item)).toList();
  }
}
