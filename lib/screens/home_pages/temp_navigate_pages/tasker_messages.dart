import 'package:flutter/material.dart';

class TaskerMessages extends StatefulWidget {
  const TaskerMessages({super.key});

  @override
  State<TaskerMessages> createState() => _TaskerMessagesState();
}

class _TaskerMessagesState extends State<TaskerMessages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[800],
      appBar: AppBar(
        title: Text('Messages', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 32)),
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
