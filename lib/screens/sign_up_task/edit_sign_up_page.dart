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

  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _askingRateController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  List<TextEditingController> _skillControllers = []; // List to hold skill controllers

  @override
  void initState() {
    super.initState();
    // Initialize the text controllers with the task data
    _locationController.text = widget.taskData['location'];
    _askingRateController.text = widget.taskData['askingRate'];
    _experienceController.text = widget.taskData['experience'];
    
    // Initialize the skill controllers with the skills from the task data
    List<dynamic> skills = widget.taskData['skills'];
    for (var skill in skills) {
      _skillControllers.add(TextEditingController(text: skill));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Task'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _locationController,
              decoration: InputDecoration(labelText: 'Location'),
            ),
            TextFormField(
              controller: _askingRateController,
              decoration: InputDecoration(labelText: 'Asking Rate'),
            ),
            TextFormField(
              controller: _experienceController,
              decoration: InputDecoration(labelText: 'Experience'),
            ),
            SizedBox(height: 10),
            Text('Skills', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Expanded(
              child: ListView.builder(
                itemCount: _skillControllers.length,
                itemBuilder: (context, index) {
                  return TextFormField(
                    controller: _skillControllers[index],
                    decoration: InputDecoration(labelText: 'Skill ${index + 1}'),
                  );
                },
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

  void _updateTaskInformation() {
    // Extract the skills from the controllers
    List<String> updatedSkills = [];
    for (var controller in _skillControllers) {
      updatedSkills.add(controller.text);
    }

    _firestore.collection('Task Categories').doc(widget.categoryName)
        .collection('Signed Up Taskers')
        .doc(_auth.currentUser!.email)
        .update({
      'location': _locationController.text,
      'askingRate': _askingRateController.text,
      'experience': _experienceController.text,
      'skills': updatedSkills,
    }).then((_) {
      Navigator.pop(context, true);
    }).catchError((error) {
      print('Error updating task information: $error');
    });
  }
}