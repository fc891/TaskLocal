// ignore_for_file: prefer_const_constructor

import 'dart:ffi';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TaskerProfilePage extends StatefulWidget {
  const TaskerProfilePage({super.key});
  @override
  State<TaskerProfilePage> createState() => _TaskerProfilePageState();
}

//Customer Profile Page Screen
class _TaskerProfilePageState extends State<TaskerProfilePage> {
  String username = "Testlocal123";
  String date = 'dd-MM-yyyy';
  int taskscompleted = 0;
  double rating = 5.0;
  //WIP
  //Get user's name using some sort of id (username?)
  void getUserName(String id) async {
    var userId = id;
    username = "TaskLocalTasker";
    final snapshot =
        await FirebaseFirestore.instance.doc('customers/$userId').get();
    if (snapshot.exists) {
      print(snapshot);
    } else {
      print('No data available.');
    }
  }

  //WIP
  //Get user's join date using id
  void getJoinDate(String id) async {
    DateFormat joindateformat = DateFormat('dd-MM-yyyy');
    DateTime joindate = DateTime(2024, 2, 8);
    date = joindateformat.format(joindate);
  }

  //WIP
  //Get user's number of requested tasks completed using id
  void getTaskssCompleted(String id) async {
    taskscompleted = 10;
  }

  //Run all getters above to initialize variables
  void runGetters() {
    String testid = "123";

    getUserName(testid);
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
            elevation: 0.0),
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
                child: Text('$username',
                    style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 1.0,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold)),
              ),
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
              Divider(
                height: 20.0,
                color: Colors.grey[1500],
              ),
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
              SizedBox(
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
                                  onTap: () {},
                                  title: Text("test$index"),
                                )));
                      })),
              Divider(
                height: 20.0,
                color: Colors.grey[1500],
              ),
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
              SizedBox(
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
                                  onTap: () {},
                                  title: Text("test$index"),
                                )));
                      })),
              Divider(
                height: 20.0,
                color: Colors.grey[1500],
              ),
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
              Expanded(
                  child: SizedBox(
                      height: 100.0,
                      child: ListView.builder(
                          itemCount: 20,
                          itemBuilder: (context, index) {
                            return Card(
                                child: ListTile(
                              onTap: () {},
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
