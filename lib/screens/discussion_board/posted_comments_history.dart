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
                        // final topicPosterEmail = topic['email'];
                        // final taskCategory = topic['task category'];
                        // final topicTitle = topic['topic title'];
                        final text = topic['text'];
                        // final mmddyy = topic['formatted date'];
                        final time = topic['time'];
                        final username = topic['username'];
                        // final numOfMsg = topic['num of msg'];
                        // final usersLiked = topic['liked by users'];
                        final timeWithSeconds = topic['time with seconds'];
                        // final locationOfTopicTitleDoc = topic['location of topic title doc'];
                        // Check if the current user has liked the topic
                        // final List<dynamic> likedByUsers = topic['liked by users'] ?? [];
                        final currentUserEmail = _auth.currentUser!.email;
                        // final isLiked = likedByUsers.contains(currentUserEmail);
                    
                        final date = topic['date'].toDate();
                        // final DateFormat formatter = DateFormat('MM/dd/yyyy');
                        final String formattedDate = DateFormat('MM/dd/yyyy').format(date);
                        // final String time = DateFormat('h:mm a').format(date);

                        // final postedTopicData = _firestore.collection('Tasker Discussion Board').doc(topic['topic poster email']).collection('Posted Topics').doc(topic['posted topic location']).get();
                        // _getPostTopicData(topic['topic poster email'], topic['posted topic location']);

                        final topicPosterEmail = topic['topic poster email'];
                        final postedTopicLocation = topic['posted topic location'];
                    
                        return FutureBuilder<DocumentSnapshot>(
                          future: _getPostTopicData(topicPosterEmail, postedTopicLocation),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return CircularProgressIndicator(); // Replace with a loading indicator
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              final postedTopicData = snapshot.data!;
                              return GestureDetector(
                                onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => DiscussionPage(topicPosterEmail: postedTopicData['email'], taskCategory: postedTopicData['task category'], topicTitle: postedTopicData['topic title'], 
                                                                                          text: postedTopicData['text'], username: postedTopicData['username'],
                                                                                          numOfMsg: postedTopicData['num of msg'], usersLiked: postedTopicData['liked by users'], mmddyy: postedTopicData['formatted date'], 
                                                                                          time: postedTopicData['time'], timeWithSeconds: postedTopicData['time with seconds'], 
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
                                      Text('${postedTopicData['task category']}'),
                                      Text('${postedTopicData['topic title']}'),
                                      Text('Commented:'),
                                      Text('$text'),
                                      Text('$formattedDate $time'),
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

  // Define a function to fetch data for a single posted topic
  Future<DocumentSnapshot> _getPostTopicData(String topicPosterEmail, String postedTopicLocation) async {
    final postedTopicData = await _firestore
      .collection('Tasker Discussion Board')
      .doc(topicPosterEmail)
      .collection('Posted Topics')
      .doc(postedTopicLocation)
      .get();
    return postedTopicData;
  }

  Future<List<DocumentSnapshot>> _getPostedComments(String sortBy) async {
    final commentedTopicsCollection = await _firestore.collection('Taskers').doc(_auth.currentUser!.email).collection('Commented Topics').get();
    final List<DocumentSnapshot> commentedTopicsList = [];
    final Set<String> uniqueComments = {}; // Use a set to store unique comments

    for (final commentedTopic in commentedTopicsCollection.docs) {
      final commentedData = commentedTopic.data();
      final topicPosterEmail = commentedData['topic poster email'];
      final locationOfCommentDoc = commentedData['posted topic location'];

      final postedTopics = _firestore.collection('Tasker Discussion Board').doc(topicPosterEmail);
      final tasker = await postedTopics.collection('Posted Topics').doc(locationOfCommentDoc).collection('Comments').where('email', isEqualTo: _auth.currentUser!.email).get();

      // commentedTopicsList.addAll(tasker.docs);
      for (final doc in tasker.docs) {
        final commentId = doc.id; // Assuming each comment has a unique ID
        if (!uniqueComments.contains(commentId)) { // Check if the comment is unique
          uniqueComments.add(commentId); // Add the comment ID to the set
          commentedTopicsList.add(doc); // Add the comment to the list
        }
      }
      // print(commentedTopicsList);
    }

    // Sort comments based on selected value
    if (sortBy == 'New') {
      commentedTopicsList.sort((a, b) {
        DateTime dateA = a['date'].toDate();
        DateTime dateB = b['date'].toDate();
        return dateB.compareTo(dateA); // Sort in descending order (latest first)
      });
    } else if (sortBy == 'Old') {
      commentedTopicsList.sort((a, b) {
        DateTime dateA = a['date'].toDate();
        DateTime dateB = b['date'].toDate();
        return dateA.compareTo(dateB); // Sort in ascending order (oldest first)
      });
    }

    // for (DocumentSnapshot doc in commentedTopicsList) {
    //   print(doc.data()); // Print entire data of the document
    // }

    return commentedTopicsList;
  }


  // Future<List<DocumentSnapshot>> _getPostedTopics(String sortBy) async {
  //   // Access the collection that stores user's signed up tasks
  //   final postedTopicsCollection = await _firestore.collection('Tasker Discussion Board').doc(_auth.currentUser!.email)
  //                         .collection('Posted Topics').get();
                          
  //   // List to store the documents in the Posted Topics subcollection
  //   List<DocumentSnapshot> postedTopics = postedTopicsCollection.docs;

  //   // Sort comments based on selected value
  //   if (sortBy == 'New') {
  //     postedTopics.sort((a, b) {
  //       DateTime dateA = a['date'].toDate();
  //       DateTime dateB = b['date'].toDate();
  //       return dateB.compareTo(dateA); // Sort in descending order (latest first)
  //     });
  //   } else if (sortBy == 'Old') {
  //     postedTopics.sort((a, b) {
  //       DateTime dateA = a['date'].toDate();
  //       DateTime dateB = b['date'].toDate();
  //       return dateA.compareTo(dateB); // Sort in ascending order (oldest first)
  //     });
  //   }
  //   return postedTopics;
  // }

  // // retrieves the comments that the user made on posted topics
  // Future<Map<String, List<DocumentSnapshot>>> _getPostedComments(String sortBy) async {
  //   // access the collection that stores the users comments
  //   final commentedTopicsCollection = await _firestore.collection('Taskers').doc(_auth.currentUser!.email).collection('Commented Topics').get();
  //   final commentedTopicsList = <String, List<DocumentSnapshot>>{};

  //   // go through the Commented Topics collection to view each comments
  //   for (final commentedTopic in commentedTopicsCollection.docs) {
  //     final commentedData = commentedTopic.data();
  //     final topicPosterEmail = commentedData['topic poster email'];
  //     final locationOfCommentDoc = commentedData['location of comments doc'];
  //     // retrieve posted topic from specific poster
  //     final postedTopics = _firestore.collection('Tasker Discussion Board').doc(topicPosterEmail);
  //     // go to the Comments collection from the Posted Topics collection
  //     final tasker = await postedTopics.collection('Posted Topics').doc(locationOfCommentDoc).collection('Comments').where('email', isEqualTo: _auth.currentUser!.email).get();
  //     // if categroy name is not stored in list, then create the key and assign it an empty list.
  //     if (!commentedTopicsList.containsKey(locationOfCommentDoc)) {
  //       commentedTopicsList[locationOfCommentDoc] = [];
  //     }
  //     commentedTopicsList[locationOfCommentDoc]!.addAll(tasker.docs);
  //   }
  //   // Sort comments based on selected value
  //   commentedTopicsList.forEach((key, value) {
  //     if (sortBy == 'New') {
  //       value.sort((a, b) {
  //         DateTime dateA = a['date'].toDate();
  //         DateTime dateB = b['date'].toDate();
  //         return dateB.compareTo(dateA); // Sort in descending order (latest first)
  //       });
  //     } else if (sortBy == 'Old') {
  //       value.sort((a, b) {
  //         DateTime dateA = a['date'].toDate();
  //         DateTime dateB = b['date'].toDate();
  //         return dateA.compareTo(dateB); // Sort in ascending order (oldest first)
  //       });
  //     }
  //   });
  //   return commentedTopicsList;
  // }
}
