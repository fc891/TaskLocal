import 'package:flutter/material.dart';
import 'package:tasklocal/components/login_button.dart';
import 'package:tasklocal/components/user_pass_input.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key});

  // text controllers
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

                // email
                UserPassInput(
                  controller: userController,
                  hintText: 'Email',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                // password
                UserPassInput(
                  controller: passController,
                  hintText: 'Password',
                  obscureText: true,
                ),

                const SizedBox(height: 10),

                // forgot password
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 15),

                // sign in button
                LoginButton(
                  onTap: logUserIn,
                ),

                const SizedBox(height: 30),

                // register
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t Have an Account?',
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(width: 4),

                    //Sign up button
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/customerregistration'); //Navigate to register selection page when made (select tasker or customer)
                      },
                      child: Text(
                        'Sign up Here',
                        style: TextStyle(
                          color: Colors.yellow,
                          fontWeight: FontWeight.bold,
                        )
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
