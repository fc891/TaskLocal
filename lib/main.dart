import 'package:flutter/material.dart';
import 'package:tasklocal/Screens/customer_home_page.dart';

import 'Screens/loginpage.dart';

import 'package:tasklocal/Screens/customerregistration.dart';
import 'package:tasklocal/Screens/customerprofilepage.dart';
import 'package:tasklocal/Screens/customerprofilepage.dart';

import 'package:tasklocal/Screens/tasker_home_page.dart';
import 'package:tasklocal/Screens/tasker_registration.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'TaskLocal',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true,
        ),
        // Initial page that is shown when program is loaded up
        // >FOR TESTING: change initialRoute to an option from routing options below 
        initialRoute: '/home',
        // Routing between pages
        routes: {
          //'/': (context) => LoadScreen(), //loading screen (WIP)
          '/home': (context) => LoginPage(),
          '/customerregistration': (context) => CustomerRegistration(),
          '/taskerregistration': (context) => TaskerRegistration(),
          '/customerhomepage': (context) => CustomerHomePage(),
          '/taskerhomepage': (context) => TaskerHomePage(),
        });
  }
}
