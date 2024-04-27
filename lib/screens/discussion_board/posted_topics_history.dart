// Contributors: Richard N.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tasklocal/screens/discussion_board/discussion_page.dart';

class PostedTopicsHistory extends StatefulWidget {
  final Function onLikeUpdated;
  const PostedTopicsHistory({super.key, required this.onLikeUpdated});
  // const PostedTopicsHistory({super.key});

  @override
  State<PostedTopicsHistory> createState() => _PostedTopicsHistoryState();
}

class _PostedTopicsHistoryState extends State<PostedTopicsHistory> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String sortBy = 'New';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                              MaterialPageRoute(builder: (context) => DiscussionPage(
                                topicPosterEmail: topicPosterEmail, taskCategory: taskCategory, topicTitle: topicTitle, text: text, username: username,
                                numOfMsg: numOfMsg, usersLiked: usersLiked, mmddyy: mmddyy, time: time, timeWithSeconds: timeWithSeconds, 
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
                                          MaterialPageRoute(builder: (context) => DiscussionPage(
                                            topicPosterEmail: topicPosterEmail, taskCategory: taskCategory, topicTitle: topicTitle, text: text, username: username,
                                            numOfMsg: numOfMsg, usersLiked: usersLiked, mmddyy: mmddyy, time: time, timeWithSeconds: timeWithSeconds,
                                            onLikeUpdated: () {
                                              setState(() {});
                                              if (widget.onLikeUpdated != null) {
                                                widget.onLikeUpdated();
                                              }
                                            }, 
                                            isTextFieldVisible: true
                                          )),
                                        ).then((updatedData) {                    
                                          if (updatedData) {
                                            setState(() {});
                                          }
                                        });
                                      },
                                      child: Icon(
                                        Icons.message, 
                                        color: Theme.of(context).colorScheme.secondary
                                      )
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

                                        if (widget.onLikeUpdated != null) {
                                          widget.onLikeUpdated();
                                        }
                                      },
                                      child: Icon(
                                        isLiked ? Icons.thumb_up : Icons.thumb_up_outlined, 
                                        color: isLiked ? Colors.white : Theme.of(context).colorScheme.secondary
                                      ),
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
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                                Text(
                                  '$formattedDate $time', 
                                    style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                              ],
                            ),
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

  Future<List<DocumentSnapshot>> _getPostedTopics(String sortBy) async {
    // Access the collection that stores user info about posted topics
    final postedTopicsCollection = await _firestore.collection('Tasker Discussion Board').doc(_auth.currentUser!.email)
                          .collection('Posted Topics').get();
                          
    // store the doc in the Posted Topics subcollection
    List<DocumentSnapshot> postedTopics = postedTopicsCollection.docs;

    // sort comments depending on the type
    if (sortBy == 'New') {
      postedTopics.sort((a, b) {
        DateTime dateA = a['date'].toDate();
        DateTime dateB = b['date'].toDate();
        return dateB.compareTo(dateA); // Sort by latest first or descending order
      });
    } else if (sortBy == 'Old') {
      postedTopics.sort((a, b) {
        DateTime dateA = a['date'].toDate();
        DateTime dateB = b['date'].toDate();
        return dateA.compareTo(dateB); // Sort by latest first or descending order
      });
    }
    return postedTopics;
  }
}
