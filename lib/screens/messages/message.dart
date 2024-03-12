// Contributors: Richard N.

import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String? senderEmail;
  final String receiverEmail;
  final String senderFirstName;
  final String senderLastName;
  final String message;
  final Timestamp timestamp;

  Message({
    required this.senderEmail,
    required this.receiverEmail,
    required this.senderFirstName,
    required this.senderLastName,
    required this.message,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderEmail': senderEmail,
      'receiverEmail': receiverEmail,
      'senderFirstName': senderFirstName,
      'senderLastName': senderLastName,
      'message': message,
      'timestamp': timestamp,
    };
  } 
}