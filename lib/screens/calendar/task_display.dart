import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// use class to create ui for the task in calendar features page 

// create variables for the different features we want to display
class Task {
  final String? title;
  final String? startTime;
  final String? endTime;
  final String? note;
  final int? color;
  final int? isCompleted;

  Task({
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.note,
    required this.color,
    required this.isCompleted,
  });
}

// create class
class TaskDisplay extends StatelessWidget {
  final Task? task;

  TaskDisplay(this.task);

  // build layout
  @override
  Widget build(BuildContext context) {
    if (task == null) {
      return Container();
    }
    final title = task!.title ?? "";
    final startTime = task!.startTime ?? "";
    final endTime = task!.endTime ?? "";
    final note = task!.note ?? "";
    final color = task!.color ?? 0;
    final isCompleted = task!.isCompleted ?? 0;

    // create nice boxed ui for layout
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(bottom: 12),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: _getColor(color),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        color: Colors.grey[200],
                        size: 18,
                      ),
                      SizedBox(width: 4),
                      Text(
                        "$startTime - $endTime",
                        style: GoogleFonts.lato(
                          textStyle:
                              TextStyle(fontSize: 13, color: Colors.grey[100]),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    note,
                    style: GoogleFonts.lato(
                      textStyle:
                          TextStyle(fontSize: 15, color: Colors.grey[100]),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              height: 60,
              width: 0.5,
              color: Colors.grey[200]!.withOpacity(0.7),
            ),
            RotatedBox(
              quarterTurns: 3,
              child: Text(
                isCompleted == 1 ? "COMPLETED" : "TODO",
                style: GoogleFonts.lato(
                  textStyle: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // synchronize with the different index for chosen color of task
  _getColor(int no) {
    switch (no) {
      case 0:
        return Color.fromARGB(255, 93, 182, 255);
      case 1:
        return Color.fromARGB(255, 255, 77, 64);
      case 2:
        return Color.fromARGB(255, 78, 247, 83);
      case 3:
        return Color.fromARGB(255, 239, 223, 80);
      default:
        return Color.fromARGB(255, 93, 182, 255);
    }
  }
}
