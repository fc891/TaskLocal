import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiverFirstName;
  final String receiverLastName;
  final String receiverUsername;
  const ChatPage({super.key, required this.receiverFirstName, 
  required this.receiverLastName,
  required this.receiverUsername,});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${widget.receiverFirstName} ${widget.receiverLastName}")),
    );
  }
}