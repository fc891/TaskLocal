import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PostDiscussionTopic extends StatefulWidget {
  const PostDiscussionTopic({super.key});

  @override
  State<PostDiscussionTopic> createState() => _PostDiscussionTopicState();
}

class _PostDiscussionTopicState extends State<PostDiscussionTopic> {
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    Color unselectedBorderColor = Theme.of(context).colorScheme.primary;
    Color selectedBorderColor = Theme.of(context).colorScheme.secondary;
    return Scaffold(
      appBar: AppBar(
        title: Text("Post Discussion Topic"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.tertiary,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: DropdownButtonFormField<String>(
                  icon: Icon(Icons.arrow_drop_down, color: Colors.white,),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                  value: _selectedCategory,
                  dropdownColor: Theme.of(context).colorScheme.tertiary,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCategory = newValue;
                    });
                  },
                  items: <String>[
                    'Furniture Assembly',
                    'Mounting Services',
                    'Yard Work',
                    'Cleaning Services',
                    'Handyman Services',
                    'Delivery Services',
                    'Event Planning',
                    'Moving Services',
                    'Computer Services',
                    'Photography Projects',
                    'Art Installations',
                    'Tech Innovations',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              // controller: locationController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                hintText: 'Topic Title',
                hintStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
                filled: true,
                fillColor: Theme.of(context).colorScheme.tertiary,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: selectedBorderColor),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: unselectedBorderColor), 
                  borderRadius: BorderRadius.circular(10)
                )
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.tertiary,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Theme.of(context).colorScheme.secondary,
                  width: 1,
                ),
              ),
              child: TextField(
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: 'Message',
                  hintStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(10),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.tertiary,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15),
              child: Text("Submit", style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}