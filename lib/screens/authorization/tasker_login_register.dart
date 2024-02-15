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
  // initially show login page
  late bool _showLoginPage;

  @override
  void initState() {
    super.initState();
    // Initialize _showLoginPage with the value from the widget
    _showLoginPage = widget.showLoginPage;
  }

  // toggle between login and register page
  void togglePages() {
    setState(() {
      _showLoginPage = !_showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showLoginPage) {
      return TaskerLogin(onTap: togglePages,);
    } else {
      return TaskerRegistration(onTap: togglePages,);
    }
  }
}