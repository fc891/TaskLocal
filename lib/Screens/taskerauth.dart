import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'tasker_temphome.dart';
import 'tasker_loginregister.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // user is logged in
          if (snapshot.hasData) {
            return HomePage();
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