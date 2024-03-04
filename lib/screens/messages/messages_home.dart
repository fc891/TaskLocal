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
      stream: _fireStore.collection('Customers').doc(_auth.currentUser!.email).collection('Message Taskers').snapshots(),
      builder: (context, snapshot) {
        // Ensures there is no error when loading in the widget
        if (snapshot.hasError) {
          return const Text('Error');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        // provides a view of the list of taskers
        return ListView(
          children: snapshot.data!.docs.map((doc) => _createEachTasker(doc)).toList(),
        );
      },
    );
  }

  Widget _createEachTasker(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    // shows all the taskers in list of rows
    if(_auth.currentUser!.email != data['email']) {    
        return ListTile(
        leading: CircleAvatar(
          child: Icon(Icons.account_circle),
        ),
        title: Text("${data['first name']} ${data['last name']} @${data['username']}"),
        trailing: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            // Access the logged in customer's collection of taskers that they want to message and
            // remove the tasker document from the collection
            _fireStore.collection('Customers').doc(_auth.currentUser!.email)
                      .collection('Message Taskers').doc(data['email']).delete()
            .then((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Tasker removed'),
                ),
              );
            })
            .catchError((error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: $error'),
                ),
              );
            });
          },
        ),
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