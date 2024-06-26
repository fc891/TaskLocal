// Contributors: Richard N.

import 'dart:math';
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
String sortBy = 'New';
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
                future: _getReservations(sortBy),
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
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0, top: 12),
                          child: Row(
                            children: [
                              Text('Sort by:', style: TextStyle(color: Colors.white)),
                              SizedBox(width: 10),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.tertiary,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.white,
                                  ),
                                ),
                                child: DropdownButtonHideUnderline(
                                  // user can select the type of sort
                                  child: DropdownButton<String>(
                                    value: sortBy,
                                    icon: Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.white,
                                    ),
                                    // iconSize: 30,
                                    // elevation: 16,
                                    style: TextStyle(color: Colors.black),
                                    dropdownColor:
                                        Theme.of(context).colorScheme.tertiary,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        sortBy = newValue!;
                                      });
                                    },
                                    items: <String>['New', 'Old']
                                        .map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(value,
                                              style: TextStyle(color: Colors.white)),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
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
                                      final String currentDateOnly = DateFormat('MM/dd/yy').format(currentDateTime); 
                        
                                      // task reservation's date and time
                                      DateTime dateTime = taskData['date'].toDate();
                                      final reservationDateOnly = DateFormat('MM/dd/yy').format(dateTime);
                        
                                      DocumentReference reservation = _firestore.collection('Reservations').doc(taskData['customerEmail'])
                                                                                                        .collection('All Pending Reservations').doc(categoryName);
                        
                                      reservation.get().then((docSnapshot) {
                                        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
                                        // 'payRate' field doesn't exist, so add it
                                        if (!data.containsKey('payRate')) {
                                          // Randomly create a pay rate between 40 and 80 (evens only)
                                          int payRate = (Random().nextInt(21) * 2) + 40;
                                          reservation.update({'payRate': payRate});
                                        }
                                      });
                        
                                      
                                      reservation.get().then((docSnapshot) {
                                        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
                                        // 'payRate' field doesn't exist, so add it
                                        if (!data.containsKey('address')) {
                                          // Randomly create a address number
                                          int addressNum = Random().nextInt(90000) + 10000;
                                          reservation.update({'address': '$addressNum address name'});
                                        }
                                      });
                        
                                      CollectionReference signedUpTasks = _firestore.collection('Taskers').doc(_auth.currentUser!.email).collection('Signed Up Tasks');
                                      // Get all documents from the collection
                                      signedUpTasks.get().then((querySnapshot) {
                                        // Generate a random index within the range of the number of documents
                                        int randomIndex = Random().nextInt(querySnapshot.docs.length);
                        
                                        // Use the random index to access a document from the collection
                                        DocumentSnapshot randomDocument = querySnapshot.docs[randomIndex];
                                        // Access the data of the random document
                                        Map<String, dynamic> documentData = randomDocument.data() as Map<String, dynamic>;
                        
                                        reservation.get().then((docSnapshot) {
                                          Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
                                          // 'payRate' field doesn't exist, so add it
                                          if (!data.containsKey('categoryName')) {
                                            reservation.update({'categoryName': documentData['task category']});
                                          }
                                        });
                                      }).catchError((error) {
                                        print("Error retrieving documents: $error");
                                      });
                        
                                      if (!taskData['taskRejected'] && !taskData['taskCompleted']) {
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
                                                padding: const EdgeInsets.only(top: 0, left: 20.0),
                                                child: Text(
                                                  taskData['categoryName'], 
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
                                                                '${taskData['customerFirstName']} ${taskData['customerLastName']}',
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
                                                                '${taskData['address']}',
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
                                                            text: '\$${taskData['payRate']}',
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
                                                            text: 'Date: ',
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
                                                            text: reservationDateOnly,
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
                                                if (!taskData['taskAccepted'])
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
                                                                        'Reservations')
                                                                    .doc(taskData['customerEmail'])
                                                                    .collection(
                                                                        'All Pending Reservations')
                                                                    .doc(categoryName)
                                                                    .update({
                                                                  'taskAccepted':
                                                                      true
                                                                });
                                                              });
                                                              ScaffoldMessenger.of(context).showSnackBar(
                                                                SnackBar(
                                                                  content: Text(
                                                                      'Successfully accepted task request.'),
                                                                ),
                                                              );
                                                            } catch (error) {
                                                              // print('There was an error deleting the signed up task: $error');
                                                              ScaffoldMessenger.of(context)
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
                                                              // final signedUpGeneral = _firestore
                                                              //     .collection(
                                                              //         'Task Categories')
                                                              //     .doc(categoryName)
                                                              //     .collection(
                                                              //         'Hired Taskers')
                                                              //     .doc(_auth
                                                              //         .currentUser!
                                                              //         .email)
                                                              //     .collection(
                                                              //         'In Progress Tasks')
                                                              //     .doc(taskData[
                                                              //         'customer email']);
                                                              // await signedUpGeneral
                                                              //     .delete();
                                                              // update the UI
                                                              setState(() {
                                                                taskCategory.removeAt(index);
                                                                _firestore
                                                                    .collection(
                                                                        'Reservations')
                                                                    .doc(taskData['customerEmail'])
                                                                    .collection(
                                                                        'All Pending Reservations')
                                                                    .doc(categoryName)
                                                                    .update({
                                                                  'taskRejected':
                                                                      true
                                                                });
                                                              });
                                                              ScaffoldMessenger.of(context).showSnackBar(
                                                                SnackBar(
                                                                  content: Text(
                                                                      'Successfully decline task request.'),
                                                                ),
                                                              );
                                                            } catch (error) {
                                                              // print('There was an error deleting the signed up task: $error');
                                                              ScaffoldMessenger.of(context).showSnackBar(
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
                                                  else if (taskData['taskAccepted'] && !taskData['taskStarted']) 
                                                    ElevatedButton(
                                                      onPressed: () async {
                                                        if(reservationDateOnly == currentDateOnly) {
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
                                                                  _firestore.collection('Reservations').doc(taskData['customerEmail'])
                                                                  .collection('All Pending Reservations').doc(categoryName)
                                                                  .update({'taskStarted': true});
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
                                                          // final taskRequestData = await _firestore.collection('Reservations').doc(taskData['customerEmail'])
                                                          //                           .collection('All Pending Reservations').doc(categoryName).get();
                                                                                    
                                                          // final data = taskRequestData.data();
                                                          // final customerEmail = data?['customerEmail'];
                                                          // final description = data?['description'];
                                                          // final location = data?['address'];
                                                          // final payRate = data?['payRate'];
                                                          // final reservationDate = data?['date'];
                                                          // final taskAccepted = data?['taskAccepted'];
                                                          // final taskStarted = data?['taskStarted'];
                                                          // final taskCategory = data?['category name'];
                                                          
                                                          // retrieve tasker data to be used for cutomer's collection
                                                          final taskerData = await _firestore.collection('Taskers').doc(_auth.currentUser!.email).get();
                                                          final taskerFirstName = taskerData['first name'];
                                                          final taskerLastName = taskerData['last name'];
                                                          final taskerUserName = taskerData['username'];
                                                                                    
                        
                                                          // if (data != null) {
                                                            // storing task request into tasker's collection
                                                            await _firestore.collection('Taskers').doc(_auth.currentUser!.email)
                                                              .collection('Completed Tasks').add({
                                                                'customer email': taskData['customerEmail'],
                                                                'customer first name': taskerFirstName,
                                                                'customer last name': taskerLastName,
                                                                'customer username': taskerUserName,
                                                                'task category': taskData['categoryName'],
                                                                'description': taskData['description'],
                                                                'location': taskData['address'],
                                                                'pay rate': taskData['payRate'],
                                                                'start date': reservationDateOnly,
                                                                'task accepted': taskData['taskAccepted'],
                                                                'task started': taskData['taskStarted'],
                                                            });
                        
                                                            // storing task request into customer's collection
                                                            await _firestore.collection('Customers').doc(taskData['customerEmail'])
                                                              .collection('Completed Tasks').add({
                                                                'tasker email': _auth.currentUser!.email,
                                                                'tasker first name': taskerFirstName,
                                                                'tasker last name': taskerLastName,
                                                                'tasker username': taskerUserName,
                                                                'task category': taskData['categoryName'],
                                                                'description': taskData['description'],
                                                                'location': taskData['address'],
                                                                'pay rate': taskData['payRate'],
                                                                'start date': reservationDateOnly,
                                                                'task accepted': taskData['taskAccepted'],
                                                                'task started': taskData['taskStarted'],
                                                            });
                                                          // }
                                                                                          
                                                          // removing from the collection
                                                          // final signedUpGeneral = _firestore.collection('Task Categories').doc(categoryName)
                                                          //                           .collection('Hired Taskers').doc(_auth.currentUser!.email)
                                                          //                           .collection('In Progress Tasks').doc(taskData['customer email']);
                        
                                                          // await signedUpGeneral.delete();
                                                          // update the UI
                                                          setState(() {
                                                            taskCategory.removeAt(index);
                                                            _firestore
                                                                    .collection(
                                                                        'Reservations')
                                                                    .doc(taskData['customerEmail'])
                                                                    .collection(
                                                                        'All Pending Reservations')
                                                                    .doc(categoryName)
                                                                    .update({
                                                                  'taskCompleted':
                                                                      true
                                                                });
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
                                                                  '${error}'),
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
                                                  if (taskData['taskStarted']) 
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
                                  }
                                      return null;
                                  },
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ],
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

  // retrieves the tasker's customers who made reservation for tasker 
  Future<Map<String, List<DocumentSnapshot>>> _getReservations(sortBy) async {
    // access the collection that stores tasker's customers
    final hiredByCustomers = await _firestore
        .collection('Taskers')
        .doc(_auth.currentUser!.email)
        .collection('Hired by Customers')
        .get();
    var customerReservation = <String, List<DocumentSnapshot>>{};
    final Set<String> uniqueReservation = {};

    // go through the collection of signed up task to view each task document
    for (final customer in hiredByCustomers.docs) {
      final customerData = customer.data();
      final customerEmail = customerData['customerEmail'];

      // go to customer doc in Reservations collection
      final customerEmail2 = _firestore.collection('Reservations').doc(customerEmail);
      // go to 'All Pending Reservations' collection to retrieve reservation data
      final pendingReservations = await customerEmail2.collection('All Pending Reservations').where('taskerEmail', isEqualTo: _auth.currentUser!.email).get();

      for (final doc in pendingReservations.docs) {
        final reservationId = doc.id;
        // ensure unique reservations
        if (!uniqueReservation.contains(reservationId)) {
          uniqueReservation.add(reservationId);
          // Add reservation to map
          if (!customerReservation.containsKey(reservationId)) {
            customerReservation[reservationId] = [];
          }
          customerReservation[reservationId]!.add(doc);
        }
      }
    }

    if (sortBy == 'New') {
      // Convert map entries to a list for sorting
      List<MapEntry<String, List<DocumentSnapshot>>> sortedEntries = customerReservation.entries.toList();
      sortedEntries.sort((a, b) {
        DateTime dateA = a.value[0]['date'].toDate();
        DateTime dateB = b.value[0]['date'].toDate();
        return dateB.compareTo(dateA); // Sort by latest first or descending order
      });
      // Convert sorted list back to a map
      customerReservation = Map.fromEntries(sortedEntries);
    } else if (sortBy == 'Old') {
      // Convert map entries to a list for sorting
      List<MapEntry<String, List<DocumentSnapshot>>> sortedEntries = customerReservation.entries.toList();
      sortedEntries.sort((a, b) {
        DateTime dateA = a.value[0]['date'].toDate();
        DateTime dateB = b.value[0]['date'].toDate();
        return dateA.compareTo(dateB); // Sort by oldest first or ascending order
      });
      // Convert sorted list back to a map
      customerReservation = Map.fromEntries(sortedEntries);
    }

    return customerReservation;
  }

  // // retrieves the task categories that the user signed up for
  // Future<Map<String, List<DocumentSnapshot>>> _getSignedUpTasks() async {
  //   // access the collection that stores user's signed up tasks
  //   final taskerSignedUpTask = await _firestore
  //       .collection('Taskers')
  //       .doc(_auth.currentUser!.email)
  //       .collection('Signed Up Tasks')
  //       .get();
  //   final taskCategoryList = <String, List<DocumentSnapshot>>{};

  //   // go through the collection of signed up task to view each task document
  //   for (final taskCategory in taskerSignedUpTask.docs) {
  //     final taskData = taskCategory.data();
  //     final categoryName = taskData['task category'];
  //     // go to task category doc in Task Categories collection
  //     final taskCategory2 = _firestore.collection('Task Categories').doc(categoryName);
  //     // go to the Hired Taskers collection (from Task Categories Collection) which stores info of taskers sign up
  //     final tasker = taskCategory2.collection('Hired Taskers').doc(_auth.currentUser!.email);
  //     final inProgressTaskDoc = await tasker.collection('In Progress Tasks').where('customer email', isNotEqualTo: _auth.currentUser!.email).get();

  //     // if categroy name is not stored in list, then create the key and assign it an empty list.
  //     if (!taskCategoryList.containsKey(categoryName)) {
  //       taskCategoryList[categoryName] = [];
  //     }
  //     taskCategoryList[categoryName]!.addAll(inProgressTaskDoc.docs);
  //   }
  //   return taskCategoryList;
  // }
}
