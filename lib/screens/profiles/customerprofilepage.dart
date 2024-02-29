// ignore_for_file: prefer_const_constructor

//Contributors: Bill

import 'dart:ffi';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tasklocal/screens/profiles/customertaskinfopage.dart';
import 'package:tasklocal/screens/profiles/taskinfo.dart';
import 'package:tasklocal/screens/profiles/customereditprofile.dart';

FirebaseAuth firebaseAuth = FirebaseAuth.instance;

//Bill's Customer Profile Page Screen
class CustomerProfilePage extends StatefulWidget {
  const CustomerProfilePage({super.key});
  @override
  State<CustomerProfilePage> createState() => _CustomerProfilePageState();
}

//Bill's Customer Profile Page Screen
class _CustomerProfilePageState extends State<CustomerProfilePage> {
  String username = "TaskLocalCustomer";
  String firstname = "First";
  String lastname = "Last";
  String date = 'dd-MM-yyyy';
  int requestscompleted = 0;

  //WIP
  //Bill's get user's info using testid (user email right now)
  void getUserInfo(String testid) async {
    var collection = FirebaseFirestore.instance.collection('Customers');
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
    DateTime joindate = DateTime(2024, 2, 15);
    date = joindateformat.format(joindate);
  }

  //WIP
  //Bill's get user's number of requested tasks completed using id
  void getRequestsCompleted(String id) async {
    requestscompleted = 1;
  }

  //Bill's function to run all getters above to initialize variables
  void runGetters() async {
    var current = FirebaseAuth.instance
        .currentUser!; //Use to get the info of the currently logged in user
    String testid = current.email!; //Get email of current user

    getUserInfo(testid);
    getJoinDate(testid);
    getRequestsCompleted(testid);
  }

  void editProfilePage() {}

  //Bill's Customer profile page screen/UI code
  @override
  Widget build(BuildContext context) {
    runGetters();
    return Scaffold(
        //Background color of UI
        backgroundColor: Colors.green[500],
        appBar: AppBar(
          title: Text('$username\'s profile page'),
          centerTitle: true,
          backgroundColor: Colors.green[800],
          elevation: 0.0,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerEditProfile()));
              },
              icon: Icon(
                Icons.edit_outlined,
                color: Colors.grey[300],
              ),
            ),
          ],
        ),
        //Customer profile picture
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
              //Display customer info on profile page (join date, # of requested tasks completed)
              Column(children: <Widget>[
                Text('Join Date: $date',
                    style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 1.0,
                      fontSize: 16.0,
                    )),
                Text('Requested Tasks Completed: $requestscompleted',
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
              //History of requested tasks
              Text('Request History',
                  style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 1.3,
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold)),
              Divider(
                height: 10.0,
                color: Colors.grey[1500],
              ),
              //Request history display
              Expanded(
                  child: SizedBox(
                      height: 50.0,
                      child: ListView.builder(
                          itemCount: 20,
                          itemBuilder: (context, index) {
                            return Card(
                                child: ListTile(
                              onTap: () {
                                TaskInfo info = TaskInfo("Test", index);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CustomerTaskInfoPage(
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
