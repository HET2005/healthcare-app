import 'package:flutter/material.dart';

class MedicineAlarmScreen extends StatelessWidget {
  const MedicineAlarmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Medicine Alarm")),
      body: Center(child: Text("Medicine Alarm Screen")),
    );
  }
}
