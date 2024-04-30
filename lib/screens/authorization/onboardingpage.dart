import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tasklocal/Screens/authorization/loginpagecustomer.dart';
import 'package:tasklocal/components/customer_selection_button.dart';
import 'package:tasklocal/Screens/authorization/register_selection.dart';
import 'package:tasklocal/components/tasker_selection_button.dart';
import 'package:tasklocal/screens/authorization/tasker_auth.dart';
import 'package:tasklocal/screens/authorization/customer_auth.dart';
import 'package:tasklocal/Screens/app_theme/theme_provider.dart';

class OnboardingPage extends StatefulWidget {
  OnboardingPage({Key? key}) : super(key: key);

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkNotificationPermission();
    });
  }

  void _checkNotificationPermission() async {
    var notificationStatus = await Permission.notification.status;
    if (!notificationStatus.isGranted) {
      _showNotificationPermissionDialog();
    }
  }

  void _showNotificationPermissionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // User must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enable Notifications'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('The App requires Notification Permissions for optimal usage.'),
                Text(''),
                Text('Please enable notifications.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Decline'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Accept'),
              onPressed: () async {
                Navigator.of(context).pop();
                await Permission.notification.request();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset('lib/images/tasklocaltransparent.png'),
                ),
                Text(
                  'TaskLocal',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 32,
                  ),
                ),
                const SizedBox(height: 25),
                SelectionButtonTasker(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TaskerAuthPage(showLoginPage: true)),
                    );
                  },
                ),
                const SizedBox(height: 10),
                SelectionButtonCustomer(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CustomerAuthPage(showLoginPageCust: true)),
                    );
                  },
                ),
                const SizedBox(height: 160),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterSelection()),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Don\'t Have an Account?',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Sign up Here',
                        style: TextStyle(
                          color: Colors.yellow,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
