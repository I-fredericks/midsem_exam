import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/task.dart';

/**
 * Task List Screen
 * Displays list of tasks with checkboxes, add new tasks via dialog
 * Requirements: Part B (3 marks), Part C (8 marks total)
 * - StatefulWidget with FAB (4 marks)
 * - Checkbox functionality (2 marks)
 * - SharedPreferences persistence (2 marks)
 */
class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  // Task list that will be managed with state
  List<Task> tasks = [];

  // Hardcoded default tasks (Part B requirement)
  final List<Task> defaultTasks = [
    Task(
      title: 'Complete Flutter Assignment',
      courseCode: 'CSCD 301',
      dueDate: DateTime(2026, 3, 20),
    ),
    Task(
      title: 'Read Chapter 5 - State Management',
      courseCode: 'CSCD 305',
      dueDate: DateTime(2026, 3, 22),
    ),
    Task(
      title: 'Prepare Group Presentation',
      courseCode: 'CSCD 310',
      dueDate: DateTime(2026, 3, 25),
    ),
    Task(
      title: 'Submit Mid-Semester Report',
      courseCode: 'CSCD 315',
      dueDate: DateTime(2026, 3, 28),
    ),
  ];

  // Controllers for text fields in add dialog
  final TextEditingController titleController = TextEditingController();
  final TextEditingController courseCodeController = TextEditingController();

  // Selected date for new task
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadTasks(); // Load saved tasks when app starts (Part C - persistence)
  }

  /**
   * Load tasks from SharedPreferences
   * If no saved data exists, use hardcoded list
   * Part C requirement (2 marks)
   */
  Future<void> _loadTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? tasksJson = prefs.getString('tasks');

      if (tasksJson != null && tasksJson.isNotEmpty) {
        // Decode JSON and convert to Task objects
        final List<dynamic> decodedList = json.decode(tasksJson);
        setState(() {
          tasks = decodedList.map((item) => Task.fromJson(item)).toList();
        });
        print('Tasks loaded from storage: ${tasks.length} tasks');
      } else {
        // No saved data, use hardcoded list
        setState(() {
          tasks = List.from(defaultTasks);
        });
        print('Using default tasks');
      }
    } catch (e) {
      print('Error loading tasks: $e');
      // Fallback to default tasks on error
      setState(() {
        tasks = List.from(defaultTasks);
      });
    }
  }

  /**
   * Save tasks to SharedPreferences
   * Called whenever tasks change (add or toggle)
   * Part C requirement (2 marks)
   */
  Future<void> _saveTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Convert tasks to JSON
      List<Map<String, dynamic>> tasksMap =
          tasks.map((task) => task.toJson()).toList();

      await prefs.setString('tasks', json.encode(tasksMap));
      print('Tasks saved to storage: ${tasks.length} tasks');
    } catch (e) {
      print('Error saving tasks: $e');
    }
  }

  // Helper method to format date as dd/mm/yyyy
  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  // Check if date is overdue
  bool isOverdue(DateTime dueDate, bool isComplete) {
    return dueDate.isBefore(DateTime.now()) && !isComplete;
  }

  /**
   * Show dialog to add new task
   * Contains TextFields and date picker
   * Part C requirement (4 marks)
   */
  void showAddTaskDialog(BuildContext context) {
    // Reset controllers and date
    titleController.clear();
    courseCodeController.clear();
    selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Add New Task'),
              titleTextStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title TextField
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: 'Task Title',
                        hintText: 'Enter task title',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.title),
                      ),
                      autofocus: true,
                    ),
                    const SizedBox(height: 16),

                    // Course Code TextField
                    TextField(
                      controller: courseCodeController,
                      decoration: InputDecoration(
                        labelText: 'Course Code',
                        hintText: 'e.g., CSCD 301',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.code),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Date picker button
                    InkWell(
                      onTap: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2027),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme.light(
                                  primary: Colors.blue,
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null) {
                          setDialogState(() {
                            selectedDate = picked;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today,
                                color: Colors.blue.shade700),
                            const SizedBox(width: 12),
                            Text(
                              'Due Date: ${formatDate(selectedDate)}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Validate inputs
                    if (titleController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter a task title'),
                          backgroundColor: Colors.orange,
                        ),
                      );
                      return;
                    }
                    if (courseCodeController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter a course code'),
                          backgroundColor: Colors.orange,
                        ),
                      );
                      return;
                    }

                    // Add new task
                    setState(() {
                      tasks.add(
                        Task(
                          title: titleController.text.trim(),
                          courseCode:
                              courseCodeController.text.trim().toUpperCase(),
                          dueDate: selectedDate,
                        ),
                      );
                    });

                    // Save to SharedPreferences
                    _saveTasks();

                    Navigator.pop(context);

                    // Show success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Task added successfully!'),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  /**
   * Toggle task completion status
   * Part C requirement (2 marks)
   */
  void _toggleTaskCompletion(int index, bool? value) {
    setState(() {
      tasks[index].isComplete = value ?? false;
    });
    _saveTasks(); // Save changes
  }

  /**
   * Delete a task
   * Extra feature - not required but nice to have
   */
  void _deleteTask(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content:
            Text('Are you sure you want to delete "${tasks[index].title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                tasks.removeAt(index);
              });
              _saveTasks();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Task deleted')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  /**
   * Reset to default tasks (for testing)
   */
  void _resetToDefault() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Tasks'),
        content: const Text(
            'Reset to default tasks? This will delete all current tasks.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                tasks = List.from(defaultTasks);
              });
              _saveTasks();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Reset to default tasks')),
              );
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 4,
        actions: [
          // Reset button (for testing)
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetToDefault,
            tooltip: 'Reset to default tasks',
          ),
        ],
      ),
      body: tasks.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.task_alt,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No tasks yet',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the + button to add a new task',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Dismissible(
                    key: Key(task.title + index.toString()),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                    onDismissed: (direction) {
                      _deleteTask(index);
                    },
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      leading: Checkbox(
                        value: task.isComplete,
                        onChanged: (value) =>
                            _toggleTaskCompletion(index, value),
                        activeColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
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
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.code,
                                size: 16,
                                color: Colors.grey.shade600,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                task.courseCode,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 14,
                                color: isOverdue(task.dueDate, task.isComplete)
                                    ? Colors.red
                                    : Colors.grey.shade600,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                formatDate(task.dueDate),
                                style: TextStyle(
                                  fontSize: 14,
                                  color:
                                      isOverdue(task.dueDate, task.isComplete)
                                          ? Colors.red
                                          : Colors.grey.shade700,
                                  fontWeight:
                                      isOverdue(task.dueDate, task.isComplete)
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: task.isComplete
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    size: 16,
                                    color: Colors.green.shade700,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Done',
                                    style: TextStyle(
                                      color: Colors.green.shade700,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : null,
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showAddTaskDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Task'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
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
