// ignore_for_file: prefer_const_constructor

//Contributors: Bill

import 'dart:ffi';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:tasklocal/screens/profiles/taskereditprofile.dart';
import 'package:tasklocal/screens/profiles/taskertaskinfopage.dart';
import 'package:tasklocal/screens/profiles/taskeruploadedmedia.dart';
import 'package:tasklocal/screens/profiles/taskertaskcategory.dart';
import 'package:tasklocal/screens/profiles/taskinfo.dart';

FirebaseAuth firebaseAuth = FirebaseAuth.instance;

//Bill's Tasker Profile Page Screen
class TaskerProfilePage extends StatefulWidget {
  const TaskerProfilePage({super.key});
  @override
  State<TaskerProfilePage> createState() => _TaskerProfilePageState();
}

//Bill's Tasker Profile Page Screen
class _TaskerProfilePageState extends State<TaskerProfilePage> {
  String username = "Testlocal123";
  String firstname = "First";
  String lastname = "Last";
  String date = 'dd-MM-yyyy';
  int taskscompleted = 0;
  double rating = 5.0;

  //WIP
  //Bill's get user's info using testid (username right now)
  void getUserInfo(String testid) async {
    var collection = FirebaseFirestore.instance.collection('Taskers');
    var docSnapshot = await collection.doc(testid).get();
    Map<String, dynamic> data = docSnapshot.data()!;
    setState(() {
      username = data['username'];
      firstname = data['first name'];
      lastname = data['last name'];
    });
  }

  //WIP
  //Bill's get user's join date using id
  void getJoinDate(String id) async {
    DateFormat joindateformat = DateFormat('MM-dd-yyyy');
    DateTime joindate = DateTime(2024, 2, 12);
    date = joindateformat.format(joindate);
  }

  //WIP
  //Bill's get user's number of requested tasks completed using id
  void getTaskssCompleted(String id) async {
    taskscompleted = 10;
  }

  //Bill's function to run all getters above to initialize variables
  void runGetters() {
    var current = FirebaseAuth.instance
        .currentUser!; //Use to get the info of the currently logged in user
    String testid = current.email!; //Get email of current user

    getUserInfo(testid);
    getJoinDate(testid);
    getTaskssCompleted(testid);
  }

  //Bill's Tasker profile page screen/UI code
  @override
  Widget build(BuildContext context) {
    runGetters(); //Run all getter functions
    return Scaffold(
        //Background color of UI
        backgroundColor: Colors.green[500],
        appBar: AppBar(
          title: Text('${username}\'s profile page'),
          centerTitle: true,
          backgroundColor: Colors.green[800],
          elevation: 0.0,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TaskerEditProfile()));
              },
              icon: Icon(
                Icons.edit_outlined,
                color: Colors.grey[300],
              ),
            ),
          ],
        ),
        //Profile page picture
        body: Padding(
            padding: EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 0.0),
            child: Column(children: <Widget>[
              Center(
                child: CircleAvatar(
                  child: Image.asset('lib/images/tasklocaltransparent.png'),
                  radius: 40.0,
                ),
              ),
              Center(
                //Username text
                child: Text('$firstname $lastname',
                    style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 1.0,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold)),
              ),
              //Display tasker info on profile page (join date, # tasks completed, user rating)
              Column(children: <Widget>[
                Text('Join Date: $date',
                    style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 1.0,
                      fontSize: 16.0,
                    )),
                Text('Tasks Completed: $taskscompleted',
                    style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 1.0,
                      fontSize: 16.0,
                    )),
                Text('User Rating: $rating',
                    style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 1.0,
                      fontSize: 16.0,
                    )),
              ]),
              //Divider (line)
              Divider(
                height: 20.0,
                color: Colors.grey[1500],
              ),
              //List task categories of tasker
              Text('Task Categories',
                  style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 1.3,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold)),
              Divider(
                height: 20.0,
                color: Colors.grey[1500],
              ),
              //Task Categories Display
              Flexible(
                  flex: 1,
                  fit:FlexFit.loose,
                  child: SizedBox(
                      height: 80.0,
                      width: 1000.0,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return Card(
                                child: SizedBox(
                                    width: 80.0,
                                    child: ListTile(
                                      onTap: () {
                                        TaskInfo info =
                                            TaskInfo("Task Category", index);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    TaskerTaskCategory(
                                                        taskinfo: info)));
                                      },
                                      title: Text("test$index"),
                                    )));
                          }))),
              Divider(
                height: 20.0,
                color: Colors.grey[1500],
              ),
              //List uploaded photos and videos by tasker
              Text('Uploaded Photos and Videos',
                  style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 1.3,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold)),
              Divider(
                height: 20.0,
                color: Colors.grey[1500],
              ),
              //Uploaded Photos and Videos Display
              Flexible(
                  flex: 1,
                  fit:FlexFit.loose,
                  child: SizedBox(
                      height: 80.0,
                      width: 1000.0,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return Card(
                                child: SizedBox(
                                    width: 80.0,
                                    child: ListTile(
                                      onTap: () {
                                        TaskInfo info =
                                            TaskInfo("Uploaded Media", index);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    TaskerUploadedMedia(
                                                        taskinfo: info)));
                                      },
                                      title: Text("test$index"),
                                    )));
                          }))),
              Divider(
                height: 20.0,
                color: Colors.grey[1500],
              ),
              //List history of tasks that tasker has completed
              Text('Task History',
                  style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 1.3,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold)),
              Divider(
                height: 20.0,
                color: Colors.grey[1500],
              ),
              //Task history display
              Flexible(
                  flex: 1,
                  fit:FlexFit.tight,
                  child: SizedBox(
                      //height: 100.0,
                      child: ListView.builder(
                          itemCount: 20,
                          itemBuilder: (context, index) {
                            return Card(
                                child: ListTile(
                              onTap: () {
                                TaskInfo info = TaskInfo(
                                    "Task History", index); //Placeholder
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TaskerTaskInfoPage(
                                            //Change to tasker specific later
                                            taskinfo: info)));
                              },
                              title: Text("test$index"),
                            ));
                          }))),
              Divider(
                height: 20.0,
                color: Colors.green[500],
              ),
            ])));
  }
}
