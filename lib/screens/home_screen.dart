import 'package:flutter/material.dart';
import 'medicine_list_screen.dart';
import 'medicine_alarm_screen.dart';
import 'doctors_list_screen.dart';
import 'about_me_screen.dart'; // Import AboutMeScreen

class HomeScreen extends StatelessWidget {
  final String userId;
  const HomeScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final buttonStyle = ElevatedButton.styleFrom(
      minimumSize: Size(double.infinity, 50),
    );

    return Scaffold(
      appBar: AppBar(title: Text("Healthcare App - Home")),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 32),
                Text(
                  "Welcome, $userId!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        offset: Offset(1, 1),
                        blurRadius: 2,
                        color: Colors.black26,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  style: buttonStyle,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MedicineListScreen(),
                      ),
                    );
                  },
                  child: Text("1. Medicine List"),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: buttonStyle,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MedicineAlarmScreen(),
                      ),
                    );
                  },
                  child: Text("2. Medicine Alarm"),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: buttonStyle,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const DoctorsListScreen(),
                      ),
                    );
                  },
                  child: Text("3. Doctors List"),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: buttonStyle,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AboutMeScreen()),
                    );
                  },
                  child: Text("4. About Me"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
