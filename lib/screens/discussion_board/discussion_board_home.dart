import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tasklocal/screens/discussion_board/post_discussion_topic.dart';

class DiscussionBoardHome extends StatefulWidget {
  const DiscussionBoardHome({super.key});

  @override
  State<DiscussionBoardHome> createState() => _DiscussionBoardHomeState();
}

class _DiscussionBoardHomeState extends State<DiscussionBoardHome> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Discussion Board"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PostDiscussionTopic()),
              );
            },
          ),
        ],
      ),
      body: Column(
        
      ),
    );
  }
}