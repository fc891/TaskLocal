import 'package:flutter/material.dart';
import 'package:tasklocal/screens/sign_up_task/edit_remove_sign_up_task.dart';
import 'package:tasklocal/screens/sign_up_task/store_completed_task.dart';

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
          title: Text('My Tasks', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 26)),
          centerTitle: true,
          backgroundColor: Colors.green[800],
          bottom: TabBar(
            unselectedLabelColor: Colors.grey[400],
            labelColor: Colors.green[300],
            tabs: const [
              Tab(icon: Icon(Icons.edit)),
              Tab(icon: Icon(Icons.tablet_android)),
              Tab(icon: Icon(Icons.laptop_windows)),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            EditRemoveSignUpTask(),
            StoreCompletedTask(),
            Icon(Icons.directions_bike),
          ],
        ),
      ),
    );
  }
}
