import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReservationConfirmationScreen extends StatelessWidget {
  final Map<String, dynamic> taskerData;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;

  ReservationConfirmationScreen({
    required this.taskerData,
    required this.selectedDate,
    required this.selectedTime,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservation Confirmation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tasker: ${taskerData['name'] ?? ''}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 16),
            Text(
              'Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Time: ${selectedTime.format(context)}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 32),
            Text(
              'Your reservation has been successfully created!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
