// Contributors: Eric C., 

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tasklocal/screens/reservations/confirmation.dart';

class ReservationFormScreen extends StatefulWidget {
  final Map<String, dynamic> taskerData;

  ReservationFormScreen({required this.taskerData});

  @override
  _ReservationFormScreenState createState() => _ReservationFormScreenState();
}

class _ReservationFormScreenState extends State<ReservationFormScreen> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay(hour: 9, minute: 0);
  String _taskDescription = '';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
                    return Center(child: Text('${index == 0 ? 12 : index}'));
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
                  children: List.generate(2, (index) => Center(child: Text('${index * 30}'))),
                ),
              ),
              Expanded(
                child: CupertinoPicker(
                  itemExtent: 40.0,
                  onSelectedItemChanged: (int index) {
                    setState(() {
                      _selectedTime = index == 1 ? TimeOfDay(hour: _selectedTime.hour + 12, minute: _selectedTime.minute) : TimeOfDay(hour: _selectedTime.hour - 12, minute: _selectedTime.minute);
                    });
                  },
                  children: const [Center(child: Text('AM')), Center(child: Text('PM'))],
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

  void _submitReservation() async {
    final DateTime reservationDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final user = FirebaseAuth.instance.currentUser;
    final customerData = await _firestore.collection('Customers').doc(user?.email).get();
    if (user != null) {
      final customerEmail = user.email;

      _firestore
          .collection('Reservations')
          .doc(customerEmail)
          .collection('All Pending Reservations')
          .add({
        'taskerEmail': widget.taskerData['email'],
        'customerEmail': customerEmail,
        'customerFirstName': customerData['first name'],
        'customerLastName': customerData['last name'],
        'customerUserName': customerData['username'],
        'taskAccepted': false,
        'taskRejected': false, // for tasker use (could be used for customer)
        'taskStarted': false, // for tasker use
        'date': reservationDateTime,
        'description': _taskDescription,
        'status': 'pending',
      }).then((value) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReservationConfirmationScreen(
              taskerData: widget.taskerData,
              selectedDate: _selectedDate,
              selectedTime: _selectedTime,
              taskDescription: _taskDescription,
            ),
          ),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to make a reservation: $error')));
      });
    } else {
      // Handle the case when the user is not logged in
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User not logged in. Please log in.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservation Form'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tasker: ${widget.taskerData['name'] ?? ''}', style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            Text('Select Date and Time:', style: TextStyle(fontSize: 16)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
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
                  child: Text('Select Date', style: TextStyle(color: Colors.black)),
                  style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.secondary),
                ),
                ElevatedButton(
                  onPressed: () => _selectTime(context),
                  child: Text('Select Time', style: TextStyle(color: Colors.black)),
                  style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.secondary),
                ),
              ],
            ),
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Task Description',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() => _taskDescription = value),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitReservation,
              child: Text('Submit Reservation', style: TextStyle(color: Colors.black)),  // Changed to black for visibility
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor, // background
              ),
            ),
          ],
        ),
      ),
    );
  }
}
