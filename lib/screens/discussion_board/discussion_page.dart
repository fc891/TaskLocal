import 'package:flutter/material.dart';

class DiscussionPage extends StatefulWidget {
  final String email;
  final String taskCategory;
  final String topicTitle;
  final String text;
  final String username;
  final int numOfMsg;
  final int numOfLikes;
  final String date;
  const DiscussionPage({super.key, required this.email, required this.taskCategory, required this.topicTitle, required this.text, required this.username, 
  required this.numOfMsg, required this.numOfLikes, required this.date});

  @override
  State<DiscussionPage> createState() => _DiscussionPageState();
}

class _DiscussionPageState extends State<DiscussionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
    );
  }
}