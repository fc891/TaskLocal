// Contributers: Richard N.
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
        // decoration: BoxDecoration(
        //   borderRadius: BorderRadius.circular(40),
        //   color: Colors.red[100],
        // ),
        margin: EdgeInsets.only(right: 25),
        // padding: EdgeInsets.all(25),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // image
            ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Image.asset(
                taskCategory.imagePath,
                height: 150,
                width: 170,
              ),
            ),
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