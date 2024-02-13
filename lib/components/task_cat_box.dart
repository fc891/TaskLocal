// Create the container for the task categories in tasker_home.dart

import 'package:flutter/material.dart';
import '../screens/home_pages/task_category.dart';

class TaskCategoryBox extends StatelessWidget {
  final TaskCategory taskcat;
  const TaskCategoryBox({super.key, required this.taskcat});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      margin: EdgeInsets.only(left: 25),
      // padding: EdgeInsets.all(25),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // image
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
          // text
          Text(
            taskcat.name,
          ),
        ],
      ),
    );
  }
}