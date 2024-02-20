// Customer Home Page UI/Screen
// Contributors: Eric C.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tasklocal/screens/customer_requests/address_input.dart';
import 'package:tasklocal/screens/profiles/taskerprofilepage.dart';
import 'package:tasklocal/screens/home_pages/temp_navigate_pages/tasker_calendar.dart';
import 'package:tasklocal/screens/home_pages/temp_navigate_pages/tasker_messages.dart';

// Eric's code for class
class CustomerHomePage extends StatefulWidget {
  @override
  _CustomerHomePageState createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
  late BuildContext _context; // Store the context here

  @override
  void initState() {
    super.initState();
    _context = context;
  }

  // Eric's code for customer's home page UI
  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Customer's Home Page"),
        centerTitle: true,
        backgroundColor: Colors.green[800],
        elevation: 0.0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: logUserOut,
            icon: Icon(Icons.logout, color: Colors.grey[300],)
          ),
        ],
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
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Looking for something else?',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
                const SizedBox(height: 20),
                _buildCategoryRow([
                  _buildCategoryBox('Furniture Assembly', 'lib/images/customer_home_images/furniture_assembly.jpeg'),
                  _buildCategoryBox('Mounting Services', 'lib/images/customer_home_images/mounting_services.jpeg'),
                  _buildCategoryBox('Yard Work\n', 'lib/images/customer_home_images/yard_work.jpeg'),
                ]),
                const SizedBox(height: 10),
                _buildCategoryRow([
                  _buildCategoryBox('Cleaning Services', 'lib/images/customer_home_images/cleaning_services.jpg'),
                  _buildCategoryBox('Handyman Services', 'lib/images/customer_home_images/handyman_services.jpg'),
                  _buildCategoryBox('Delivery Services', 'lib/images/customer_home_images/delivery_services.jpeg'),
                ]),
                const SizedBox(height: 10),
                _buildCategoryRow([
                  _buildCategoryBox('Event Planning', 'lib/images/customer_home_images/event_planning.jpeg'),
                  _buildCategoryBox('Moving Services', 'lib/images/customer_home_images/moving_services.jpeg'),
                  _buildCategoryBox('Computer Services', 'lib/images/customer_home_images/computer_services.jpeg'),
                ]),
                const SizedBox(height: 10),
                _buildCategoryRow([
                  _buildCategoryBox('Photography Projects', 'lib/images/customer_home_images/photography_proj.jpeg'),
                  _buildCategoryBox('Art Installations', 'lib/images/customer_home_images/art_installations.jpeg'),
                  _buildCategoryBox('Tech Innovations', 'lib/images/customer_home_images/tech_innovations.jpeg'),
                ]),
                const SizedBox(height: 10),
                _buildCategoryRow([
                  _buildCategoryBox('Gardening Projects', 'lib/images/customer_home_images/gardening_proj.jpeg'),
                  _buildCategoryBox('Music Productions', 'lib/images/customer_home_images/music_prod.jpeg'),
                  _buildCategoryBox('Fitness Training', 'lib/images/customer_home_images/fitness_training.jpeg'),
                ]),
                const SizedBox(height: 10),
                _buildCategoryRow([
                  _buildCategoryBox('Organization', 'lib/images/customer_home_images/organization.jpeg'),
                  _buildCategoryBox('Wall Repair', 'lib/images/customer_home_images/wall_repair.jpeg'),
                  _buildCategoryBox('Smart Home Installation', 'lib/images/customer_home_images/smart_home_install.jpeg'),
                ]),
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
        // Eric's code for redirects
        onTap: (int index) {
          switch (index) {
            case 0:
              // Redirects to calendar
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TaskerCalendar()),
              );
              break;
            case 1:
              // Redirect to messages
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TaskerMessages()),
              );
              break;
            case 2:
              // Redirect to tasker's profile
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TaskerProfilePage()),
              );
          }
        },
      ),
    );
  }

  Widget _buildCategoryRow(List<Widget> categories) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: categories,
    );
  }

  Widget _buildCategoryBox(String label, String imagePath) {
    return GestureDetector(
      onTap: () {
        _navigateToAddressInputPage();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 0.0, right: 8.0, top: 8.0, bottom: 8.0),
            width: 100,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0), // Rounded corners added here
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
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
      ),
    );
  }

  void _navigateToAddressInputPage() {
    Navigator.push(
      _context, // Use stored context here
      MaterialPageRoute(builder: (context) => AddressInputPage()),
    );
  }

  void _navigateToTaskerProfilePage() {
    Navigator.push(
      _context, // Use stored context here
      MaterialPageRoute(builder: (context) => TaskerProfilePage()),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: CustomerHomePage(),
  ));
}
