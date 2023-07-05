import 'package:flutter/foundation.dart';

import 'task.dart';

class TaskList extends ChangeNotifier {
  List<Task> tasks = [];

  void addTask(Task task) {
    tasks.add(task);
    notifyListeners();
  }

  void updateTask(String id, String title, bool isCompleted) {
    final taskIndex = tasks.indexWhere((task) => task.id == id);
    if (taskIndex >= 0) {
      tasks[taskIndex] = Task(
        title: title,
        isCompleted: isCompleted,
        id: id,
      );
      notifyListeners();
    }
  }

  void deleteTask(String id) {
    tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }

  void toggleTaskStatus(String id) {
    final taskIndex = tasks.indexWhere((task) => task.id == id);
    if (taskIndex >= 0) {
      tasks[taskIndex].isCompleted = !tasks[taskIndex].isCompleted;
      notifyListeners();
    }
  }
}
