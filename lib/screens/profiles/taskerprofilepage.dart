// ignore_for_file: prefer_const_constructor

//Contributors: Bill

import 'dart:ffi';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:tasklocal/screens/profiles/taskereditprofile.dart';
import 'package:tasklocal/screens/profiles/taskertaskinfopage.dart';
import 'package:tasklocal/screens/profiles/taskeruploadedmedia.dart';
import 'package:tasklocal/screens/profiles/taskertaskcategory.dart';
import 'package:tasklocal/screens/profiles/taskinfo.dart';
import 'package:tasklocal/screens/profiles/profilepageglobals.dart' as globals;

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
  final dB = FirebaseStorage.instance;
  String defaultProfilePictureURL =
      "https://firebasestorage.googleapis.com/v0/b/authtutorial-a4202.appspot.com/o/profilepictures%2Ftasklocaltransparent.png?alt=media&token=31e20dcc-4b9a-41cb-85ed-bc82166ac836";
  late String profilePictureURL;
  bool _hasProfilePicture = false;
  bool runOnce = true;
  int numMediaUploaded = 0;
  List <String> mediaList = [];

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

  //Bill's get user's profile picture using id
  void getProfilePicture(String id) async {
    try {
      final ref = dB.ref().child("profilepictures/$id/profilepicture.jpg");
      final url = await ref.getDownloadURL();
      setState(() {
        profilePictureURL = url;
      });
      _hasProfilePicture = true;
      globals.checkProfilePictureTasker =
          false; //Set to false after one check so that this function does not run multiple times
    } catch (err) {
      _hasProfilePicture = false;
      globals.checkProfilePictureTasker =
          false; //Set to false after one check so that this function does not run multiple times
    }
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
  void getTasksCompleted(String id) async {
    taskscompleted = 10;
  }

  void getUploadedMedia(String id) async {
    numMediaUploaded = 0;
    globals.checkMedia = false;
    final storageRef = dB.ref().child("taskermedia/$id");
    final listResult = await storageRef.listAll();
    // for (var prefix in listResult.prefixes) {
    //   final url = await prefix.getDownloadURL();
    //   mediaList[numMediaUploaded] = url;
    //   numMediaUploaded += 1;
    // }
    for (var item in listResult.items) {
      final url = await item.getDownloadURL();
      setState(() {
        mediaList.add(url);
      });
      numMediaUploaded += 1;
    }
  }

  //Bill's function to run all getters above to initialize variables
  void runGetters() async {
    var current = FirebaseAuth.instance
        .currentUser!; //Use to get the info of the currently logged in user
    String testid = current.email!; //Get email of current user
    if (globals.checkProfilePictureTasker) {
      getProfilePicture(testid);
    }
    getUserInfo(testid);
    getJoinDate(testid);
    getTasksCompleted(testid);
    if (globals.checkMedia) {
      getUploadedMedia(testid);
    }
  }

  //Bill's Tasker profile page screen/UI code
  @override
  Widget build(BuildContext context) {
    if (runOnce) {
      globals.checkProfilePictureTasker =
          true; //Check once in case user has a profile page set but did not set a new one
      globals.checkMedia = true;
      runOnce = false;
    }
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
        //Tasker profile picture
        body: Padding(
            padding: EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 0.0),
            child: Column(children: [
              Center(
                  child: Stack(
                children: <Widget>[
                  Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                          border: Border.all(
                            width: 4,
                            color: Colors.white,
                          ),
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 2,
                                blurRadius: 10,
                                color: Colors.green)
                          ],
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: _hasProfilePicture
                                ? NetworkImage(
                                    profilePictureURL) //If user has selected an image from their gallery, display it
                                : NetworkImage(
                                        defaultProfilePictureURL) //If user has NOT selected an image from their gallery, display their original profile picture
                                    as ImageProvider,
                            fit: BoxFit.cover,
                          ))),
                ],
              )),
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
                height: 10.0,
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
                height: 10.0,
                color: Colors.grey[1500],
              ),
              //Task Categories Display
              Flexible(
                  flex: 1,
                  fit: FlexFit.loose,
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
                height: 10.0,
                color: Colors.grey[1500],
              ),
              //List uploaded photos and videos by tasker
              Text('Uploaded Photos and Videos($numMediaUploaded)',
                  style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 1.3,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold)),
              Divider(
                height: 10.0,
                color: Colors.grey[1500],
              ),
              //Uploaded Photos and Videos Display
              Flexible(
                  flex: 1,
                  fit: FlexFit.loose,
                  child: SizedBox(
                      height: 80.0,
                      width: 1000.0,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: numMediaUploaded,
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
                                        trailing: Image.network(mediaList[index]))));
                          }))),
              Divider(
                height: 10.0,
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
                height: 10.0,
                color: Colors.grey[1500],
              ),
              //Task history display
              Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
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
