// Contributors: Richard N.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tasklocal/screens/sign_up_task/edit_remove_sign_up_task.dart';
import 'package:tasklocal/screens/sign_up_task/completed_task.dart';

class MyTasksHome extends StatefulWidget {
  const MyTasksHome({super.key});

  @override
  State<MyTasksHome> createState() => _MyTasksHomeState();
}

class _MyTasksHomeState extends State<MyTasksHome> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        // backgroundColor: Colors.green[800],
        appBar: AppBar(
          title: Text('My Tasks', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 26)),
          centerTitle: true,
          backgroundColor: Colors.green[800],
          bottom: TabBar(
            unselectedLabelColor: Colors.grey[400],
            labelColor: Colors.green[300],
            tabs: const [
              Tab(text: 'Signed Up'),
              Tab(text: 'In Progress'),
              Tab(text: 'Completed'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            EditRemoveSignUpTask(),
            Icon(Icons.directions_bike),
            CompletedTask(),
          ],
        ),
      ),
    );
  }
}
