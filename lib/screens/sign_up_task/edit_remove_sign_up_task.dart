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

    // update the UI, so it reflects the changes to the task info made by the user
    Future<void> _updateTaskInformation(bool updatedData) async {
    if (updatedData) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: FutureBuilder<Map<String, List<DocumentSnapshot>>>(
                future: _getSignedUpTasks(),
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
                    // a list contianing a list of the task categories from the user
                    final Map<String, List<DocumentSnapshot>> signedUpTasks = snapshot.data!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: signedUpTasks.entries.map((entry) {
                        final categoryName = entry.key;
                        final taskCategory = entry.value;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Padding(
                              //   padding: const EdgeInsets.all(8.0),
                              //   child: Text(
                              //     categoryName,
                              //     style: TextStyle(
                              //       fontSize: 18,
                              //       fontWeight: FontWeight.bold,
                              //     ),
                              //   ),
                              // ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: taskCategory.length,
                                itemBuilder: (context, index) {
                                  final taskData = taskCategory[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    // display the information of the signed up task in a ListTile
                                    child: Container(
                                      // color: Colors.blue,
                                      child: ListTile(
                                        // default padding
                                        minVerticalPadding: 0,
                                        contentPadding: EdgeInsets.all(0),
                                        title: Padding(
                                          padding: const EdgeInsets.only(left: 20.0),
                                          child: Text(
                                            categoryName, 
                                            style: TextStyle(
                                              fontSize: 18, 
                                              fontWeight: FontWeight.bold,
                                            )
                                          ),
                                        ),
                                        subtitle: Padding(
                                          padding: const EdgeInsets.only(left: 20.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('Location: ${taskData['location']}', style: TextStyle(fontSize: 16,)),
                                              // Text('${taskData['location']}', style: TextStyle(fontSize: 16)),
                                              Text('Asking Rate: ${taskData['askingRate']}', style: TextStyle(fontSize: 16)),
                                              Text('Experience: ${taskData['experience']}', style: TextStyle(fontSize: 16)),
                                              Text('Skills: ${taskData['skills'].join(', ')}', style: TextStyle(fontSize: 16)),
                                            ],
                                          ),
                                        ),
                                        // buttons for the user to edit and remove the signed up task
                                        trailing: Padding(
                                          padding: const EdgeInsets.only(right: 8.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              // allow user to edit the task
                                              IconButton(
                                                icon: Icon(Icons.edit),
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => EditSignUpPage(taskData: taskData, categoryName: categoryName),
                                                    ),
                                                    // receive the result from the EditSignUpPage to see if any changes occurred
                                                  ).then((updatedData) {
                                                    // Handle the result when returning from EditSignUpPage
                                                    _updateTaskInformation(updatedData);
                                                  });
                                                },
                                              ),
                                              // allow user to remove the task
                                              IconButton(
                                                icon: Icon(Icons.delete),
                                                onPressed: () async {
                                                  // give user a warning if they really want to delete the task category
                                                  bool confirmed = await showDialog(
                                                    context: context,
                                                    builder: (context) => AlertDialog(
                                                      title: Text('Confirm Deletion'),
                                                      content: Text('Are you sure you want to remove your signed up task category?'),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () => Navigator.of(context).pop(true),
                                                          child: Text('Delete'),
                                                        ),
                                                        TextButton(
                                                          onPressed: () => Navigator.of(context).pop(false),
                                                          child: Text('Cancel'),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                  // proceed with the removal process if true
                                                  if (confirmed == true) {
                                                    try {
                                                      // removing from two collection, one is stored for the public and the other for the user 
                                                      final signedUpIndividual = _firestore.collection('Taskers').doc(_auth.currentUser!.email)
                                                                        .collection('Signed Up Tasks').doc(categoryName);
                                                      final signedUpGeneral = _firestore.collection('Task Categories').doc(categoryName)
                                                                                .collection('Signed Up Taskers').doc(_auth.currentUser!.email);
                                                      await signedUpIndividual.delete();
                                                      await signedUpGeneral.delete();
                                                      // update the UI
                                                      setState(() {
                                                        taskCategory.removeAt(index);
                                                      });
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        SnackBar(
                                                          content: Text('Signed up task removed successfully.'),
                                                        ),
                                                      );
                                                    } catch (error) {
                                                      // print('There was an error deleting the signed up task: $error');
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        SnackBar(
                                                          content: Text('An error occurred while removing the task.'),
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
                    }).toList(),
                  );
                }
              },
            ),
          ),
        );
      },
    ),
  );
}

  // retrieves the task categories that the user signed up for
  Future<Map<String, List<DocumentSnapshot>>> _getSignedUpTasks() async {
    // access the collection that stores user's signed up tasks
    final taskerSignedUpTask = await _firestore.collection('Taskers').doc(_auth.currentUser!.email).collection('Signed Up Tasks').get();
    final taskCategoryList = <String, List<DocumentSnapshot>>{};

    // go through the collection of signed up task to view each task document
    for (final taskCategory in taskerSignedUpTask.docs) {
      final taskData = taskCategory.data();
      final categoryName = taskData['task category'];
      // go to task category doc in Task Categories collection
      final taskCategory2 = _firestore.collection('Task Categories').doc(categoryName);
      // go to the Signed Up Taskers collection (from Task Categories Collection) which stores info of taskers sign up
      final tasker = await taskCategory2.collection('Signed Up Taskers').where('email', isEqualTo: _auth.currentUser!.email).get();
      // if categroy name is not stored in list, then create the key and assign it an empty list.
      if (!taskCategoryList.containsKey(categoryName)) {
        taskCategoryList[categoryName] = [];
      }
      taskCategoryList[categoryName]!.addAll(tasker.docs);
    }
    return taskCategoryList;
  }
}