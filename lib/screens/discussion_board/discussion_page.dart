import 'package:flutter/material.dart';

class DiscussionPage extends StatefulWidget {
  final String email;
  final String taskCategory;
  final String topicTitle;
  final String text;
  final String username;
  final int numOfMsg;
  final int numOfLikes;
  final List<dynamic> usersLiked;
  final String date;
  final String mmddyy;
  const DiscussionPage({super.key, required this.email, required this.taskCategory, required this.topicTitle, required this.text, required this.username, 
                        required this.numOfMsg, required this.numOfLikes, required this.usersLiked, required this.date, required this.mmddyy});

  @override
  State<DiscussionPage> createState() => _DiscussionPageState();
}

class _DiscussionPageState extends State<DiscussionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
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
                  Text (
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
                  Icon(Icons.message),
                  SizedBox(width: 8),
                  Text(widget.numOfMsg.toString()),
                  SizedBox(width: 16),
                  Icon(Icons.thumb_up),
                  SizedBox(width: 8),
                  // Text(widget.numOfLikes.toString()),
                  Text(widget.usersLiked.length.toString()),
                ],
              ),
              SizedBox(height: 16),
              // Add more widgets or components as needed
            ],
          ),
        ),
      ),
    );
  }
}