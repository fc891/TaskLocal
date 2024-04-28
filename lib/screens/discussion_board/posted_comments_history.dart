// Contributors: Richard N.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tasklocal/screens/discussion_board/discussion_page.dart';

class PostedCommentsHistory extends StatefulWidget {
  final Function onLikeUpdated;
  const PostedCommentsHistory({super.key, required this.onLikeUpdated});

  @override
  State<PostedCommentsHistory> createState() => _PostedCommentsHistoryState();
}

class _PostedCommentsHistoryState extends State<PostedCommentsHistory> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String sortBy = 'New';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<DocumentSnapshot>>(
          future: _getPostedComments(sortBy),
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
                      Text( 'Sort by:', style: TextStyle(color: Colors.white)),
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
                            icon: Icon(Icons.arrow_drop_down, color: Colors.white,),
                            style: TextStyle(color: Colors.black),
                            dropdownColor: Theme.of(context).colorScheme.tertiary,
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
                                    child: Text(value, style: TextStyle(color: Colors.white)),
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
                        // final topicPosterEmail = topic['email'];
                        // final taskCategory = topic['task category'];
                        // final topicTitle = topic['topic title'];
                        final text = topic['text'];
                        // final mmddyy = topic['formatted date'];
                        final time = topic['time'];
                        final username = topic['username'];
                        final timeWithSeconds = topic['time with seconds'];
                        final currentUserEmail = _auth.currentUser!.email;
                    
                        final date = topic['date'].toDate();
                        final String formattedDate = DateFormat('MM/dd/yyyy').format(date);

                        final topicPosterEmail = topic['topic poster email'];
                        final postedTopicLocation = topic['posted topic location'];
                    
                        return FutureBuilder<DocumentSnapshot>(
                          future: _getPostTopicData(topicPosterEmail, postedTopicLocation),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              final postedTopicData = snapshot.data!;
                              return GestureDetector(
                                onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => DiscussionPage(
                                    dateAndTime: postedTopicData['date'].toDate(),
                                    topicPosterEmail: postedTopicData['email'], taskCategory: postedTopicData['task category'], topicTitle: postedTopicData['topic title'], 
                                    text: postedTopicData['text'], username: postedTopicData['username'],
                                    numOfMsg: postedTopicData['num of msg'], usersLiked: postedTopicData['liked by users'], mmddyy: postedTopicData['formatted date'], 
                                    time: postedTopicData['time'], timeWithSeconds: postedTopicData['time with seconds'], 
                                    onLikeUpdated: () {
                                      setState(() {});
                                      if (widget.onLikeUpdated != null) {
                                        widget.onLikeUpdated();
                                      }
                                    }, 
                                    isTextFieldVisible: false
                                    )),
                                  ).then((updatedData) {                    
                                    if (updatedData) {
                                      setState(() {});
                                    }
                                  });
                                },
                                child: ListTile(
                                  contentPadding: EdgeInsets.all(0),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${postedTopicData['task category']} • ${postedTopicData['topic title']}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Theme.of(context).colorScheme.secondary,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      // Text(
                                      //   '${postedTopicData['topic title']}',
                                      //   style: TextStyle(
                                      //     fontSize: 16,
                                      //     color: Theme.of(context).colorScheme.secondary,
                                      //   ),
                                      // ),
                                      Text(
                                        '@$username commented $formattedDate $time',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Theme.of(context).colorScheme.secondary,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        '$text',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Theme.of(context).colorScheme.secondary,
                                        ),
                                      ),
                                      // SizedBox(height: 5),
                                      // Text(
                                      //   '$formattedDate $time',
                                      //   style: TextStyle(
                                      //     fontSize: 12,
                                      //     color: Theme.of(context).colorScheme.secondary,
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              );
                            }
                          },
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

  // retrieve data of posted topic discussion
  Future<DocumentSnapshot> _getPostTopicData(String topicPosterEmail, String postedTopicLocation) async {
    final postedTopicData = await _firestore
      .collection('Tasker Discussion Board')
      .doc(topicPosterEmail)
      .collection('Posted Topics')
      .doc(postedTopicLocation)
      .get();
    return postedTopicData;
  }

  // retrieves the comments that the user made on posted topics
  Future<List<DocumentSnapshot>> _getPostedComments(String sortBy) async {
    // access the collection that stores the users comments
    final commentedTopicsCollection = await _firestore.collection('Taskers').doc(_auth.currentUser!.email).collection('Commented Topics').get();
    final List<DocumentSnapshot> commentedTopicsList = [];
    // store comments that are unique
    final Set<String> uniqueComments = {};

    // go through the Commented Topics collection to view each comments
    for (final commentedTopic in commentedTopicsCollection.docs) {
      final commentedData = commentedTopic.data();
      final topicPosterEmail = commentedData['topic poster email'];
      final locationOfCommentDoc = commentedData['posted topic location'];
      // retrieve posted topic from specific poster
      final postedTopics = _firestore.collection('Tasker Discussion Board').doc(topicPosterEmail);
      // go to the Comments collection from the Posted Topics collection
      final tasker = await postedTopics.collection('Posted Topics').doc(locationOfCommentDoc).collection('Comments').where('email', isEqualTo: _auth.currentUser!.email).get();

      for (final doc in tasker.docs) {
        final commentId = doc.id;
        // ensure unique comments
        if (!uniqueComments.contains(commentId)) {
          uniqueComments.add(commentId);
          commentedTopicsList.add(doc); 
        }
      }
    }

    // sort comments depending on the type
    if (sortBy == 'New') {
      commentedTopicsList.sort((a, b) {
        DateTime dateA = a['date'].toDate();
        DateTime dateB = b['date'].toDate();
        return dateB.compareTo(dateA); // Sort by latest first or descending order
      });
    } else if (sortBy == 'Old') {
      commentedTopicsList.sort((a, b) {
        DateTime dateA = a['date'].toDate();
        DateTime dateB = b['date'].toDate();
        return dateA.compareTo(dateB); // Sort by latest first or descending order
      });
    }
    return commentedTopicsList;
  }
}
