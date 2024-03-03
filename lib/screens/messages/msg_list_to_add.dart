import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MsgListToAdd extends StatefulWidget {
  const MsgListToAdd({super.key});

  @override
  State<MsgListToAdd> createState() => _MsgListToAddState();
}

class _MsgListToAddState extends State<MsgListToAdd> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[800],
      appBar: AppBar(
        title: Text('Title', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 32)),
        centerTitle: true,
        backgroundColor: Colors.green[800],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('Taskers').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final taskers = snapshot.data!.docs;

          return ListView.builder(
            itemCount: taskers.length,
            itemBuilder: (context, index) {
              final taskerData = taskers[index].data() as Map<String, dynamic>;
              print("TASKER DATA: ${taskerData}");
              return GestureDetector(
                onTap: () {
                  _addTaskerToCollection(taskers[index].id); // Add tasker to collection
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${taskerData['first name']} - ${taskerData['description']}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
  Future<void> _addTaskerToCollection(String taskId) async {
    try {
      await _firestore.collection('YourCollectionName').doc(taskId).set({'selected': true});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tasker added to collection.'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('Error adding tasker to collection: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add tasker to collection.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}