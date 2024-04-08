// Contributors: Eric C., 

// TODO: Route to/from tasker_details.dart, reservation_form.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Widget for displaying reservation confirmation details
class ReservationConfirmationScreen extends StatelessWidget {
  // Data variables required for reservation confirmation
  final Map<String, dynamic> taskerData; // Tasker information
  final DateTime selectedDate; // Selected date for reservation
  final TimeOfDay selectedTime; // Selected time for reservation

  // Constructor for initializing data variables
  ReservationConfirmationScreen({
    required this.taskerData,
    required this.selectedDate,
    required this.selectedTime,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservation Confirmation'), // App bar title
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display Tasker's name
            Text(
              'Tasker: ${taskerData['name'] ?? ''}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 16), // Spacer
            // Display selected date
            Text(
              'Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}',
              style: TextStyle(fontSize: 18),
            ),
            // Display selected time
            Text(
              'Time: ${selectedTime.format(context)}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 32), // Spacer
            // Confirmation message
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
