import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tasklocal/Screens/authorization/passwordresetpage.dart';
import 'package:tasklocal/components/login_button_customer.dart';
import 'package:tasklocal/components/user_pass_input.dart';
import 'package:tasklocal/screens/home_pages/customer_home.dart';

class LoginPageCustomer extends StatefulWidget {
  LoginPageCustomer({Key? key}) : super(key: key);

  @override
  _LoginPageCustomerState createState() => _LoginPageCustomerState();
}

class _LoginPageCustomerState extends State<LoginPageCustomer> {
  // text controllers
  final userController = TextEditingController();
  final passController = TextEditingController();

  Future<void> logUserIn() async {
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: userController.text.trim(), 
      password: passController.text.trim(),
    ).then((_) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return CustomerHomePage(); 
      }));
    });
  } catch (error) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Login Error'),
          content: Text('Incorrect email or password. Please try again.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); 
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}


  @override
  void dispose() {
    userController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[500],
      appBar: AppBar(
        backgroundColor: Colors.green[500],
      ),
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
                SizedBox(height: 16), 

                // Name
                Text(
                  'TaskLocal',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                  ),
                ),

                SizedBox(height: 24), 

                // email
                UserPassInput(
                  controller: userController,
                  hintText: 'Email',
                  obscureText: false,
                ),

                SizedBox(height: 8), 

                // password
                UserPassInput(
                  controller: passController,
                  hintText: 'Password',
                  obscureText: true,
                ),

                SizedBox(height: 8),

                // forgot password
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0), 
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return PasswordResetPage();
                          }));
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Colors.yellow,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 12), 

                // sign in button
                LoginButtonCustomer(
                  onTap: logUserIn,
                ),

                SizedBox(height: 28), 
              ],
            ),
          ),
        ),
      ),
    );
  }
}
