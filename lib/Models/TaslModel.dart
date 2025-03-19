class Task {
  final int id;
  final String title;
  final String description;
  final int progress;
  final int goal;
  final bool showProgress;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.progress,
    required this.goal,
    required this.showProgress,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      progress: json['progress'],
      goal: json['goal'],
      showProgress: json['showProgress'],
    );
  }
}
