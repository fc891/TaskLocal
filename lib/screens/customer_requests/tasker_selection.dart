// Contributors: Eric C.

import 'package:flutter/material.dart';
import 'package:tasklocal/Screens/customer_requests/address_input.dart';
import 'package:tasklocal/Screens/profiles/taskerprofilepage.dart';

// Eric's Code for TaskerSelectionPage class
class TaskerSelectionPage extends StatefulWidget {
  const TaskerSelectionPage({Key? key}) : super(key: key);

  @override
  _TaskerSelectionPageState createState() => _TaskerSelectionPageState();
}

class _TaskerSelectionPageState extends State<TaskerSelectionPage> {
  TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Proximity'; // Default filter option

  void _navigateToTaskerProfilePage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskerProfilePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Example list of taskers (replace this with your actual list of taskers)
    List<Map<String, dynamic>> taskers = [
      {
        "name": "Tasker 1",
        "description": "Join Date: 01-02-2023\nTasks Completed: 10\nRating: 4.5, \nBiography: Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
      },
      {
        "name": "Tasker 2",
        "description": "Join Date: 15-05-2022\nTasks Completed: 20\nRating: 4.8, \nBiography: Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
      },
      {
        "name": "Tasker 3",
        "description": "Join Date: 15-03-2019\nTasks Completed: 25\nRating: 4.3, \nBiography: Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
      },
      {
        "name": "Tasker 4",
        "description": "Join Date: 19-02-2024\nTasks Completed: 5\nRating: 4.0, \nBiography: Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
      },
      // Add more tasker profiles here
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey), // Added border
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search Taskers',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                _showFilterOptions();
              },
              icon: Icon(Icons.filter_list),
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.white, // Set background color to white
        child: ListView.builder(
          itemCount: taskers.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(taskers[index]["name"]),
              subtitle: Text(taskers[index]["description"]),
              leading: CircleAvatar(
                // You can add profile images for each tasker here
                child: Text('T${index + 1}'),
              ),
              onTap: _navigateToTaskerProfilePage,
            );
          },
        ),
      ),
    );
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: MediaQuery.of(context).size.width, // Set width to full screen width
          color: Colors.white, // Background color set to white
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Filter by:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Center( // Center the filter options
                child: DropdownButton<String>(
                  value: _selectedFilter,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedFilter = newValue!;
                    });
                  },
                  items: <String>[
                    'Proximity',
                    'Budget',
                    'Experience',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Implement filter/sort functionality here
                  Navigator.pop(context); // Close the bottom sheet
                },
                child: Text('Apply Filters'),
              ),
            ],
          ),
        );
      },
    );
  }
}
