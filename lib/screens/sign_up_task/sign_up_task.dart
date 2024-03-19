// Contributors: Richard N.

import 'package:flutter/material.dart';
import 'package:tasklocal/screens/home_pages/task_category.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class SignUpTask extends StatefulWidget {
  final TaskCategory taskCategory;
  const SignUpTask({super.key, required this.taskCategory});

  @override
  State<SignUpTask> createState() => _SignUpTaskState();
}

class _SignUpTaskState extends State<SignUpTask> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final expController = TextEditingController();
  final askingRateController = TextEditingController();
  final locationController = TextEditingController();
  final exampleController = TextEditingController();
  final describeController = TextEditingController();

  String dropdownValue = 'Years'; 
  List<String> skills = []; // List to hold user's skills

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        title: Text(widget.taskCategory.name, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24)),
        centerTitle: true,
        backgroundColor: Colors.green[800],
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "How many experience do you have?",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                controller: expController,
                decoration: InputDecoration(
                  hintText: 'Enter the amount',
                  filled: true,
                  fillColor: Colors.grey[200],
                  // border is black by default and when click the text field, border is white
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
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "How many experience do you have?",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                controller: expController,
                decoration: InputDecoration(
                  hintText: 'Enter the amount',
                  filled: true,
                  fillColor: Colors.grey[200],
                  // border is black by default and when click the text field, border is white
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
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "How many experience do you have?",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextField(
                      controller: expController,
                      decoration: InputDecoration(
                        hintText: 'Enter the amount',
                        filled: true,
                        fillColor: Colors.grey[200],
                        // border is black by default and when click the text field, border is white
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
                ),
                SizedBox(width: 10),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: DropdownButton<String>(
                    value: dropdownValue,
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(color: Colors.black),
                    underline: Container(
                      height: 2,
                      color: Colors.grey[200],
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                      });
                    },
                    items: <String>['Years', 'Months', 'Weeks']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20), // Add some space between the experience section and skills section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Skills:",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    SizedBox(
                      width: 150,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: skills.length + 1, // +1 for the initial empty text field
                        itemBuilder: (context, index) {
                          if (index == skills.length) {
                            // Add button to add more skills
                            return TextButton(
                              onPressed: () {
                                setState(() {
                                  skills.add('');
                                });
                              },
                              child: Text(
                                "Add Skill",
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                          }
                          return TextFormField(
                            // initialValue: skills[index],
                            // onChanged: (value) {
                            //   setState(() {
                            //     skills[index] = value;
                            //   });
                            // },
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              hintText: "Enter skill ${index + 1}",
                              hintStyle: TextStyle(color: Colors.grey),
                              filled: true,
                              fillColor: Colors.grey[200],
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}