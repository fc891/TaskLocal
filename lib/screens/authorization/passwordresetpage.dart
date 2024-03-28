import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PasswordResetPage extends StatefulWidget {
  const PasswordResetPage({Key? key}) : super(key: key);

  @override
  State<PasswordResetPage> createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage> {
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.trim());
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content:  Text('A password reset link has been sent to your email!'),
          );
        }
      );
    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(e.message.toString()),
          );
        }
      );  
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Colors.green[500],
        title: Text('Reset Password'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Lock icon
          Icon(Icons.lock, size: 64, color: Theme.of(context).colorScheme.tertiary), // Adjust icon size and color as needed

          SizedBox(height: 24),

          // "Enter your Email" text
          Text(
            'Enter your Email',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),

          SizedBox(height: 12),

          // Email 
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: TextField(
              controller: emailController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary),
                ),
                fillColor: Theme.of(context).colorScheme.tertiary,
                filled: true,
                hintText: 'Email',
                hintStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
              ),
            ),
          ),

          SizedBox(height: 12),

          // Reset Password Button
          MaterialButton(
            onPressed: passwordReset,
            child: Text('Reset Password'),
            color: Colors.white, // Change button color as needed
          ),
        ],
      )
    );
  }
}



