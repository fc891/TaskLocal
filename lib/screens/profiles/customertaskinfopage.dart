// ignore_for_file: prefer_const_constructor

//Contributors: Bill

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tasklocal/screens/profiles/taskinfo.dart';

//Bill's Customer Task Info Screen
class CustomerTaskInfoPage extends StatelessWidget {
  const CustomerTaskInfoPage({super.key, required this.taskinfo});
  final TaskInfo taskinfo;

//Bill's Customer Task Info Screen
  @override
  Widget build(BuildContext context) {
    String taskcategory = taskinfo.taskInfo;
    int tasknumber = taskinfo.taskNumber;
    return Scaffold(
      //Background color of UI
      backgroundColor: Colors.green[500],
      //UI Appbar (bar at top of screen)
      appBar: AppBar(
        title: Text('Customer Task#$tasknumber'),
        centerTitle: true,
        backgroundColor: Colors.green[800],
        elevation: 0.0,
      ),
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(children: [
          Column(children: <Widget>[
            Text('Task Completed Date:',
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 1.0,
                  fontSize: 26.0,
                )),
            Text('testdate',
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 1.0,
                  fontSize: 16.0,
                )),
            Text('Tasks Completed By:',
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 1.0,
                  fontSize: 26.0,
                )),
            Text('taskername',
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 1.0,
                  fontSize: 16.0,
                )),
            Text('Task Duration:',
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 1.0,
                  fontSize: 26.0,
                )),
            Text('testduration',
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 1.0,
                  fontSize: 16.0,
                )),
            Text('Price: 20',
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 1.0,
                  fontSize: 26.0,
                )),
            Text('20',
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
