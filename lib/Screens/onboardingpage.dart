import 'package:flutter/material.dart';
import 'package:tasklocal/Screens/loginpagetasker.dart';
import 'package:tasklocal/Screens/loginpagecustomer.dart';
import 'package:tasklocal/components/login_customer_button.dart';
import 'package:tasklocal/components/login_tasker_button.dart';

class FrontPage extends StatelessWidget {
  FrontPage({Key? key});

  final userController = TextEditingController();
  final passController = TextEditingController();

  // login method
  void logUserIn() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[500],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                // Logo
                Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset('lib/images/tasklocaltransparent.png'),
                ),
                const SizedBox(height: 0),

                // Name
                Text(
                  'TaskLocal',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                  ),
                ),

                const SizedBox(height: 25),

                // login tasker
                TaskerLoginButton(
                  onTap: logUserIn,
                ),

                const SizedBox(height: 10),

                // login customer
                CustomerLoginButton(
                  onTap: logUserIn,
                ),

                const SizedBox(height: 160),

                // register
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t Have an Account?',
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'Sign up Here',
                      style: TextStyle(
                        color: Colors.yellow,
                        fontWeight: FontWeight.bold,
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