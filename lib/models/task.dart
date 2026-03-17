/**
 * Task Model Class
 * Represents a task with title, course code, due date and completion status
 * Requirements: Part A - 2 marks
 */
class Task {
  // Properties
  String title;
  String courseCode;
  DateTime dueDate;
  bool isComplete;

  // Constructor with required parameters
  Task({
    required this.title,
    required this.courseCode,
    required this.dueDate,
    this.isComplete = false, // default value
  });

  // Convert Task to JSON for SharedPreferences storage
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'courseCode': courseCode,
      'dueDate': dueDate.toIso8601String(),
      'isComplete': isComplete,
    };
  }

  // Create Task from JSON (for loading from SharedPreferences)
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'],
      courseCode: json['courseCode'],
      dueDate: DateTime.parse(json['dueDate']),
      isComplete: json['isComplete'],
    );
  }

  // Create a copy of task with updated values
  Task copyWith({
    String? title,
    String? courseCode,
    DateTime? dueDate,
    bool? isComplete,
  }) {
    return Task(
      title: title ?? this.title,
      courseCode: courseCode ?? this.courseCode,
      dueDate: dueDate ?? this.dueDate,
      isComplete: isComplete ?? this.isComplete,
    );
  }
}
