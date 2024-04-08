// Contributors: Eric C., 

// TODO: Route to/from tasker_details.dart, confirmation.dart

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:tasklocal/screens/reservations/confirmation.dart';

class ReservationFormScreen extends StatefulWidget {
  final Map<String, dynamic> taskerData;

  ReservationFormScreen({required this.taskerData});

  @override
  _ReservationFormScreenState createState() => _ReservationFormScreenState();
}

class _ReservationFormScreenState extends State<ReservationFormScreen> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).copyWith().size.height / 3,
          child: CupertinoTimerPicker(
            mode: CupertinoTimerPickerMode.hm,
            minuteInterval: 30, // Set minute interval to 30 minutes
            initialTimerDuration: Duration(
              hours: _selectedTime.hour,
              minutes: _selectedTime.minute,
            ),
            onTimerDurationChanged: (Duration duration) {
              setState(() {
                _selectedTime = TimeOfDay(
                  hour: duration.inHours,
                  minute: duration.inMinutes % 60,
                );
              });
            },
          ),
        );
      },
    );
    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservation Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tasker: ${widget.taskerData['name'] ?? ''}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 16),
            Text(
              'Select Date and Time:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(DateTime.now().year + 1),
                      );
                      if (pickedDate != null && pickedDate != _selectedDate) {
                        setState(() {
                          _selectedDate = pickedDate;
                        });
                      }
                    },
                    child: Text('Select Date'),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      _selectTime(context);
                    },
                    child: Text('Select Time'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Submit reservation form
                // Implement submission logic here
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReservationConfirmationScreen(
                      taskerData: widget.taskerData,
                      selectedDate: _selectedDate,
                      selectedTime: _selectedTime,
                    ),
                  ),
                );
              },
              child: Text('Submit Reservation'),
            ),
          ],
        ),
      ),
    );
  }
}
