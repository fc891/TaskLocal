import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PostDiscussionTopic extends StatefulWidget {
  const PostDiscussionTopic({super.key});

  @override
  State<PostDiscussionTopic> createState() => _PostDiscussionTopicState();
}

class _PostDiscussionTopicState extends State<PostDiscussionTopic> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _selectedCategory;
  final topicTitleController = TextEditingController();
  final textController = TextEditingController();

  // when user presses the submit button, stores all the inputs of the user to the db
  void _submitPost() async {
    // provide some dialog when user hasn't enter any info
    BuildContext? dialogContext;
    try {
      // store user's input into the variables
      String topicTitle = topicTitleController.text;
      String text = textController.text;

      // access the tasker's document
      final taskerDoc = _firestore.collection('Tasker Discussion Board').doc(_auth.currentUser!.email);
      // create dummy values so document is actually created and stored in db
      taskerDoc.set({'dummy': 'dummy'});
      // for public knowledge, go to the tasker's collection of posted discussion
      final postedTopicDoc = taskerDoc.collection('Posted Topics').doc('${_auth.currentUser!.email}_${DateTime.now().toString()}');
      // for individual purposes
      final postedTopicDoc2 = _firestore.collection('Taskers').doc(_auth.currentUser!.email).collection('Posted Topics').doc('${_auth.currentUser!.email}_${DateTime.now().toString()}');

      // Check if all required fields are filled in
      if (_selectedCategory != null && topicTitle.isNotEmpty && text.isNotEmpty) {
        // store all info in the Task Categories collection
        await postedTopicDoc.set({
          'task category': _selectedCategory,
          'topic title': topicTitle,
          'text': text,
        });
        await postedTopicDoc2.set({
          'location of posted topic': '${_auth.currentUser!.email}_${DateTime.now().toString()}',
          'task category': _selectedCategory,
          'topic title': topicTitle,
        });
        // Remove the user's input after submitting
        topicTitleController.clear();
        textController.clear();
        setState(() {
          _selectedCategory = null;
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

  // prevents memory leaks
  @override
  void dispose() {
    topicTitleController.dispose();
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color unselectedBorderColor = Theme.of(context).colorScheme.primary;
    Color selectedBorderColor = Theme.of(context).colorScheme.secondary;
    return Scaffold(
      appBar: AppBar(
        title: Text("Post Discussion Topic"),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: false,
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
                  menuMaxHeight: 350,
                  icon: Icon(Icons.arrow_drop_down, color: Colors.white,),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Task Category',
                    hintStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
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
                    'Gardening Projects'
                    'Music Productions',
                    'Fitness Training',
                    'Organization',
                    'Wall Repair',
                    'Smart Home Intallation'
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
              controller: topicTitleController,
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
              height: 300,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.tertiary,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Theme.of(context).colorScheme.secondary,
                  width: 1,
                ),
              ),
              child: TextField(
                controller: textController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: 'Text',
                  hintStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(10),
                ),
              ),
            ),
          ),
          SizedBox(height: 40),
          ElevatedButton(
            onPressed: _submitPost,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.tertiary,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15),
              child: Text("Submit"),
            ),
          ),
        ],
      ),
    );
  }
}