// Contributors: Eric C.

// TODO: Change the collection taskers are pulled from ("Signed Up Tasks" collection)

// TODO: After, display the tasker's information (Task Categories -> docs -> Signed Up Tasks -> tasker emails -> fields)

import 'package:firebase_auth/firebase_auth.dart';
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
          stream: FirebaseFirestore.instance.collection('Task Categories').snapshots(),
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
                  trailing: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      // Add tasker to "My Taskers"
                      _addTaskerToMyTaskers(taskerData);
                    },
                  ),
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

  void _addTaskerToMyTaskers(Map<String, dynamic> taskerData) {
    String email = taskerData['email']; // Assuming 'email' is a field in your tasker data

    // Get the currently logged-in user's email
    String currentUserEmail = FirebaseAuth.instance.currentUser!.email!;

    // Check if the document for the logged-in customer exists in the "Customers" collection
    FirebaseFirestore.instance.collection('Customers').doc(currentUserEmail).get().then((docSnapshot) {
      // If the document exists, proceed to check if the "Selected Taskers" collection exists within it
      if (docSnapshot.exists) {
        FirebaseFirestore.instance.collection('Customers').doc(currentUserEmail).collection('Selected Taskers').doc().get().then((collectionSnapshot) {
          // If the collection doesn't exist, create it
          if (!collectionSnapshot.exists) {
            FirebaseFirestore.instance.collection('Customers').doc(currentUserEmail).collection('Selected Taskers').doc();
          }

          // Add tasker data to Firestore under "Selected Taskers" collection within the customer's document
          FirebaseFirestore.instance.collection('Customers').doc(currentUserEmail).collection('Selected Taskers').doc(email).set({
            'name': taskerData['username'],
            'description': '${taskerData['first name']} ${taskerData['last name']}',
            'email': email, // Include email in Firestore document
            // Add other necessary tasker data fields
          }).then((value) {
            // Show success message or perform any other action upon successful addition
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Tasker added to My Taskers'),
              ),
            );
          }).catchError((error) {
            // Show error message or perform any other action upon error
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to add tasker to My Taskers'),
              ),
            );
          });
        });
      }
    });
  }

  void _applyFilters() {
  // Implement filter/sort functionality based on selected filter (_selectedFilter)
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
