// ignore_for_file: prefer_const_constructor

import 'dart:ffi';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CustomerProfilePage extends StatefulWidget {
  const CustomerProfilePage({super.key});
  @override
  State<CustomerProfilePage> createState() => _CustomerProfilePageState();
}

//Customer Profile Page Screen
class _CustomerProfilePageState extends State<CustomerProfilePage> {
  String username = "TaskLocalCustomer";
  String date = 'dd-MM-yyyy';
  int requestscompleted = 0;
  //WIP
  //Get user's name using some sort of id (username?)
  void getUserName(String id) async {
    var userId = id;
    username = "TaskLocal1";
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
    DateTime joindate = DateTime(2024, 2, 6);
    date = joindateformat.format(joindate);
  }

  //WIP
  //Get user's number of requested tasks completed using id
  void getRequestsCompleted(String id) async {
    requestscompleted = 1;
  }

  //Run all getters above to initialize variables
  void runGetters() {
    String testid = "123";

    getUserName(testid);
    getJoinDate(testid);
    getRequestsCompleted(testid);
  }

  //Bill's Customer profile page screen/UI code
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
                Text('Requested Tasks Completed: $requestscompleted',
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
              Text('Request History',
                  style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 1.3,
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold)),
              Divider(
                height: 20.0,
                color: Colors.grey[1500],
              ),
              Expanded(
                  child: SizedBox(
                      height: 50.0,
                      child: ListView.builder(
                          itemCount: 20,
                          itemBuilder: (context, index) {
                            return Card(
                                child: ListTile(
                              onTap: () {},
                              title: Text("test"),
                            ));
                          }))),
              Divider(
                height: 20.0,
                color: Colors.green[500],
              ),
            ])));
  }
}
