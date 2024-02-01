// Tasker Registration UI/Screen

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// import 'package:tasklocal/Database/mongoconnection.dart';
// import 'package:tasklocal/Database/mongodbmodelcustomer.dart';
// import 'package:mongo_dart/mongo_dart.dart' as mongo_dart;
// void main() => runApp(MaterialApp(
//       home: TaskerRegistration(),
//     ));

class TaskerRegistration extends StatefulWidget {
  final Function()? onTap;  
  const TaskerRegistration({Key? key, required this.onTap}) : super(key: key);

  @override
  State<TaskerRegistration> createState() => _TaskerRegistrationState();
}

class _TaskerRegistrationState extends State<TaskerRegistration> {
  final fnameController = TextEditingController();
  final lnameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Richard's code for the signUserUp function
  void signUserUp() async {
    // Display loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    );

    try {
      // Creates the user
      if (passwordController.text == confirmPasswordController.text) {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        Navigator.pop(context);
        // Create a document in the Cloud Firestore
        await FirebaseFirestore.instance.collection("Taskers").doc(userCredential.user!.email).set(
          {
            'first name' : fnameController.text,
            'last name' : lnameController.text,
            'username' : usernameController.text
          }
        );

      } else {
        Navigator.pop(context);
        showErrorMessage("Passwords don't match!");
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      showErrorMessage(e.code);
    }
  }

  // Display error message to user
  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(child: Text(message)),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[500],
      appBar: AppBar(
        title: Text('Tasker Account Registration'),
        centerTitle: true,
        backgroundColor: Colors.green[800],
        elevation: 0.0,
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 30),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: TextField(
                  controller: fnameController,
                  decoration: const InputDecoration(labelText: "First Name"),
                )),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: TextField(
                  controller: lnameController,
                  decoration: const InputDecoration(labelText: "Last Name"),
                )),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(labelText: "Username"),
                )),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: "Email Address"),
                )),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(labelText: "Password"),
                  obscureText: true,
                )),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: TextField(
                  controller: confirmPasswordController,
                  decoration: const InputDecoration(labelText: "Confirm Password"),
                  obscureText: true,
                )),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                signUserUp();
              }, 
              child: const Text("Register Account"),
            ),
            // ElevatedButton(
            //     onPressed: () {
            //       _insertTaskerData(fnameController.text, lnameController.text,
            //           usernameController.text, addressController.text,
            //           passwordController.text);
            //     },
            //     child: const Text("Register Account"))
          ],
        ),
      ),
    );
  }

  // No longer using MongoDB
  // Future<void> _insertTaskerData(String fname, String lname, String username,
  //     String address, String password) async {
  //   var _id = mongo_dart.ObjectId();
  //   final data = Mongodbmodelcustomer(
  //       id: _id,
  //       firstName: fname,
  //       lastName: lname,
  //       username: username,
  //       address: address,
  //       password: password);
  //   var result = await MongoConnection.insertCustomerData(data);
  //   ScaffoldMessenger.of(context)
  //       .showSnackBar(SnackBar(content: Text("Inserted ID " + _id.$oid)));
  //   _clearAll();
  // }

  // void _clearAll() {
  //   fnameController.text = '';
  //   lnameController.text = '';
  //   usernameController.text = '';
  //   addressController.text = '';
  //   passwordController.text = '';
  // }
}
