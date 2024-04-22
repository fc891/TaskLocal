import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DiscussionPage extends StatefulWidget {
  final String topicPosterEmail;
  final String taskCategory;
  final String topicTitle;
  final String text;
  final String username;
  final int numOfMsg;
  final List<dynamic> usersLiked;
  final String mmddyy;
  final String time;
  final String timeWithSeconds;
  final Function? onLikeUpdated; // Callback function
  final bool isTextFieldVisible;

  const DiscussionPage({
    Key? key,
    required this.topicPosterEmail,
    required this.taskCategory,
    required this.topicTitle,
    required this.text,
    required this.username,
    required this.numOfMsg,
    required this.usersLiked,
    required this.mmddyy,
    required this.time,
    required this.timeWithSeconds,
    this.onLikeUpdated, // Receive the callback function
    required this.isTextFieldVisible,
  }) : super(key: key);

  @override
  State<DiscussionPage> createState() => _DiscussionPageState();
}

class _DiscussionPageState extends State<DiscussionPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late bool isLiked;
  late List<dynamic> _updatedUsersLiked;
  late int updatedNumOfMsg;
  bool isTextFieldVisible = false; // Add this variable to track visibility
  final commentBoxController = TextEditingController();
  String sortBy = 'New';

  // when user presses the submit button, stores all the inputs of the user to the db
  void _submitPost() async {
    DateTime currentDateTime = DateTime.now();
    final String date = DateFormat('MM/dd/yyyy').format(currentDateTime); 
    String time = DateFormat('h:mm a').format(currentDateTime);
    String timeWithSeconds = DateFormat('h:mm:ss a').format(currentDateTime);

    // provide some dialog when user hasn't enter any info
    BuildContext? dialogContext;
    try {
      // store user's input into the variables
      String commentBox = commentBoxController.text;
       // for public knowledge, go to the Tasker Discussion Board's collection
      final topicTitleDoc = _firestore.collection('Tasker Discussion Board').doc(widget.topicPosterEmail).collection('Posted Topics').doc('${widget.topicTitle}_${widget.timeWithSeconds}');
      // create collection to store the comments
      final commentsDoc = topicTitleDoc.collection('Comments').doc('${_auth.currentUser!.email}_$timeWithSeconds');
      // create dummy values so document is actually created and stored in db
      // commentsDoc.set({'dummy': 'dummy'});

      // for individual purposes
      final commentsDoc2 = _firestore.collection('Taskers').doc(_auth.currentUser!.email).collection('Commented Topics').doc('${widget.topicTitle}_$timeWithSeconds');

      final taskerInfo = await _firestore.collection('Taskers').doc(_auth.currentUser!.email).get();

      // Check if all required fields are filled in
      if (commentBox.isNotEmpty) {
        // store all info in the Task Categories collection
        await commentsDoc.set({
          'text': commentBox,
          'email': _auth.currentUser!.email,
          'username': taskerInfo['username'],
          'date': currentDateTime,
          'date posted': date,
          'date edited': date,
          'time': time,
          'time with seconds': timeWithSeconds,
        });
        await commentsDoc2.set({
          'topic poster email': widget.topicPosterEmail,
          'task category': widget.taskCategory,
          'topic title': widget.topicTitle,
          'location of doc': '${widget.topicTitle}_$timeWithSeconds',
        });
        // Remove the user's input after submitting
        commentBoxController.clear();
        setState(() {
          isTextFieldVisible = false;
          updatedNumOfMsg++;
        });
                // Increment 'num of msg' in the database
        final topicDocRef = _firestore.collection('Tasker Discussion Board').doc(widget.topicPosterEmail).collection('Posted Topics').doc('${widget.topicTitle}_${widget.timeWithSeconds}');
        
        await topicDocRef.update({
          'num of msg': updatedNumOfMsg
        });
        if (widget.onLikeUpdated != null) {
          widget.onLikeUpdated!();
        }
      } else {
        // Show an error message requiring user to fill in the fields 
        showDialog(
          context: dialogContext ?? context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Please write a text.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch(error) {
      // Any error that occurs while inputting info is displayed in a dialog box to the user
      showDialog(
        context: dialogContext ?? context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('There was an error when inputting info: $error'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // Check if the current user has liked the topic
    isLiked = widget.usersLiked.contains(_auth.currentUser!.email);
    _updatedUsersLiked = List.from(widget.usersLiked); // Initialize the updated users liked list
    isTextFieldVisible = widget.isTextFieldVisible;
    updatedNumOfMsg = widget.numOfMsg;
  }

  // Function to update database and call callback
  Future<void> _updateDatabaseAndCallback() async {
    setState(() {
      isLiked = !isLiked;
      if (isLiked) {
        _updatedUsersLiked.add(_auth.currentUser!.email); // Add user to liked list
      } else {
        _updatedUsersLiked.remove(_auth.currentUser!.email); // Remove user from liked list
      }
    });

    final docRef = _firestore.collection('Tasker Discussion Board').doc(widget.topicPosterEmail).collection('Posted Topics').doc('${widget.topicTitle}_${widget.timeWithSeconds}');

    await docRef.update({
      'liked by users': _updatedUsersLiked,
    });

    // Call the callback function to inform the parent widget
    if (widget.onLikeUpdated != null) {
      widget.onLikeUpdated!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    widget.taskCategory,
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  Spacer(),
                  if (_auth.currentUser!.email == widget.topicPosterEmail)
                    IconButton(
                      onPressed: () async {
                        // Get a reference to the document to be deleted
                        final docRef = _firestore
                            .collection('Tasker Discussion Board')
                            .doc(widget.topicPosterEmail)
                            .collection('Posted Topics')
                            .doc('${widget.topicTitle}_${widget.timeWithSeconds}');

                        // Delete the document
                        await docRef.delete();
                        setState(() {
                          
                        });
                        // go back to the DiscussionBoardHome (previous) screen
                        Navigator.pop(context, true);
                      },
                      icon: Icon(Icons.delete),
                    ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                widget.topicTitle,
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              Row(
                children: [
                  Icon(Icons.person),
                  SizedBox(width: 8),
                  Text(
                    '${widget.username} - ${widget.mmddyy} ${widget.time}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                widget.text,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isTextFieldVisible = !isTextFieldVisible; // Toggle visibility
                      });
                    },
                    child: Icon(
                      Icons.message
                    )
                  ),
                  SizedBox(width: 8),
                  // Text(widget.numOfMsg.toString()),
                  Text(updatedNumOfMsg.toString()),
                  SizedBox(width: 16),
                  GestureDetector(
                    onTap: _updateDatabaseAndCallback, // Call function on tap
                    child: Icon(
                      isLiked ? Icons.thumb_up : Icons.thumb_up_alt_outlined,
                      color: isLiked ? Colors.blue : Theme.of(context).iconTheme.color,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(_updatedUsersLiked.length.toString()), // Use updated liked list length
                ],
              ),
              SizedBox(height: 16),
              if (isTextFieldVisible)
                Container(
                  decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.tertiary,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.secondary,
                            width: 1,
                          ),
                        ),
                  child: Column(
                    children: [
                      Container(
                        height: 200,
                        child: TextField(
                          controller: commentBoxController,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            hintText: 'Text',
                            hintStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(10),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: _submitPost,
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 14),
                            ),
                            child: Text(
                              "Comment",
                              style: TextStyle(
                                color: Colors.black,
                                // fontSize: 14,
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                isTextFieldVisible = !isTextFieldVisible; // Toggle visibility
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 25),
                            ),
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                color: Colors.black,
                                // fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    // padding: EdgeInsets.only(right: 20.0),
                    padding: EdgeInsets.symmetric(horizontal: 5),
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
                        iconSize: 30,
                        elevation: 16,
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
                  StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection('Tasker Discussion Board')
                        .doc(widget.topicPosterEmail)
                        .collection('Posted Topics')
                        .doc('${widget.topicTitle}_${widget.timeWithSeconds}')
                        .collection('Comments')
                        .snapshots(),
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
                        final comments = snapshot.data!.docs;
                        if (comments.isEmpty) {
                          return SizedBox(); // Return an empty container if no comments found
                        }

                        // Sort comments based on selected value
                        if (sortBy == 'New') {
                          comments.sort((a, b) {
                            DateTime dateA = a['date'].toDate();
                            DateTime dateB = b['date'].toDate();
                            return dateB.compareTo(dateA); // Sort in descending order (latest first)
                          });
                        } else if (sortBy == 'Old') {
                          comments.sort((a, b) {
                            DateTime dateA = a['date'].toDate();
                            DateTime dateB = b['date'].toDate();
                            return dateA.compareTo(dateB); // Sort in ascending order (oldest first)
                          });
                        }

                        // Map comments to ListTiles
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: comments.length,
                          itemBuilder: (context, index) {
                            final commentData = comments[index].data() as Map<String, dynamic>; // Explicit cast
                            // Ensure that commentData is not null
                            if (commentData.isNotEmpty) {
                              // Safely access fields using '?'
                              final commentText = commentData['text'] as String?;
                              final username = commentData['username'] as String?;
                              final datePosted = commentData['date posted'] as String?;
                              final time = commentData['time'] as String?;
                              final timeWithSeconds = commentData['time with seconds'] as String?;
                              final email = commentData['email']as String?;
                                          
                              // Check for nullability before using the values
                              if (commentText != null && username != null && datePosted != null && time != null) {
                                // Create a ListTile for each comment
                                return Row(
                                  children: [
                                    Expanded(
                                      child: ListTile(
                                        contentPadding: EdgeInsets.all(0),
                                        title: Text(commentText),
                                        subtitle: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('$username'),
                                            Text('$datePosted $time'),
                                            Text(commentText),
                                          ],
                                        ),
                                        // Add additional fields from commentData as needed
                                      ),
                                    ),
                                    if (_auth.currentUser!.email == email)
                                      IconButton(
                                        onPressed: () async {
                                          // Get a reference to the document to be deleted
                                          final docRef = _firestore
                                              .collection('Tasker Discussion Board')
                                              .doc(widget.topicPosterEmail)
                                              .collection('Posted Topics')
                                              .doc('${widget.topicTitle}_${widget.timeWithSeconds}')
                                              .collection('Comments')
                                              .doc('${_auth.currentUser!.email}_$timeWithSeconds');

                                          // Delete the document
                                          await docRef.delete();

                                          setState(() {
                                            updatedNumOfMsg--;
                                          });
                                          // Decrement 'num of msg' in the database
                                          final topicDocRef = _firestore.collection('Tasker Discussion Board').doc(widget.topicPosterEmail)
                                          .collection('Posted Topics').doc('${widget.topicTitle}_${widget.timeWithSeconds}');
                                          
                                          await topicDocRef.update({
                                            'num of msg': updatedNumOfMsg
                                          });
                                          if (widget.onLikeUpdated != null) {
                                            widget.onLikeUpdated!();
                                          }
                                        },
                                        icon: Icon(Icons.delete),
                                      ),
                                  ],
                                );
                              }
                            }
                            // Return an empty container if any required field is null
                            return Container();
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
