// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'package:flutter/material.dart';
import 'package:tasklocal/Database/mongoconnection.dart';
import 'package:tasklocal/mongodbmodel.dart';

class MongoDbDisplay extends StatefulWidget {
  MongoDbDisplay({Key? key}) : super(key: key);

  @override
  _MongoDbDisplayState createState() => _MongoDbDisplayState();
}

class _MongoDbDisplayState extends State<MongoDbDisplay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: MongoConnection.getData(),
          builder: (context , AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            else {
              if (snapshot.hasData) {
                var totalData = snapshot.data.length;
                print("Total Data: $totalData");
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (content, index) {
                    return displayCard(Mongodbmodel.fromJson(snapshot.data[index]));
                  }
                );
              } else {
                return Center(child: Text("No Data Available"));
              }
            }
          }
        )
      )
    );
  }

  Widget displayCard(Mongodbmodel data) {
    return Card()
  }
}