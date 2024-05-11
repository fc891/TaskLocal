// Contributors: Eric C., 

// to-do list
// add a pay rate, address, and task category for customer's budget for a task

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
  String _payRate = '';
  String _address = '';
  String _category = 'Furniture Assembly'; // Default category
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showModalBottomSheet<TimeOfDay>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height / 3,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.time,
            initialDateTime: DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
              _selectedTime.hour,
              _selectedTime.minute,
            ),
            use24hFormat: false,
            minuteInterval: 30,
            onDateTimeChanged: (DateTime dateTime) {
              setState(() {
                _selectedTime = TimeOfDay.fromDateTime(dateTime);
              });
            },
          ),
        );
      },
    );
  }

  bool _validateInputs() {
    if (_taskDescription.isEmpty || _payRate.isEmpty || _address.isEmpty || _category.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Missing Information'),
            content: Text('Please fill out all fields before submitting.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return false;
    }
    return true;
  }

  void _submitReservation() {
    if (!_validateInputs()) {
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    final customerData = await _firestore.collection('Customers').doc(user?.email).get();
    if (user != null) {
      final customerEmail = user.email;
      final DateTime reservationDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      _firestore
          .collection('Reservations')
          .doc(customerEmail)
          .collection('All Pending Reservations')
          .add({
        'taskerEmail': widget.taskerData['email'],
        'customerEmail': customerEmail,
        'date': reservationDateTime,
        'description': _taskDescription,
        'payRate': int.tryParse(_payRate) ?? 0,
        'address': _address,
        'categoryName': _category,
        'status': 'pending',
        'taskAccepted': false,
        'taskCompleted': false,
        'taskRejected': false,
        'taskStarted': false,
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
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User not logged in. Please log in.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> categories = [
      'Furniture Assembly', 'Mounting Services', 'Yard Work', 'Art Installations',
      'Cleaning Services', 'Computer Services', 'Delivery Services', 'Event Planning',
      'Fitness Training', 'Gardening Projects', 'Handyman Services', 'Moving Services',
      'Music Productions', 'Organization', 'Photography Projects', 'Smart Home Installation',
      'Tech Innovations', 'Wall Repair'
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Reservation Form'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tasker Details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Tasker: ${widget.taskerData['name']}', style: TextStyle(fontSize: 18)),
            Divider(height: 30),
            Text('Date and Time', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Selected Date: ${DateFormat('EEE, MMM d, yyyy').format(_selectedDate)}', style: TextStyle(fontSize: 18)),
            Text('Selected Time: ${_selectedTime.format(context)}', style: TextStyle(fontSize: 18)),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(Duration(days: 365)),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _selectedDate = pickedDate;
                        });
                      }
                    },
                    child: Text('Select Date', style: TextStyle(color: Colors.black)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _selectTime(context),
                    child: Text('Select Time', style: TextStyle(color: Colors.black)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
              ],
            ),
            Divider(height: 30),
            Text('Task Details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Task Description',
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
                hintStyle: TextStyle(color: Colors.black),
                labelStyle: TextStyle(color: Colors.black),
              ),
              style: TextStyle(color: Colors.black),
              onChanged: (value) => _taskDescription = value,
              maxLines: 3,
            ),
            SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Pay Rate (\$)',
                border: OutlineInputBorder(),
                prefixText: '\$ ',
                fillColor: Colors.white,
                filled: true,
                hintStyle: TextStyle(color: Colors.black),
                labelStyle: TextStyle(color: Colors.black),
              ),
              style: TextStyle(color: Colors.black),
              keyboardType: TextInputType.number,
              onChanged: (value) => _payRate = value,
            ),
            SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
                hintStyle: TextStyle(color: Colors.black),
                labelStyle: TextStyle(color: Colors.black),
              ),
              style: TextStyle(color: Colors.black),
              onChanged: (value) => _address = value,
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
                hintStyle: TextStyle(color: Colors.black),
                labelStyle: TextStyle(color: Colors.black),
              ),
              value: _category,
              style: TextStyle(color: Colors.black),
              items: categories.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _category = value;
                  });
                }
              },
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _submitReservation,
                child: Text('Submit Reservation', style: TextStyle(color: Colors.black)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
