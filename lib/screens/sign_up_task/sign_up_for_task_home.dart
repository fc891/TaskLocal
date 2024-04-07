// Contributors: Richard N.

import 'package:flutter/material.dart';
import 'package:tasklocal/screens/home_pages/task_category.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class SignUpForTaskHome extends StatefulWidget {
  final TaskCategory taskCategory;
  const SignUpForTaskHome({super.key, required this.taskCategory});

  @override
  State<SignUpForTaskHome> createState() => _SignUpForTaskHomeState();
}

class _SignUpForTaskHomeState extends State<SignUpForTaskHome> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // controllers for getting the input of the user
  final locationController = TextEditingController();
  final askingRateController = TextEditingController();
  final expController = TextEditingController();
  final expController2 = TextEditingController();
  // initalize variables for getting user data
  String typeOfLength = 'Years'; 
  List<String> skills = [];

  // retrieve the data of the current signed user
  Future<Map<String, dynamic>?> getTaskerData(String? email) async {
    try {
      DocumentSnapshot taskerDoc = await _firestore.collection('Taskers').doc(email).get();
      // checks to see if the tasker is stored in collection Taskers
      if (taskerDoc.exists) {
        return taskerDoc.data() as Map<String, dynamic>;
      } else {
        // print('The tasker does not exist');
        return null;
      }
    } catch (e) {
      // any conflicts with retrieving data goes here
      // print('There was an error retrieving data: $e');
      return null;
    }
  }
  
  // when user presses the submit button, stores all the inputs of the user to the db
  void _submitTaskSignUp() async {
    // provide some dialog when user hasn't enter any info
    BuildContext? dialogContext;
    try {
      // store user's input into the variables
      String location = locationController.text;
      String askingRate = askingRateController.text;
      String experience = expController.text;
      // stores the amount of experience with the type of length, so it doesn't get displayed in the UI
      String experience2 = expController2.text;

      Map<String, dynamic>? currTaskerData = await getTaskerData(_auth.currentUser!.email);

      final taskCategoryDoc = _firestore.collection('Task Categories').doc(widget.taskCategory.name);
      // create dummy values so document is actually created and stored in db
      taskCategoryDoc.set({'dummy': 'dummy'});
      // for public knowledge when customer wants to hire tasker
      final currTaskerDoc = taskCategoryDoc.collection('Signed Up Taskers').doc(_auth.currentUser!.email);
      // for individual purposes
      final currTaskerDoc2 = _firestore.collection('Taskers').doc(_auth.currentUser!.email).collection('Signed Up Tasks').doc(widget.taskCategory.name);

      // Check if all required fields are filled in
      if (location.isNotEmpty && askingRate.isNotEmpty && experience.isNotEmpty && skills.isNotEmpty) {
        // store all info in the Task Categories collection
        await currTaskerDoc.set({
          'email': _auth.currentUser!.email,
          'first name': currTaskerData?['first name'],
          'last name': currTaskerData?['last name'],
          'location': location,
          'askingRate': askingRate,
          'experience': experience2,
          'skills': skills,
        });
        // store only the task category name since tasker can retrieve the data in Task Categories collection
        // and they sign up once for each Task Category
        await currTaskerDoc2.set({
          'task category': widget.taskCategory.name,
        });
        // print('Task added successfully!');
        // Remove the user's input after submitting
        locationController.clear();
        askingRateController.clear();
        expController.clear();
        setState(() {
          skills.clear();
        });
      } else {
        // Show an error message requiring user to fill in the fields 
        showDialog(
          context: dialogContext ?? context,
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
      // print('Error adding task: $error');
      // Any error that occurs while inputting info is displayed in a dialog box to the user
      showDialog(
        context: dialogContext ?? context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('There was an error when inputting info: $error'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // listens to any changes to the expController values
    expController.addListener(_updateExpController2);
  }

  @override
  void dispose() {
    // prevents memory leaks by removing the listener and controller
    expController.removeListener(_updateExpController2);
    super.dispose();
  }

  // update the expController2 
  void _updateExpController2() {
    setState(() {
      expController2.text = '${expController.text} $typeOfLength';
    });
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
            // Address section
            // instructions for the user to enter their address
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
            // get the user's address info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                controller: locationController,
                style: TextStyle(fontSize: 15),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
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
            // Asking Rate section
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
            // retrieve the amount that was inputted
            Row(
              children: [
                SizedBox(
                  width: 180,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextField(
                      controller: askingRateController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
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
            // Experience section
            // Ask the user's experience
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
            // retrieve the amount of experience that was inputted
            Row(
              children: [
                SizedBox(
                  width: 180,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextField(
                      controller: expController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
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
                  decoration: BoxDecoration(
                    color: Colors.grey[200], 
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.black,
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    // user can select the type of length that corresponds to their amount of experience
                    child: DropdownButton<String>(
                      value: typeOfLength,
                      icon: Icon(Icons.arrow_drop_down, color: Colors.black,),
                      iconSize: 30,
                      elevation: 16,
                      style: TextStyle(color: Colors.black),
                      dropdownColor: Colors.white,
                      onChanged: (String? newValue) {
                        setState(() {
                          typeOfLength = newValue!;
                          // store the amount of experience with typeOfLength
                          expController2.text = '${expController.text} $typeOfLength';
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
            // Skills section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // label allowing users to know what it is
                    Text(
                      "Skills:",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    // starting point where user can input their skills
                    Container(
                      height: 300,
                      width: 300,
                      decoration: BoxDecoration(color: Colors.green[400], borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15, top: 5,),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: skills.length + 1, // allow user to use the add button
                          itemBuilder: (context, index) {
                            if (index == skills.length) {
                              return Column(
                                children: [
                                  SizedBox(
                                    width: 50,
                                    // Add button to add additional form to enter skills
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
                                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                                    // user can type in the skills in the form
                                    child: TextFormField(
                                      style: TextStyle(color: Colors.black),
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
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
                                        // store the skill in the list of skills
                                        setState(() {
                                          skills[index] = value;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                // user can remove the skill
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
            // user submits the info they inputted
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
    );
  }
}