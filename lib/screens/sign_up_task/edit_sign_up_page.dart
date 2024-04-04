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
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit ${widget.categoryName}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
        centerTitle: true,
        backgroundColor: Colors.green[800],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        // display all the required fields that was stored in the db
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            TextFormField(
              controller: locationController,
              decoration: InputDecoration(
                labelText: 'Location',
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 180,
              child: TextFormField(
                controller: askingRateController,
                decoration: InputDecoration(
                  labelText: 'Asking Rate',
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  border: OutlineInputBorder(),
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
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
                  child: DropdownButton<String>(
                    value: typeOfLength,
                    icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                    iconSize: 30,
                    elevation: 16,
                    style: TextStyle(color: Colors.black),
                    dropdownColor: Colors.white,
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
                          child: Text(value, style: TextStyle(color: Colors.black)),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            Text('Skills', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 15),
            Expanded(
              child: SizedBox(
                width: 300,
                child: ListView.builder(
                  itemCount: skillControllers.length,
                  itemBuilder: (context, index) {
                    return TextFormField(
                      controller: skillControllers[index],
                      decoration: InputDecoration(
                        labelText: 'Skill ${index + 1}',
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                        border: OutlineInputBorder(),
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _updateTaskInformation();
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  // submits the changes the user made to the db
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
      'experience': expController.text,
      'skills': updatedSkills,
    }).then((_) {
      Navigator.pop(context, true);
    }).catchError((error) {
      print('Error updating task information: $error');
    });
  }
}