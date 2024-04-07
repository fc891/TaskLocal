// Contributors: Richard N.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tasklocal/components/chat_bubble.dart';
import 'package:tasklocal/screens/messages/chat_functionality.dart';

class ChatPage extends StatefulWidget {
  // member variables that are required
  final String receiverFirstName;
  final String receiverLastName;
  final String receiverEmail;
  final String taskersOrCustomersCollection;
  const ChatPage({
    super.key,
    required this.receiverFirstName,
    required this.receiverLastName,
    required this.receiverEmail,
    required this.taskersOrCustomersCollection,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  //
  final TextEditingController _messageController = TextEditingController();
  final ChatFunctionality _chatFunctionality = ChatFunctionality();
  final ScrollController _scrollController = ScrollController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // allow user to send a message to another user
  void sendMessage() async {
    List<DocumentSnapshot> senderInfoList = await _retrieveSenderInfo();
    var currUserData = senderInfoList[0].data() as Map<String, dynamic>;

    // if there is no message, then then a new message can be sent
    if (_messageController.text.isNotEmpty) {
      await _chatFunctionality.sendMessage(
          widget.receiverEmail,
          _messageController.text,
          currUserData['first name'],
          currUserData['last name']);
      _messageController.clear();
    }
  }

  // retrieve info about the logged in user
  Future<List<DocumentSnapshot>> _retrieveSenderInfo() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection(widget.taskersOrCustomersCollection)
        .get();

    // Find the current user/sender's document and return it as a List
    List<DocumentSnapshot> currUserDoc = snapshot.docs.where((doc) {
      Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
      return _auth.currentUser!.email == data['email'];
    }).toList();
    return currUserDoc;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.receiverFirstName} ${widget.receiverLastName}",
            style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.w700,
                fontSize: 25)),
        centerTitle: true,
        //backgroundColor: Colors.green[800],
        elevation: 0.0,
      ),
      body: Column(
        children: [
          Expanded(
            child: _createMessageList(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    child: TextField(
                      controller: _messageController,
                      // get the user's input for the message
                      decoration: InputDecoration(
                        hintText: 'Text Message',
                        hintStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
                        contentPadding: EdgeInsets.symmetric(horizontal: 15),
                        // filled: true,
                        // fillColor: Colors.grey[250],
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary),
                            borderRadius: BorderRadius.circular(10)),
                        // border is black by default and when click the search bar border is white
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        // submit the message to be displayed on screen
                        suffixIcon: IconButton(
                            onPressed: sendMessage,
                            icon: Icon(Icons.arrow_upward, size: 30), color: Theme.of(context).colorScheme.secondary,),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _createMessageList() {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is OverscrollNotification) {
          // ensures the latest messages are always at the bottom when keyboard is shown
          if (notification.overscroll > 0) {
            _scrollToBottom();
          }
        }
        return false;
      },
      child: SingleChildScrollView(
        reverse: true, // show messages from bottom to top
        controller: _scrollController,
        child: StreamBuilder(
          stream: _chatFunctionality.getMessages(
              widget.receiverEmail, _auth.currentUser!.email),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error${snapshot.error}');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text('Loading...');
            }
            return Column(
              children: snapshot.data!.docs
                  .map((document) => _createMessageItem(document))
                  .toList(),
            );
          },
        ),
      ),
    );
  }

  // prevent the keyboard from moving the screen to the top
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  Widget _createMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    // align the messages to the right if sender, to the left if receiver
    var alignment = (data['senderEmail'] == _auth.currentUser!.email)
        ? Alignment.centerRight
        : Alignment.centerLeft;
    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          crossAxisAlignment: (data['senderEmail'] == _auth.currentUser!.email)
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          // display the name of sender with chat bubble's messages
          children: [
            Text("${data['senderFirstName']} ${data['senderLastName']}"),
            SizedBox(height: 5),
            Container(
                constraints: BoxConstraints(maxWidth: 195),
                child: ChatBubble(message: data['message'])),
                
          ],
        ),
      ),
    );
  }
}
