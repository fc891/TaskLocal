import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tasklocal/screens/discussion_board/discussion_page.dart';
import 'package:tasklocal/screens/discussion_board/post_discussion_topic.dart';
import 'package:intl/intl.dart';


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
            icon: Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PostDiscussionTopic()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PostDiscussionTopic()),
              ).then((value) {
                if (value == true) {
                  setState(() {
                    // Trigger a rebuild of the widget
                  });
                }
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: _getPostedTopics(),
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
            return ListView.builder(
              itemCount: topics.length,
              itemBuilder: (context, index) {
                final topic = topics[index];
                final email = topic['email'];
                final taskCategory = topic['task category'];
                final topicTitle = topic['topic title'];
                final text = topic['text'];
                final username = topic['username'];
                final numOfMsg = topic['num of msg'];
                final usersLiked = topic['liked by users'];
                // Check if the current user has liked the topic
                final List<dynamic> likedByUsers = topic['liked by users'] ?? [];
                final currentUserEmail = _auth.currentUser!.email;
                final isLiked = likedByUsers.contains(currentUserEmail);

                final date = topic['date'].toDate();
                // final DateFormat formatter = DateFormat('MM/dd/yyyy');
                final String formattedDate = DateFormat('MM/dd/yyyy').format(date);

                return GestureDetector(
                    onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DiscussionPage(email: email, taskCategory: taskCategory, topicTitle: topicTitle, text: text, username: username,
                                                                              numOfMsg: numOfMsg, usersLiked: usersLiked, mmddyy: formattedDate, onLikeUpdated: () {
                            // Trigger rebuild when like is updated
                            setState(() {});
                          }, isTextFieldVisible: false)),
                    );
                  },
                  child: ListTile(
                    // title: Text(topicTitle),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('$taskCategory'),
                            Spacer(),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => DiscussionPage(email: email, taskCategory: taskCategory, topicTitle: topicTitle, text: text, username: username,
                                                                                          numOfMsg: numOfMsg, usersLiked: usersLiked, mmddyy: formattedDate, onLikeUpdated: () {
                                        // Trigger rebuild when like is updated
                                        setState(() {});
                                      }, isTextFieldVisible: true)),
                                );
                              },
                              child: Icon(
                                Icons.message, 
                                color: Theme.of(context).colorScheme.secondary
                              )
                            ),
                            Text('$numOfMsg'),
                            GestureDetector(
                              onTap: () async {
                                setState(() {});
                                // Access the document reference
                                final documentReference = topic.reference;

                                // List of users who liked the topic, stored as 'liked by users'
                                final List<dynamic> likedByUsers = topic['liked by users'] ?? [];

                                // Check if the current user's email is in the list of likedByUsers
                                final currentUserEmail = _auth.currentUser!.email;
                                if (isLiked) {
                                  // If the user unlikes the topic, remove their email from the list
                                  likedByUsers.remove(currentUserEmail);
                                } else {
                                  // If the user likes the topic, add their email to the list
                                  likedByUsers.add(currentUserEmail);
                                }

                                // Update the 'liked by users' field in Firestore
                                await documentReference.update({
                                  'liked by users': likedByUsers,
                                });
                              },
                              child: Icon(
                                isLiked ? Icons.favorite : Icons.favorite_border, 
                                color: isLiked ? Colors.red : Theme.of(context).colorScheme.secondary
                              ),
                            ),
                            Text(likedByUsers.length.toString()),
                          ],
                        ),
                        Text('$topicTitle'),
                        Text('@$username - $formattedDate'),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<DocumentSnapshot>> _getPostedTopics() async {
    // Map to store the data
    Map<String, List<DocumentSnapshot>> postedTopicsData = {};

    // Access the collection that stores user's signed up tasks
    final taskers = await _firestore.collection('Tasker Discussion Board').get();

    // Loop through each document in the Tasker Discussion Board collection
    for (var taskerDoc in taskers.docs) {
      // Access the subcollection Posted Topics for each tasker
      final postedTopicsCollection = await taskerDoc.reference.collection('Posted Topics').get();

      // List to store the documents in the Posted Topics subcollection
      List<DocumentSnapshot> postedTopics = postedTopicsCollection.docs;
      
      // Add the list of posted topics to the map with the tasker's document ID as the key
      postedTopicsData[taskerDoc.id] = postedTopics;
    }
    // Return the map containing the data
    List<DocumentSnapshot> combinedPostedTopics = [];
  
    // Combine all posted topics into a single list
    for (var postedTopics in postedTopicsData.values) {
      combinedPostedTopics.addAll(postedTopics);
    }

    // Sort the combined list of posted topics by date
    combinedPostedTopics.sort((a, b) {
      // Assuming the date is stored in a field named 'date' in each document
      DateTime dateA = a['date'].toDate(); // Convert Firebase Timestamp to DateTime
      DateTime dateB = b['date'].toDate(); // Convert Firebase Timestamp to DateTime
      return dateB.compareTo(dateA); // Sort in descending order (latest first)
    });

    // for (DocumentSnapshot doc in combinedPostedTopics) {
    //   print('Document ID: ${doc.id}');
    //   // Assuming fields in the document are 'title', 'content', and 'date'
    //   print('Title: ${doc['task category']}');
    //   // Convert Firebase Timestamp to DateTime for the 'date' field
    //   DateTime date = doc['date'].toDate();
    //   print('Date: $date');
    //   print('--------------------------------------');
    // }
    return combinedPostedTopics;
  }
}
