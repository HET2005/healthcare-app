import 'dart:ui';
import 'package:flutter/material.dart';

class MedicineListScreen extends StatefulWidget {
  const MedicineListScreen({super.key});

  @override
  _MedicineListScreenState createState() => _MedicineListScreenState();
}

class _MedicineListScreenState extends State<MedicineListScreen> {
  List<Map<String, String>> medicines = [
    {"name": "Paracetamol", "dosage": "500mg - Twice a day"},
    {"name": "Vitamin D", "dosage": "1000 IU - Once a day"},
    {"name": "Ibuprofen", "dosage": "200mg - After meals"},
  ];

  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();

  void _addMedicine() {
    _nameController.clear();
    _dosageController.clear();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Add New Medicine'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "Medicine Name"),
            ),
            TextField(
              controller: _dosageController,
              decoration: InputDecoration(labelText: "Dosage"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              final name = _nameController.text.trim();
              final dosage = _dosageController.text.trim();
              if (name.isNotEmpty && dosage.isNotEmpty) {
                setState(() {
                  medicines.add({"name": name, "dosage": dosage});
                });
                Navigator.of(ctx).pop();
              }
            },
            child: Text("Add"),
          ),
        ],
      ),
    );
  }

  void _deleteMedicine(int index) {
    setState(() {
      medicines.removeAt(index);
    });
  }

  Widget _medicineItem(Map<String, String> med, int index) {
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
                  Color(0xFF80F6FF).withOpacity(0.4),
                  Color(0xFF69EC91).withOpacity(0.4),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        med["name"] ?? "",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        med["dosage"] ?? "",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () => _deleteMedicine(index),
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
        title: Text("Medicine List"),
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
                  child: medicines.isEmpty
                      ? Center(
                          child: Text(
                            "No medicines added yet.",
                            style: TextStyle(
                              color: const Color.fromARGB(179, 0, 0, 0),
                              fontSize: 16,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: medicines.length,
                          itemBuilder: (ctx, index) {
                            return _medicineItem(medicines[index], index);
                          },
                        ),
                ),
                SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: _addMedicine,
                  icon: Icon(Icons.add),
                  label: Text("Add Medicine"),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor: const Color.fromARGB(255, 0, 2, 2),
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
