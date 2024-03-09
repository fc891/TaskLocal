// Contributors: Richard N.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tasklocal/screens/messages/message.dart';

class ChatFunctionality extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  
  // allow users to send a message to another user
  Future<void> sendMessage(String receiverEmail, String message, String senderFirstName, String senderLastName) async {
    // retrieve the logged in user email
    final String? currUserEmail = _auth.currentUser!.email;
    final Timestamp timestamp = Timestamp.now();

    // an instance of Message to store information about the message
    Message newMessage = Message(
      senderEmail: currUserEmail,
      senderFirstName: senderFirstName,
      senderLastName: senderLastName,
      receiverEmail: receiverEmail,
      message: message, 
      timestamp: timestamp
    );
    // ensures the messages between users are sorted and accessible
    List<String?> emails = [currUserEmail, receiverEmail];
    emails.sort();
    String chatAreaEmail = emails.join("_");
    // add new messages between the users
    await _fireStore.collection("Chatting Area").doc(chatAreaEmail).collection('messages').add(newMessage.toMap());
    // await _fireStore.collection('Customers').doc(currUserEmail).collection('Message Taskers').doc(receiverEmail).collection('messages').add(newMessage.toMap());
  }

  // retrieve messages from the database
  Stream<QuerySnapshot> getMessages(String receiverEmail, senderEmail) {
    // create the document between users to access in db
    List<String> emails = [receiverEmail, senderEmail];
    emails.sort();
    String chatAreaEmail = emails.join("_"); 
    // provides the messages in order of the timestampo
    return _fireStore.collection('Chatting Area').doc(chatAreaEmail).collection('messages')
          .orderBy('timestamp', descending: false).snapshots();
    // return _fireStore.collection('Customers').doc(senderEmail).collection('Message Taskers').doc(receiverEmail).collection('messages')
    //       .orderBy('timestamp', descending: false).snapshots();
  }

}