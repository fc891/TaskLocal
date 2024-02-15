// ignore_for_file: prefer_const_constructor

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tasklocal/screens/profiles/taskinfo.dart';

//Bill's Task Info Screen
class CustomerTaskInfoPage extends StatelessWidget {
  const CustomerTaskInfoPage({super.key, required this.taskinfo});
  final TaskInfo taskinfo;

//Bill's Customer task info screen
  @override
  Widget build(BuildContext context) {
    String taskcategory = taskinfo.taskCategory;
    int tasknumber = taskinfo.taskNumber;
    return Scaffold(
      //Background color of UI
      backgroundColor: Colors.green[500],
      //UI Appbar (bar at top of screen)
      appBar: AppBar(
        title: Text('Task#$tasknumber'),
        centerTitle: true,
        backgroundColor: Colors.green[800],
        elevation: 0.0,
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Column(children: [
        const Padding(
          padding: EdgeInsets.only(top: 30, bottom: 20),
          // child: Text(
          //   "",
          //   style: TextStyle(fontSize: 20),
          // ),
        ),
      ])),
    );
  }
}
