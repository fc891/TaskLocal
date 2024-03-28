// ignore_for_file: prefer_const_constructor

//Contributors: Bill, Richard

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class CustomerRegistration extends StatefulWidget {
  // Richard's code for onTap where user can switch back and forth between login and register
  final Function()? onTap;
  const CustomerRegistration({super.key, this.onTap});

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

    try {
      // Creates the customer user and directs them to CustomerHomePage
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
            .collection("Customers")
            .doc(userCredential.user!.email)
            .set({
          'email': userCredential.user!.email,
          'first name': fnameController.text,
          'last name': lnameController.text,
          'username': usernameController.text,
          'joindate': formattedDate,
        });
        _clearAll(); //Clear text fields
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

  //Bill's Customer registration screen/UI code
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //Background color of UI
        //backgroundColor: Colors.green[500],
        //UI Appbar (bar at top of screen)
        appBar: AppBar(
          title: Text('Customer Account Registration',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 22.0)),
          centerTitle: true,
          //backgroundColor: Colors.green[800],
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
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
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
                        _obscureConfirmPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
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
            const SizedBox(height: 20),
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
            SizedBox(height: 15),
          ],
        )));
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