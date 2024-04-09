// Contributors: Eric C., 

import 'package:flutter/material.dart';
import 'package:tasklocal/screens/customer_requests/address_input.dart';

// list of job categories to pass as a list
class SearchPage extends StatefulWidget {
  final List<String> jobCategories;
  final Map<String, String> categoryImages = {
    'Furniture Assembly': 'lib/images/customer_home_images/furniture_assembly.jpeg',
    'Mounting Services': 'lib/images/customer_home_images/mounting_services.jpeg',
    'Yard Work': 'lib/images/customer_home_images/yard_work.jpeg',
    'Art Installations': 'lib/images/customer_home_images/art_installations.jpeg',
    'Cleaning Services': 'lib/images/customer_home_images/cleaning_services.jpg',
    'Computer Services': 'lib/images/customer_home_images/computer_services.jpeg',
    'Delivery Services': 'lib/images/customer_home_images/delivery_services.jpeg',
    'Event Planning': 'lib/images/customer_home_images/event_planning.jpeg',
    'Fitness Training': 'lib/images/customer_home_images/fitness_training.jpeg',
    'Gardening Projects': 'lib/images/customer_home_images/gardening_proj.jpeg',
    'Handyman Services': 'lib/images/customer_home_images/handyman_services.jpg',
    'Moving Services': 'lib/images/customer_home_images/moving_services.jpeg',
    'Music Productions': 'lib/images/customer_home_images/music_prod.jpeg',
    'Organization': 'lib/images/customer_home_images/organization.jpeg',
    'Photography Projects': 'lib/images/customer_home_images/photography_proj.jpeg',
    'Smart Home Installation': 'lib/images/customer_home_images/smart_home_install.jpeg',
    'Tech Innovations': 'lib/images/customer_home_images/tech_innovations.jpeg',
    'Wall Repair': 'lib/images/customer_home_images/wall_repair.jpeg',
  };

  SearchPage({required this.jobCategories});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<String> filteredCategories = [];

  @override
  void initState() {
    super.initState();
    filteredCategories = widget.jobCategories;
  }

  void filterCategories(String query) {
    setState(() {
      if (query.isNotEmpty) {
        filteredCategories = widget.jobCategories
            .where((category) => category.toLowerCase().startsWith(query.toLowerCase()))
            .toList();
      } else {
        filteredCategories = widget.jobCategories;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onChanged: filterCategories,
          decoration: InputDecoration(
            hintText: 'Search for services...',
            border: InputBorder.none,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Job Categories',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredCategories.length,
              itemBuilder: (context, index) {
                String category = filteredCategories[index];
                String imagePath = widget.categoryImages[category] ?? ''; // get the image path from the mapping
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddressInputPage(jobCategory: '',)), // navigate to AddressInputPage
                    );
                  },
                  child: Card(
                    elevation: 2,
                    margin: EdgeInsets.all(8),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              imagePath,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 16),
                          Text(category),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
