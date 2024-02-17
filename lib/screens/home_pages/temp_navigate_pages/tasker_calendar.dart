import 'package:flutter/material.dart';

class TaskerCalendar extends StatefulWidget {
  const TaskerCalendar({super.key});

  @override
  State<TaskerCalendar> createState() => _TaskerCalendarState();
}

class _TaskerCalendarState extends State<TaskerCalendar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[800],
      appBar: AppBar(
        title: Text('Calendar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 32)),
        centerTitle: true,
        backgroundColor: Colors.green[800],
      ),
      body: Center(
        child: Text(
          "Work in Progress",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
