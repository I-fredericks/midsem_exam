import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  // List of tasks with state
  List<Task> tasks = [
    Task(
      title: 'Complete Flutter Assignment',
      courseCode: 'CSCD 301',
      dueDate: DateTime(2026, 3, 20),
    ),
    Task(
      title: 'Read Chapter 5',
      courseCode: 'CSCD 305',
      dueDate: DateTime(2026, 3, 22),
    ),
    Task(
      title: 'Prepare Presentation',
      courseCode: 'CSCD 310',
      dueDate: DateTime(2026, 3, 25),
    ),
  ];

  // Controllers for text fields
  final TextEditingController titleController = TextEditingController();
  final TextEditingController courseCodeController = TextEditingController();

  // Selected date for new task
  DateTime selectedDate = DateTime.now();

  // Helper method to format date
  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  // Method to show add task dialog
  void showAddTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Task'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title TextField
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Task Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // Course Code TextField
                TextField(
                  controller: courseCodeController,
                  decoration: const InputDecoration(
                    labelText: 'Course Code',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // Date picker button
                ListTile(
                  title: Text('Due Date: ${formatDate(selectedDate)}'),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2027),
                    );
                    if (picked != null) {
                      setState(() {
                        selectedDate = picked;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Clear controllers and close dialog
                titleController.clear();
                courseCodeController.clear();
                setState(() {
                  selectedDate = DateTime.now();
                });
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Add new task (4 marks)
                if (titleController.text.isNotEmpty &&
                    courseCodeController.text.isNotEmpty) {
                  setState(() {
                    tasks.add(
                      Task(
                        title: titleController.text,
                        courseCode: courseCodeController.text,
                        dueDate: selectedDate,
                      ),
                    );
                  });

                  // Clear controllers
                  titleController.clear();
                  courseCodeController.clear();
                  setState(() {
                    selectedDate = DateTime.now();
                  });

                  Navigator.pop(context);

                  // Show success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Task added successfully!')),
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: tasks.isEmpty
          ? const Center(
              child: Text(
                'No tasks yet. Add one using the + button!',
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    leading: Checkbox(
                      value: task.isComplete,
                      onChanged: (bool? value) {
                        // Implement checkbox functionality (2 marks)
                        setState(() {
                          task.isComplete = value ?? false;
                        });
                      },
                    ),
                    title: Text(
                      task.title,
                      style: TextStyle(
                        decoration: task.isComplete
                            ? TextDecoration.lineThrough
                            : null,
                        fontWeight: task.isComplete
                            ? FontWeight.normal
                            : FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Course: ${task.courseCode}'),
                        Text(
                          'Due: ${formatDate(task.dueDate)}',
                          style: TextStyle(
                            color:
                                task.dueDate.isBefore(DateTime.now()) &&
                                    !task.isComplete
                                ? Colors.red
                                : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    trailing: task.isComplete
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : null,
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddTaskDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up controllers
    titleController.dispose();
    courseCodeController.dispose();
    super.dispose();
  }
}
