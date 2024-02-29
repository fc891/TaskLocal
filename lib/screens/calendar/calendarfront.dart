import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tasklocal/screens/calendar/addapointment.dart';
import 'package:tasklocal/screens/calendar/setavailability.dart';
import 'package:tasklocal/screens/calendar/viewschedule.dart';

class CalendarFront extends StatefulWidget {
  const CalendarFront({Key? key}) : super(key: key);
  @override
  State<CalendarFront> createState() => _CalendarFrontState();
}

class _CalendarFrontState extends State<CalendarFront> {
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
          SizedBox(height: 100),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: DropdownButton<String>(
              items: <String>['Add Appointment', 'Set Availability', 'View Schedule']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? value) {
                if (value == 'Add Appointment') {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddAppointment()));
                } else if (value == 'Set Availability') {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SetAvailability()));
                } else if (value == 'View Schedule') {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ViewSchedule()));
                }
              },
              hint: Text('Select an option'),
            ),
          ),
        ],
      ),
    );
  }
}