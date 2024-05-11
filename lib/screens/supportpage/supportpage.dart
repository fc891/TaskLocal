import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class SupportPage extends StatefulWidget {
  @override
  _SupportPageState createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  // create controllers to take in the different area fields that the user fills out
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  String _userType = 'Customer'; 
  bool _dropdownIsOpen = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // build layout
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Support', style: GoogleFonts.lato()),
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // top of the page 
                  Text('How can we help you?', style: GoogleFonts.lato(fontSize: 28, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                  SizedBox(height: 20),

                  // take in the user's username
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                      prefixIcon: Icon(Icons.person),
                    ),
                    style: GoogleFonts.lato(),
                  ),
                  SizedBox(height: 20),

                  // take in the type of user 
                  DropdownButtonFormField<String>(
                    value: _userType,
                    decoration: InputDecoration(
                      labelText: 'You are a:',
                      border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        _userType = newValue!;
                        _dropdownIsOpen = false; 
                      });
                    },
                    onTap: () {
                      setState(() {
                        _dropdownIsOpen = !_dropdownIsOpen;
                      });
                    },
                    dropdownColor: Colors.black, 
                    // either a customer or a tasker
                    items: <String>['Customer', 'Tasker']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: GoogleFonts.lato(color: Colors.white)), 
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20),

                  // take in the subject of the message
                  TextField(
                    controller: _subjectController,
                    decoration: InputDecoration(
                      labelText: 'Subject',
                      border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                      prefixIcon: Icon(Icons.subject),
                    ),
                    style: GoogleFonts.lato(),
                  ),
                  SizedBox(height: 20),

                  // take in the message the user wants to send
                  TextField(
                    controller: _bodyController,
                    decoration: InputDecoration(
                      labelText: 'Your Message',
                      border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                      prefixIcon: Icon(Icons.message),
                      alignLabelWithHint: true,
                    ),
                    maxLines: 5,
                    style: GoogleFonts.lato(),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // have a submit button at bottom of page
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            child: ElevatedButton(
              onPressed: submitsupportticket,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF004D40), 
              ),
              child: Text('Submit', style: GoogleFonts.lato(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }

  // create function to send information to the database
  void submitsupportticket() async {
    try {
      await _firestore.collection('Support Requests').add({
        'username': _usernameController.text,
        'userType': _userType,
        'subject': _subjectController.text,
        'message': _bodyController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });
      // clear to clean up space allocation
      _usernameController.clear();
      _subjectController.clear();
      _bodyController.clear();

      // display message at very bottom when submit is successful or not successful
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Request submitted successfully! We\'ll try to get back to you as soon as possible. Thanks for your patience!',
            style: GoogleFonts.lato(fontSize: 16), 
          ),
          duration: Duration(seconds: 5),
        )
      );
    } catch (error) {
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to submit request', style: GoogleFonts.lato())));
    }
  }
}
