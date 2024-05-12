import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tasklocal/Screens/authorization/loginpagecustomer.dart';
import 'package:tasklocal/components/customer_selection_button.dart';
import 'package:tasklocal/Screens/authorization/register_selection.dart';
import 'package:tasklocal/components/tasker_selection_button.dart';
import 'package:tasklocal/screens/authorization/tasker_auth.dart';
import 'package:tasklocal/screens/authorization/customer_auth.dart';
import 'package:tasklocal/Screens/app_theme/theme_provider.dart';
import 'package:device_info_plus/device_info_plus.dart';

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
      _notificationVerification();
    });
  }

  // create function to see if user has given permission to notifications
  void _notificationVerification() async {
  if (Platform.isAndroid) {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    
    if (androidInfo.version.sdkInt >= 31) { // Android 12 and above
      final intent = AndroidIntent(
        action: 'android.settings.ACTION_REQUEST_SCHEDULE_EXACT_ALARM',
      );
      try {
        await intent.launch();
      } catch (e) {
        print("Failed to launch intent: $e");
      }
    } else {
      var notificationStatus = await Permission.notification.status;
      if (!notificationStatus.isGranted) {
        _notificationVerificationDialog();
      }
    }
  } else {
    var notificationStatus = await Permission.notification.status;
    if (!notificationStatus.isGranted) {
      _notificationVerificationDialog();
    }
  }
}

  // create function for dialog pop up when user doesn't have notifications on
  void _notificationVerificationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, 
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

  // build layout
  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: SafeArea(
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,  
                children: [
                  // image of TaskLocal
                  Image.asset('lib/images/tasklocaltransparent.png'),
                  Positioned(
                    bottom: 10, 
                    // name
                    child: Text(
                      'TaskLocal',
                      style: GoogleFonts.oswald(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 52,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 100),

                // tasker sign in
                SelectionButtonTasker(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TaskerAuthPage(showLoginPage: true)),
                    );
                  },
                ),
                const SizedBox(height: 15),

                // customer sign in
                SelectionButtonCustomer(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CustomerAuthPage(showLoginPageCust: true)),
                    );
                  },
                ),
                const SizedBox(height: 125),

                // register 
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
