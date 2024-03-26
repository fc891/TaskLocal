import 'package:flutter/material.dart';

class StoreCompletedTask extends StatefulWidget {
  const StoreCompletedTask({super.key});

  @override
  State<StoreCompletedTask> createState() => _StoreCompletedTaskState();
}

class _StoreCompletedTaskState extends State<StoreCompletedTask> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Work in Progress",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
