/**
 * Student Model Class
 * Represents a student with their basic information
 * Requirements: Part A - 2 marks
 */
class Student {
  // Properties
  final String name;
  final String studentId;
  final String programme;
  final int level;

  // Constructor with required parameters
  Student({
    required this.name,
    required this.studentId,
    required this.programme,
    required this.level,
  });

  // Helper method to get student initials
  String getInitials() {
    List<String> names = name.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }
}
