import 'package:flutter/material.dart';

class StoreSignUpAndCompTask extends StatefulWidget {
  const StoreSignUpAndCompTask({super.key});

  @override
  State<StoreSignUpAndCompTask> createState() => _StoreSignUpAndCompTaskState();
}

class _StoreSignUpAndCompTaskState extends State<StoreSignUpAndCompTask> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        // backgroundColor: Colors.green[800],
        appBar: AppBar(
          title: Text('My Tasks', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 32)),
          centerTitle: true,
          backgroundColor: Colors.green[800],
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.phone_android)),
              Tab(icon: Icon(Icons.tablet_android)),
              Tab(icon: Icon(Icons.laptop_windows)),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Icon(Icons.directions_car),
            Icon(Icons.directions_transit),
            Icon(Icons.directions_bike),
          ],
        ),
      ),
    );
  }
}
