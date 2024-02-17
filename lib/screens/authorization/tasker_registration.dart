// Tasker Registration UI/Screen
// Contributors: Eric C., Richard N.

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tasklocal/Screens/home_pages/tasker_home.dart';

// Eric's code for TaskerRegistration class
class TaskerRegistration extends StatefulWidget {
  // Richard's code
  // user can switch back and forth between login and register
  final Function()? onTap;  
  const TaskerRegistration({super.key, this.onTap});

  @override
  State<TaskerRegistration> createState() => _TaskerRegistrationState();
}

class _TaskerRegistrationState extends State<TaskerRegistration> {
  // Richard's code
  // created controllers for managing the info of user
  final fnameController = TextEditingController();
  final lnameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

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
      // Creates the tasker user and directs them to TaskerHomePage
      if (passwordController.text == confirmPasswordController.text) {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        Navigator.pop(context);
        // Create a document in the Cloud Firestore to store the user info
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
      // any error besides password goes through here
      Navigator.pop(context);
      showErrorMessage(e.code);
    }
  }
  // Richard's code
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

  // Eric's code for TASKER REG UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        title: Text('Tasker Account Registration', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        centerTitle: true,
        backgroundColor: Colors.green[800],
        elevation: 0.0,
        // automaticallyImplyLeading: false,
      ),
      resizeToAvoidBottomInset: false,
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
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey[300],
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
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey[300],
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Center(
                  child: ElevatedButton(
                    onPressed: signUserUp,
                    child: Text("Register Account"),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Richard's code where it allows users to go back to login page
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account? ', style: TextStyle(color: Colors.white)),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Login Now', 
                        style: TextStyle(
                          color: Colors.yellow, 
                          fontWeight: FontWeight.bold
                        )
                      )
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
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
