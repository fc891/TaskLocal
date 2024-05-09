// Contributors: Eric C.,

// Use case #22 Manage Customer's List of Taskers

import 'package:flutter/material.dart';

class ManageTasks extends StatefulWidget {
  @override
  _ManageTasksState createState() => _ManageTasksState();
}

class _ManageTasksState extends State<ManageTasks> {
  PageController _pageController = PageController();
  int _currentPage = 0;

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
        ),
        ListTile(
          title: Text('Active Task 2', style: TextStyle(color: Colors.white)),
          subtitle: Text('Details of active task 2', style: TextStyle(color: Colors.white)),
        ),
        ListTile(
          title: Text('Active Task 3', style: TextStyle(color: Colors.white)),
          subtitle: Text('Details of active task 3', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Widget _buildPendingTasks() {
    return ListView(
      children: [
        ListTile(
          title: Text('Pending Task 1', style: TextStyle(color: Colors.white)),
          subtitle: Text('Details of pending task 1', style: TextStyle(color: Colors.white)),
          trailing: IconButton(
            icon: Icon(Icons.cancel, color: Colors.red),
            onPressed: () => _showCancelConfirmationDialog('Pending Task 1'),
          ),
        ),
        ListTile(
          title: Text('Pending Task 2', style: TextStyle(color: Colors.white)),
          subtitle: Text('Details of pending task 2', style: TextStyle(color: Colors.white)),
          trailing: IconButton(
            icon: Icon(Icons.cancel, color: Colors.red),
            onPressed: () => _showCancelConfirmationDialog('Pending Task 2'),
          ),
        ),
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
}
