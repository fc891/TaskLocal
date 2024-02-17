import 'package:flutter/material.dart';

class TaskerPostService extends StatefulWidget {
  const TaskerPostService({super.key});

  @override
  State<TaskerPostService> createState() => _TaskerPostServiceState();
}

class _TaskerPostServiceState extends State<TaskerPostService> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[800],
      appBar: AppBar(
        title: Text('Post Service', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 32)),
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
