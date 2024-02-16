// Tasker Home Page UI/Screen
// Contributors: Eric C., Richard N.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tasklocal/components/task_cat_box.dart';
import 'package:tasklocal/screens/home_pages/task_category.dart';
import 'package:tasklocal/screens/profiles/taskerprofilepage.dart';

class TaskerHomePage extends StatefulWidget {
  const TaskerHomePage({super.key});

  @override
  State<TaskerHomePage> createState() => _TaskerHomePageState();
}

class _TaskerHomePageState extends State<TaskerHomePage> {
  // Created a variable to track the selected button in the bottom navigation
  int _selectedIndex = 0;

  List jobCategoryFirstRow = [
    TaskCategory(name: "Furniture Assembly"),
    TaskCategory(name: "Mounting Services"),
    TaskCategory(name: "Yard Work"),
    TaskCategory(name: "Cleaning Services"),
    TaskCategory(name: "Handyman Services"),
    TaskCategory(name: "Delivery Services"),
  ];
  List jobCategorySecondRow = [
    TaskCategory(name: "Event Planning"),
    TaskCategory(name: "Moving Services"),
    TaskCategory(name: "Computer Services"),
    TaskCategory(name: "Cleaning Services"),
    TaskCategory(name: "Handyman Services"),
    TaskCategory(name: "Delivery Services"),
  ];

  // sign user out of the app
  void logUserOut() {
    FirebaseAuth.instance.signOut();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        title: Text('Welcome, Tasker!', style: TextStyle(color: Colors.white)),
        // centerTitle: true,
        backgroundColor: Colors.green[800],
        elevation: 0.0,
        actions: [
          IconButton(onPressed: () => {},icon: Icon(Icons.notifications, color: Colors.grey[300])),
          IconButton(
            onPressed: logUserOut, 
            icon: Icon(Icons.logout, color: Colors.grey[300],)
          ),
        ],
//         title: Text('', style: TextStyle(color: Colors.white)),
//         centerTitle: true,
//         backgroundColor: Colors.green[800],
//         elevation: 0.0,
//         automaticallyImplyLeading: false,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(
                //   'Welcome, Tasker!',
                //   style: TextStyle(
                //     color: Colors.white,
                //     fontSize: 20,
                //   ),
                // ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(color: Colors.green[800], borderRadius: BorderRadius.circular(20)),
                  padding: EdgeInsets.all(25),
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    children: const [
                      Column(
                        children: [
                          Text("You have a scheduled appointment!"),
                          Text("You have a scheduled appointment!")
                        ],
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
                // Search bar to search for tasks
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
                  height: 170,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      // shrinkWrap: true,
                      itemCount: jobCategoryFirstRow.length,
                      itemBuilder: (context, index) => TaskCategoryBox(
                        taskcat: jobCategoryFirstRow[index],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 170,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal:20.0),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      // shrinkWrap: true,
                      itemCount: jobCategorySecondRow.length,
                      itemBuilder: (context, index) => TaskCategoryBox(
                        taskcat: jobCategorySecondRow[index],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left:20),
                  child: Text(
                    'Popular Task Catagories',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 170,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal:20.0),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      // shrinkWrap: true,
                      itemCount: jobCategorySecondRow.length,
                      itemBuilder: (context, index) => TaskCategoryBox(
                        taskcat: jobCategorySecondRow[index],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 170,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal:20.0),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      // shrinkWrap: true,
                      itemCount: jobCategorySecondRow.length,
                      itemBuilder: (context, index) => TaskCategoryBox(
                        taskcat: jobCategorySecondRow[index],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                // Job Categories
                // Updated to display 3 categories per row
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: [
                //     _buildCategoryBox('Job Category 1', 'Furniture Assembly', 'images/furniture_assembly.jpg', Colors.blue),
                //     _buildCategoryBox('Job Category 2', 'Mounting Services', 'images/mounting_services.jpg', Colors.orange),
                //     _buildCategoryBox('Job Category 3', 'Yard Work\n', 'images/yard_work.jpg', Colors.purple),
                //   ],
                // ),
                // const SizedBox(height: 10),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: [
                //     _buildCategoryBox('Job Category 4', 'Cleaning Services', 'images/cleaning_services.jpg', Colors.red),
                //     _buildCategoryBox('Job Category 5', 'Handyman Services', 'images/handyman_services.jpg', Colors.pink),
                //     _buildCategoryBox('Job Category 6', 'Delivery Services', 'images/delivery_services.jpg', Colors.yellow),
                //   ],
                // ),
                // const SizedBox(height: 10),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: [
                //     _buildCategoryBox('Job Category 7', 'Event Planning', 'images/event_planning.jpg', Colors.teal),
                //     _buildCategoryBox('Job Category 8', 'Moving Services', 'images/moving_services.jpg', Colors.deepOrange),
                //     _buildCategoryBox('Job Category 9', 'Computer Services', 'images/computer_services.jpg', Colors.indigo),
                //   ],
                // ),
                // const SizedBox(height: 10),
                // // Trending Projects
                // Text(
                //   'Trending Projects',
                //   style: TextStyle(
                //     color: Colors.black,
                //     fontSize: 24,
                //   ),
                // ),
                // const SizedBox(height: 10),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: [
                //     _buildCategoryBox('Trending Project 1', 'Photography Projects', 'images/photography_projects.jpg', Colors.green),
                //     _buildCategoryBox('Trending Project 2', 'Art Installations', 'images/art_installations.jpg', Colors.cyan),
                //     _buildCategoryBox('Trending Project 3', 'Tech Innovations', 'images/tech_innovations.jpg', Colors.amber),
                //   ],
                // ),
                // const SizedBox(height: 10),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: [
                //     _buildCategoryBox('Trending Project 4', 'Gardening Projects', 'images/gardening_projects.jpg', Colors.deepPurple),
                //     _buildCategoryBox('Trending Project 5', 'Music Productions', 'images/music_productions.jpg', Colors.lightBlue),
                //     _buildCategoryBox('Trending Project 6', 'Fitness Training', 'images/fitness_training.jpg', Colors.lime),
                //   ],
                // ),
                // const SizedBox(height: 10),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: [
                //     _buildCategoryBox('Job Category 10 with Long Name', 'Long Job Category 10', 'images/long_job_category_10.jpg', Colors.cyan),
                //     _buildCategoryBox('Job Category 11 with Very Long Name', 'Very Long Job Category 11', 'images/very_long_job_category_11.jpg', Colors.amber),
                //     _buildCategoryBox('Job Category 12', 'Job Category 12', 'images/job_category_12.jpg', Colors.brown),
                //   ],
                // ),
                // const SizedBox(height: 20),
              ],
            ),
          ),
        // ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
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
        //
        onTap: (int index) {
          setState(() {
          _selectedIndex = index; // Update selected index
          });
          switch (index) {
            case 0:
              // Redirect to Home
              break;
            case 1:
              // Redirect to Calendar
              break;
            case 2:
              // Redirect to Messages
              break;
            case 3:
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
  Widget _buildCategoryBox(String category, String label, String imagePath, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 0.0, right: 8.0, top: 8.0, bottom: 8.0),
          width: 100,
          height: 120,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(15.0),
          ),
          // child: Image.asset(
          //   imagePath,
          //   fit: BoxFit.cover,
          // ),
        ),
        Container(
          width: 100,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
