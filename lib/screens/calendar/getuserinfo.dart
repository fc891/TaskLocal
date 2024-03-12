import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class getUserInfo extends StatelessWidget {
  final String documentId;

  getUserInfo({required this.documentId});

  @override
  Widget build(BuildContext context) {
    CollectionReference<Map<String, dynamic>> taskers = FirebaseFirestore.instance.collection('Taskers').doc(FirebaseAuth.instance.currentUser!.email).collection('Tasks');

    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: taskers.doc(documentId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            Map<String, dynamic>? data = snapshot.data!.data();
            if (data != null) {
              String title = data['title'];
              String note = data['note'];
              String startTime = data['startTime'];
              String endTime = data['endTime'];
              DateTime date = data['date'].toDate();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Title: $title'),
                  Text('Note: $note'),
                  Text('Start Time: $startTime'),
                  Text('End Time: $endTime'),
                  Text('Date: ${DateFormat.yMd().format(date)}'),
                ],
              );
            }
          }
          return Text('No data available');
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
