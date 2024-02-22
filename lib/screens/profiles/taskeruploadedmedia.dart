// ignore_for_file: prefer_const_constructor

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tasklocal/screens/profiles/taskinfo.dart';

//Bill's Tasker Uploadaed Media Screen
class TaskerUploadedMedia extends StatelessWidget {
  const TaskerUploadedMedia({super.key, required this.taskinfo});
  final TaskInfo taskinfo; //WIP: convert this to some sort of image/video once implemented in the future

//Bill's Tasker Uploaded Media screen
  @override
  Widget build(BuildContext context) {
    String taskcategory = taskinfo.taskCategory;
    int tasknumber = taskinfo.taskNumber;
    return Scaffold(
      //Background color of UI
      backgroundColor: Colors.green[500],
      //UI Appbar (bar at top of screen)
      appBar: AppBar(
        title: Text('$taskcategory# $tasknumber'),
        centerTitle: true,
        backgroundColor: Colors.green[800],
        elevation: 0.0,
      ),
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(children: [
          Column(children: <Widget>[
            Text('WIP:',
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 1.0,
                  fontSize: 26.0,
                )),
            Text('Display uploaded media here',
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 1.0,
                  fontSize: 16.0,
                )),
            ]),
        
      ])),
    );
  }
}
