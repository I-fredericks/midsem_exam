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
}
