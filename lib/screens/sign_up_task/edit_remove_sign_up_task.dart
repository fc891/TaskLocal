// Contributors: Richard N.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignedUpTask extends StatefulWidget {
  const SignedUpTask({super.key});

  @override
  State<SignedUpTask> createState() => _SignedUpTaskState();
}

class _SignedUpTaskState extends State<SignedUpTask> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, List<DocumentSnapshot>>>(
        future: _fetchSignedUpTasks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final Map<String, List<DocumentSnapshot>> tasksByCategory = snapshot.data!;
            return ListView.builder(
              itemCount: tasksByCategory.length,
              itemBuilder: (context, index) {
                final categoryName = tasksByCategory.keys.toList()[index];
                final taskDocs = tasksByCategory[categoryName]!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(0),
                      child: Text(
                        categoryName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      // physics: NeverScrollableScrollPhysics(),
                      itemCount: taskDocs.length,
                      itemBuilder: (context, index) {
                        final taskData = taskDocs[index];
                        return Container(
                          color: Colors.blue,
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('location: ${taskData['location']}'),
                                Text('Asking Rate: ${taskData['askingRate']}'),
                                Text('Experience: ${taskData['experience']}'),
                                Text('Skills: ${taskData['skills']}'),
                              ],
                            ),
                            // leading: Icon(Icons.location_on), // Example of using a leading icon
                            trailing: IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                // Action to perform when the trailing icon is pressed
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<Map<String, List<DocumentSnapshot>>> _fetchSignedUpTasks() async {
    final taskerSignedUpTask = await _firestore.collection('Taskers').doc(_auth.currentUser!.email).collection('Signed Up Tasks').get();

    final tasksByCategory = <String, List<DocumentSnapshot>>{};

    for (final taskCategoryDoc in taskerSignedUpTask.docs) {
      final taskData = taskCategoryDoc.data();
      final categoryName = taskData['task category'];
      // go to task category doc in Task Categories collection
      final taskCategoryDocRef = _firestore.collection('Task Categories').doc(categoryName);
      // go to the Signed Up Taskers collection (from Task Categories Collection) which stores info of taskers sign up
      final taskDocs = await taskCategoryDocRef.collection('Signed Up Taskers')
                                              .where('email', isEqualTo: _auth.currentUser!.email)
                                              .get();
      // if categroy name is not stored in list, then create the key and assign it an empty list.
      if (!tasksByCategory.containsKey(categoryName)) {
        tasksByCategory[categoryName] = [];
      }
      tasksByCategory[categoryName]!.addAll(taskDocs.docs);
    }

    return tasksByCategory;
  }
}