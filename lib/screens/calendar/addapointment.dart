import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class AddAppointment extends StatefulWidget {
  const AddAppointment({Key? key}) : super(key: key);
  @override
  State<AddAppointment> createState() => _CalendarFrontState();
}

class _CalendarFrontState extends State<AddAppointment> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
    }
  }


  void _addAppointment() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Appointment'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
        backgroundColor: Colors.green[500],
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: TableCalendar(
                focusedDay: _focusedDay,
                firstDay: DateTime.utc(2024, 1, 1),
                lastDay: DateTime.utc(2030, 1, 1),
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                calendarFormat: _calendarFormat,
                startingDayOfWeek: StartingDayOfWeek.monday,
                onDaySelected: _onDaySelected,
                calendarStyle: CalendarStyle(
                  outsideDaysVisible: false,
                ),
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
              ),
            ),
          ),
          SizedBox(height: 8.0),
          ElevatedButton(
            onPressed: _addAppointment,
            child: Text('Add Appointment'),
          ),
        ],
      ),
    );
  }
}