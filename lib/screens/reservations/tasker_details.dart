import 'package:flutter/material.dart';
import 'package:tasklocal/screens/reservations/reservation_form.dart';

class TaskerDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> taskerData;

  TaskerDetailsScreen({required this.taskerData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasker Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              taskerData['name'] ?? '',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              taskerData['description'] ?? '',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReservationFormScreen(taskerData: taskerData),
                  ),
                );
              },
              child: Text('Create Reservation'),
            ),
          ],
        ),
      ),
    );
  }
}
