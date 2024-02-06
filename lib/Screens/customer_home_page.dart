// Customer Home Page UI/Screen

import 'package:flutter/material.dart';

class CustomerHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Customer Homepage'),
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
                  'Get something done today',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 32,
                  ),
                ),
                const SizedBox(height: 10),
                // Search Box
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search for available taskers...',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Job Categories
                // Updated to display 3 categories per row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildCategoryBox('Job Category 1', 'Furniture\nAssembly', Colors.blue),
                    _buildCategoryBox('Job Category 2', 'Mounting\nServices', Colors.orange),
                    _buildCategoryBox('Job Category 3', 'Yard Work\n', Colors.purple),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildCategoryBox('Job Category 4', 'Cleaning\nServices', Colors.red),
                    _buildCategoryBox('Job Category 5', 'Handyman\nServices', Colors.pink),
                    _buildCategoryBox('Job Category 6', 'Delivery\nServices', Colors.yellow),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildCategoryBox('Job Category 7', 'Event\nPlanning', Colors.teal),
                    _buildCategoryBox('Job Category 8', 'Moving\nServices', Colors.deepOrange),
                    _buildCategoryBox('Job Category 9', 'Computer\nServices', Colors.indigo),
                  ],
                ),
                const SizedBox(height: 10),
                // Trending Projects
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
                    _buildCategoryBox('Trending Project 1', 'Photography\nProjects', Colors.green),
                    _buildCategoryBox('Trending Project 2', 'Art\nInstallations', Colors.cyan),
                    _buildCategoryBox('Trending Project 3', 'Tech\nInnovations', Colors.amber),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildCategoryBox('Trending Project 4', 'Gardening\nProjects', Colors.deepPurple),
                    _buildCategoryBox('Trending Project 5', 'Music\nProductions', Colors.lightBlue),
                    _buildCategoryBox('Trending Project 6', 'Fitness\nTraining', Colors.lime),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildCategoryBox('Job Category 10 with Long Name', 'Long Job Category 10', Colors.cyan),
                    _buildCategoryBox('Job Category 11 with Very Long Name', 'Very Long Job Category 11', Colors.amber),
                    _buildCategoryBox('Job Category 12', 'Job Category 12', Colors.brown),
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
      ),
    );
  }

  Widget _buildCategoryBox(String category, String label, Color color) {
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
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  category,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
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
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: CustomerHomePage(),
  ));
}
