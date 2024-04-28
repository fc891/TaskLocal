// Contributors: Richard N.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tasklocal/screens/discussion_board/discussion_page.dart';
import 'package:tasklocal/screens/discussion_board/post_discussion_topic.dart';
import 'package:intl/intl.dart';
import 'package:tasklocal/screens/discussion_board/posted_topics_comments_history_home.dart';

class DiscussionBoardHome extends StatefulWidget {
  const DiscussionBoardHome({super.key});

  @override
  State<DiscussionBoardHome> createState() => _DiscussionBoardHomeState();
}

class _DiscussionBoardHomeState extends State<DiscussionBoardHome> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String sortBy = 'New';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Discussion Board"),
        centerTitle: true,
        actions: [
          // navigate to history page
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        PostedTopicsCommentsHistoryHome(onLikeUpdated: () {
                          setState(() {});
                        })),
              );
            },
          ),
          // navigate to post discussion topic
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PostDiscussionTopic()),
              ).then((value) {
                if (value == true) {
                  setState(() {});
                }
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<DocumentSnapshot>>(
          future: _getPostedTopics(sortBy),
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
              final List<DocumentSnapshot> topics = snapshot.data!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
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
                  Expanded(
                    child: ListView.builder(
                      itemCount: topics.length,
                      itemBuilder: (context, index) {
                        final topic = topics[index];
                        final topicPosterEmail = topic['email'];
                        final taskCategory = topic['task category'];
                        final topicTitle = topic['topic title'];
                        final text = topic['text'];
                        final mmddyy = topic['formatted date'];
                        final time = topic['time'];
                        final username = topic['username'];
                        final numOfMsg = topic['num of msg'];
                        final usersLiked = topic['liked by users'];
                        final timeWithSeconds = topic['time with seconds'];
                        final List<dynamic> likedByUsers = topic['liked by users'] ?? [];
                        final currentUserEmail = _auth.currentUser!.email;
                        final isLiked = likedByUsers.contains(currentUserEmail);
                        final date = topic['date'].toDate();
                        final String formattedDate = DateFormat('MM/dd/yyyy').format(date);

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DiscussionPage(
                                    dateAndTime: date,
                                      topicPosterEmail: topicPosterEmail,
                                      taskCategory: taskCategory,
                                      topicTitle: topicTitle,
                                      text: text,
                                      username: username,
                                      numOfMsg: numOfMsg,
                                      usersLiked: usersLiked,
                                      mmddyy: mmddyy,
                                      time: time,
                                      timeWithSeconds: timeWithSeconds,
                                      onLikeUpdated: () {
                                        setState(() {});
                                      },
                                      isTextFieldVisible: false)),
                            ).then((updatedData) {
                              if (updatedData) {
                                setState(() {});
                              }
                            });
                          },
                          child: Column(
                            children: [
                              ListTile(
                                contentPadding: EdgeInsets.all(0),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text('$taskCategory',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Theme.of(context).colorScheme.secondary,
                                          ),
                                        ),
                                        Spacer(),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                  DiscussionPage(
                                                    dateAndTime: date,
                                                    topicPosterEmail: topicPosterEmail,
                                                    taskCategory: taskCategory,
                                                    topicTitle: topicTitle,
                                                    text: text,
                                                    username: username,
                                                    numOfMsg: numOfMsg,
                                                    usersLiked: usersLiked,
                                                    mmddyy: mmddyy,
                                                    time: time,
                                                    timeWithSeconds: timeWithSeconds,
                                                    onLikeUpdated: () {
                                                      setState(() {});
                                                    },
                                                    isTextFieldVisible: true
                                                  )),
                                            ).then((updatedData) {
                                              if (updatedData) {
                                                setState(() {});
                                              }
                                            });
                                          },
                                          child: Icon(Icons.message,
                                              color: Theme.of(context).colorScheme.secondary)
                                        ),
                                        SizedBox(width: 5),
                                        Text('$numOfMsg',
                                          style: TextStyle(
                                            color: Theme.of(context).colorScheme.secondary,
                                          ),
                                        ),
                                        SizedBox(width: 20),
                                        GestureDetector(
                                          onTap: () async {
                                            // updates the page
                                            setState(() {});
                                            final documentReference = topic.reference;
                              
                                            // access the list of users that liked the topic
                                            final List<dynamic> likedByUsers = topic['liked by users'] ?? [];
                              
                                            // Check if the user's email is in list
                                            final currentUserEmail = _auth.currentUser!.email;
                                            if (isLiked) {
                                              // If user removes like to topic, delete email from list
                                              likedByUsers.remove(currentUserEmail);
                                            } else {
                                              // If user adds like to topic, add email to list
                                              likedByUsers.add(currentUserEmail);
                                            }
                                            // updates in the database
                                            await documentReference.update({
                                              'liked by users': likedByUsers,
                                            });
                                          },
                                          child: Icon(
                                              isLiked
                                                  ? Icons.thumb_up
                                                  : Icons.thumb_up_outlined,
                                              color: isLiked
                                                  ? Colors.white
                                                  : Theme.of(context)
                                                      .colorScheme
                                                      .secondary),
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          likedByUsers.length.toString(), 
                                          style: TextStyle(
                                            color: Theme.of(context).colorScheme.secondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '$topicTitle',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).colorScheme.secondary,
                                      ),
                                    ),
                                    Text(
                                      '@$username - $formattedDate $time', 
                                        style: TextStyle(
                                        fontSize: 12,
                                        color: Theme.of(context).colorScheme.secondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(color: Colors.white,),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  // Retrieves and display the posted discussion topics
  Future<List<DocumentSnapshot>> _getPostedTopics(String sortBy) async {
    // Map is used to store data
    Map<String, List<DocumentSnapshot>> postedTopicsData = {};

    // Access the collection that stores user info about posted topics
    final taskers =
        await _firestore.collection('Tasker Discussion Board').get();

    // Loop through each doc in the Tasker Discussion Board collection
    for (var taskerDoc in taskers.docs) {
      // Access the subcollection Posted Topics for each tasker to retrieve the doc
      final postedTopicsCollection =
          await taskerDoc.reference.collection('Posted Topics').get();
      // store the doc
      List<DocumentSnapshot> postedTopics = postedTopicsCollection.docs;

      // use the doc ID of tasker as key to store the list of posted doc
      postedTopicsData[taskerDoc.id] = postedTopics;
    }
    List<DocumentSnapshot> combinedPostedTopics = [];

    // combine every tasker's posted topics
    for (var postedTopics in postedTopicsData.values) {
      combinedPostedTopics.addAll(postedTopics);
    }

    // sort comments depending on the type
    if (sortBy == 'New') {
      combinedPostedTopics.sort((a, b) {
        DateTime dateA = a['date'].toDate();
        DateTime dateB = b['date'].toDate();
        return dateB
            .compareTo(dateA); // Sort by latest first or descending order
      });
    } else if (sortBy == 'Old') {
      combinedPostedTopics.sort((a, b) {
        DateTime dateA = a['date'].toDate();
        DateTime dateB = b['date'].toDate();
        return dateA
            .compareTo(dateB); // Sort by oldest first or ascending order
      });
    }
    return combinedPostedTopics;
  }
}
