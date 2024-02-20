// ignore_for_file: prefer_const_constructor

//Contributors: Bill, Richard

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerRegistration extends StatefulWidget {
  const CustomerRegistration({super.key});
  @override
  State<CustomerRegistration> createState() => _CustomerRegistrationState();
}

//Customer registration screen
class _CustomerRegistrationState extends State<CustomerRegistration> {
  // Richard's code for the controllers which is used for managing the info of user
  var fnameController = TextEditingController();
  var lnameController = TextEditingController();
  var usernameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

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

    try {
      // Creates the customer user and directs them to CustomerHomePage
      if (passwordController.text == confirmPasswordController.text) {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        Navigator.pop(context);
        // Create a document in the Cloud Firestore to store the user info
        await FirebaseFirestore.instance
            .collection("Customers")
            .doc(userCredential.user!.email)
            .set({
          'first name': fnameController.text,
          'last name': lnameController.text,
          'username': usernameController.text,
        });
        _clearAll(); //Clear text fields
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

  //Bill's Customer registration screen/UI code
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //Background color of UI
        backgroundColor: Colors.green[500],
        //UI Appbar (bar at top of screen)
        appBar: AppBar(
          title: Text('Customer Account Registration'),
          centerTitle: true,
          backgroundColor: Colors.green[800],
          elevation: 0.0,
        ),
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 30, bottom: 20),
              // child: Text(
              //   "",
              //   style: TextStyle(fontSize: 20),
              // ),
            ),
            //First and Last name entry field
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                child: SizedBox(
                  width: 150,
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                child: SizedBox(
                  width: 150,
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
            ]),
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
            //Email entry field
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 37, vertical: 10),
              child: SizedBox(
                width: 400,
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[250],
                    labelText: "Email Address",
                  ),
                ),
              ),
            ),
            //Password entry field
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 37, vertical: 10),
              child: SizedBox(
                width: 400,
                child: TextField(
                  obscureText: _obscurePassword,
                  controller: passwordController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[250],
                    labelText: "Password",
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey[300],
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                  ),
                ),
                ),
              ),
            ),
            //CONFIRM Password entry field
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 37, vertical: 10),
              child: SizedBox(
                width: 400,
                child: TextField(
                  obscureText: _obscureConfirmPassword,
                  controller: confirmPasswordController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[250],
                    labelText: "Confirm Password",
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey[300],
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                  ),
                ),
                ),
              ),
            ),
            //Register account button
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                signUserUp();
              },
              child: const Text("Register Account"),
            ),
            // const SizedBox(height: 50),
            // ElevatedButton(
            //     onPressed: () {
            //       _insertData(
            //           fnameController.text,
            //           lnameController.text,
            //           usernameController.text,
            //           emailController.text,
            //           passwordController.text);
            //     },
            //     child: const Text("Register Account"))
          ],
        )
      )
    );
  }

  //Function to clear all text fields
  void _clearAll() {
    fnameController.text = '';
    lnameController.text = '';
    usernameController.text = '';
    emailController.text = '';
    passwordController.text = '';
    confirmPasswordController.text = '';
  }
}

//   //Inserting data to database using data entered in text fields above
//   Future<void> _insertData(String fname, String lname, String username,
//       String address, String password) async {
//     var _id = mongo_dart.ObjectId();
//     final data = Mongodbmodelcustomer(
//         id: _id,
//         firstName: fname,
//         lastName: lname,
//         username: username,
//         address: address,
//         password: password);
//     var result = await MongoConnection.insertCustomerData(data);
//     ScaffoldMessenger.of(context)
//         .showSnackBar(SnackBar(content: Text("Inserted ID " + _id.$oid)));
//     _clearAll();
//   }