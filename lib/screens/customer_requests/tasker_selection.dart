// Contributors: Eric C.

// TODO: Change the collection taskers are pulled from ("Signed Up Tasks" collection)

// TODO: After, display the tasker's information (Task Categories -> docs -> Signed Up Tasks -> tasker emails -> fields)

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tasklocal/screens/profiles/taskerprofilepage.dart';

class TaskerSelectionPage extends StatefulWidget {
  final String jobCategory;

  const TaskerSelectionPage({Key? key, required this.jobCategory})
      : super(key: key);

  @override
  _TaskerSelectionPageState createState() => _TaskerSelectionPageState();
}

class _TaskerSelectionPageState extends State<TaskerSelectionPage> {
  TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Years of Experience (Most to Least)';
  List<String> _filterOptions = [
    'Years of Experience (Most to Least)',
    'Location (Closest to Farthest)',
    'Price (Highest to Lowest)',
    'Rating (Highest to Lowest)',
  ];

  late StreamController<QuerySnapshot> _streamController;

  @override
  void initState() {
    super.initState();
    _streamController = StreamController<QuerySnapshot>();
    // Initially, load the taskers data
    _loadTaskers();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  void _loadTaskers() {
    // Load taskers data without any filters
    FirebaseFirestore.instance
        .collection('Task Categories')
        .doc(widget.jobCategory)
        .collection('Signed Up Taskers')
        .snapshots()
        .listen((snapshot) {
      _streamController.add(snapshot);
    });
  }

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
                  style: TextStyle(color: Colors.black),
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
              icon: Icon(Icons.filter_list), // Change icon color to black
            ),
          ],
        ),
      ),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: _streamController.stream,
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

            List<DocumentSnapshot> taskers = snapshot.data!.docs;

            return ListView.builder(
              itemCount: taskers.length,
              itemBuilder: (BuildContext context, int index) {
                var taskerData = taskers[index].data() as Map<String, dynamic>;
                String firstName = taskerData['first name'] ?? '';
                String lastName = taskerData['last name'] ?? '';
                String email = taskerData['email'] ?? '';
                String askingRate = taskerData['askingRate'] ?? '';
                String experience = taskerData['experience'] ?? '';
                String location = taskerData['location'] ?? '';

                String name = (firstName.isNotEmpty || lastName.isNotEmpty)
                    ? '$firstName $lastName'
                    : 'No Name Available';

                return ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: TextStyle(color: Colors.white)),
                      Text('Asking Rate: $askingRate | Experience: $experience | Location: $location', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  subtitle: Text('Email: $email', style: TextStyle(color: Colors.white)),
                  trailing: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      _addTaskerToMyTaskers(taskerData);
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TaskerProfilePage(userEmail: email, isOwnProfilePage: false,)),
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
          color: Theme.of(context).colorScheme.tertiary,
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
                  dropdownColor: Theme.of(context).colorScheme.tertiary,
                  iconEnabledColor: Theme.of(context).colorScheme.secondary,
                  iconDisabledColor: Theme.of(context).colorScheme.secondary,
                  focusColor: Theme.of(context).colorScheme.secondary,
                  value: _selectedFilter,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedFilter = newValue!;
                    });
                    _applyFilters();
                  },
                  items: _filterOptions
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(
                            color: Colors.white), // Change text color to black
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Apply Filters',
                  style: TextStyle(
                      color: Colors.black), // Change text color to black
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _addTaskerToMyTaskers(Map<String, dynamic> taskerData) {
    String? email = taskerData['email'];
    if (email != null) {
      String currentUserEmail = FirebaseAuth.instance.currentUser!.email!;

      FirebaseFirestore.instance
          .collection('Customers')
          .doc(currentUserEmail)
          .collection('Selected Taskers')
          .doc(email)
          .set({
        'name': '${taskerData['first name'] ?? ''} ${taskerData['last name'] ?? ''}',
        'description':
            '${taskerData['first name'] ?? ''} ${taskerData['last name'] ?? ''}',
        'email': email,
      }).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Tasker added to My Taskers'),
          ),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add tasker to My Taskers'),
          ),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tasker email is missing'),
        ),
      );
    }
  }

  void _applyFilters() {
    // Implement filter/sort functionality based on selected filter (_selectedFilter)
    switch (_selectedFilter) {
      case 'Years of Experience (Most to Least)':
        setState(() {
          // Update the stream with the ordered query
          _streamController.sink.addStream(FirebaseFirestore.instance
              .collection('Task Categories')
              .doc(widget.jobCategory)
              .collection('Signed Up Taskers')
              .orderBy('experience', descending: true)
              .snapshots());
        });
        break;
      case 'Location (Closest to Farthest)':
        // Implement filtering logic
        break;
      case 'Price (Highest to Lowest)':
        setState(() {
          // Update the stream with the ordered query
          _streamController.sink.addStream(FirebaseFirestore.instance
              .collection('Task Categories')
              .doc(widget.jobCategory)
              .collection('Signed Up Taskers')
              .orderBy('askingRate', descending: true)
              .snapshots());
        });
        break;
      case 'Rating (Highest to Lowest)':
        // Implement filtering logic
        break;
      default:
        break;
    }
  }
}
