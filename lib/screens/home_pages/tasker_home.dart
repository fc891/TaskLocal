// Tasker Home Page UI/Screen
// Contributors: Richard N., Eric C.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tasklocal/components/task_category_box.dart';
import 'package:tasklocal/screens/home_pages/task_category.dart';
import 'package:tasklocal/screens/home_pages/tasker_search_task.dart';
import 'package:tasklocal/screens/messages/tasker_messages_home.dart';
import 'package:tasklocal/screens/profiles/taskerprofilepage.dart';
import 'package:tasklocal/screens/calendar/calendarfront.dart';
import 'package:tasklocal/screens/sign_up_task/my_task_home.dart';
import 'package:tasklocal/screens/sign_up_task/sign_up_for_task_home.dart';


class TaskerHomePage extends StatefulWidget {
  const TaskerHomePage({super.key});

  @override
  State<TaskerHomePage> createState() => _TaskerHomePageState();
}

class _TaskerHomePageState extends State<TaskerHomePage> {
  // Richard's code
  final FocusNode _focusNode = FocusNode();
  @override
  void dispose() {
    _focusNode.dispose(); // Dispose the focus node when the widget is disposed
    super.dispose();
  }
  final searchController = TextEditingController();
  // Created a variable to track the selected button in the bottom navigation
  int _selectedIndex = 0;
  // Richard's code
  // Created 2 list of TaskCategory objects that will be used to display in the page
  List<TaskCategory> jobCategoryFirstRow = [
    TaskCategory(name: "Furniture Assembly", imagePath: 'lib/images/tasker_home_images/furniture_assembly.jpeg'),
    TaskCategory(name: "Mounting Services", imagePath: 'lib/images/tasker_home_images/mounting_services.jpeg'),
    TaskCategory(name: "Yard Work", imagePath: 'lib/images/tasker_home_images/yard_work.jpeg'),
    TaskCategory(name: "Cleaning Services", imagePath: 'lib/images/tasker_home_images/cleaning_services.jpg'),
    TaskCategory(name: "Handyman Services", imagePath: 'lib/images/tasker_home_images/handyman_services.jpg'),
    TaskCategory(name: "Delivery Services", imagePath: 'lib/images/tasker_home_images/delivery_services.jpeg'),
    TaskCategory(name: "Event Planning", imagePath: 'lib/images/tasker_home_images/event_planning.jpeg'),
    TaskCategory(name: "Moving Services", imagePath: 'lib/images/tasker_home_images/moving_services.jpeg'),
    TaskCategory(name: "Computer Services", imagePath: 'lib/images/tasker_home_images/computer_services.jpeg'),
  ];
  List<TaskCategory> jobCategorySecondRow = [
    TaskCategory(name: "Photography Projects", imagePath: 'lib/images/tasker_home_images/photography_proj.jpeg'),
    TaskCategory(name: "Art Installations", imagePath: 'lib/images/tasker_home_images/art_installations.jpeg'),
    TaskCategory(name: "Tech Innovations", imagePath: 'lib/images/tasker_home_images/tech_innovations.jpeg'),
    TaskCategory(name: "Gardening Projects", imagePath: 'lib/images/tasker_home_images/gardening_proj.jpeg'),
    TaskCategory(name: "Music Productions", imagePath: 'lib/images/tasker_home_images/music_prod.jpeg'),
    TaskCategory(name: "Fitness Training", imagePath: 'lib/images/tasker_home_images/fitness_training.jpeg'),
    TaskCategory(name: "Organization", imagePath: 'lib/images/tasker_home_images/organization.jpeg'),
    TaskCategory(name: "Wall Repair", imagePath: 'lib/images/tasker_home_images/wall_repair.jpeg'),
    TaskCategory(name: "Smart Home Installation", imagePath: 'lib/images/tasker_home_images/smart_home_install.jpeg'),
  ];
  late List<TaskCategory> jobCategoryCombinedRow = [...jobCategoryFirstRow, ...jobCategorySecondRow];
  // Richard's code
  // sign user out of the application
  void logUserOut() {
    FirebaseAuth.instance.signOut();
    Navigator.pop(context);
  }
  // Richard's code
  // direct user to a page for more info about each task category
  void navigateToTaskerCategoryInfo(int index, List listRow) {
    Navigator.push(context,
      MaterialPageRoute(builder: (context) => SignUpForTaskHome(taskCategory: listRow[index],)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.green,
      // Richard's code
      // app bar contains the title and sign out button
      appBar: AppBar(
        title: Text('Welcome, Tasker!', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green[800],
        elevation: 0.0,
        automaticallyImplyLeading: false,
        actions: [
          // potential notification button to be used
          // IconButton(onPressed: () => {},icon: Icon(Icons.notifications, color: Colors.grey[300])),
          // Richard's code
          // direct user to the logUserOut function where they can log out
          IconButton(
            onPressed: logUserOut, 
            icon: Icon(Icons.logout, color: Colors.grey[300],)
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              // Richard's code
              // Displays any important info of the user such as schedule appointments
              Container(
                decoration: BoxDecoration(color: Colors.green[800], borderRadius: BorderRadius.circular(20)),
                padding: EdgeInsets.all(25),
                margin: EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(bottom: 20.0),
                      child: Column(
                        children: [
                          Text("You have a scheduled appointment!", style: TextStyle(color: Colors.white),),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:20),
                child: Text(
                  'Sign up for a service!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              // Eric's code
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: FocusScope(
                  node: FocusScopeNode(),
                  child: TextFormField(
                    focusNode: _focusNode,
                    onTap: () {
                      _focusNode.unfocus();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TaskerSearchTask(taskList: jobCategoryCombinedRow)),
                      );
                    },
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search for task categories',
                      filled: true,
                      fillColor: Colors.grey[250],
                      // Richard's code
                      // border is black by default and when click the search bar border is white
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      // Richard's code
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black), 
                        borderRadius: BorderRadius.circular(10)
                      )
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Richard's code
              // subtitle of the different categories available
              Padding(
                padding: const EdgeInsets.only(left:20),
                child: Text(
                  'Task Catagories',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Richard's code
              // display the images and title of the task categories
              Container(
                height: 180,
                // color: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    // shrinkWrap: true,
                    itemCount: jobCategoryFirstRow.length,
                    // go through the list of the task categories and displays
                    itemBuilder: (context, index) => TaskCategoryBox(
                      taskCategory: jobCategoryFirstRow[index],
                      onTap: () => navigateToTaskerCategoryInfo(index, jobCategoryFirstRow),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Richard's code
              // display the images and title of the task categories
              Container(
                height: 180,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal:20.0),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    // shrinkWrap: true,
                    itemCount: jobCategorySecondRow.length,
                    // go through the list of the task categories and displays
                    itemBuilder: (context, index) => TaskCategoryBox(
                      taskCategory: jobCategorySecondRow[index], 
                      onTap: () => navigateToTaskerCategoryInfo(index, jobCategorySecondRow),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        // Richard's code
        // Created additional navigation items
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        items: const [
          // Richard's code
          // navigates to home page
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
           // Richard's code
           // navigates to tasker's past, current, and future tasks
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'My Tasks',
          ),
          // navigates to the calendar page
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          // navigates to the messages
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Messages',
          ),
          // navigates to the profile page
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (int index) {
          // Richard's code
          // switch indexes to identify which button has been selected
          // by default the home page is selected
          setState(() {
          _selectedIndex = index;
          });
          switch (index) {
            case 0:
              // navigates to the home page
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => TaskerHomePage()),
              );
              break;
            case 1:
              // navigates to tasker's list of tasks that they have to complete
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyTaskHome()),
              );
              break;
            case 2:
              // navigates to the calendar page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CalendarFront()),
              );
              break;
            case 3:
              // directs to the messages page where users can send and receive messages
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TaskerMessagesHome()),
              );
              break;
            case 4:
              // Redirect to Profile
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TaskerProfilePage()),
              );
              break;
          }
        },
      ),
    );
  }
}
