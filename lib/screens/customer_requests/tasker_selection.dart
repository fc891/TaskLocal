// Contributors: Eric C.

import 'package:flutter/material.dart';
// import 'package:tasklocal/Screens/customer_requests/address_input.dart';
import 'package:tasklocal/Screens/profiles/taskerprofilepage.dart';

class TaskerSelectionPage extends StatefulWidget {
  const TaskerSelectionPage({Key? key}) : super(key: key);

  @override
  _TaskerSelectionPageState createState() => _TaskerSelectionPageState();
}

class _TaskerSelectionPageState extends State<TaskerSelectionPage> {
  TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Years of Experience (Most to Least)'; // Default filter option
  List<String> _filterOptions = [
    'Years of Experience (Most to Least)',
    'Location (Closest to Farthest)',
    'Price (Highest to Lowest)',
    'Rating (Highest to Lowest)',
  ];

  void _navigateToTaskerProfilePage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskerProfilePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> taskers = [
      {
        "name": "Tasker 1",
        "description":
            "Join Date: 01-02-2023\nTasks Completed: 10\nRating: 4.5, \nBiography: Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
      },
      {
        "name": "Tasker 2",
        "description":
            "Join Date: 15-05-2022\nTasks Completed: 20\nRating: 4.8, \nBiography: Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
      },
      {
        "name": "Tasker 3",
        "description":
            "Join Date: 15-03-2019\nTasks Completed: 25\nRating: 4.3, \nBiography: Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
      },
      {
        "name": "Tasker 4",
        "description":
            "Join Date: 19-02-2024\nTasks Completed: 5\nRating: 4.0, \nBiography: Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
      },
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
                  border: Border.all(color: Colors.grey),
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
        color: Colors.white,
        child: ListView.builder(
          itemCount: taskers.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(taskers[index]["name"]),
              subtitle: Text(taskers[index]["description"]),
              leading: CircleAvatar(
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
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Filter by:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Center(
                child: DropdownButton<String>(
                  value: _selectedFilter,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedFilter = newValue!;
                    });
                  },
                  items: _filterOptions
                      .map<DropdownMenuItem<String>>((String value) {
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
                  _applyFilters();
                  Navigator.pop(context);
                },
                child: Text('Apply Filters'),
              ),
            ],
          ),
        );
      },
    );
  }

  // ! Work for Feb. 25 - Mar. 2
  void _applyFilters() {
  // Implement filter/sort functionality based on selected filter (_selectedFilter)
  // ! Retrieve real tasker data from the database and apply filters
  
    switch (_selectedFilter) {
      case 'Years of Experience':
        // taskers.sort((a, b) => a.experience.compareTo(b.experience));
        break;
      case 'Location Proximity':
        // taskers = taskers.where((tasker) => tasker.distance <= MAX_DISTANCE).toList();
        break;
      case 'Price Range':
        // taskers = taskers.where((tasker) => tasker.price >= MIN_PRICE && tasker.price <= MAX_PRICE).toList();
        break;
      case 'Rating/Reviews':
        // taskers.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      default:
        break;
    }
  }
}
