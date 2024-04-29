import 'package:flutter/material.dart';

class ManageTasks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Tasks'),
      ),
      body: Center(
        child: Text('This is where customers can view current and pending tasks.'),
      ),
    );
  }
}
