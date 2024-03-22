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

  final locationController = TextEditingController();
  final askingRateController = TextEditingController();
  final expController = TextEditingController();

  String dropdownValue = 'Years'; 
  List<String> skills = []; // List to hold user's skills

  Future<Map<String, dynamic>?> getCurrTaskerData(String? email) async {
    try {
      DocumentSnapshot currTaskerDoc = await _firestore.collection('Customers').doc(email).get();
      if (currTaskerDoc.exists) {
        return currTaskerDoc.data() as Map<String, dynamic>;
      } else {
        print('Customer document does not exist');
        return null;
      }
    } catch (error) {
      print('Error fetching customer data: $error');
      return null;
    }
  }

  void _submitTaskSignUp() async {
    try {
      // DocumentSnapshot currTaskerDoc = await _firestore.collection('Taskers').doc(_auth.currentUser!.email).get();
      // Map<String, dynamic>? currTaskerData = currTaskerDoc.data() as Map<String, dynamic>;

      String location = locationController.text;
      String askingRate = askingRateController.text;
      String experience = expController.text;

      // Future<Map<String, dynamic>?> currTaskerData = getCurrTaskerData(_auth.currentUser!.email);
          Map<String, dynamic>? currTaskerData = await getCurrTaskerData(_auth.currentUser!.email);


      // Check if all required fields are filled in
      if (location.isNotEmpty && askingRate.isNotEmpty && experience.isNotEmpty && skills.isNotEmpty) {
        _firestore.collection('Signed Up Tasks').doc(widget.taskCategory.name).set({
          'email': _auth.currentUser!.email,
          'first name': currTaskerData?['first name'],
          'last name': currTaskerData?['last name'],
          'location': location,
          'askingRate': askingRate,
          'experience': experience,
          'skills': skills,
        }).then((value) {
          print('Task added successfully!');
          // Clear the text fields after adding the task
          locationController.clear();
          askingRateController.clear();
          expController.clear();
          setState(() {
            skills.clear(); // Clear the skills list
          });
        }).catchError((error) {
          print('Error adding task: $error');
        });
      } else {
        // Display an error message indicating that all fields are required
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Please fill in all required fields.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch(error) {
      print('Error submitting task: $error');
    }
  }

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
        child: SingleChildScrollView(
          child: Column(
            children: [
              // get the user's address info
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Enter address you'll work around",
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
                  controller: locationController,
                  decoration: InputDecoration(
                    labelText: 'Address',
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
              // ask the user for the asking rate
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "What is your asking rate?",
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
                  SizedBox(
                    width: 180,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        controller: askingRateController,
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
                ],
              ),
              SizedBox(height: 10),
              // Ask and retrieve the user's experience
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "How many experience?",
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
                  SizedBox(
                    width: 180,
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
                  Container(
                    // padding: EdgeInsets.only(right: 20.0),
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: dropdownValue,
                        icon: Icon(Icons.arrow_drop_down, color: Colors.black,),
                        iconSize: 30,
                        elevation: 16,
                        style: TextStyle(color: Colors.black),
                        dropdownColor: Colors.white,
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue = newValue!;
                          });
                        },
                        items: <String>['Years', 'Months', 'Weeks']
                        .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(value, style: TextStyle(color: Colors.black)),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              // skills section where users can input their skills
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
                      SizedBox(height: 10),
                      Container(
                        height: 300,
                        width: 300,
                        decoration: BoxDecoration(color: Colors.green[400], borderRadius: BorderRadius.circular(10)),
                        // color: Colors.green[400],
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20,top: 0,),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: skills.length + 1, // +1 for the initial empty text field
                            itemBuilder: (context, index) {
                              if (index == skills.length) {
                                // Add button to add more skills
                                return Column(
                                  children: [
                                    SizedBox(
                                      width: 50,
                                      child: IconButton(
                                        icon: Icon(Icons.add_circle),
                                        color: Colors.white,
                                        onPressed: () {
                                          setState(() {
                                            skills.add('');
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              }
                              return Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: TextFormField(
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
                                        onChanged: (value) {
                                          setState(() {
                                            skills[index] = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.remove_circle),
                                    color: Colors.white,
                                    onPressed: () {
                                      setState(() {
                                        skills.removeAt(index);
                                      });
                                    },
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitTaskSignUp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[800],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15),
                  child: Text("Submit", style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}