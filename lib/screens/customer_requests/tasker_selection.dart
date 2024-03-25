// Contributors: Eric C.

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tasklocal/screens/profiles/taskerprofilepage.dart';

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

  @override
  Widget build(BuildContext context) {
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
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('Taskers').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            // Convert snapshot data to a list of taskers
            List<DocumentSnapshot> taskers = snapshot.data!.docs;

            return ListView.builder(
              itemCount: taskers.length,
              itemBuilder: (BuildContext context, int index) {
                // Access tasker data
                var taskerData = taskers[index].data() as Map<String, dynamic>;
                String username = taskerData['username'];
                String firstName = taskerData['first name'];
                String lastName = taskerData['last name'];

                return ListTile(
                  title: Text(username),
                  subtitle: Text('$firstName $lastName'),
                  onTap: () {
                    // Navigate to tasker profile page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TaskerProfilePage()),
                    );
                  },
                );
              },
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
