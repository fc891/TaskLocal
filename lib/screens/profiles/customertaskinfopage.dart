// ignore_for_file: prefer_const_constructor

//Contributors: Bill

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tasklocal/screens/profiles/taskinfo.dart';
import 'package:tasklocal/screens/profiles/completedtask.dart';

//Bill's Customer Task Info Screen
class CustomerTaskInfoPage extends StatelessWidget {
  const CustomerTaskInfoPage({super.key, required this.taskinfo});
  final CompletedTask taskinfo;

//Bill's Customer Task Info Screen
  @override
  Widget build(BuildContext context) {
    String category = taskinfo.taskCategory;
    String email = taskinfo.customerEmail;
    String first = taskinfo.customerFirstName;
    String last = taskinfo.customerLastName;
    String username = taskinfo.customerUsername;
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
        title: Text('Requested Task#$tasknumber'),
        centerTitle: true,
        //backgroundColor: Colors.green[800],
        elevation: 0.0,
      ),
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(children: [
        Column(children: <Widget>[
          const SizedBox(height: 10.0),
          //Display task category
          Text('Task Category:',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                letterSpacing: 1.0,
                fontSize: 26.0,
                fontWeight: FontWeight.bold,
              )),
          Text('$category',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                letterSpacing: 1.0,
                fontSize: 18.0,
              )),
          //Display user that task was completed for
          const SizedBox(height: 20.0),
          Text('Task Completed by User:',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                letterSpacing: 1.0,
                fontSize: 26.0,
                fontWeight: FontWeight.bold,
              )),
          Text('$first $last (@$username)',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                letterSpacing: 1.0,
                fontSize: 18.0,
              )),
          //Display task description
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
          //Display task location
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
          //Display date that task was accepted
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
          //Display pay rate ($/hr)
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
