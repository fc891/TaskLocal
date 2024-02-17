// Contributors: Richard N.

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tasklocal/screens/authorization/passwordresetpage.dart';

class TaskerLogin extends StatefulWidget {
  // Richard's code
  // user can switch back and forth between login and register
  final Function()? onTap;
  const TaskerLogin({Key? key, required this.onTap}) : super(key: key);

  @override
  State<TaskerLogin> createState() => _TaskerLogin();
}

class _TaskerLogin extends State<TaskerLogin> {
  // Richard's code
  // created controllers for managing the info of user
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  // Richard's code for the userLogin function
  // login method called on when press the login button
  void userLogin() async {
    // display a loading circle to give users idea of time
    showDialog(
      context: context, 
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    );

    try {
      // verify whether the account is stored in the database and then sign in
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text, 
        password: passwordController.text,
      );
      // remove the loading circle after logging in
      Navigator.pop(context);   

    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      // get an idea of what the 'logging in' error is
      print(e.code);
      // Display the error message depending on the error code
      if (e.code == 'invalid-email' || e.code == 'user-not-found') {
        showErrorMessage('Incorrect Email');
      } 
      else if (e.code == 'wrong-password') {
        showErrorMessage("Incorrect Password");
      }
      else if (e.code == 'channel-error') {
        showErrorMessage('Unable to process Email/Password');
      }
    }
  }

  // convenient method to display error message
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
  // Richard's entire code for this Widget build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[500],
      appBar: AppBar(
        title: Text('Tasker Login',
                  style: TextStyle(
                    color: Colors.white,
                    // fontSize: 25,
                    fontWeight: FontWeight.w600,
                  )),
        centerTitle: true,
        backgroundColor: Colors.green[800],
        // Richard's code
        // Add a back button to the AppBar
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Direct users to go back to the onboarding page
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // app's logo image displayed
                Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset(
                    'lib/images/tasklocaltransparent.png',
                    height: 300,
                  ),
                ),
                // Richard's code
                // title of the login page
                // Text(
                //   'Tasker Login',
                //   style: TextStyle(
                //     color: Colors.white,
                //     fontSize: 32,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                const SizedBox(height: 20),
                // Richard's code
                // Have the user input their email info
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Email Address", 
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      filled: true,
                      fillColor: Colors.grey[250],
                    ),
                  )
                ),
                const SizedBox(height: 20),
                // Richard's code
                // Have the user input their password info
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: "Password", 
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      filled: true,
                      fillColor: Colors.grey[250],
                    ),
                    obscureText: true,
                  )
                ),
                const SizedBox(height: 8),
                // allow user to change their password
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0), 
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return PasswordResetPage();
                          }));
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Colors.yellow,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Richard's code
                // Presses the Login button to verify if info is correct to proceed
                const SizedBox(height: 8),
                Center(
                  child: ElevatedButton(
                    onPressed: userLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[800],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Text("Login", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Richard's code
                // go to register page to register if no account
                // convenient for user to register quickly
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Don\'t have an account? ', style: TextStyle(color: Colors.white)),
                    const SizedBox(height: 30),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Sign Up Here', 
                        style: TextStyle(
                          color: Colors.yellow, 
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}