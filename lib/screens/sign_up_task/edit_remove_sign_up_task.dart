// Contributors: Richard N.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tasklocal/screens/sign_up_task/edit_sign_up_page.dart';

class EditRemoveSignUpTask extends StatefulWidget {
  const EditRemoveSignUpTask({super.key});

  @override
  State<EditRemoveSignUpTask> createState() => _EditRemoveSignUpTaskState();
}

class _EditRemoveSignUpTaskState extends State<EditRemoveSignUpTask> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

    Future<void> _handleEditTaskResult(bool dataChanged) async {
    if (dataChanged) {
      setState(() {});
    }
  }

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
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                    //   child: Text(
                    //     categoryName,
                    //     style: TextStyle(
                    //       fontWeight: FontWeight.bold,
                    //       fontSize: 24,
                    //     ),
                    //   ),
                    // ),
                    ListView.builder(
                      shrinkWrap: true,
                      // physics: NeverScrollableScrollPhysics(),
                      itemCount: taskDocs.length,
                      itemBuilder: (context, index) {
                        final taskData = taskDocs[index];
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Container(
                            // color: Colors.blue,
                            child: ListTile(
                              // default padding
                              minVerticalPadding: 0,
                              contentPadding: EdgeInsets.all(0),
                              title: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(categoryName, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,)),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Location: ${taskData['location']}', style: TextStyle(fontSize: 16)),
                                    Text('Asking Rate: ${taskData['askingRate']}', style: TextStyle(fontSize: 16)),
                                    Text('Experience: ${taskData['experience']}', style: TextStyle(fontSize: 16)),
                                    Text('Skills: ${taskData['skills']}', style: TextStyle(fontSize: 16)),
                                  ],
                                ),
                              ),
                              trailing: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => EditSignUpPage(taskData: taskData, categoryName: categoryName),
                                          ),
                                          // receive the result from the EditSignUpPage to see if any changes occurred
                                        ).then((dataChanged) {
                                          // Handle the result when returning from EditSignUpPage
                                          _handleEditTaskResult(dataChanged);
                                        });
                                        // // Handle the result when returning from EditSignUpPage
                                        // _handleEditTaskResult(true);
                                      },
                                    ),
                                    IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                bool confirmed = await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Confirm Deletion'),
                    content: Text('Are you sure you want to delete this task?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: Text('Delete'),
                      ),
                    ],
                  ),
                );
                if (confirmed == true) {
                  try {
                    final taskDocRef = _firestore.collection('Taskers')
                                                    .doc(_auth.currentUser!.email)
                                                    .collection('Signed Up Tasks')
                                                    .doc(categoryName);
                    final taskCategoryDocRef = _firestore.collection('Task Categories')
                                                            .doc(categoryName)
                                                            .collection('Signed Up Taskers')
                                                            .doc(_auth.currentUser!.email);
                    await taskDocRef.delete();
                    await taskCategoryDocRef.delete();

                    // Update UI
                    setState(() {
                      taskDocs.removeAt(index);
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Task deleted successfully.'),
                      ),
                    );
                  } catch (error) {
                    print('Error deleting document: $error');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('An error occurred while deleting the task.'),
                      ),
                    );
                  }
                }
              },
            ),
                                  ],
                                ),
                              ),
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