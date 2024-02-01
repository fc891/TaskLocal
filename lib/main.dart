import 'package:flutter/material.dart';
import 'package:tasklocal/Screens/taskerregistration.dart';
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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      // inserting data
      //home: MongoDbInsert(),
      // displaying data
      //home: MongoDbDisplay(),
      // customer registration screen
      //home: CustomerRegistration()
      // tasker registration screen
      home: TaskerRegistration(),
    );
  }
}
