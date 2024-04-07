// Contributors: Richard N.

import 'package:flutter/material.dart';
import 'package:tasklocal/screens/home_pages/task_category.dart';
import 'package:tasklocal/screens/home_pages/temp_navigate_pages/tasker_category_info.dart';
import 'package:tasklocal/screens/sign_up_task/sign_up_for_task_home.dart';

class TaskerSearchTask extends StatefulWidget {
  final List<TaskCategory> taskList;
  const TaskerSearchTask({super.key, required this.taskList});

  @override
  State<TaskerSearchTask> createState() => _TaskerSearchTaskState();
}

class _TaskerSearchTaskState extends State<TaskerSearchTask> {
  final searchController = TextEditingController();
  late List<TaskCategory> taskList;

  @override
  void initState() {
    super.initState();
    taskList = widget.taskList;
  }

  @override
  Widget build(BuildContext context) {
    Color unselectedBorderColor = Theme.of(context).colorScheme.primary;
    Color selectedBorderColor = Theme.of(context).colorScheme.secondary;
    return Scaffold(
      //backgroundColor: Colors.green,
      appBar: AppBar(
        //title: Text('', style: TextStyle(color: Colors.white)),
        //backgroundColor: Colors.green[800],
        elevation: 0.0,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Task Category Name',
                  hintStyle:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.tertiary,
                  // Richard's code
                  // border is black by default and when click the search bar border is white
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: selectedBorderColor),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  // Richard's code
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: unselectedBorderColor),
                      borderRadius: BorderRadius.circular(10))),
              onChanged: searchTaskCategory,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: taskList.length,
              itemBuilder: (context, index) {
                final task = taskList[index];
                return ListTile(
                  leading: Image.asset(
                    width: 50,
                    height: 50,
                    task.imagePath,
                    fit: BoxFit.cover,
                  ),
                  title: Text(task.name,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary)),
                  onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignUpForTaskHome(taskCategory: task,)),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void searchTaskCategory(String query) {
    final suggestions = widget.taskList.where((task) {
      final taskName = task.name.toLowerCase();
      final input = query.toLowerCase();
      return taskName.contains(input);
    }).toList();

    setState(() => taskList = suggestions);
  }
}
