import 'package:flutter/material.dart';

import 'package:tasklocal/Screens/tasker_home_page.dart';
import 'package:tasklocal/Screens/tasker_registration.dart';

import 'Screens/loginpage.dart';
import 'package:tasklocal/Screens/tasker_registration.dart';
import 'package:tasklocal/Screens/customerregistration.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp (
      options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      // Change which screen is being displayed here
      home: TaskerHomePage(),
    );
  }
}
