// Contributors: Richard N.

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
  @override
  Widget build(BuildContext context) {
    // creates the tab navigation bar
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('History'),
          centerTitle: true,
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
            PostedTopicsHistory(
              onLikeUpdated: () {
                // update the UI for discussion board home
                if (widget.onLikeUpdated != null) {
                  widget.onLikeUpdated!();
                }
              },
            ),
            PostedCommentsHistory(
              onLikeUpdated: () {
                // update the UI for discussion board home
                if (widget.onLikeUpdated != null) {
                  widget.onLikeUpdated!();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}