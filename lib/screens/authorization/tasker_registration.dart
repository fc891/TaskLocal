// Tasker Registration UI/Screen
// Contributors: Eric C., Richard N.

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class TaskerRegistration extends StatefulWidget {
  // Richard's code for onTap where user can switch back and forth between login and register
  final Function()? onTap;
  const TaskerRegistration({super.key, this.onTap});

  @override
  State<TaskerRegistration> createState() => _TaskerRegistrationState();
}

class _TaskerRegistrationState extends State<TaskerRegistration> {
  // Richard's code for the controllers which is used for managing the info of user
  final fnameController = TextEditingController();
  final lnameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  String errorCode = "";

  // Richard's code for the signUserUp function
  void signUserUp() async {
    // Display loading circle
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    // Eric's code for routing
    try {
      // Creates the tasker user and directs them to TaskerHomePage
      if (passwordController.text == confirmPasswordController.text) {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        Navigator.pop(context);

        //Get the date of registration to save to database (join date)
        var now = new DateTime.now();
        var formatter = new DateFormat('MM-dd-yyyy');
        String formattedDate = formatter.format(now);

        // Create a document in the Cloud Firestore to store the user info
        await FirebaseFirestore.instance
            .collection("Taskers")
            .doc(userCredential.user!.email)
            .set({
          'email': userCredential.user!.email,
          'first name': fnameController.text,
          'last name': lnameController.text,
          'username': usernameController.text,
          'joindate': formattedDate,
        });
      } else {
        Navigator.pop(context);
        showErrorMessage("Passwords don't match!");
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      // get an idea of what the 'logging in' error is
      print(e.code);
      // Display the error message depending on the error code
      if (e.code == 'email-already-in-use') {
        //showErrorMessage('Incorrect Email');
        errorCode = "Email already in use!";
        showErrorMessage(errorCode);
      }
    }
  }

  // Richard's code
  // Display error message to user
  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Login Error'),
          backgroundColor: Theme.of(context).colorScheme.tertiary,
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK', style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  // Eric's code for TASKER REG UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.green,
      appBar: AppBar(
        title: Text('Tasker Account Registration',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 22.0)),
        centerTitle: true,
        //backgroundColor: Colors.green[800],
        elevation: 0.0,
        // automaticallyImplyLeading: false,
      ),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  // Richard's code for the controller
                  controller: fnameController,
                  decoration: InputDecoration(
                    labelText: "First Name",
                    border: OutlineInputBorder(),
                    // Richard's code for TextField's background color
                    filled: true,
                    fillColor: Colors.grey[250],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  // Richard's code for the controller
                  controller: lnameController,
                  decoration: InputDecoration(
                    labelText: "Last Name",
                    border: OutlineInputBorder(),
                    // Richard's code for TextField's background color
                    filled: true,
                    fillColor: Colors.grey[250],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  // Richard's code for the controller
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: "Username",
                    border: OutlineInputBorder(),
                    // Richard's code for TextField's background color
                    filled: true,
                    fillColor: Colors.grey[250],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  // Richard's code for the controller
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email Address",
                    border: OutlineInputBorder(),
                    // Richard's code for TextField's background color
                    filled: true,
                    fillColor: Colors.grey[250],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  obscureText: !_isPasswordVisible,
                  // Richard's code for the controller
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                    // Richard's code for TextField's background color
                    filled: true,
                    fillColor: Colors.grey[250],
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey[500],
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  obscureText: !_isConfirmPasswordVisible,
                  // Richard's code for the controller
                  controller: confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                    border: OutlineInputBorder(),
                    // Richard's code for TextField's background color
                    filled: true,
                    fillColor: Colors.grey[250],
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey[500],
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordVisible =
                              !_isConfirmPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  // Richard's code for button's background color
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.tertiary,
                  ),
                  onPressed: signUserUp,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text("Register Account",
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
              SizedBox(height: 15),
              // Richard's code where it allows users to go back to login page
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account? ',
                      style: TextStyle(color: Colors.white)),
                  GestureDetector(
                      onTap: widget.onTap,
                      child: const Text('Login Now',
                          style: TextStyle(
                              color: Colors.yellow,
                              fontWeight: FontWeight.bold))),
                ],
              ),
              SizedBox(
                height: 15,
                child: Container(
                    // color: Colors.blue, // Set the color here
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
