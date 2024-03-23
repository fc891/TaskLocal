import 'package:flutter/material.dart';
//import 'package:tasklocal/Screens/loginpagetasker.dart';
import 'package:tasklocal/Screens/authorization/loginpagecustomer.dart';
import 'package:tasklocal/components/customer_selection_button.dart';
import 'package:tasklocal/Screens/authorization/register_selection.dart';
import 'package:tasklocal/components/tasker_selection_button.dart';
import 'package:tasklocal/screens/authorization/tasker_auth.dart';
import 'package:tasklocal/screens/authorization/customer_auth.dart';

import 'package:tasklocal/Screens/app_theme/theme_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
//import 'package:tasklocal/components/tasker_selection_button.dart';

class OnboardingPage extends ConsumerWidget {
  OnboardingPage({Key? key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var isDarkMode = ref.watch(appThemeProvider);
    return Scaffold(
      
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
                const SizedBox(height: 0),

                // Name
                Text(
                  'TaskLocal',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 32,
                  ),
                ),

                const SizedBox(height: 25),

                // Login as Tasker button
                SelectionButtonTasker(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                            TaskerAuthPage(showLoginPage: true)),
                    );
                  },
                ),

                const SizedBox(height: 10),

                // Login as Customer button
                SelectionButtonCustomer(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          //builder: (context) => LoginPageCustomer()),
                          builder: (context) => 
                            CustomerAuthPage(showLoginPage: true)),
                    );
                  },
                ),

                const SizedBox(height: 160),

                // register
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegisterSelection()),
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
