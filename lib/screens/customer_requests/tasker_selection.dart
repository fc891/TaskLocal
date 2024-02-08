import 'package:flutter/material.dart';
import 'package:tasklocal/Screens/customer_requests/tasker_overview.dart';

class TaskerSelectionPage extends StatefulWidget {
  const TaskerSelectionPage({Key? key}) : super(key: key);

  @override
  _TaskerSelectionPageState createState() => _TaskerSelectionPageState();
}

class _TaskerSelectionPageState extends State<TaskerSelectionPage> {
  void _navigateToTaskerOverviewPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskerOverviewPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Tasker'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'List of available taskers will be displayed here.',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _navigateToTaskerOverviewPage,
              child: Text('Select Tasker'),
            ),
          ],
        ),
      ),
    );
  }
}
