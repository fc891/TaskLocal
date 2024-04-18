import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tasklocal/screens/discussion_board/post_discussion_topic.dart';

class DiscussionBoardHome extends StatefulWidget {
  const DiscussionBoardHome({super.key});

  @override
  State<DiscussionBoardHome> createState() => _DiscussionBoardHomeState();
}

class _DiscussionBoardHomeState extends State<DiscussionBoardHome> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
                final date = topic['date'].toDate();
                final taskCategory = topic['task category'];
                final text = topic['text'];
                final topicTitle = topic['topic title'];
                final username = topic['username'];

                return ListTile(
                  title: Text(topicTitle),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Date: $date'),
                      Text('Task Category: $taskCategory'),
                      Text('Text: $text'),
                      Text('Text: $username'),
                    ],
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