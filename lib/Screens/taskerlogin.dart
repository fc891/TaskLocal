import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TaskerLogin extends StatefulWidget {
  const TaskerLogin({super.key});

  @override
  State<TaskerLogin> createState() => _TaskerLogin();
}

class _TaskerLogin extends State<TaskerLogin> {
  // text controllers
  final userController = TextEditingController();

  final passController = TextEditingController();

  // login method
  void signUserIn() async {
    // show loading circle
    showDialog(
      context: context, 
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    );

    // try sign in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text, 
        password: passwordController.text,
      );
      // pop the loading circle
      Navigator.pop(context);   

    } on FirebaseAuthException catch (e) {
      // pop the loading circle
      Navigator.pop(context);
      // wrong email
      print(e.code);
      if (e.code == 'invalid-email') {
        // show error to user
        showErrorMessage('Incorrect Email');
      } 
      // wrong password
      else if (e.code == 'wrong-password') {
        showErrorMessage("Incorrect Password");
      }
    }
  }

  // error message to user
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