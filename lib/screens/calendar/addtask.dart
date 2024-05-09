import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tasklocal/screens/calendar/calendartheme.dart';
import 'package:tasklocal/screens/calendar/taskinputfield.dart';
import 'package:tasklocal/screens/calendar/viewschedulebutton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tasklocal/screens/notifications/notification_services.dart';

// create class
class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  // create controller's for title and note to place into database 
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  // to set date and time to current
  DateTime _selectedDate = DateTime.now();
  // format date to be current date 
  String _dateHint = DateFormat.yMd().format(DateTime.now());
  // format start time to be current time
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  // static time for end time 
  String _endTime = "5:00 PM";
  // create variable for reminder
  int _selectedRemind = 5;
  // create list with different reminder times
  List<int> timeReminder = [5, 10, 15, 20, 25, 30];
  // create variable for color
  int _selectedColor = 0;

  // build layout
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // header
              Text(
                "Add Task",
                style: currentdayheading,
              ),
              // create title for task
              TaskInputField(
                title: "Title",
                hint: "Enter your Task",
                controller: _titleController,
              ),
              // create note for task
              TaskInputField(
                title: "Note",
                hint: "Enter any Notes",
                controller: _noteController,
              ),
              // allow tasker to select the date of the task
              TaskInputField(
                title: "Date",
                hint: _dateHint,
                widget: IconButton(
                  icon: Icon(Icons.calendar_today_outlined,
                      color: Colors.grey),
                  onPressed: () {
                    _getDate();
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                    // get the start time of the task
                    child: TaskInputField(
                        title: "Start Time",
                        hint: _startTime,
                        widget: IconButton(
                            onPressed: () {
                              _getTime(isStartTime: true);
                            },
                            icon: Icon(Icons.access_time_rounded,
                                color: Colors.grey))),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    // get the end time of the task
                    child: TaskInputField(
                        title: "End Time",
                        hint: _endTime,
                        widget: IconButton(
                            onPressed: () {
                              _getTime(isStartTime: false);
                            },
                            icon: Icon(Icons.access_time_rounded,
                                color: Colors.grey))),
                  ),
                ],
              ),
              // allow tasker to select how many minutes before they get notififed
              TaskInputField(
                title: "Remind",
                hint: "$_selectedRemind minutes before",
                widget: DropdownButton(
                  icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                  iconSize: 32,
                  elevation: 4,
                  style: subtitle,
                  underline: Container(height: 0),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRemind = int.parse(newValue!);
                    });
                  },
                  items: timeReminder
                      .map<DropdownMenuItem<String>>((int value) {
                    return DropdownMenuItem<String>(
                      value: value.toString(),
                      child: Text(value.toString(), style: TextStyle(color: Theme.of(context).colorScheme.tertiary)),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 130),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // allow tasker to color code their task
                      Text(
                        "Assign a Color to Task",
                        style: maintitle,
                      ),
                      SizedBox(height: 10),
                      Wrap(
                        children: List<Widget>.generate(
                          4,
                          (int index) {
                            Color color;
                            switch (index) {
                              case 0:
                                color = Color.fromARGB(255, 93, 182, 255);
                                break;
                              case 1:
                                color = Color.fromARGB(255, 255, 77, 64);
                                break;
                              case 2:
                                color = Color.fromARGB(255, 78, 247, 83);
                                break;
                              case 3:
                                color = Color.fromARGB(255, 239, 223, 80);
                                break;
                              default:
                                color = Colors.grey; 
                            }
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedColor = index;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: CircleAvatar(
                                  radius: 14,
                                  backgroundColor: color,
                                  child: _selectedColor == index
                                      ? Icon(Icons.done,
                                          color: Colors.white, size: 16)
                                      : Container(),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  // create the task and send to database
                  ViewScheduleButton(
                      label: "Create Task",
                      onTap: () => _validateDate(context)
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // accesses what the tasker filled out and inputs it into the database under the right tasker
  _validateDate(BuildContext context) async {
  if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // schedule the reminder notification
      DateTime startTime = DateFormat("hh:mm a").parse(_startTime);
      DateTime scheduledNotificationDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        startTime.hour,
        startTime.minute,
      ).subtract(Duration(minutes: _selectedRemind));

      // add the task to our database
      await FirebaseFirestore.instance.collection('Taskers').doc(user.email).collection('Tasks').add({
        'title': _titleController.text,
        'note': _noteController.text,
        'date': _selectedDate,
        'startTime': _startTime,
        'endTime': _endTime,
        'remind': _selectedRemind,
        'colorIndex': _selectedColor,
      });

      // schedule our notification
      NotificationService().scheduleNotification(
        user.hashCode, 
        "Task Reminder",
        "Your task ${_titleController.text} is starting in $_selectedRemind minutes.",
        scheduledNotificationDateTime
      );

      Navigator.of(context).pop();
    } 
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("All fields must be filled out"),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }
}



  // allow the user to select what date the task is to be completed on
  _getDate() async {
    DateTime? _pickerDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2023),
        lastDate: DateTime(2030));

    if (_pickerDate != null) {
      setState(() {
        _selectedDate = _pickerDate;
        _dateHint = DateFormat.yMd().format(_selectedDate);
        print(_selectedDate);
      });
    } else {
      print("error");
    }
  }

  // allow the tasker to select what time the task is to be completed
  _getTime({required bool isStartTime}) async {
    var _pickedTime = await _showTime(context);
    String _formatedTime = _pickedTime.format(context);
    if (_pickedTime == null) {
      print("error");
    } else if (isStartTime == true) {
      setState(() {
        _startTime = _formatedTime;
      });
    } else if (isStartTime == false) {
      setState(() {
        _endTime = _formatedTime;
      });
    }
  }

  // helps with formatting the time 
  _showTime(BuildContext context) async {
    var _pickedTime = await showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: TimeOfDay(
          hour: int.parse(_startTime.split(":")[0]),
          minute: int.parse(_startTime.split(":")[1].split(" ")[0])),
    );
    return _pickedTime;
  }
}
