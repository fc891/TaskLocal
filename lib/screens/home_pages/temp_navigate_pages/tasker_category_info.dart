import 'package:flutter/material.dart';
import 'package:tasklocal/screens/home_pages/task_category.dart';

class TaskerCategoryInfo extends StatefulWidget {
  final TaskCategory taskCategory;
  const TaskerCategoryInfo({super.key, required this.taskCategory});

  @override
  State<TaskerCategoryInfo> createState() => _TaskerCategoryInfoState();
}

class _TaskerCategoryInfoState extends State<TaskerCategoryInfo> {
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