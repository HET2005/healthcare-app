import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:url_launcher/url_launcher.dart';

class DoctorsListScreen extends StatefulWidget {
  const DoctorsListScreen({super.key});

  @override
  _DoctorsListScreenState createState() => _DoctorsListScreenState();
}

class _DoctorsListScreenState extends State<DoctorsListScreen> {
  List<Map<String, String>> doctors = [
    {"name": "Dr. Sarah Johnson", "specialty": "Cardiologist", "phone": "+1 (555) 123-4567"},
    {"name": "Dr. Michael Chen", "specialty": "Neurologist", "phone": "+1 (555) 234-5678"},
    {"name": "Dr. Emily Rodriguez", "specialty": "Pediatrician", "phone": "+1 (555) 345-6789"},
    {"name": "Dr. David Wilson", "specialty": "Orthopedist", "phone": "+1 (555) 456-7890"},
    {"name": "Dr. Lisa Thompson", "specialty": "Dermatologist", "phone": "+1 (555) 567-8901"},
    {"name": "Dr. James Anderson", "specialty": "Psychiatrist", "phone": "+1 (555) 678-9012"},
  ];

  Future<void> _makePhoneCall(String phoneNumber) async {
    final String sanitized = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    final Uri phoneUri = Uri(scheme: 'tel', path: sanitized);

    try {
      final bool supported = await canLaunchUrl(phoneUri);
      if (supported) {
        await launchUrl(
          phoneUri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("No dialer available. Try on a physical device."),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error making phone call: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _doctorItem(Map<String, String> doctor, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 232, 253, 255).withOpacity(0.4),
                  Color.fromARGB(255, 216, 255, 228).withOpacity(0.4),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.3),
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctor["name"] ?? "",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        doctor["specialty"] ?? "",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.phone,
                            color: Colors.white70,
                            size: 16,
                          ),
                          SizedBox(width: 8),
                          Text(
                            doctor["phone"] ?? "",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.call, color: Colors.green),
                  onPressed: () {
                    _makePhoneCall(doctor["phone"] ?? "");
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Doctors Directory"),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Expanded(
                  child: doctors.isEmpty
                      ? Center(
                          child: Text(
                            "No doctors available.",
                            style: TextStyle(
                              color: const Color.fromARGB(179, 0, 0, 0),
                              fontSize: 16,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: doctors.length,
                          itemBuilder: (ctx, index) {
                            return _doctorItem(doctors[index], index);
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
