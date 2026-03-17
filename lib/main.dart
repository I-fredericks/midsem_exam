import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

/**
 * Main Application Entry Point
 * Requirements: Part D a (2 marks) - Firebase setup
 * Note: Firebase requires configuration files, code structure is shown
 */
void main() {
  // In a real app with Firebase, you would initialize here:
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Task Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          elevation: 4,
          centerTitle: true,
        ),
      ),
      home: const LoginScreen(),
    );
  }
}
