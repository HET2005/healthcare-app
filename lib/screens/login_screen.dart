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

  Future<void> loginUser() async {
    final String id = idController.text.trim();
    final String pass = passwordController.text.trim();

    final bool ok = await UserDatabase.login(id, pass);
    if (ok) {
      if (!mounted) return;
      setState(() => message = "✅ Login successful!");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(userId: id)),
      );
    } else {
      if (!mounted) return;
      setState(() => message = "❌ Invalid ID or password.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF80F6FF), Color(0xFF69EC91)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Center(
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
                    Text(
                      message,
                      style: TextStyle(
                        color: message.contains("✅") ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
