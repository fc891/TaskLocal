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
                          // user can select the type of length that corresponds to their amount of experience
                          child: DropdownButton<String>(
                            value: sortBy,
                            icon: Icon(Icons.arrow_drop_down, color: Colors.white,),
                            // iconSize: 30,
                            // elevation: 16,
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
                        // Check if the current user has liked the topic
                        final List<dynamic> likedByUsers = topic['liked by users'] ?? [];
                        final currentUserEmail = _auth.currentUser!.email;
                        final isLiked = likedByUsers.contains(currentUserEmail);
                    
                        final date = topic['date'].toDate();
                        // final DateFormat formatter = DateFormat('MM/dd/yyyy');
                        final String formattedDate = DateFormat('MM/dd/yyyy').format(date);
                        // final String time = DateFormat('h:mm a').format(date);
                    
                        return GestureDetector(
                            onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => DiscussionPage(topicPosterEmail: topicPosterEmail, taskCategory: taskCategory, topicTitle: topicTitle, text: text, username: username,
                                                                                      numOfMsg: numOfMsg, usersLiked: usersLiked, mmddyy: mmddyy, time: time, timeWithSeconds: timeWithSeconds, 
                                                                                      onLikeUpdated: () {
                                    // Trigger rebuild when like is updated
                                    setState(() {});

                                    // Trigger rebuild when like is updated
                                            if (widget.onLikeUpdated != null) {
                                              widget.onLikeUpdated();
                                            }
                                  }, isTextFieldVisible: false)),
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
                                    Text('$taskCategory'),
                                    Spacer(),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => DiscussionPage(topicPosterEmail: topicPosterEmail, taskCategory: taskCategory, topicTitle: topicTitle, text: text, username: username,
                                                                                                  numOfMsg: numOfMsg, usersLiked: usersLiked, mmddyy: mmddyy, time: time, timeWithSeconds: timeWithSeconds,
                                                                                                  onLikeUpdated: () {
                                                // Trigger rebuild when like is updated
                                                setState(() {});

                                                // Trigger rebuild when like is updated
                                            if (widget.onLikeUpdated != null) {
                                              widget.onLikeUpdated();
                                            }

                                              }, isTextFieldVisible: true)),
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

                                            // Trigger rebuild when like is updated
                                            if (widget.onLikeUpdated != null) {
                                              widget.onLikeUpdated();
                                            }


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
                                Text('$formattedDate $time'),
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
    // Access the collection that stores user's signed up tasks
    final postedTopicsCollection = await _firestore.collection('Tasker Discussion Board').doc(_auth.currentUser!.email)
                          .collection('Posted Topics').get();
                          
    // List to store the documents in the Posted Topics subcollection
    List<DocumentSnapshot> postedTopics = postedTopicsCollection.docs;

    // Sort comments based on selected value
    if (sortBy == 'New') {
      postedTopics.sort((a, b) {
        DateTime dateA = a['date'].toDate();
        DateTime dateB = b['date'].toDate();
        return dateB.compareTo(dateA); // Sort in descending order (latest first)
      });
    } else if (sortBy == 'Old') {
      postedTopics.sort((a, b) {
        DateTime dateA = a['date'].toDate();
        DateTime dateB = b['date'].toDate();
        return dateA.compareTo(dateB); // Sort in ascending order (oldest first)
      });
    }
    return postedTopics;
  }
}
