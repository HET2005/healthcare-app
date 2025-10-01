import 'package:flutter/material.dart';

class AboutMeScreen extends StatefulWidget {
  const AboutMeScreen({super.key});

  @override
  _AboutMeScreenState createState() => _AboutMeScreenState();
}

class _AboutMeScreenState extends State<AboutMeScreen> {
  bool _isEditing = false;

  // Sample data fields
  String age = "30";
  String weight = "70 kg";
  String contact = "+1 234 567 8901";
  String emergencyNumber = "+1 987 654 3210";
  String bloodGroup = "O+";
  String allergies = "None";

  // Controllers for editing
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _contactController = TextEditingController();
  final _emergencyController = TextEditingController();
  final _bloodGroupController = TextEditingController();
  final _allergiesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing data
    _ageController.text = age;
    _weightController.text = weight;
    _contactController.text = contact;
    _emergencyController.text = emergencyNumber;
    _bloodGroupController.text = bloodGroup;
    _allergiesController.text = allergies;
  }

  void _toggleEdit() {
    if (_isEditing) {
      // Save data on finishing edits
      setState(() {
        age = _ageController.text.trim();
        weight = _weightController.text.trim();
        contact = _contactController.text.trim();
        emergencyNumber = _emergencyController.text.trim();
        bloodGroup = _bloodGroupController.text.trim();
        allergies = _allergiesController.text.trim();
        _isEditing = false;
      });
    } else {
      setState(() {
        _isEditing = true;
      });
    }
  }

  Widget _buildRow(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: _isEditing
          ? TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: label,
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white.withOpacity(0.9),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "$label:",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(controller.text),
              ],
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About Me"),
        actions: [
          TextButton(
            onPressed: _toggleEdit,
            child: Text(
              _isEditing ? "Save" : "Edit",
              style: TextStyle(
                color: Colors.black87,
                fontSize: 16,
              ), // Dark text
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF80F6FF), Color(0xFF69EC91)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRow("Age", _ageController),
                  _buildRow("Weight", _weightController),
                  _buildRow("Contact Number", _contactController),
                  _buildRow("Emergency Number", _emergencyController),
                  _buildRow("Blood Group", _bloodGroupController),
                  _buildRow("Allergies", _allergiesController),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
