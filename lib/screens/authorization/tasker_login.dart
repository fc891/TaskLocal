import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Richard's code
class TaskerLogin extends StatefulWidget {
  final Function()? onTap;
  const TaskerLogin({Key? key, required this.onTap}) : super(key: key);

  @override
  State<TaskerLogin> createState() => _TaskerLogin();
}

class _TaskerLogin extends State<TaskerLogin> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[500],
      appBar: AppBar(
        backgroundColor: Colors.green[800],
        // Add a back button to the AppBar
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to previous page
          },
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // app's logo image
                Align(
                  alignment: Alignment.topCenter, // Aligns to the top center
                  child: Image.asset(
                    'lib/images/tasklocaltransparent.png',
                    height: 300,
                  ),
                ),
                // title of the login page
                Text(
                  'Tasker Login',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
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
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: userLogin,
                      child: Text("Login"),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
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