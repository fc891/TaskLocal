// Create the container for the task categories in tasker_home.dart
// Contributers: Richard N.

import 'package:flutter/material.dart';
import 'package:tasklocal/screens/home_pages/task_category.dart';

class TaskCategoryBox extends StatelessWidget {
  // variables and functions are created to access the separate pages of the task category
  final TaskCategory taskCategory;
  final void Function()? onTap;
  const TaskCategoryBox({super.key, required this.taskCategory, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // directs the user to a separate page when tap the container
      onTap: onTap,
      child: Container(
        // potential decoration
        // decoration: BoxDecoration(
        //   borderRadius: BorderRadius.circular(40),
        //   color: Colors.red[100],
        // ),
        margin: EdgeInsets.only(right: 25),
        child: Column(
          children: [
            // display the image of the task category
            ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Image.asset(
                taskCategory.imagePath,
                height: 150,
                width: 170,
                fit: BoxFit.cover,
              ),
            ),
            // display the text of the task category
            Text(
              taskCategory.name,
              style: TextStyle(color: Colors.white, fontSize: 14,),
            ),
          ],
        ),
      ),
    );
  }
}