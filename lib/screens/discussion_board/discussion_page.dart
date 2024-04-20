import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DiscussionPage extends StatefulWidget {
  final String email;
  final String taskCategory;
  final String topicTitle;
  final String text;
  final String username;
  final int numOfMsg;
  final List<dynamic> usersLiked;
  final String mmddyy;
  final Function? onLikeUpdated; // Callback function
  final bool isTextFieldVisible;

  const DiscussionPage({
    Key? key,
    required this.email,
    required this.taskCategory,
    required this.topicTitle,
    required this.text,
    required this.username,
    required this.numOfMsg,
    required this.usersLiked,
    required this.mmddyy,
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
  bool isTextFieldVisible = false; // Add this variable to track visibility

  @override
  void initState() {
    super.initState();
    // Check if the current user has liked the topic
    isLiked = widget.usersLiked.contains(_auth.currentUser!.email);
    _updatedUsersLiked = List.from(widget.usersLiked); // Initialize the updated users liked list
    isTextFieldVisible = widget.isTextFieldVisible;
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

    final docRef = _firestore.collection('Tasker Discussion Board').doc(widget.email).collection('Posted Topics').doc(widget.topicTitle);

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
              Text(
                widget.taskCategory,
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.secondary,
                ),
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
                    '${widget.username} - ${widget.mmddyy}',
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
                  Text(widget.numOfMsg.toString()),
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
                height: 200,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiary,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.secondary,
                    width: 1,
                  ),
                ),
                child: TextField(
                  // controller: textController,
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
            ],
          ),
        ),
      ),
    );
  }
}
