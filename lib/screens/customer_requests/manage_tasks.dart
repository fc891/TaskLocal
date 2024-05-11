// Contributors: Eric C.,

// Use case #22 Manage Customer's List of Taskers

/* - remove 'active tasks' and just keep 'pending' tasks
   - when customer clicks on task, it takes to separate page with more info/actions
   - on first screen, display just task category, tasker name
   - on second screen, display task category, tasker name, task details, asking rate, reservation details

   - have different buttons show up when a task is pending vs accepted
   - grab from tasker (/Taskers/richard@gmail.com/Completed Tasks/xZBKvJS1fKl8VDzTlsRl)

   - do not allow customer to edit once a task is accepted by a tasker
*/

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ManageTasks extends StatefulWidget {
  @override
  _ManageTasksState createState() => _ManageTasksState();
}

class _ManageTasksState extends State<ManageTasks> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Manage Tasks"),
        ),
        body: Center(
          child: Text("Please log in to view tasks."),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Your Pending Tasks"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('Reservations')
                .doc(user?.email)
                .collection('All Pending Reservations')
                .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var documents = snapshot.data!.docs;
          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              var task = documents[index].data() as Map<String, dynamic>;
              return _buildTaskTile(context, task, documents[index].id);
            },
          );
        },
      ),
    );
  }

  Widget _buildTaskTile(BuildContext context, Map<String, dynamic> task, String docId) {
    DateTime taskDate = (task['date'] as Timestamp).toDate();
    bool isCompleted = task['status'] == 'completed';
    return Card(
      child: ListTile(
        title: Text(task['categoryName'], style: TextStyle(color: Colors.white)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Description: ${task['description']}', style: TextStyle(color: Colors.white)),
            Text('Address: ${task['address']}', style: TextStyle(color: Colors.white)),
            Text('Date: ${DateFormat('yyyy-MM-dd – kk:mm').format(taskDate)}', style: TextStyle(color: Colors.white)),
            // Text('Rate: \$${task['payRate']} per hour', style: TextStyle(color: Colors.white)),
            Text('Tasker: ${task['taskerEmail']} - Accepted: ${task['taskAccepted'] ? "Yes" : "No"}', style: TextStyle(color: Colors.white)),
            Text('Status: ${task['status']}', style: TextStyle(color: Colors.white)),
          ],
        ),
        isThreeLine: true,
        trailing: Wrap(
          spacing: 12, // space between two icons
          children: <Widget>[
            IconButton(
              icon: Icon(isCompleted ? Icons.undo : Icons.check_circle_outline,
                  color: isCompleted ? Colors.orange : Colors.green),
              onPressed: () => _toggleTaskCompletion(docId, isCompleted),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => _showCancelDialog(context, docId),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleTaskCompletion(String docId, bool isCompleted) {
    _firestore.collection('Reservations')
        .doc(user!.email)
        .collection('All Pending Reservations')
        .doc(docId)
        .update({'status': isCompleted ? 'pending' : 'completed'});
  }

  void _showCancelDialog(BuildContext context, String docId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Cancel Task'),
          content: Text('Are you sure you want to cancel this task? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              child: Text('No', style: TextStyle(color: Colors.white)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Yes', style: TextStyle(color: Colors.white)),
              onPressed: () {
                _cancelTask(docId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _cancelTask(String docId) {
    _firestore.collection('Reservations')
        .doc(user!.email)
        .collection('All Pending Reservations')
        .doc(docId)
        .delete();
  }
}
