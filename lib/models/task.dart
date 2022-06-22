class Task {
  Task({
    required this.id,
    required this.title,
    required this.isCompleted,
    this.description,
  });

  final String id;
  final String title;
  final String? description;
  bool isCompleted;
}
