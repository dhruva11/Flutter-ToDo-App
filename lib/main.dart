import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'task.dart';
import 'task_list.dart';

void main() {
  runApp(TaskApp());
}

class TaskApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskList(),
      child: MaterialApp(
        title: 'Task Manager',
        theme: ThemeData(
          primaryColor: Colors.blue,
        ),
        home: TaskScreen(),
      ),
    );
  }
}

class TaskScreen extends StatelessWidget {
  final TextEditingController _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final taskList = Provider.of<TaskList>(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Task Manager'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'All Tasks'),
              Tab(text: 'Still Doing'),
              Tab(text: 'Completed'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ListView.builder(
              itemCount: taskList.tasks.length,
              itemBuilder: (context, index) {
                final task = taskList.tasks[index];
                return ListTile(
                  title: Text(task.title),
                  trailing: Checkbox(
                    value: task.isCompleted,
                    onChanged: (value) {
                      taskList.toggleTaskStatus(task.id);
                    },
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Edit Task'),
                          content: TextField(
                            controller: _titleController..text = task.title,
                            decoration: InputDecoration(labelText: 'Task Title'),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                final newTitle = _titleController.text.trim();
                                if (newTitle.isNotEmpty) {
                                  taskList.updateTask(task.id, newTitle, task.isCompleted);
                                  _titleController.clear();
                                }
                              },
                              child: Text('Update'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Delete Task'),
                          content: Text('Are you sure you want to delete the task?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                taskList.deleteTask(task.id);
                              },
                              child: Text('Delete'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Cancel'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            ),
            ListView.builder(
              itemCount: taskList.tasks.length,
              itemBuilder: (context, index) {
                final task = taskList.tasks[index];
                if (!task.isCompleted) {
                  return ListTile(
                    title: Text(task.title),
                    trailing: Checkbox(
                      value: task.isCompleted,
                      onChanged: (value) {
                        taskList.toggleTaskStatus(task.id);
                      },
                    ),
                  );
                } else {
                  return SizedBox.shrink();
                }
              },
            ),
            ListView.builder(
              itemCount: taskList.tasks.length,
              itemBuilder: (context, index) {
                final task = taskList.tasks[index];
                if (task.isCompleted) {
                  return ListTile(
                    title: Text(task.title),
                    trailing: Checkbox(
                      value: task.isCompleted,
                      onChanged: (value) {
                        taskList.toggleTaskStatus(task.id);
                      },
                    ),
                  );
                } else {
                  return SizedBox.shrink();
                }
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Add Task'),
                  content: TextField(
                    controller: _titleController,
                    decoration: InputDecoration(labelText: 'Task Title'),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        final title = _titleController.text.trim();
                        if (title.isNotEmpty) {
                          final id = UniqueKey().toString();
                          final newTask = Task(title: title, id: id);
                          taskList.addTask(newTask);
                          _titleController.clear();
                        }
                      },
                      child: Text('Add Task'),
                    ),
                  ],
                );
              },
            );
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
