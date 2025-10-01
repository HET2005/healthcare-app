import 'package:flutter/material.dart';
import 'dart:ui';
import '../services/user_database.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final idController = TextEditingController();
  final passwordController = TextEditingController();
  String message = "";

  void registerUser() {
    String id = idController.text.trim();
    String pass = passwordController.text.trim();

    if (id.isEmpty || pass.isEmpty) {
      setState(() => message = "⚠ Please enter all details.");
    } else if (UserDatabase.userExists(id)) {
      setState(() => message = "⚠ User ID already exists.");
    } else {
      UserDatabase.register(id, pass);
      setState(() => message = "✅ Account created successfully!");
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pop(context);
      });
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
                        decoration: InputDecoration(
                          labelText: "Enter New User ID",
                        ),
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          labelText: "Create Password",
                        ),
                        obscureText: true,
                      ),
                      SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: registerUser,
                        child: Text("Create Account"),
                      ),
                      SizedBox(height: 10),
                      Text(
                        message,
                        style: TextStyle(
                          color: message.contains("✅")
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
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
