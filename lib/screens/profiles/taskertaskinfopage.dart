// ignore_for_file: prefer_const_constructor

//Contributors: Bill

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tasklocal/screens/profiles/completedtask.dart';

//Bill's Tasker Task Info Screen
class TaskerTaskInfoPage extends StatelessWidget {
  const TaskerTaskInfoPage({super.key, required this.taskinfo});
  final CompletedTask taskinfo;

//Bill's Tasker Task Info Screen
  @override
  Widget build(BuildContext context) {
    String email = taskinfo.customerEmail;
    String first = taskinfo.customerFirstName;
    String last = taskinfo.customerLastName;
    String desc = taskinfo.description;
    String loc = taskinfo.location;
    String payRate = taskinfo.payRate;
    String date = taskinfo.startDate;
    int tasknumber = taskinfo.taskNumber;
    return Scaffold(
      //Background color of UI
      //backgroundColor: Colors.green[500],
      //UI Appbar (bar at top of screen)
      appBar: AppBar(
        title: Text('Task #$tasknumber'),
        centerTitle: true,
        //backgroundColor: Colors.green[800],
        elevation: 0.0,
      ),
      resizeToAvoidBottomInset: false,
      body: Center(
          child: Column(children: [
        Column(children: <Widget>[
          const SizedBox(height: 10.0),
          Text('Task Completed For User:',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                letterSpacing: 1.0,
                fontSize: 26.0,
                fontWeight: FontWeight.bold,
              )),
          Text('$first $last ($email)',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                letterSpacing: 1.0,
                fontSize: 18.0,
              )),
          const SizedBox(height: 20.0),
          Text('Task Description:',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                letterSpacing: 1.0,
                fontSize: 26.0,
                fontWeight: FontWeight.bold,
              )),
          Text('$desc',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                letterSpacing: 1.0,
                fontSize: 18.0,
              )),
          const SizedBox(height: 20.0),
          Text('Task Location:',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                letterSpacing: 1.0,
                fontSize: 26.0,
                fontWeight: FontWeight.bold,
              )),
          Text('$loc',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                letterSpacing: 1.0,
                fontSize: 18.0,
              )),
          const SizedBox(height: 20.0),
          Text('Start Date:',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                letterSpacing: 1.0,
                fontSize: 26.0,
                fontWeight: FontWeight.bold,
              )),
          Text('$date',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                letterSpacing: 1.0,
                fontSize: 18.0,
              )),
          const SizedBox(height: 20.0),
          Text('Pay Rate:',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                letterSpacing: 1.0,
                fontSize: 26.0,
                fontWeight: FontWeight.bold,
              )),
          Text('\$$payRate/hr',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                letterSpacing: 1.0,
                fontSize: 18.0,
              )),
          const SizedBox(height: 20.0),
        ]),
      ])),
    );
  }
}
