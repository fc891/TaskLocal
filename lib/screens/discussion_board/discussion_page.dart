// Contributors: Richard N.

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
  final Function? onLikeUpdated;
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
    this.onLikeUpdated,
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
  bool isTextFieldVisible = false; // determines whether keyboard opens up
  final commentBoxController = TextEditingController();
  String sortBy = 'New';

  // after user presses the submit button, stores all the inputs of the user to the db
  void _submitPost() async {
    DateTime currentDateTime = DateTime.now();
    final String date = DateFormat('MM-dd-yy').format(currentDateTime); 
    String time = DateFormat('h:mm a').format(currentDateTime);
    String timeWithSeconds = DateFormat('h:mm:ss a').format(currentDateTime);

    // provide some dialog when user hasn't enter any info
    BuildContext? dialogContext;
    try {
      // store user's input into the variables
      String commentBox = commentBoxController.text;
       // for public knowledge, go to the Tasker Discussion Board's collection
      final topicTitleDoc = _firestore.collection('Tasker Discussion Board').doc(widget.topicPosterEmail)
                            .collection('Posted Topics').doc('${widget.topicTitle}_${widget.mmddyy}_${widget.timeWithSeconds}');
      // create collection to store the comments
      final commentsDoc = topicTitleDoc.collection('Comments').doc('${_auth.currentUser!.email}_${date}_$timeWithSeconds');
      // create dummy values so document is actually created and stored in db
      // commentsDoc.set({'dummy': 'dummy'});

      // for individual purposes
      final commentsDoc2 = _firestore.collection('Taskers').doc(_auth.currentUser!.email)
                          .collection('Commented Topics').doc('${_auth.currentUser!.email}_${date}_$timeWithSeconds');

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

          'posted topic location': '${widget.topicTitle}_${widget.mmddyy}_${widget.timeWithSeconds}',
          'topic poster email': widget.topicPosterEmail,
        });
        await commentsDoc2.set({
          'topic poster email': widget.topicPosterEmail,
          'task category': widget.taskCategory,
          'topic title': widget.topicTitle,
          'posted topic location': '${widget.topicTitle}_${widget.mmddyy}_${widget.timeWithSeconds}',
          'posted comment location': '${_auth.currentUser!.email}_${date}_$timeWithSeconds',
        });
        // Clear the user's input after submitting
        commentBoxController.clear();

        // removes keyboard and increment number of msg
        setState(() {
          isTextFieldVisible = false;
          updatedNumOfMsg++;
        });

        final topicDocRef = _firestore.collection('Tasker Discussion Board').doc(widget.topicPosterEmail)
                            .collection('Posted Topics').doc('${widget.topicTitle}_${widget.mmddyy}_${widget.timeWithSeconds}');
        // update in db
        await topicDocRef.update({
          'num of msg': updatedNumOfMsg
        });

        // go back to previous page to update the UI for the number of comments
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

  // Initialize the variables
  @override
  void initState() {
    super.initState();
    // Check if the current user has liked the topic
    isLiked = widget.usersLiked.contains(_auth.currentUser!.email);
    _updatedUsersLiked = List.from(widget.usersLiked); // used to display the number of likes in the UI and show the current user like
    isTextFieldVisible = widget.isTextFieldVisible;
    updatedNumOfMsg = widget.numOfMsg;
  }

  // udpate database
  Future<void> _updateDatabaseAndCallback() async {
    setState(() {
      isLiked = !isLiked;
      if (isLiked) {
        _updatedUsersLiked.add(_auth.currentUser!.email);
      } else {
        _updatedUsersLiked.remove(_auth.currentUser!.email);
      }
    });

    final docRef = _firestore.collection('Tasker Discussion Board').doc(widget.topicPosterEmail)
                  .collection('Posted Topics').doc('${widget.topicTitle}_${widget.mmddyy}_${widget.timeWithSeconds}');

    await docRef.update({
      'liked by users': _updatedUsersLiked,
    });

    // go back to previous page to update the UI for number of likes and show current user like
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
              Container(
                height: 40,
                child: Row(
                  children: [
                    Text(
                      widget.taskCategory,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    Spacer(),
                    // user can only delete the topic post if its theirs
                    if (_auth.currentUser!.email == widget.topicPosterEmail)
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.delete_outline, color: Theme.of(context).colorScheme.secondary, size: 25),
                            onPressed: () async {
                              // ensure user really wants to remove the topic
                              bool confirmed = await showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Confirm Deletion'),
                                  content: Text('Are you sure want to delete the discussion topic?'),
                                  backgroundColor: Theme.of(context).colorScheme.tertiary,
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(true),
                                      child: Text('Confirm'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(false),
                                      child: Text('Cancel'),
                                    ),
                                  ],
                                ),
                              );
                              if (confirmed == true) {                            
                              // Get a reference to the document to be deleted
                                final docRef = _firestore
                                    .collection('Tasker Discussion Board')
                                    .doc(widget.topicPosterEmail)
                                    .collection('Posted Topics')
                                    .doc('${widget.topicTitle}_${widget.mmddyy}_${widget.timeWithSeconds}');
                                          
                                // Delete the document
                                await docRef.delete();
                                // setState(() {});

                                // Access the posted topic from the tasker's individual collection
                                final postedTopicDoc = _firestore.collection('Taskers').doc(_auth.currentUser!.email)
                                                      .collection('Posted Topics').doc('${widget.topicTitle}_${widget.mmddyy}_${widget.timeWithSeconds}');
                                // remove the posted topic from the tasker's individual collection
                                await postedTopicDoc.delete();

                                // go back to the DiscussionBoardHome (previous) screen to update the UI
                                Navigator.pop(context, true);
                              }
                            },
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              Text(
                widget.topicTitle,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    '${widget.mmddyy} ${widget.time}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              ), 
              Row(
                children: [
                  Text(
                    '@${widget.username}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                widget.text,
                style: TextStyle(fontSize: 20),
              ),              
              SizedBox(height: 16),
              Row(
                children: [
                  GestureDetector(
                    // toggle keyboard visibility
                    onTap: () {
                      setState(() {
                        isTextFieldVisible = !isTextFieldVisible;
                      });
                    },
                    child: Icon(
                      Icons.message, color: Theme.of(context).colorScheme.secondary,
                    )
                  ),
                  SizedBox(width: 8),
                  Text(updatedNumOfMsg.toString()),
                  SizedBox(width: 16),
                  GestureDetector(
                    onTap: _updateDatabaseAndCallback, // Call function on tap
                    child: Icon(
                      isLiked ? Icons.thumb_up : Icons.thumb_up_alt_outlined,
                      color: isLiked ? Colors.white : Theme.of(context).colorScheme.secondary,                
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(_updatedUsersLiked.length.toString()),
                ],
              ),
              SizedBox(height: 16),
              if (isTextFieldVisible)
                Column(
                  children: [
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
                    SizedBox(height: 16),
                  ],
                ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text( 'Sort by:', style: TextStyle(color: Colors.white)),
                      SizedBox(width: 10),
                      Container(
                        // padding: EdgeInsets.only(right: 20.0),
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
                  StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection('Tasker Discussion Board')
                        .doc(widget.topicPosterEmail)
                        .collection('Posted Topics')
                        .doc('${widget.topicTitle}_${widget.mmddyy}_${widget.timeWithSeconds}')
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
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: comments.length,
                          itemBuilder: (context, index) {
                            final commentData = comments[index].data() as Map<String, dynamic>;
                            if (commentData.isNotEmpty) {
                              final commentText = commentData['text'] as String?;
                              final username = commentData['username'] as String?;
                              final datePosted = commentData['date posted'] as String?;
                              final time = commentData['time'] as String?;
                              final timeWithSeconds = commentData['time with seconds'] as String?;
                              final email = commentData['email']as String?;
                              final date = commentData['date'].toDate();
                              final String dateWithSlash = DateFormat('MM/dd/yyyy').format(date);

                              if (commentText != null && username != null && datePosted != null && time != null) {
                                // Create a ListTile for each comment
                                return Column(
                                  children: [
                                    ListTile(
                                      contentPadding: EdgeInsets.all(0),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(commentText, style: TextStyle(color: Colors.white, fontSize: 16)),
                                          if (_auth.currentUser!.email != email)
                                            SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text('$dateWithSlash $time', style: TextStyle(color: Colors.white, fontSize: 12)),
                                                  Text(username, style: TextStyle(color: Colors.white, fontSize: 12)),
                                                ],
                                              ),
                                              SizedBox(width: 20),
                                              if (_auth.currentUser!.email == email)
                                                IconButton(
                                                  icon: Icon(Icons.delete_outline, color: Theme.of(context).colorScheme.secondary, size: 25),
                                                  onPressed: () async {
                                                    bool confirmed = await showDialog(
                                                      context: context,
                                                      builder: (context) => AlertDialog(
                                                        title: Text('Confirm Deletion'),
                                                        content: Text('Are you sure want to delete the comment?'),
                                                        backgroundColor: Theme.of(context).colorScheme.tertiary,
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () => Navigator.of(context).pop(true),
                                                            child: Text('Confirm'),
                                                          ),
                                                          TextButton(
                                                            onPressed: () => Navigator.of(context).pop(false),
                                                            child: Text('Cancel'),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                    if (confirmed == true) { 
                                                      final docRef = _firestore
                                                          .collection('Tasker Discussion Board')
                                                          .doc(widget.topicPosterEmail)
                                                          .collection('Posted Topics')
                                                          .doc('${widget.topicTitle}_${widget.mmddyy}_${widget.timeWithSeconds}')
                                                          .collection('Comments')
                                                          .doc('${_auth.currentUser!.email}_${datePosted}_$timeWithSeconds');
                                                                                    
                                                      // Delete the document
                                                      await docRef.delete();
                                                                                    
                                                      setState(() {
                                                        updatedNumOfMsg--;
                                                      });
                                                      
                                                      final topicDocRef = _firestore.collection('Tasker Discussion Board').doc(widget.topicPosterEmail)
                                                                      .collection('Posted Topics').doc('${widget.topicTitle}_${widget.mmddyy}_${widget.timeWithSeconds}');
                                                      
                                                      await topicDocRef.update({
                                                        'num of msg': updatedNumOfMsg
                                                      });

                                                      // Access the comment from the tasker's individual collection
                                                      final commentsDoc = _firestore.collection('Taskers').doc(_auth.currentUser!.email)
                                                                          .collection('Commented Topics').doc('${_auth.currentUser!.email}_${datePosted}_$timeWithSeconds');
                                                      // remove the comment from the tasker's individual collection
                                                      await commentsDoc.delete();

                                                      // update the UI for the DiscussionBoardHome (previous) screen
                                                      if (widget.onLikeUpdated != null) {
                                                        widget.onLikeUpdated!();
                                                      }
                                                    }
                                                  },
                                                ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(color: Colors.white,),
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
