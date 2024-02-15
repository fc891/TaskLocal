import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tasklocal/screens/home_pages/tasker_home.dart';
import 'tasker_login_register.dart';

class TaskerAuthPage extends StatelessWidget {
  final bool showLoginPage;
  const TaskerAuthPage({super.key, required this.showLoginPage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   // Add a back button to the AppBar
      //   leading: IconButton(
      //     icon: Icon(Icons.arrow_back),
      //     onPressed: () {
      //       Navigator.pop(context); // Navigate back to previous page
      //     },
      //   ),
      // ),
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // user is logged in
          if (snapshot.hasData) {
            return TaskerHomePage();
          }
          // user is not logged in
          else {
            return LoginOrRegisterPage(showLoginPage: showLoginPage);
          }
        }
      )
    );
  }
}
