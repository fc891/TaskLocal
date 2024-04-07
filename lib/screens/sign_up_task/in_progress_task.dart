// Contributors: Richard N.

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InProgressTask extends StatefulWidget {
  const InProgressTask({super.key});

  @override
  State<InProgressTask> createState() => _InProgressTaskState();
}

class _InProgressTaskState extends State<InProgressTask> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int? YOUR_SPECIFIC_INDEX;
  bool showStartButton = true;

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
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: taskCategory.length,
                                itemBuilder: (context, index) {
                                  final taskData = taskCategory[index];
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
                                              )
                                            ),
                                          ),
                                          subtitle: Padding(
                                            padding: const EdgeInsets.only(left: 20.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('Customer Name: ${taskData['customer first name']} ${taskData['customer last name']}', style: TextStyle(fontSize: 16,)),
                                                Text('Description: \n${taskData['description']}', style: TextStyle(fontSize: 16,)),
                                                Text('Location: ${taskData['location']}', style: TextStyle(fontSize: 16,)),
                                                Text('Pay Rate: \$${taskData['pay rate']}', style: TextStyle(fontSize: 16,)),
                                                Text('Start Date: ${taskData['start date']}', style: TextStyle(fontSize: 16,)),
                                              ],
                                            ),
                                          ),
                                        ),
                                        
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            YOUR_SPECIFIC_INDEX != index ? Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                IconButton(
                                                  icon: Icon(Icons.check_circle,  color: Colors.green,),
                                                  // padding: EdgeInsets.zero,
                                                  onPressed: () async {
                                                    // give user a warning if they really want to confirm the task
                                                    bool confirmed = await showDialog(
                                                      context: context,
                                                      builder: (context) => AlertDialog(
                                                        title: Text('Confirm Accept'),
                                                        content: Text('Are you sure you want to accept this offer?'),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () => Navigator.of(context).pop(true),
                                                            child: Text('Accept'),
                                                          ),
                                                          TextButton(
                                                            onPressed: () => Navigator.of(context).pop(false),
                                                            child: Text('Cancel'),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                    // proceed with the accepting process if true
                                                    if (confirmed == true) {
                                                      try {
                                                        // update the UI
                                                        setState(() {
                                                          YOUR_SPECIFIC_INDEX = index;
                                                        });

                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          SnackBar(
                                                            content: Text('Accepting offer successful.'),
                                                          ),
                                                        );
                                                      } catch (error) {
                                                        // print('There was an error deleting the signed up task: $error');
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          SnackBar(
                                                            content: Text('An error occurred while accepting the offer.'),
                                                          ),
                                                        );
                                                      }
                                                    }
                                                  },
                                                ),
                                                // allow user to decline the task
                                                IconButton(
                                                  icon: Icon(Icons.cancel, color: Colors.red,),
                                                  padding: EdgeInsets.zero,
                                                  onPressed: () async {
                                                    // give user a warning if they want to declne the task
                                                    bool confirmed = await showDialog(
                                                      context: context,
                                                      builder: (context) => AlertDialog(
                                                        title: Text('Confirm Decline'),
                                                        content: Text('Are you sure you want to decline this offer?'),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () => Navigator.of(context).pop(true),
                                                            child: Text('Decline'),
                                                          ),
                                                          TextButton(
                                                            onPressed: () => Navigator.of(context).pop(false),
                                                            child: Text('Cancel'),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                    // proceed with the decline process if true
                                                    if (confirmed == true) {
                                                      try {
                                                        // removing from the collection
                                                        final signedUpGeneral = _firestore.collection('Task Categories').doc(categoryName)
                                                                                  .collection('Hired Taskers').doc(_auth.currentUser!.email)
                                                                                  .collection('In Progress Tasks').doc(taskData['customer email']);
                                                        await signedUpGeneral.delete();
                                                        // update the UI
                                                        setState(() {
                                                          taskCategory.removeAt(index);
                                                        });
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          SnackBar(
                                                            content: Text('Declining offer successful.'),
                                                          ),
                                                        );
                                                      } catch (error) {
                                                        // print('There was an error deleting the signed up task: $error');
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          SnackBar(
                                                            content: Text('An error occurred while declining the offer.'),
                                                          ),
                                                        );
                                                      }
                                                    }
                                                  },
                                                ),
                                              ],
                                            ) : showStartButton ? ElevatedButton(
                                              onPressed: () {
                                                setState(() {
                                                  showStartButton = false;
                                                });
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.green[800],
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0),
                                                child: Text("Start", style: TextStyle(color: Colors.white, fontSize: 14)),
                                              ),
                                            ) : ElevatedButton(
                                              onPressed: () {
                                                
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.green[800],
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0),
                                                child: Text("Complete", style: TextStyle(color: Colors.white, fontSize: 14)),
                                              ),
                                            )
                                          ],
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
    final taskerSignedUpTask = await _firestore.collection('Taskers').doc(_auth.currentUser!.email).collection('Signed Up Tasks').get();
    final taskCategoryList = <String, List<DocumentSnapshot>>{};

    // go through the collection of signed up task to view each task document
    for (final taskCategory in taskerSignedUpTask.docs) {
      final taskData = taskCategory.data();
      final categoryName = taskData['task category'];
      // go to task category doc in Task Categories collection
      final taskCategory2 = _firestore.collection('Task Categories').doc(categoryName);
      // go to the Signed Up Taskers collection (from Task Categories Collection) which stores info of taskers sign up
      final tasker = taskCategory2.collection('Hired Taskers').doc(_auth.currentUser!.email);
      final inProgressTaskDoc = await tasker.collection('In Progress Tasks').where('customer email', isNotEqualTo: _auth.currentUser!.email).get();

      // if categroy name is not stored in list, then create the key and assign it an empty list.
      if (!taskCategoryList.containsKey(categoryName)) {
        taskCategoryList[categoryName] = [];
      }
      taskCategoryList[categoryName]!.addAll(inProgressTaskDoc.docs);
    }
    return taskCategoryList;
  }
}