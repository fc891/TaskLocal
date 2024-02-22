// ignore_for_file: prefer_const_constructor

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tasklocal/Screens/profiles/taskerprofilepage.dart';
import 'package:tasklocal/screens/profiles/taskinfo.dart';

class TaskerEditProfile extends StatefulWidget {
  const TaskerEditProfile({super.key});
  @override
  State<TaskerEditProfile> createState() => _TaskerEditProfileState();
}

//Customer profile edit screen
class _TaskerEditProfileState extends State<TaskerEditProfile> {
  var fnameController = TextEditingController();
  var lnameController = TextEditingController();
  var usernameController = TextEditingController();
  var emailController = TextEditingController();

  //WIP: Controllers to edit password
  // var passwordController = TextEditingController();
  // var confirmPasswordController = TextEditingController();
  // bool _obscurePassword = true;
  // bool _obscureConfirmPassword = true;

  void confirmChanges() async {
    var current = FirebaseAuth.instance.currentUser!;

    var collection = FirebaseFirestore.instance.collection('Taskers');
    var docSnapshot = await collection.doc(current.email!).get();
    Map<String, dynamic> data = docSnapshot.data()!;

    var newUserName = data['username'];
    var newFirstName = data['first name'];
    var newLastName = data['last name'];

    final currentDB = FirebaseFirestore.instance
        .collection("Taskers")
        .doc("${current.email}");
    FirebaseFirestore.instance.runTransaction((transaction) async {
      //Changing values based on user entry. If empty, do not change (keep same)
      if (usernameController.text.isNotEmpty) {
        newUserName = usernameController.text;
      }
      if (fnameController.text.isNotEmpty) {
        newFirstName = fnameController.text;
      }
      if (lnameController.text.isNotEmpty) {
        newLastName = lnameController.text;
      }

      //Update the current user based on entered information
      transaction.update(currentDB, {
        "username": newUserName,
        "first name": newFirstName,
        "last name": newLastName,
      });
    }).then(
      (value) => print("DocumentSnapshot successfully updated!"),
      onError: (e) => print("Error updating document $e"),
    );
  }

//Bill's Tasker edit profile screen/UI code
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //Background color of UI
        backgroundColor: Colors.green[500],
        //UI Appbar (bar at top of screen)
        appBar: AppBar(
          title: Text('Edit Tasker Profile Page'),
          centerTitle: true,
          backgroundColor: Colors.green[800],
          elevation: 0.0,
        ),
        resizeToAvoidBottomInset: true,
        body: SafeArea(
            child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 30, bottom: 20),
            ),
            //First name entry field
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 37, vertical: 10),
              child: SizedBox(
                width: 400,
                child: TextField(
                  controller: fnameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[250],
                    labelText: "First Name",
                  ),
                ),
              ),
            ),
            //Last name entry field
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 37, vertical: 10),
              child: SizedBox(
                width: 400,
                child: TextField(
                  controller: lnameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[250],
                    labelText: "Last Name",
                  ),
                ),
              ),
            ),
            //Username entry field
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 37, vertical: 10),
              child: SizedBox(
                width: 400,
                child: TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[250],
                    labelText: "Username",
                  ),
                ),
              ),
            ),
            // //Email entry field
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 37, vertical: 10),
            //   child: SizedBox(
            //     width: 400,
            //     child: TextField(
            //       controller: emailController,
            //       decoration: InputDecoration(
            //         border: OutlineInputBorder(),
            //         filled: true,
            //         fillColor: Colors.grey[250],
            //         labelText: "Email Address",
            //       ),
            //     ),
            //   ),
            // ),
            // //Password entry field
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 37, vertical: 10),
            //   child: SizedBox(
            //     width: 400,
            //     child: TextField(
            //       obscureText: _obscurePassword,
            //       controller: passwordController,
            //       decoration: InputDecoration(
            //         border: OutlineInputBorder(),
            //         filled: true,
            //         fillColor: Colors.grey[250],
            //         labelText: "Password",
            //         suffixIcon: IconButton(
            //           icon: Icon(
            //             _obscurePassword
            //                 ? Icons.visibility
            //                 : Icons.visibility_off,
            //             color: Colors.grey[500],
            //           ),
            //           onPressed: () {
            //             setState(() {
            //               _obscurePassword = !_obscurePassword;
            //             });
            //           },
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            // //CONFIRM Password entry field
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 37, vertical: 10),
            //   child: SizedBox(
            //     width: 400,
            //     child: TextField(
            //       obscureText: _obscureConfirmPassword,
            //       controller: confirmPasswordController,
            //       decoration: InputDecoration(
            //         border: OutlineInputBorder(),
            //         filled: true,
            //         fillColor: Colors.grey[250],
            //         labelText: "Confirm Password",
            //         suffixIcon: IconButton(
            //           icon: Icon(
            //             _obscureConfirmPassword
            //                 ? Icons.visibility
            //                 : Icons.visibility_off,
            //             color: Colors.grey[500],
            //           ),
            //           onPressed: () {
            //             setState(() {
            //               _obscureConfirmPassword = !_obscureConfirmPassword;
            //             });
            //           },
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            //Register account button
            ElevatedButton(
              onPressed: () {
                confirmChanges();
                Navigator.pop(context);
              },
              child: const Text("Confirm Changes"),
            ),
          ],
        )));
  }
}
