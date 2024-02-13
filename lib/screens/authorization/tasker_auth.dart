import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tasklocal/screens/home_pages/tasker_home.dart';
import 'tasker_login_register.dart';

// auth page 
class TaskerAuthPage extends StatelessWidget {
  const TaskerAuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // user is logged in
          if (snapshot.hasData) {
            return TaskerHomePage();
          }
          // user is not logged in
          else {
            return const LoginOrRegisterPage();
          }
        }

      )
    );
  }
}