import 'package:flutter/material.dart';
import 'dart:ui';
import '../services/user_database.dart';
import 'register_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final idController = TextEditingController();
  final passwordController = TextEditingController();
  String message = "";

  void loginUser() {
    String id = idController.text.trim();
    String pass = passwordController.text.trim();

    if (UserDatabase.login(id, pass)) {
      setState(() => message = "✅ Login successful!");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(userId: id)),
      );
    } else {
      setState(() => message = "❌ Invalid ID or password.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF80F6FF), Color(0xFF69EC91)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
          ),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  width: 350,
                  padding: EdgeInsets.all(24),
                  color: Colors.white.withOpacity(0.25),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: idController,
                        decoration: InputDecoration(labelText: "Enter User ID"),
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          labelText: "Enter Password",
                        ),
                        obscureText: true,
                      ),
                      SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: loginUser,
                        child: Text("Login"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterScreen(),
                            ),
                          );
                        },
                        child: Text("Don't have an ID? Create one"),
                      ),
                      SizedBox(height: 10),
                      Text(message, style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
