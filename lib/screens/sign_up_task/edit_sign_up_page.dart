// Contributors: Richard N.

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditSignUpPage extends StatefulWidget {
  final DocumentSnapshot taskData;
  final String categoryName;

  const EditSignUpPage({super.key, required this.taskData, required this.categoryName});

  @override
  State<EditSignUpPage> createState() => _EditSignUpPageState();
}

class _EditSignUpPageState extends State<EditSignUpPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final locationController = TextEditingController();
  final askingRateController = TextEditingController();
  final expController = TextEditingController();
  final List<TextEditingController> skillControllers = [];
  String typeOfLength = 'Years'; 

  @override
  void initState() {
    super.initState();
    // Initialize the required fields with data
    locationController.text = widget.taskData['location'];
    askingRateController.text = widget.taskData['askingRate'];
    
    // Split the experience data into amount and typeOfLength
    List<String> experienceParts = widget.taskData['experience'].split(' ');
    expController.text = experienceParts[0]; // Set the amount
    typeOfLength = experienceParts[1]; // Set the typeOfLength
    
    List<dynamic> skills = widget.taskData['skills'];
    for (var skill in skills) {
      skillControllers.add(TextEditingController(text: skill));
    }
  }

  @override
  Widget build(BuildContext context) {
    Color unselectedBorderColor = Theme.of(context).colorScheme.primary;
    Color selectedBorderColor = Theme.of(context).colorScheme.secondary;

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit ${widget.categoryName}"),
        centerTitle: true,
        //backgroundColor: Colors.green[800],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        // display all the required fields that was stored in the db
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              TextFormField(
                controller: locationController,
                style: TextStyle(fontSize: 15),
                decoration: InputDecoration(
                  labelText: 'Location',
                  labelStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: selectedBorderColor),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: unselectedBorderColor), 
                    borderRadius: BorderRadius.circular(10)
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.tertiary,
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 180,
                child: TextFormField(
                  controller: askingRateController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Asking Rate',
                    labelStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                    focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: selectedBorderColor),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: unselectedBorderColor), 
                    borderRadius: BorderRadius.circular(10)
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  SizedBox(
                    width: 180,
                    child: TextFormField(
                      controller: expController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Experience',
                        labelStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: selectedBorderColor),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: unselectedBorderColor), 
                          borderRadius: BorderRadius.circular(10)
                        ),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.tertiary, 
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.white,
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: typeOfLength,
                        icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                        iconSize: 30,
                        elevation: 16,
                        style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
                        dropdownColor: Theme.of(context).colorScheme.tertiary,
                        onChanged: (String? newValue) {
                          setState(() {
                            typeOfLength = newValue!;
                          });
                        },
                        items: <String>['Years', 'Months', 'Weeks']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(value, style: TextStyle(color: Colors.white)),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
              // SizedBox(height: 15),
              // Text('Skills', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 15),
              Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 12, top: 8),
                  child: ListView.builder(
                    itemCount: skillControllers.length + 1,
                    itemBuilder: (context, index) {
                      if (index == skillControllers.length) {
                        // Add button to add more skills
                        return IconButton(
                          icon: Icon(Icons.add_circle, color: Colors.white),
                          onPressed: () {
                            setState(() {
                              skillControllers.add(TextEditingController());
                            });
                          },
                        );
                      }
                      return Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: TextFormField(
                                controller: skillControllers[index],
                                decoration: InputDecoration(
                                  labelText: 'Skill ${index + 1}',
                                  labelStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                                  border: OutlineInputBorder(),
                                  filled: true,
                                  fillColor: Theme.of(context).colorScheme.tertiary,
                                ),
                              ),
                            ),
                          ),
                          // Add a button to remove the skill
                          IconButton(
                            icon: Icon(Icons.remove_circle, color: Colors.white),
                            onPressed: () {
                              setState(() {
                                skillControllers.removeAt(index);
                              });
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: _updateTaskInformation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.tertiary,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 15),
                    child: Text("Save Changes", style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  // submits the changes the user made to be stored in the db
  void _updateTaskInformation() {
    List<String> updatedSkills = [];
    for (var controller in skillControllers) {
      updatedSkills.add(controller.text);
    }

    _firestore.collection('Task Categories').doc(widget.categoryName)
        .collection('Signed Up Taskers').doc(_auth.currentUser!.email)
        .update({
      'location': locationController.text,
      'askingRate': askingRateController.text,
      'experience': '${expController.text} $typeOfLength',
      'skills': updatedSkills,
    }).then((_) {
      Navigator.pop(context, true);
    }).catchError((error) {
      print('Error updating task information: $error');
    });
  }
}