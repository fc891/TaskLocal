// Create the container for the task categories in tasker_home.dart

import 'package:flutter/material.dart';
import '../screens/home_pages/task_category.dart';

class TaskCategoryBox extends StatelessWidget {
  final TaskCategory taskCategory;
  final void Function()? onTap;
  const TaskCategoryBox({super.key, required this.taskCategory, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
        ),
        margin: EdgeInsets.only(right: 25),
        // padding: EdgeInsets.all(25),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // image
            Image.asset(
              taskCategory.imagePath,
              height: 140,
              
            ),
            // Container(
            //   width: 150,
            //   height: 150,
            //   decoration: BoxDecoration(
            //     color: Colors.blue,
            //     borderRadius: BorderRadius.circular(15.0),
            //   ),
            // ),
            // text
            Text(
              taskCategory.name,
            ),
          ],
        ),
      ),
    );
  }
}