import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tasklocal/Screens/authorization/passwordresetpage.dart';
import 'package:tasklocal/components/login_button_customer.dart';
import 'package:tasklocal/components/user_pass_input.dart';
import 'package:tasklocal/screens/home_pages/customer_home.dart';

import 'package:tasklocal/Screens/app_theme/theme_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPageCustomer extends StatefulWidget {
  // Richard's code
  // user can switch back and forth between login and register
  final Function()? onTap;
  const LoginPageCustomer({Key? key, required this.onTap}) : super(key: key);

  @override
  State<LoginPageCustomer> createState() => _LoginPageCustomer();
}

class _LoginPageCustomer extends State<LoginPageCustomer> {

  @override
  void initState() {
    super.initState();
  }

// class LoginPageCustomer extends ConsumerStatefulWidget {
//   LoginPageCustomer({Key? key}) : super(key: key);

//   @override
//   _LoginPageCustomerState createState() => _LoginPageCustomerState();
// }

// class _LoginPageCustomerState extends ConsumerState<LoginPageCustomer> {

  // text controllers
  final userController = TextEditingController();
  final passController = TextEditingController();

  Future<void> logUserIn() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: userController.text.trim(),
        password: passController.text.trim(),
      )
          .then((_) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return CustomerHomePage();
        }));
      });
    } catch (error) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Login Error'),
            backgroundColor: Theme.of(context).primaryColor,
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
      appBar: AppBar(
        title: Text('Customer Login',
            style: TextStyle(
              //color: Colors.white,
              fontWeight: FontWeight.w600,
            )),
        centerTitle: true,
        //backgroundColor: Colors.green[800],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // app's logo image displayed
                Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset(
                    'lib/images/tasklocaltransparent.png',
                    height: 300,
                  ),
                ),
                // Richard's code
                // title of the login page
                // Text(
                //   'Tasker Login',
                //   style: TextStyle(
                //     color: Colors.white,
                //     fontSize: 32,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                const SizedBox(height: 20),
                // Richard's code
                // Have the user input their email info
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: TextField(
                      controller: userController,
                      decoration: InputDecoration(
                        labelText: "Email Address",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        filled: true,
                        //fillColor: Colors.grey[250],
                      ),
                    )),
                const SizedBox(height: 20),
                // Richard's code
                // Have the user input their password info
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: TextField(
                      controller: passController,
                      decoration: InputDecoration(
                        labelText: "Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        filled: true,
                        //fillColor: Colors.grey[250],
                      ),
                      obscureText: true,
                    )),
                const SizedBox(height: 8),
                // allow user to change their password
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
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
                // Richard's code
                // Presses the Login button to verify if info is correct to proceed
                const SizedBox(height: 8),
                Center(
                  child: ElevatedButton(
                    onPressed: logUserIn,
                    style: ElevatedButton.styleFrom(
                      //backgroundColor: Colors.green[800],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 15),
                      child:
                          Text("Login", style: TextStyle(color: Colors.black)),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Richard's code
                // go to register page to register if no account
                // convenient for user to register quickly
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Don\'t have an account? ',
                        style: TextStyle(color: Colors.white)),
                    const SizedBox(height: 30),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Sign Up Here',
                        style: TextStyle(
                            color: Colors.yellow, fontWeight: FontWeight.bold),
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

    // Alex's old code
    //   body: SafeArea(
    //     child: SingleChildScrollView(
    //       child: Center(
    //         child: Column(
    //           children: [
    //             // Logo
    //             Align(
    //               alignment: Alignment.topCenter,
    //               child: Image.asset('lib/images/tasklocaltransparent.png'),
    //             ),
    //             SizedBox(height: 16),

    //             // Name
    //             Text(
    //               'TaskLocal',
    //               style: TextStyle(
    //                 //color: Colors.white,
    //                 fontSize: 32,
    //               ),
    //             ),

    //             SizedBox(height: 24),

    //             // email
    //             UserPassInput(
    //               controller: userController,
    //               hintText: 'Email',
    //               obscureText: false,
    //             ),

    //             SizedBox(height: 8),

    //             // password
    //             UserPassInput(
    //               controller: passController,
    //               hintText: 'Password',
    //               obscureText: true,
    //             ),

    //             SizedBox(height: 8),

    //             // forgot password
    //             Padding(
    //               padding: const EdgeInsets.symmetric(horizontal: 24.0),
    //               child: Row(
    //                 mainAxisAlignment: MainAxisAlignment.end,
    //                 children: [
    //                   GestureDetector(
    //                     onTap: () {
    //                       Navigator.push(context,
    //                           MaterialPageRoute(builder: (context) {
    //                         return PasswordResetPage();
    //                       }));
    //                     },
    //                     child: Text(
    //                       'Forgot Password?',
    //                       style: TextStyle(
    //                         color: Colors.yellow,
    //                         fontWeight: FontWeight.bold,
    //                       ),
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),

    //             SizedBox(height: 12),

    //             // sign in button
    //             const SizedBox(height: 8),
    //             Center(
    //               child: ElevatedButton(
    //                 onPressed: logUserIn,
    //                 style: ElevatedButton.styleFrom(
    //                   //backgroundColor: Colors.green[800],
    //                 ),
    //                 child: Padding(
    //                   padding: const EdgeInsets.symmetric(
    //                       horizontal: 30.0, vertical: 15),
    //                   child:
    //                       Text("Login", style: TextStyle(color: Theme.of(context).primaryColor)),
    //                 ),
    //               ),
    //             ),

    //             SizedBox(height: 28),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}
