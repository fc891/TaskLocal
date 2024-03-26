import 'package:flutter/material.dart';

class EditRemoveSignUpTask extends StatefulWidget {
  const EditRemoveSignUpTask({super.key});

  @override
  State<EditRemoveSignUpTask> createState() => _EditRemoveSignUpTaskState();
}

class _EditRemoveSignUpTaskState extends State<EditRemoveSignUpTask> {
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
