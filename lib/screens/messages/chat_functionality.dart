import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tasklocal/screens/messages/message.dart';

class ChatFunctionality extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  
  // allow users to send a message
  Future<void> sendMessage(String receiverEmail, String message, String senderFirstName, String senderLastName) async {
    // retrieve the user information
    final String? currUserEmail = _auth.currentUser!.email;
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
      senderEmail: currUserEmail,
      senderFirstName: senderFirstName,
      senderLastName: senderLastName,
      receiverEmail: receiverEmail,
      message: message, 
      timestamp: timestamp)
    ;

    List<String?> emails = [currUserEmail, receiverEmail];
    emails.sort();
    String chatAreaEmail = emails.join("_");
    await _fireStore.collection("Chatting Area").doc(chatAreaEmail).collection('messages').add(newMessage.toMap());
    // await _fireStore.collection('Customers').doc(currUserEmail).collection('Message Taskers').doc(receiverEmail).collection('messages').add(newMessage.toMap());
  }

  // Retrieve messages
  Stream<QuerySnapshot> getMessages(String receiverEmail, senderEmail) {
    List<String> emails = [receiverEmail, senderEmail];
    emails.sort();
    String chatAreaEmail = emails.join("_"); 
    return _fireStore.collection('Chatting Area').doc(chatAreaEmail).collection('messages')
          .orderBy('timestamp', descending: false).snapshots();
    // return _fireStore.collection('Customers').doc(senderEmail).collection('Message Taskers').doc(receiverEmail).collection('messages')
    //       .orderBy('timestamp', descending: false).snapshots();
  }

}