// ignore_for_file: prefer_const_constructor

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tasklocal/screens/profiles/taskinfo.dart';

//Bill's Tasker Task Info Screen
class TaskerTaskInfoPage extends StatelessWidget {
  const TaskerTaskInfoPage({super.key, required this.taskinfo});
  final TaskInfo taskinfo;

//Bill's Tasker Task Info Screen
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
            Text('Task Completed Date:',
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 1.0,
                  fontSize: 26.0,
                )),
            Text('testcompleteddate',
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 1.0,
                  fontSize: 16.0,
                )),
            Text('Tasks Completed For User:',
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 1.0,
                  fontSize: 26.0,
                )),
            Text('customername',
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
            Text('Earnings:',
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
