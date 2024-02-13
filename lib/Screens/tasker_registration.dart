// Tasker Registration UI/Screen

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tasklocal/Screens/tasker_home_page.dart';

// import 'package:tasklocal/Database/mongoconnection.dart';
// import 'package:tasklocal/Database/mongodbmodelcustomer.dart';
// import 'package:mongo_dart/mongo_dart.dart' as mongo_dart;
// void main() => runApp(MaterialApp(
//       home: TaskerRegistration(),
//     ));

class TaskerRegistration extends StatefulWidget {
  final Function()? onTap;  
  const TaskerRegistration({Key? key, this.onTap}) : super(key: key);

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
        // Create a document in the Cloud Firestore
        await FirebaseFirestore.instance.collection("Taskers").doc(userCredential.user!.email).set(
          {
            'first name' : fnameController.text,
            'last name' : lnameController.text,
            'username' : usernameController.text
          }
        );

        // // Redirects to TaskerHomePage if registration is successful
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => TaskerHomePage()),
        // );

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

  // Eric's code for TASKER REG UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Tasker Account Registration'),
        centerTitle: true,
        backgroundColor: Colors.green[800],
        elevation: 0.0,
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
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey,
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
                  controller: confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey,
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
                    const Text('Already have an account? '),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Login Now', 
                        style: TextStyle(
                          color: Colors.blue, 
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
