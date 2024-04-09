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
    final pickedTime = await showModalBottomSheet<TimeOfDay>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).copyWith().size.height / 3,
          child: Row(
            children: [
              Expanded(
                child: CupertinoPicker(
                  itemExtent: 40.0,
                  onSelectedItemChanged: (int index) {
                    setState(() {
                      _selectedTime = TimeOfDay(
                        hour: index % 12 == 0 ? 12 : index % 12,
                        minute: _selectedTime.minute,
                      );
                    });
                  },
                  children: List.generate(12, (index) {
                    final hour = index == 0 ? 12 : index;
                    return Center(
                      child: Text(
                        '${hour.toString().padLeft(2, '0')}',
                      ),
                    );
                  }),
                ),
              ),
              Expanded(
                child: CupertinoPicker(
                  itemExtent: 40.0,
                  onSelectedItemChanged: (int index) {
                    setState(() {
                      _selectedTime = TimeOfDay(
                        hour: _selectedTime.hour,
                        minute: index * 30,
                      );
                    });
                  },
                  children: List.generate(2, (index) {
                    final minute = index == 0 ? '00' : '30';
                    return Center(
                      child: Text(
                        '$minute',
                      ),
                    );
                  }),
                ),
              ),
              Expanded(
                child: CupertinoPicker(
                  itemExtent: 40.0,
                  onSelectedItemChanged: (int index) {
                    setState(() {
                      // toggle between AM and PM based on the selected index
                      if (index == 0 && _selectedTime.period == DayPeriod.pm) {
                        _selectedTime = TimeOfDay(hour: _selectedTime.hour - 12, minute: _selectedTime.minute);
                      } else if (index == 1 && _selectedTime.period == DayPeriod.am) {
                        _selectedTime = TimeOfDay(hour: _selectedTime.hour + 12, minute: _selectedTime.minute);
                      }
                    });
                  },
                  children: [
                    Center(child: Text('AM')),
                    Center(child: Text('PM')),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );

    if (pickedTime != null) {
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
                    child: Text(
                      'Select Date',
                      style: TextStyle(color: Colors.black), // Change text color to black
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      _selectTime(context);
                    },
                    child: Text(
                      'Select Time',
                      style: TextStyle(color: Colors.black), // Change text color to black
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
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
                child: Text(
                  'Submit Reservation',
                  style: TextStyle(color: Colors.black), // Change text color to black
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
