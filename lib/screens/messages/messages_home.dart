// Contributors: Richard N.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tasklocal/screens/messages/chat_page.dart';
import 'package:tasklocal/screens/messages/msg_list_to_add.dart';

class MessagesHome extends StatefulWidget {
  const MessagesHome({super.key});

  @override
  State<MessagesHome> createState() => _MessagesHomeState();
}

class _MessagesHomeState extends State<MessagesHome> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.green[800],
        elevation: 0.0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MsgListToAdd())
              );
            },
            icon: Icon(
              Icons.message,
              color: Colors.grey[300],
            ),
          ),
        ],
      ),
      body: _createListOfTaskers(),
    );
  }
  // original
  //   Widget _createListOfTaskers() {
  //   return StreamBuilder<QuerySnapshot>(
  //     // later find a way to have customers add and remove taskers to their messages page
  //     stream: FirebaseFirestore.instance.collection('Customers').doc(_auth.currentUser!.email).snapshots(),
  //     builder: (context, snapshot) {
  //       if (snapshot.hasError) {
  //         return const Text('error');
  //       }
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return const Text('');
  //       }
  //       return ListView(
  //         children: snapshot.data!.docs.map<Widget>((doc) => _createEachListOfTaskers(doc)).toList(),
  //       );
  //     },
  //   );
  // }

  Widget _createListOfTaskers() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Customers').doc(_auth.currentUser!.email).collection('Message Taskers').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        // Reference to the user's document
        DocumentReference userDocRef = _fireStore.collection('Customers').doc(_auth.currentUser!.email);
        
        // Check if the 'messages' collection exists in the user's document
        userDocRef.collection('Message Taskers').get().then((querySnapshot) {
          if (querySnapshot.size == 0) {
            // 'messages' collection doesn't exist, create it
            // userDocRef.collection('Message Taskers').doc('placeholder').set({});
            userDocRef.collection('Message Taskers').doc('placeholder');
          }
        });

        // // Extracting documents from the snapshot
        // final List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
        // // Mapping documents to widgets using _createEachListOfTaskers
        // final List<Widget> widgets = documents.map((doc) => _createEachListOfTaskers(doc)).toList();

        return ListView(
          children: snapshot.data!.docs.map((doc) => _createEachListOfTaskers(doc)).toList(),
        );
        // final userData = snapshot.data!.data() as Map<String, dynamic>;
        // final taskersData = userData['taskers'] ?? []; // Assuming 'taskers' is a list
        // return ListView(
        //   // children: snapshot.data!.docs.map<Widget>((doc) => _createEachListOfTaskers(doc)).toList(),
        //   children: taskersData.map<Widget>((tasker) => _createEachListOfTaskers(tasker)).toList(),
        // );
      },
    );
  }


  // create each taskers record object
  Widget _createEachListOfTaskers(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    // shows the entire taskers
    if(_auth.currentUser!.email != data['email']) {    
        return ListTile(
        leading: CircleAvatar(
          child: Icon(Icons.account_circle),
        ),
        title: Text("${data['first name']} ${data['last name']} @${data['username']}"),
        onTap: () {
          Navigator.push(context, 
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverFirstName: data['first name'],
                receiverLastName: data['last name'],
                receiverEmail: data['email'],
              ),
            )
          );
        },
      );
    }
    return Container();
  }
}