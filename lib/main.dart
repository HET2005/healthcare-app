import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'services/user_database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserDatabase.init();
  runApp(HealthcareApp());
}

class HealthcareApp extends StatelessWidget {
  const HealthcareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: LoginScreen(),
    );
  }
}
