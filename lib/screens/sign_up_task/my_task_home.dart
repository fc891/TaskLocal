// Contributors: Richard N.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tasklocal/screens/sign_up_task/edit_remove_sign_up_task.dart';
import 'package:tasklocal/screens/sign_up_task/completed_task.dart';

class MyTaskHome extends StatefulWidget {
  const MyTaskHome({super.key});

  @override
  State<MyTaskHome> createState() => _MyTaskHomeState();
}

class _MyTaskHomeState extends State<MyTaskHome> {
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
            SignedUpTask(),
            Icon(Icons.directions_bike),
            CompletedTask(),
          ],
        ),
      ),
    );
  }
}
