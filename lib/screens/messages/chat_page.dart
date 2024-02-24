import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tasklocal/screens/messages/chat_functionality.dart';

class ChatPage extends StatefulWidget {
  final String receiverFirstName;
  final String receiverLastName;
  final String receiverUsername;
  final String receiverEmail;
  const ChatPage({
    super.key, 
    required this.receiverFirstName, 
    required this.receiverLastName,
    required this.receiverUsername,
    required this.receiverEmail
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatFunctionality _chatFunctionality = ChatFunctionality();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    // if there is no message
    if (_messageController.text.isNotEmpty) {
      await _chatFunctionality.sendMessage(widget.receiverEmail, _messageController.text);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${widget.receiverFirstName} ${widget.receiverLastName}", 
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 30)),
        centerTitle: true,
        backgroundColor: Colors.green[800],
        elevation: 0.0,
      ),
      body: Column(
        children: [        
          Expanded(
            child: _createMessageList(),
          ),

          //Get the user's input for the message
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Type Message...',
                    filled: true,
                    fillColor: Colors.grey[250],
                    // Richard's code
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black), 
                      borderRadius: BorderRadius.circular(10)
                    ),
                    // Richard's code
                    // border is black by default and when click the search bar border is white
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              IconButton(onPressed: sendMessage, icon: Icon(Icons.arrow_upward, size: 40)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _createMessageList() {
    return StreamBuilder(
      stream: _chatFunctionality.getMessages(widget.receiverEmail, _firebaseAuth.currentUser!.email), 
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text('Loading...');
        }
        return ListView(
          children: snapshot.data!.docs.map(
            (document) => _createMessageItem(document)).toList(),
        );
      },
    );
  }

  Widget _createMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    // align the messages to the right if sender, otherwise to the left
    var alignment = (data['senderEmail'] == _firebaseAuth.currentUser!.email) ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Text(data['senderEmail']), 
            Text(data['message'])
          ],
        ),
      ),
    );
  }
}