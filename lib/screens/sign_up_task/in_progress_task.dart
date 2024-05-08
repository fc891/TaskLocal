// Contributors: Richard N.

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:tasklocal/screens/gps_services/current_location.dart';

class InProgressTask extends StatefulWidget {
  const InProgressTask({super.key});

  @override
  State<InProgressTask> createState() => _InProgressTaskState();
}

class _InProgressTaskState extends State<InProgressTask> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
                    final Map<String, List<DocumentSnapshot>> signedUpTasks =
                        snapshot.data!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: signedUpTasks.entries.map((entry) {
                        final categoryName = entry.key;
                        final taskCategory = entry.value;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: taskCategory.length,
                                itemBuilder: (context, index) {
                                  final taskData = taskCategory[index];
                                  // get the current date and time
                                  DateTime currentDateTime = DateTime.now();
                                  final String date = DateFormat('MM/dd/yy').format(currentDateTime); 
                                  
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    // display the information of the signed up task in a ListTile
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ListTile(
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
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                              )),
                                        ),
                                        subtitle: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20.0, right: 15),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text.rich(
                                                TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: 'Customer Name: ',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .secondary,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          '${taskData['customer first name']} ${taskData['customer last name']}',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .secondary,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Text.rich(
                                                TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: 'Description: ',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .secondary,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          '${taskData['description']}',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .secondary,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Text.rich(
                                                TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: 'Location: ',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .secondary,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          '${taskData['location']}',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .secondary,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Text.rich(
                                                TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: 'Pay Rate: ',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .secondary,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          '\$${taskData['pay rate']}',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .secondary,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Text.rich(
                                                TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: 'Start Date: ',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .secondary,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          '${taskData['start date']}',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .secondary,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            if (!taskData['task accepted'])
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  IconButton(
                                                    icon: Icon(
                                                        Icons.check_circle,
                                                        color:
                                                            Colors.green[800]),
                                                    // padding: EdgeInsets.zero,
                                                    onPressed: () async {
                                                      // give user a warning if they really want to confirm the task
                                                      bool confirmed =
                                                          await showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                            AlertDialog(
                                                          title: Text(
                                                              'Confirm Accept'),
                                                          content: Text(
                                                              'Are you sure you want to accept this task request?'),
                                                          backgroundColor:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .tertiary,
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () =>
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop(
                                                                          true),
                                                              child: Text(
                                                                  'Accept'),
                                                            ),
                                                            TextButton(
                                                              onPressed: () =>
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop(
                                                                          false),
                                                              child: Text(
                                                                  'Cancel'),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                      // proceed with the accepting process if true
                                                      if (confirmed == true) {
                                                        try {
                                                          // Update database to mark task as accepted
                                                          setState(() {
                                                            _firestore
                                                                .collection(
                                                                    'Task Categories')
                                                                .doc(
                                                                    categoryName)
                                                                .collection(
                                                                    'Hired Taskers')
                                                                .doc(_auth
                                                                    .currentUser!
                                                                    .email)
                                                                .collection(
                                                                    'In Progress Tasks')
                                                                .doc(taskData[
                                                                    'customer email'])
                                                                .update({
                                                              'task accepted':
                                                                  true
                                                            });
                                                          });
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            SnackBar(
                                                              content: Text(
                                                                  'Successfully accepted task request.'),
                                                            ),
                                                          );
                                                        } catch (error) {
                                                          // print('There was an error deleting the signed up task: $error');
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            SnackBar(
                                                              content: Text(
                                                                  'An error occurred while accepting the task request.'),
                                                            ),
                                                          );
                                                        }
                                                      }
                                                    },
                                                  ),
                                                  // allow user to decline the task
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.cancel,
                                                      color: Colors.red,
                                                    ),
                                                    padding: EdgeInsets.zero,
                                                    onPressed: () async {
                                                      // give user a warning if they want to declne the task
                                                      bool confirmed =
                                                          await showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                            AlertDialog(
                                                          title: Text(
                                                              'Confirm Decline'),
                                                          content: Text(
                                                              'Are you sure you want to decline this task request?'),
                                                          backgroundColor:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .tertiary,
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () =>
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop(
                                                                          true),
                                                              child: Text(
                                                                  'Decline'),
                                                            ),
                                                            TextButton(
                                                              onPressed: () =>
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop(
                                                                          false),
                                                              child: Text(
                                                                  'Cancel'),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                      // proceed with the decline process if true
                                                      if (confirmed == true) {
                                                        try {
                                                          // removing from the collection
                                                          final signedUpGeneral = _firestore
                                                              .collection(
                                                                  'Task Categories')
                                                              .doc(categoryName)
                                                              .collection(
                                                                  'Hired Taskers')
                                                              .doc(_auth
                                                                  .currentUser!
                                                                  .email)
                                                              .collection(
                                                                  'In Progress Tasks')
                                                              .doc(taskData[
                                                                  'customer email']);
                                                          await signedUpGeneral
                                                              .delete();
                                                          // update the UI
                                                          setState(() {
                                                            taskCategory
                                                                .removeAt(
                                                                    index);
                                                          });
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            SnackBar(
                                                              content: Text(
                                                                  'Successfully decline task request.'),
                                                            ),
                                                          );
                                                        } catch (error) {
                                                          // print('There was an error deleting the signed up task: $error');
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            SnackBar(
                                                              content: Text(
                                                                  'An error occurred while declining the task request.'),
                                                            ),
                                                          );
                                                        }
                                                      }
                                                    },
                                                  ),
                                                ],
                                              ) 
                                              else if (taskData['task accepted'] && !taskData['task started']) 
                                                ElevatedButton(
                                                  onPressed: () async {
                                                    if(taskData['start date'] == date) {
                                                      bool confirmed = await showDialog(
                                                        context: context,
                                                        builder: (context) => AlertDialog(
                                                          title: Text('Confirm Start'),
                                                          content: Text('Are you sure you want to start the task?'),
                                                          backgroundColor: Theme.of(context).colorScheme.tertiary,
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () => Navigator.of(context).pop(true),
                                                              child: Text('Confirm'),
                                                            ),
                                                            TextButton(
                                                              onPressed: () => Navigator.of(context).pop(false),
                                                              child: Text('Cancel'),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                      if (confirmed == true) {
                                                        try {
                                                          // update the UI
                                                          setState(() {
                                                              _firestore.collection('Task Categories').doc(categoryName)
                                                              .collection('Hired Taskers').doc(_auth.currentUser!.email)
                                                              .collection('In Progress Tasks').doc(taskData['customer email'])
                                                              .update({'task started': true});
                                                            }
                                                          );
                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                            SnackBar(
                                                              content: Text('Successfully started task.'),
                                                            ),
                                                          );
                                                        } catch (error) {
                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                            SnackBar(
                                                              content: Text('An error occurred while starting the task.'),
                                                            ),
                                                          );
                                                        }
                                                      }
                                                    } else {
                                                      await showDialog(
                                                        context: context,
                                                        builder: (context) => AlertDialog(
                                                          title: Text('Cannot Start'),
                                                          content: Text('You cannot start the task until the specificed date'),
                                                          backgroundColor: Theme.of(context).colorScheme.tertiary,
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () => Navigator.of(context).pop(true),
                                                              child: Text('OK'),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    }
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.green[800],
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0),
                                                    child: Text("Start", style: TextStyle(color: Colors.white, fontSize: 14)),
                                                  ),
                                                ) 
                                              else ElevatedButton(
                                                onPressed: () async {
                                                  // give user a warning if they really want to delete the task category
                                                  bool confirmed =
                                                      await showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                      title: Text(
                                                          'Confirm Completion'),
                                                      content: Text(
                                                          'Are you sure you are completed with the task?'),
                                                      backgroundColor:
                                                          Theme.of(context).colorScheme.tertiary,
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () => Navigator.of(context).pop(true),
                                                          child:
                                                            Text('Confirm'),
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
                                                      // task request's data to be used for both tasker and customer's collections
                                                      final taskRequestData = await _firestore.collection('Task Categories').doc(categoryName)
                                                                                .collection('Hired Taskers').doc(_auth.currentUser!.email)
                                                                                .collection('In Progress Tasks').doc(taskData['customer email']).get();
                                                      final data = taskRequestData.data();
                                                      final customerEmail = data?['customer email'];
                                                      final description = data?['description'];
                                                      final location = data?['location'];
                                                      final payRate = data?['pay rate'];
                                                      final startDate = data?['start date'];
                                                      final taskAccepted = data?['task accepted'];
                                                      final taskStarted = data?['task started'];
                                                      
                                                      // retrieve tasker data to be used for cutomer's collection
                                                      final taskerData = await _firestore.collection('Taskers').doc(_auth.currentUser!.email).get();
                                                      final taskerFirstName = taskerData['first name'];
                                                      final taskerLastName = taskerData['last name'];
                                                      final taskerUserName = taskerData['username'];
                                                                                

                                                      if (data != null) {
                                                        // storing task request into tasker's collection
                                                        await _firestore.collection('Taskers').doc(_auth.currentUser!.email)
                                                          .collection('Completed Tasks').add({
                                                            ...data,
                                                            'task category': categoryName,
                                                        });

                                                        // storing task request into customer's collection
                                                        await _firestore.collection('Customers').doc(customerEmail)
                                                          .collection('Completed Tasks').add({
                                                            'tasker email': _auth.currentUser!.email,
                                                            'tasker first name': taskerFirstName,
                                                            'tasker last name': taskerLastName,
                                                            'tasker username': taskerUserName,
                                                            'task category': categoryName,
                                                            'description': description,
                                                            'location': location,
                                                            'pay rate': payRate,
                                                            'startDate': startDate,
                                                            'task accepted': taskAccepted,
                                                            'task started': taskStarted,
                                                        });
                                                      }
                                                                                      
                                                      // removing from the collection
                                                      final signedUpGeneral = _firestore.collection('Task Categories').doc(categoryName)
                                                                                .collection('Hired Taskers').doc(_auth.currentUser!.email)
                                                                                .collection('In Progress Tasks').doc(taskData['customer email']);

                                                      await signedUpGeneral.delete();
                                                      // update the UI
                                                      setState(() {
                                                        taskCategory
                                                            .removeAt(index);
                                                      });
                                                      // ignore: use_build_context_synchronously
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                              'Successfully completed task.'),
                                                        ),
                                                      );
                                                    } catch (error) {
                                                      // print('There was an error deleting the signed up task: $error');
                                                      // ignore: use_build_context_synchronously
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                              'An error occurred while completing task.'),
                                                        ),
                                                      );
                                                    }
                                                  }
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .tertiary,
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 0.0,
                                                      vertical: 0),
                                                  child: Text("Complete",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14)),
                                                ),
                                              ),
                                              if (taskData['task started']) 
                                                IconButton(
                                                  icon: Icon(Icons.location_on),
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                CurrentLocation(
                                                                    userType:
                                                                        "Taskers")));
                                                  },
                                                ),
                                          ],
                                        ),
                                      ),
                                    ],
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
    final taskerSignedUpTask = await _firestore
        .collection('Taskers')
        .doc(_auth.currentUser!.email)
        .collection('Signed Up Tasks')
        .get();
    final taskCategoryList = <String, List<DocumentSnapshot>>{};

    // go through the collection of signed up task to view each task document
    for (final taskCategory in taskerSignedUpTask.docs) {
      final taskData = taskCategory.data();
      final categoryName = taskData['task category'];
      // go to task category doc in Task Categories collection
      final taskCategory2 =
          _firestore.collection('Task Categories').doc(categoryName);
      // go to the Hired Taskers collection (from Task Categories Collection) which stores info of taskers sign up
      final tasker = taskCategory2
          .collection('Hired Taskers')
          .doc(_auth.currentUser!.email);
      final inProgressTaskDoc = await tasker
          .collection('In Progress Tasks')
          .where('customer email', isNotEqualTo: _auth.currentUser!.email)
          .get();

      // if categroy name is not stored in list, then create the key and assign it an empty list.
      if (!taskCategoryList.containsKey(categoryName)) {
        taskCategoryList[categoryName] = [];
      }
      taskCategoryList[categoryName]!.addAll(inProgressTaskDoc.docs);
    }
    return taskCategoryList;
  }
}
