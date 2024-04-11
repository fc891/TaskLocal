// Contributors: Richard N.

import 'package:flutter/material.dart';
import 'package:tasklocal/screens/sign_up_task/edit_remove_sign_up_task.dart';
import 'package:tasklocal/screens/sign_up_task/in_progress_task.dart';

class MyTasksHome extends StatefulWidget {
  const MyTasksHome({super.key});

  @override
  State<MyTasksHome> createState() => _MyTasksHomeState();
}

class _MyTasksHomeState extends State<MyTasksHome> {
  @override
  Widget build(BuildContext context) {
    // creates the tab navigation bar, there will be 2 tabs
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Tasks'),
          centerTitle: true,
          //backgroundColor: Colors.green[800],
          bottom: TabBar(
            // have color based on user selecting the tab
            unselectedLabelColor: Colors.grey[400],
            labelColor: Colors.green[300],
            // labels for each tab
            tabs: const [
              Tab(text: 'Signed Up'),
              Tab(text: 'In Progress'),
            ],
          ),
        ),
        body: const TabBarView(
          // navigate to the pages
          children: [
            EditRemoveSignUpTask(),
            InProgressTask(),
          ],
        ),
      ),
    );
  }
}
