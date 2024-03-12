import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tasklocal/screens/calendar/addtask.dart';
import 'package:tasklocal/screens/calendar/calendartheme.dart';
import 'package:tasklocal/screens/calendar/task_display.dart';
import 'package:tasklocal/screens/calendar/viewschedulebutton.dart'; 

// create class
class CalendarFeatures extends StatefulWidget {
  const CalendarFeatures({Key? key}) : super(key: key);

  @override
  _CalendarFeaturesState createState() => _CalendarFeaturesState();
}

class _CalendarFeaturesState extends State<CalendarFeatures> {
  DateTime _selectedDate = DateTime.now();
  // create list of maps to return the task
  Future<List<Map<String, dynamic>>> getTasksForDate(DateTime selectedDate) async {
    // empty list to store the task that are gathered from firebase
    List<Map<String, dynamic>> tasks = [];
    // get the start and end of the day of the date that tasker selected
    DateTime startOfDay = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    DateTime endOfDay = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 23, 59, 59);

    // get the task from firebase and add them to the list
    await FirebaseFirestore.instance
        .collection('Taskers')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection('Tasks')
        .where('date', isGreaterThanOrEqualTo: startOfDay)
        .where('date', isLessThanOrEqualTo: endOfDay)
        .get()
        .then((snapshot) => snapshot.docs.forEach((document) {
              tasks.add(document.data());
            }));

    return tasks;
  }

  // build layout
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // get the date of the selected date and display it in a certain format
                      Text(
                        DateFormat.yMMMMd().format(_selectedDate),
                        style: dateheading,
                      ),
                      // text displaying the day selected
                      Text(
                        "Selected Day",
                        style: currentdayheading,
                      ),
                    ],
                  ),
                ),
                // button to bring tasker to addtask page
                ViewScheduleButton(
                  label: "+ Add Task",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddTask()),
                    );
                  },
                ),
              ],
            ),
          ),
          // implement datepicker function for scrollable calendar
          Container(
            margin: const EdgeInsets.only(top: 20, left: 20),
            child: DatePicker(
              DateTime.now(),
              height: 100,
              width: 80,
              initialSelectedDate: DateTime.now(),
              selectionColor: Colors.blue,
              selectedTextColor: Colors.white,
              dateTextStyle: GoogleFonts.lato(
                textStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
              dayTextStyle: GoogleFonts.lato(
                textStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
              monthTextStyle: GoogleFonts.lato(
                textStyle: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
              onDateChange: (date) {
                setState(() {
                  _selectedDate = date;
                });
              },
            ),
          ),
          SizedBox(height: 16.0),
          // display the different task depending on day selected
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: getTasksForDate(_selectedDate),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No current task for selected date'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return TaskDisplay(
                        Task(
                          title: snapshot.data![index]['title'],
                          startTime: snapshot.data![index]['startTime'],
                          endTime: snapshot.data![index]['endTime'],
                          note: snapshot.data![index]['note'],
                          color: snapshot.data![index]['colorIndex'],
                          isCompleted: snapshot.data![index]['isCompleted'],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}