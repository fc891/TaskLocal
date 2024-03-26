// ignore_for_file: prefer_const_constructor

//Contributors: Bill

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tasklocal/screens/profiles/taskinfo.dart';

//Bill's Tasker Task Category Screen
class TaskerTaskCategory extends StatelessWidget {
  const TaskerTaskCategory({super.key, required this.taskinfo});
  final TaskInfo taskinfo; //WIP: convert this to some sort of image/video once implemented in the future

//Bill's Tasker Task Category screen
  @override
  Widget build(BuildContext context) {
    String taskcategory = taskinfo.taskInfo;
    int tasknumber = taskinfo.taskNumber;
    return Scaffold(
      //Background color of UI
      //backgroundColor: Colors.green[500],
      //UI Appbar (bar at top of screen)
      appBar: AppBar(
        title: Text('$taskcategory# $tasknumber'),
        centerTitle: true,
        //backgroundColor: Colors.green[800],
        elevation: 0.0,
      ),
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(children: [
          Column(children: <Widget>[
            Text('Number of Tasks Completed:',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  letterSpacing: 1.0,
                  fontSize: 26.0,
                )),
            Text('3',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  letterSpacing: 1.0,
                  fontSize: 16.0,
                )),
            ]),
        
      ])),
    );
  }
}
