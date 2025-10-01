import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class MedicineAlarmScreen extends StatefulWidget {
  const MedicineAlarmScreen({super.key});

  @override
  _MedicineAlarmScreenState createState() => _MedicineAlarmScreenState();
}

class _MedicineAlarmScreenState extends State<MedicineAlarmScreen> {
  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  List<Map<String, dynamic>> alarms = [];
  int _nextAlarmId = 1;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    tz.initializeTimeZones();
    await _requestPermissions();
    
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    
    await _notifications.initialize(initializationSettings);

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'medicine_alarms_v2',
      'Medicine Alarms',
      description: 'Notifications for medicine reminders',
      importance: Importance.high,
    );
    final androidPlugin = _notifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(channel);
  }

  Future<void> _requestPermissions() async {
    final androidPlugin = _notifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.requestNotificationsPermission();
    await androidPlugin?.requestExactAlarmsPermission();
  }

  Future<void> _showDateTimePicker() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        final DateTime alarmDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        if (alarmDateTime.isAfter(DateTime.now())) {
          _addAlarm(alarmDateTime);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Please select a future date and time"),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _addAlarm(DateTime alarmDateTime) {
    final String alarmId = _nextAlarmId.toString();
    _nextAlarmId++;

    setState(() {
      alarms.add({
        'id': alarmId,
        'title': 'Medicine Reminder',
        'dateTime': alarmDateTime,
        'isActive': true,
      });
    });

    _scheduleNotification(alarmId, alarmDateTime);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Alarm set for ${_formatDateTime(alarmDateTime)}"),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _scheduleNotification(String alarmId, DateTime alarmDateTime) async {
    await _notifications.zonedSchedule(
      int.parse(alarmId),
      'Medicine Reminder',
      'Time to take your medicine!',
      tz.TZDateTime.from(alarmDateTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'medicine_alarms_v2',
          'Medicine Alarms',
          channelDescription: 'Notifications for medicine reminders',
          importance: Importance.high,
          priority: Priority.high,
          // Use default sound to avoid missing raw resource issues
        ),
        iOS: DarwinNotificationDetails(
          sound: 'alarm.wav',
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  void _deleteAlarm(int index) {
    final alarm = alarms[index];
    _notifications.cancel(int.parse(alarm['id']));
    
    setState(() {
      alarms.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Alarm deleted"),
        backgroundColor: Colors.orange,
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return "${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
  }

  Widget _alarmItem(Map<String, dynamic> alarm, int index) {
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
              children: [
                Icon(
                  Icons.alarm,
                  color: Colors.white,
                  size: 24,
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        alarm['title'],
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        _formatDateTime(alarm['dateTime']),
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteAlarm(index),
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
        title: Text("Medicine Alarms"),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF80F6FF), Color(0xFF69EC91)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Expanded(
                  child: alarms.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.alarm_off,
                                size: 64,
                                color: Colors.white.withOpacity(0.7),
                              ),
                              SizedBox(height: 16),
                              Text(
                                "No alarms set",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Tap the + button to add an alarm",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: alarms.length,
                          itemBuilder: (ctx, index) {
                            return _alarmItem(alarms[index], index);
                          },
                        ),
                ),
                SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _showDateTimePicker,
                  icon: Icon(Icons.add_alarm),
                  label: Text("Add Alarm"),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
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
