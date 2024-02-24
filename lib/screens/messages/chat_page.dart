import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tasklocal/screens/messages/chat_functionality.dart';

class ChatPage extends StatefulWidget {
  final String receiverFirstName;
  final String receiverLastName;
  final String receiverUsername;
  final String receiverEmail;
  const ChatPage({super.key, required this.receiverFirstName, 
  required this.receiverLastName,
  required this.receiverUsername,
  required this.receiverEmail});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatFunctionality _chatFunctionality = ChatFunctionality();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    // if there is
    if (_messageController.text.isNotEmpty) {
      await _chatFunctionality.sendMessage(widget.receiverEmail, _messageController.text);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${widget.receiverFirstName} ${widget.receiverLastName}")),
      body: Column(
        children: [        
          Expanded(
            child: _createMessageList(),
          ),
          Row(
            children: [
              Expanded
            ],
          ),
        ],
      ),
    );
  }
}