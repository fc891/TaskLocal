// Contributors: Richard N.

import 'package:flutter/material.dart';
import 'tasker_login.dart';
import 'tasker_registration.dart';

class LoginOrRegisterPage extends StatefulWidget {
  final bool showLoginPage;
  const LoginOrRegisterPage({super.key, required this.showLoginPage});

  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {
  // show the login or register page depending on what the user click
  late bool _showLoginPage;
  // initialize the local variable with the widget's variable
  @override
  void initState() {
    super.initState();
    _showLoginPage = widget.showLoginPage;
  }
  // have the local variable change its value to either true/false
  void togglePages() {
    setState(() {
      _showLoginPage = !_showLoginPage;
    });
  }
  // allow user to shift betweeen loggig in and registering
  @override
  Widget build(BuildContext context) {
    if (_showLoginPage) {
      return TaskerLogin(onTap: togglePages,);
    } else {
      return TaskerRegistration(onTap: togglePages,);
    }
  }
}