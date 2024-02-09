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
  void userLogin() async {
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
      print(e.code);
      // wrong email
      if (e.code == 'invalid-email' || e.code == 'user-not-found') {
        // show error to user
        showErrorMessage('Incorrect Email');
      } 
      // wrong password
      else if (e.code == 'wrong-password') {
        showErrorMessage("Incorrect Password");
      }
      else if (e.code == 'channel-error') {
        showErrorMessage('Unable to process Email/Password');
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
                // const Padding(
                //   padding: EdgeInsets.only(top: 30),
                // ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset('lib/images/tasklocaltransparent.png'),
                ),
                const SizedBox(height: 0),
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
                // ElevatedButton(
                //   onPressed: () {
                //     userLogin();
                //   }, 
                //   child: const Text("Login"),
                // ),
                Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Center(
                  child: ElevatedButton(
                    onPressed: userLogin,
                    child: Text("Login"),
                  ),
                ),
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