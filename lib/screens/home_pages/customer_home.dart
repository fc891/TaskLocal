// Customer Home Page UI/Screen

import 'package:flutter/material.dart';
import 'package:tasklocal/Screens/customer_requests/address_input.dart';
import 'package:tasklocal/Screens/profiles/customerprofilepage.dart';

// Eric's code for CustomerHomePage class
class CustomerHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Customer's Home Page"),
        centerTitle: true,
        backgroundColor: Colors.green[800],
        elevation: 0.0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  'Get something done!',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 32,
                  ),
                ),
                const SizedBox(height: 10),
                // Eric's code for search box functionality
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Looking for something else?',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    prefixIcon: Icon(Icons.search), // Search icon added here
                  ),
                ),
                const SizedBox(height: 20),
                // Eric's list of job categories
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _navigateToAddressInputPage(context);
                      },
                      child: _buildCategoryBox(
                          'Job Category 1', 'Furniture Assembly', 'lib/images/furniture_assembly.webp', Colors.blue),
                    ),
                    GestureDetector(
                      onTap: () {
                        _navigateToAddressInputPage(context);
                      },
                      child: _buildCategoryBox(
                          'Job Category 2', 'Mounting Services', 'images/mounting_services.jpg', Colors.orange),
                    ),
                    GestureDetector(
                      onTap: () {
                        _navigateToAddressInputPage(context);
                      },
                      child: _buildCategoryBox(
                          'Job Category 3', 'Yard Work\n', 'images/yard_work.jpg', Colors.purple),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _navigateToAddressInputPage(context);
                      },
                      child: _buildCategoryBox(
                          'Job Category 4', 'Cleaning Services', 'images/cleaning_services.jpg', Colors.red),
                    ),
                    GestureDetector(
                      onTap: () {
                        _navigateToAddressInputPage(context);
                      },
                      child: _buildCategoryBox(
                          'Job Category 5', 'Handyman Services', 'images/handyman_services.jpg', Colors.pink),
                    ),
                    GestureDetector(
                      onTap: () {
                        _navigateToAddressInputPage(context);
                      },
                      child: _buildCategoryBox(
                          'Job Category 6', 'Delivery Services', 'images/delivery_services.jpg', Colors.yellow),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _navigateToAddressInputPage(context);
                      },
                      child: _buildCategoryBox(
                          'Job Category 7', 'Event Planning', 'images/event_planning.jpg', Colors.teal),
                    ),
                    GestureDetector(
                      onTap: () {
                        _navigateToAddressInputPage(context);
                      },
                      child: _buildCategoryBox(
                          'Job Category 8', 'Moving Services', 'images/moving_services.jpg', Colors.deepOrange),
                    ),
                    GestureDetector(
                      onTap: () {
                        _navigateToAddressInputPage(context);
                      },
                      child: _buildCategoryBox(
                          'Job Category 9', 'Computer Services', 'images/computer_services.jpg', Colors.indigo),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Second section of job categories
                Text(
                  'Trending Projects',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _navigateToAddressInputPage(context);
                      },
                      child: _buildCategoryBox('Trending Project 1', 'Photography Projects', 'images/photography_projects.jpg', Colors.green),
                    ),
                    GestureDetector(
                      onTap: () {
                        _navigateToAddressInputPage(context);
                      },
                      child: _buildCategoryBox('Trending Project 2', 'Art Installations', 'images/art_installations.jpg', Colors.cyan),
                    ),
                    GestureDetector(
                      onTap: () {
                        _navigateToAddressInputPage(context);
                      },
                      child: _buildCategoryBox('Trending Project 3', 'Tech Innovations', 'images/tech_innovations.jpg', Colors.amber),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _navigateToAddressInputPage(context);
                      },
                      child: _buildCategoryBox('Trending Project 4', 'Gardening Projects', 'images/gardening_projects.jpg', Colors.deepPurple),
                    ),
                    GestureDetector(
                      onTap: () {
                        _navigateToAddressInputPage(context);
                      },
                      child: _buildCategoryBox('Trending Project 5', 'Music Productions', 'images/music_productions.jpg', Colors.lightBlue),
                    ),
                    GestureDetector(
                      onTap: () {
                        _navigateToAddressInputPage(context);
                      },
                      child: _buildCategoryBox('Trending Project 6', 'Fitness Training', 'images/fitness_training.jpg', Colors.lime),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _navigateToAddressInputPage(context);
                      },
                      child: _buildCategoryBox('Trending Project 7', 'Organization\n', 'images/long_job_category_10.jpg', Colors.cyan),
                    ),
                    GestureDetector(
                      onTap: () {
                        _navigateToAddressInputPage(context);
                      },
                      child: _buildCategoryBox('Trending Project 8', 'Wall Repair\n', 'images/very_long_job_category_11.jpg', Colors.amber),
                    ),
                    GestureDetector(
                      onTap: () {
                        _navigateToAddressInputPage(context);
                      },
                      child: _buildCategoryBox('Trending Project 9', 'Smart Home Installation', 'images/job_category_12.jpg', Colors.brown),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
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
        // Eric's code for routing to different screens
        onTap: (int index) {
          switch (index) {
            case 0:
              // Redirects to calendar
              break;
            case 1:
              // Redirect to messages
              break;
            case 2:
              // Redirect to user's profile
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CustomerProfilePage()),
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
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
          ),
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

  void _navigateToAddressInputPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddressInputPage()),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: CustomerHomePage(),
  ));
}
