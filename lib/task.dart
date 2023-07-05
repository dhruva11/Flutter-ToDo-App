class Task {
  String title;
  bool isCompleted;
  String id;

  Task({
    required this.title,
    this.isCompleted = false,
    required this.id,
  });
}
