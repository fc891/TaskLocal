// Contributors: Richard N.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tasklocal/screens/home_pages/tasker_home.dart';
import 'tasker_login_register.dart';

// Richard's code for this entire class
class TaskerAuthPage extends StatelessWidget {
  // variable used to either go to login or register page
  final bool showLoginPage;
  const TaskerAuthPage({super.key, required this.showLoginPage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        // detects the info of the user whether logged in or not
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // user is logged in so directs user to the home page
          if (snapshot.hasData) {
            return TaskerHomePage();
          }
          // user is not logged in so direct user to a page where users can either go to login or register page
          else {
            return TaskerLoginRegisterPage(showLoginPage: showLoginPage);
          }
        }
      )
    );
  }
}
