import 'package:flutter/material.dart';

class TaskerTasks extends StatefulWidget {
  const TaskerTasks({super.key});

  @override
  State<TaskerTasks> createState() => _TaskerTasksState();
}

class _TaskerTasksState extends State<TaskerTasks> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.green[800],
      appBar: AppBar(
        title: Text('My Tasks', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 32)),
        centerTitle: true,
        //backgroundColor: Colors.green[800],
      ),
      body: Center(
        child: Text(
          "Work in Progress",
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
