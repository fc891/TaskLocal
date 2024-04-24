import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tasklocal/screens/discussion_board/posted_comments_history.dart';
import 'package:tasklocal/screens/discussion_board/posted_topics_history.dart';

class PostedTopicsCommentsHistoryHome extends StatefulWidget {
  final Function? onLikeUpdated;
  const PostedTopicsCommentsHistoryHome({super.key, this.onLikeUpdated});

  @override
  State<PostedTopicsCommentsHistoryHome> createState() => _PostedTopicsCommentsHistoryHomeState();
}

class _PostedTopicsCommentsHistoryHomeState extends State<PostedTopicsCommentsHistoryHome> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // _firestore.collection('Task Discussion Board').doc(_auth.currentUser.!email).collection('Posted Topics');

  @override
  Widget build(BuildContext context) {
    // creates the tab navigation bar, there will be 2 tabs
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Tasks'),
          centerTitle: true,
          //backgroundColor: Colors.green[800],
          bottom: TabBar(
            // have color based on user selecting the tab
            unselectedLabelColor: Colors.white,
            labelColor: Colors.green[300],
            // labels for each tab
            tabs: const [
              Tab(text: 'Posts'),
              Tab(text: 'Comments'),
            ],
          ),
        ),
        body: TabBarView(
          // navigate to the pages
          children: [
            // PostedTopicsHistory(),
            PostedTopicsHistory(
              onLikeUpdated: () {
                // Trigger rebuild when like is updated
                if (widget.onLikeUpdated != null) {
                  widget.onLikeUpdated!();
                }
              },
            ),
            PostedCommentsHistory(),
          ],
        ),
      ),
    );
  }
}