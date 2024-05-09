// Contributors: Eric C.,

// Use case #22 Manage Customer's List of Taskers

/* - remove 'active tasks' and just keep 'pending' tasks
   - when customer clicks on task, it takes to separate page with more info/actions
   - on first screen, display just task category, tasker name
   - on second screen, display task category, tasker name, task details, asking rate, reservation details

   - have different buttons show up when a task is pending vs accepted
   - grab from tasker (/Taskers/richard@gmail.com/Completed Tasks/xZBKvJS1fKl8VDzTlsRl)

   - do not allow customer to edit once a task is accepted by a tasker
*/

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // Import Cupertino widgets for iOS-style pickers
import 'package:intl/intl.dart';
import 'package:tasklocal/screens/messages/chat_page.dart';  // Ensure the import path is correct

class ManageTasks extends StatefulWidget {
  @override
  _ManageTasksState createState() => _ManageTasksState();
}

class _ManageTasksState extends State<ManageTasks> {
  PageController _pageController = PageController();
  int _currentPage = 0;

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay(hour: 9, minute: 0); // Default start time

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Your Tasks', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    _pageController.animateToPage(0, duration: Duration(milliseconds: 300), curve: Curves.ease);
                  },
                  child: Text(
                    'Active Tasks',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      decoration: _currentPage == 0 ? TextDecoration.underline : TextDecoration.none,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _pageController.animateToPage(1, duration: Duration(milliseconds: 300), curve: Curves.ease);
                  },
                  child: Text(
                    'Pending Tasks',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      decoration: _currentPage == 1 ? TextDecoration.underline : TextDecoration.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: [
                _buildActiveTasks(),
                _buildPendingTasks(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveTasks() {
    return ListView(
      children: [
        ListTile(
          title: Text('Active Task 1', style: TextStyle(color: Colors.white)),
          subtitle: Text('Details of active task 1', style: TextStyle(color: Colors.white)),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.check_circle, color: Colors.green),
                onPressed: () => _showCompleteConfirmationDialog('Active Task 1'),
              ),
              IconButton(
                icon: Icon(Icons.message, color: Colors.white),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(
                      receiverFirstName: 'John',
                      receiverLastName: 'Doe',
                      receiverEmail: 'johndoe@example.com',
                      taskersOrCustomersCollection: 'users',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Repeat for other active tasks...
      ],
    );
  }

  Widget _buildPendingTasks() {
    return ListView(
      children: [
        ListTile(
          title: Text('Pending Task 1', style: TextStyle(color: Colors.white)),
          subtitle: Text('Details of pending task 1', style: TextStyle(color: Colors.white)),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.cancel, color: Colors.red),
                onPressed: () => _showCancelConfirmationDialog('Pending Task 1'),
              ),
              IconButton(
                icon: Icon(Icons.calendar_today, color: Colors.white),
                onPressed: () => _showDatePicker(context, 'Pending Task 1'),
              ),
              IconButton(
                icon: Icon(Icons.message, color: Colors.white),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(
                      receiverFirstName: 'Jane',
                      receiverLastName: 'Doe',
                      receiverEmail: 'janedoe@example.com',
                      taskersOrCustomersCollection: 'users',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Repeat for other pending tasks...
      ],
    );
  }

  void _showCancelConfirmationDialog(String taskName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cancel Reservation'),
          content: Text('Are you sure you want to cancel the reservation for $taskName?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                // Here you would add your logic to handle the cancellation
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showCompleteConfirmationDialog(String taskName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Complete Task'),
          content: Text('Are you sure you want to mark $taskName as complete?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context). pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                // Here you would add your logic to handle the task completion
                Navigator.of(context). pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDatePicker(BuildContext context, String taskName) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
      _showTimePicker(context, taskName);
    }
  }

  Future<void> _showTimePicker(BuildContext context, String taskName) async {
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
                        hour: index % 12 + 1,
                        minute: _selectedTime.minute,
                      );
                    });
                  },
                  children: List.generate(12, (index) {
                    return Center(
                      child: Text(
                        '${index + 1}',
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
                        minute: index * 30 % 60,
                      );
                    });
                  },
                  children: List.generate(2, (index) {
                    return Center(
                      child: Text(
                        '${index * 30}',
                      ),
                    );
                  }),
                ),
              ),
              Expanded(
                child: CupertinoPicker(
                  itemExtent: 40.0,
                  onSelectedItemChanged: (int index) {
                    bool isPM = index == 1;
                    int hour = _selectedTime.hour;
                    if (isPM && hour < 12) hour += 12;
                    if (!isPM && hour >= 12) hour -= 12;
                    setState(() {
                      _selectedTime = TimeOfDay(
                        hour: hour,
                        minute: _selectedTime.minute,
                      );
                    });
                  },
                  children: ['AM', 'PM']
                      .map((period) => Center(child: Text(period)))
                      .toList(),
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
      _confirmReschedule(taskName);
    }
  }

  void _confirmReschedule(String taskName) {
    final String formattedDateTime = DateFormat('yyyy-MM-dd – kk:mm').format(
      DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, _selectedTime.hour, _selectedTime.minute)
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Reschedule'),
          content: Text('Reschedule $taskName to $formattedDateTime?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Confirm'),
              onPressed: () {
                // Add logic to handle the reschedule
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
