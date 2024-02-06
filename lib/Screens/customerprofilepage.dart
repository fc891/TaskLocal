// ignore_for_file: prefer_const_constructor
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CustomerProfilePage extends StatelessWidget {
  
  //WIP
  //Get user's name using some sort of id (username?)
  void getUserName(String id) async{
    var userId = id;
    final snapshot = await FirebaseFirestore.instance.doc('customers/$userId').get();
    if (snapshot.exists) {
      print(snapshot);
    } else {
      print('No data available.');
    }
  }

  //Bill's Customer profile page screen/UI code
  Widget build(BuildContext context) {
    return Scaffold(
      //Background color of UI
      backgroundColor: Colors.green[500],
      appBar: AppBar(
          title: Text('User\'s profile page'),
          centerTitle: true,
          backgroundColor: Colors.green[800],
          elevation: 0.0),
      body: Padding(
        padding: EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0.0),
        child: Column(
          children: <Widget>[
            Text('USERNAME',
              style: TextStyle(
                color: Colors.white,
                letterSpacing: 1.0,
                fontSize: 30.0,
                fontWeight: FontWeight.bold
              )
            ),
            Text('USERNAME',
              style: TextStyle(
                color: Colors.white,
                letterSpacing: 1.0,
                fontSize: 30.0,
                fontWeight: FontWeight.bold
              )
            ),
          ]
        )
      )
    );
  }
}
