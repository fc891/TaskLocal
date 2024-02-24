import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tasklocal/screens/messages/message.dart';

class ChatFunctionality extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  
  // allow users to send a message
  Future<void> sendMessage(String receiverEmail, String message) async {
    // retrieve the user information
    final String? currUserEmail = _firebaseAuth.currentUser!.email;
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
      senderEmail: currUserEmail,
      receiverEmail: receiverEmail,
      message: message, 
      timestamp: timestamp)
    ;

    // 
    List<String?> emails = [currUserEmail, receiverEmail];
    emails.sort();
    String chatAreaEmail = emails.join("_");
    await _fireStore.collection("chat area").doc(chatAreaEmail).collection('messages').add(newMessage.toMap());
  }

  // Retrieve messages
  Stream<QuerySnapshot> getMessages(String firstUserEmail, secondUserEmail) {
    List<String?> emails = [firstUserEmail, secondUserEmail];
    emails.sort();
    String chatAreaEmail = emails.join("_"); 
    return _fireStore.collection('chat area').doc(chatAreaEmail).collection('messages')
    .orderBy('timestamp', descending: false).snapshots();
  }

}