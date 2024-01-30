import 'package:flutter/material.dart';
import 'package:tasklocal/Database/mongoconnection.dart';
import 'package:tasklocal/display.dart';
import 'package:tasklocal/insert.dart';
import 'package:tasklocal/Screens/customerregistration.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await MongoConnection.connect(); //Connect to database
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
      home: CustomerRegistration(),
    );
  }
}
