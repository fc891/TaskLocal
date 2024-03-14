import 'package:flutter/material.dart';
import 'package:tasklocal/screens/home_pages/task_category.dart';

class SignUpTask extends StatefulWidget {
  final TaskCategory taskCategory;
  const SignUpTask({super.key, required this.taskCategory});

  @override
  State<SignUpTask> createState() => _SignUpTaskState();
}

class _SignUpTaskState extends State<SignUpTask> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[800],
      appBar: AppBar(
        title: Text(widget.taskCategory.name, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 32)),
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