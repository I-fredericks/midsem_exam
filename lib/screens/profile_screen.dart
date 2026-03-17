import 'package:flutter/material.dart';
import 'task_list_screen.dart';
import '../models/student.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  // Hardcoded student data for demonstration
  final Student student = Student(
    name: 'John Doe',
    studentId: 'STU2025001',
    programme: 'Computer Science',
    level: 300,
  );

  // Helper method to get initials
  String getInitials(String name) {
    List<String> names = name.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Profile'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Card with CircleAvatar and student details
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    // CircleAvatar with student's initial
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.blue,
                      child: Text(
                        getInitials(student.name),
                        style: const TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Student details
                    Text(
                      student.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Text(
                      'ID: ${student.studentId}',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),

                    Text(
                      'Programme: ${student.programme}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 4),

                    Text(
                      'Level: ${student.level}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Edit Profile button (no functionality required)
            ElevatedButton(
              onPressed: () {
                // Edit functionality not required for this exam
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Edit profile feature coming soon!'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Edit Profile'),
            ),

            const SizedBox(height: 10),

            // View Tasks button for navigation (Bonus mark)
            ElevatedButton(
              onPressed: () {
                // Navigate to TaskListScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TaskListScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('View Tasks'),
            ),
          ],
        ),
      ),
    );
  }
}
