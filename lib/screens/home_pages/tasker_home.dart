// Tasker Home Page UI/Screen
// Contributors: Eric C., Richard N.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tasklocal/components/task_category_box.dart';
import 'package:tasklocal/screens/home_pages/task_category.dart';
import 'package:tasklocal/screens/home_pages/temp_navigate_pages/tasker_calendar.dart';
import 'package:tasklocal/screens/home_pages/temp_navigate_pages/tasker_category_info.dart';
import 'package:tasklocal/screens/home_pages/temp_navigate_pages/tasker_messages.dart';
import 'package:tasklocal/screens/home_pages/temp_navigate_pages/tasker_post_service.dart';
import 'package:tasklocal/screens/profiles/taskerprofilepage.dart';

class TaskerHomePage extends StatefulWidget {
  const TaskerHomePage({super.key});

  @override
  State<TaskerHomePage> createState() => _TaskerHomePageState();
}

class _TaskerHomePageState extends State<TaskerHomePage> {
  // Richard's code
  // Created a variable to track the selected button in the bottom navigation
  int _selectedIndex = 0;

  List jobCategoryFirstRow = [
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
  List jobCategorySecondRow = [
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
  // Richard's code
  // sign user out of the app
  void logUserOut() {
    FirebaseAuth.instance.signOut();
  }
  
  // Richard's code
  void navigateToTaserCategoryInfo(int index, List listRow) {
    Navigator.push(context,
      MaterialPageRoute(builder: (context) => TaskerCategoryInfo(taskCategory: listRow[index],)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      // Richard's code
      appBar: AppBar(
        title: Text('Welcome, Tasker!', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green[800],
        elevation: 0.0,
        actions: [
          // IconButton(onPressed: () => {},icon: Icon(Icons.notifications, color: Colors.grey[300])),
          IconButton(
            onPressed: logUserOut, 
            icon: Icon(Icons.logout, color: Colors.grey[300],)
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              // Richard's code
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
              // Eric's code
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:20),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search for available tasks...',
                    filled: true,
                    fillColor: Colors.grey[250],
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black), 
                      borderRadius: BorderRadius.circular(10)
                    )
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Richard's code
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
              Container(
                height: 180,
                // color: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    // shrinkWrap: true,
                    itemCount: jobCategoryFirstRow.length,
                    itemBuilder: (context, index) => TaskCategoryBox(
                      taskCategory: jobCategoryFirstRow[index],
                      onTap: () => navigateToTaserCategoryInfo(index, jobCategoryFirstRow),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 180,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal:20.0),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    // shrinkWrap: true,
                    itemCount: jobCategorySecondRow.length,
                    itemBuilder: (context, index) => TaskCategoryBox(
                      taskCategory: jobCategorySecondRow[index], 
                      onTap: () => navigateToTaserCategoryInfo(index, jobCategorySecondRow),
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
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
           // Richard's code
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: 'Post Service',
          ),
           // Richard's code
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (int index) {
          setState(() {
          _selectedIndex = index; // Update selected index
          });
          switch (index) {
            case 0:
              // Redirect to Home
              // Richard's code
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TaskerHomePage()),
              );
              break;
            case 1:
              // Redirect to Post Service
              // Richard's code
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TaskerPostService()),
              );
              break;
            case 2:
              // Redirect to Calendar
              // Richard's code
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TaskerCalendar()),
              );
              break;
            case 3:
              // Redirect to Messages
              // Richard's code
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TaskerMessages()),
              );
              break;
            case 4:
              // Redirect to Profile
              // Eric's code
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
