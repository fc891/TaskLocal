import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TaskerLogin extends StatefulWidget {
  final Function()? onTap;
  const TaskerLogin({Key? key, required this.onTap}) : super(key: key);

  @override
  State<TaskerLogin> createState() => _TaskerLogin();
}

class _TaskerLogin extends State<TaskerLogin> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

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
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 30),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: TextField(
                      controller: emailController,
                      decoration: const InputDecoration(labelText: "Email Address"),
                    )),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: TextField(
                      controller: passwordController,
                      decoration: const InputDecoration(labelText: "Password"),
                      obscureText: true,
                    )),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    signUserIn();
                  }, 
                  child: const Text("Login"),
                ),
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
                        )
                      )
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