import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tasklocal/components/chat_bubble.dart';
import 'package:tasklocal/screens/messages/chat_functionality.dart';

class ChatPage extends StatefulWidget {
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
  final TextEditingController _messageController = TextEditingController();
  final ChatFunctionality _chatFunctionality = ChatFunctionality();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final ScrollController _scrollController = ScrollController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void sendMessage() async {
    List<DocumentSnapshot> senderInfoList = await _retrieveSenderInfo();
    var currUserData = senderInfoList[0].data() as Map<String, dynamic>;

    // if there is no message
    if (_messageController.text.isNotEmpty) {
      await _chatFunctionality.sendMessage(widget.receiverEmail, _messageController.text, currUserData['first name'], currUserData['last name']);
      _messageController.clear();
    }
  }
  Future<List<DocumentSnapshot>> _retrieveSenderInfo() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection(widget.taskersOrCustomersCollection).get();
    // List<DocumentSnapshot> docs = snapshot.docs;
    
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Text Message',
                        contentPadding: EdgeInsets.symmetric(horizontal: 15),
                        // filled: true,
                        // fillColor: Colors.grey[250],
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
                        suffixIcon: IconButton(onPressed: sendMessage, icon: Icon(Icons.arrow_upward, size: 30)),
                      ),
                    ),
                  ),
                ),
                // IconButton(onPressed: sendMessage, icon: Icon(Icons.arrow_upward, size: 30)),
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
          // Scroll the ListView to the bottom when overscroll occurs (keyboard is shown)
          if (notification.overscroll > 0) {
            _scrollToBottom();
          }
        }
        return false;
      },
      child: SingleChildScrollView(
        reverse: true, // Display messages from bottom to top
        controller: _scrollController,
        child: StreamBuilder(
          stream: _chatFunctionality.getMessages(widget.receiverEmail, _firebaseAuth.currentUser!.email), 
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error${snapshot.error}');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text('Loading...');
            }
            return Column(
              children: snapshot.data!.docs.map(
                (document) => _createMessageItem(document)).toList(),
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
    var alignment = (data['senderEmail'] == _firebaseAuth.currentUser!.email) ? Alignment.centerRight : Alignment.centerLeft;
    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          crossAxisAlignment: (data['senderEmail'] == _firebaseAuth.currentUser!.email) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text("${data['senderFirstName']} ${data['senderLastName']}"),
            SizedBox(height: 5),
            ChatBubble(message: data['message']),
          ],
        ),
      ),
    );
  }
}