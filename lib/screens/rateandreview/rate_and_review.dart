import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';

class RateandReviewPage extends StatefulWidget {
  const RateandReviewPage({Key? key}) : super(key: key);

  @override
  _RateandReviewPageState createState() => _RateandReviewPageState();
}

class _RateandReviewPageState extends State<RateandReviewPage> {
  // set rating variable
  double _rating = 0;
  // set controllers
  final TextEditingController _reviewController = TextEditingController();
  final TextEditingController _taskTypeController = TextEditingController();
  // set image variable
  final ImagePicker _picker = ImagePicker();
  // create list for images using image picker API
  List<XFile> _images = [];
  // create boolean for submission
  bool _isLoading = false;
  // get user info
  String? selectedTaskerUsername;
  List<String> taskerUsernames = [];
  Map<String, String> taskerUsernameToEmail = {};

  @override
  void initState() {
    super.initState();
    fetchTaskerUsernames();
  }

  // get tasker username to display 
  Future<void> fetchTaskerUsernames() async {
    var snapshot = await FirebaseFirestore.instance.collection('Taskers').get();
    Map<String, String> usernamesToEmails = {};
    snapshot.docs.forEach((doc) {
      String username = doc.data()['username'];
      String email = doc.id; 
      usernamesToEmails[username] = email;
    });
    setState(() {
      taskerUsernameToEmail = usernamesToEmails;
      taskerUsernames = taskerUsernameToEmail.keys.toList();
    });
  }

  // create image selector function
  Future<void> _imageSelector() async {
    const int maxImages = 5;
    final List<XFile>? selectedImages = await _picker.pickMultiImage();
    if (selectedImages != null) {
      if ((_images.length + selectedImages.length) > maxImages) {
        int availableSlots = maxImages - _images.length;
        List<XFile> imagesToAdd = selectedImages.take(availableSlots).toList();
        setState(() {
          _images.addAll(imagesToAdd);
        });
      } else {
        setState(() {
          _images.addAll(selectedImages);
        });
      }
    }
  }

  // create image uploader function
  Future<List<String>> _imageUpload(List<XFile> images) async {
    List<String> imageUrls = [];
    for (XFile image in images) {
      String fileName = 'reviews/${DateTime.now().millisecondsSinceEpoch}_${image.name}';
      Reference ref = FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = ref.putFile(File(image.path));
      await uploadTask;
      String downloadUrl = await ref.getDownloadURL();
      imageUrls.add(downloadUrl);
    }
    return imageUrls;
  }

  // display imges 
  Widget _imageDisplay() {
    return _images.isNotEmpty
        ? GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            itemCount: _images.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return Stack(
                alignment: Alignment.topRight,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(File(_images[index].path), fit: BoxFit.cover),
                  ),
                  IconButton(
                    icon: Icon(Icons.remove_circle, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        _images.removeAt(index);
                      });
                    },
                  ),
                ],
              );
            },
          )
        : Text('No images selected', style: TextStyle(color: Colors.black));
  }

  // create function to submit and store info
  Future<void> _submitReview() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    try {
      if (_taskTypeController.text.isEmpty || _rating == 0 || _reviewController.text.isEmpty) {
        throw ('Please make sure all areas of the field are filled out.');
      }

      List<String> imageUrls = await _imageUpload(_images);
      
      String? customerEmail = FirebaseAuth.instance.currentUser?.email;
      if (customerEmail == null) {
        throw ('User is not authenticated.');
      }
      
      DocumentSnapshot customerSnapshot = await FirebaseFirestore.instance.collection('Customers').doc(customerEmail).get();
      if (!customerSnapshot.exists) {
        throw ('Customer data not found.');
      }
      
      Map<String, dynamic>? customerData = customerSnapshot.data() as Map<String, dynamic>?; 
      if (customerData == null) {
        throw ('Customer data is empty.');
      }

      // customer username and pfp
      String customerUsername = customerData['username'] ?? 'Unknown';
      String customerProfilePic = customerData['profile picture'] ?? 'https://firebasestorage.googleapis.com/v0/b/authtutorial-a4202.appspot.com/o/profilepictures%2Ftasklocaltransparent.png?alt=media&token=31e20dcc-4b9a-41cb-85ed-bc82166ac836'; 

      // get data for all things sent to firebase
      final reviewData = {
        "taskType": _taskTypeController.text,
        "rating": _rating,
        "reviewText": _reviewController.text,
        "imageUrls": imageUrls,
        "createdAt": FieldValue.serverTimestamp(),
        "customerUsername": customerUsername,
        "customerEmail": customerEmail,
        "customerProfilePicture": customerProfilePic, 
      };

      String? selectedTaskerUsername = this.selectedTaskerUsername;
      if (selectedTaskerUsername != null && taskerUsernameToEmail.containsKey(selectedTaskerUsername)) {
        String selectedTaskerEmail = taskerUsernameToEmail[selectedTaskerUsername]!;
        await FirebaseFirestore.instance
            .collection('Taskers')
            .doc(selectedTaskerEmail)
            .collection('Reviews')
            .add(reviewData);
      }

      setState(() {
        _isLoading = false;
      });

      // dialog for after submitting review
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.green,
          title: Text('Review Submitted', style: TextStyle(color: Colors.white)),
          content: Text('Your review has been successfully submitted.', style: TextStyle(color: Colors.white)),
          actions: <Widget>[
            TextButton(
              child: Text('OK', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(foregroundColor: Colors.white, backgroundColor: Colors.green),
            ),
          ],
        ),
      );
  } catch (error) {
    setState(() {
      _isLoading = false;
    });
      // diaglog for error
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.red,
        title: Text('Error', style: TextStyle(color: Colors.white)),
        content: Text(error.toString(), style: TextStyle(color: Colors.white)),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK', style: TextStyle(color: Colors.white)),
            style: TextButton.styleFrom(foregroundColor: Colors.white, backgroundColor: Colors.red),
          ),
        ],
      ),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rate and Review', style: GoogleFonts.lato()),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: DropdownButton<String>(
                      value: selectedTaskerUsername,
                      hint: Text(
                        'Select a Tasker',
                        style: TextStyle(color: Colors.black),
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedTaskerUsername = newValue;
                        });
                      },
                      items: taskerUsernames.map<DropdownMenuItem<String>>((String username) {
                        return DropdownMenuItem<String>(
                          value: username,
                          child: Text(
                            username,
                            style: TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList(),
                      dropdownColor: Colors.white,
                    ),
                  ),
                  SizedBox(height: 32),

                  Text('Task Completed', style: GoogleFonts.lato(color: Colors.black)),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _taskTypeController,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: "Enter the type of task",
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  SizedBox(height: 24),

                  Text('Your Rating', style: GoogleFonts.lato(color: Colors.black)),
                  SizedBox(height: 8),
                  RatingBar.builder(
                    initialRating: _rating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
                    onRatingUpdate: (rating) {
                      setState(() {
                        _rating = rating;
                      });
                    },
                  ),
                  SizedBox(height: 24),

                  Text('Your Review', style: GoogleFonts.lato(color: Colors.black)),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _reviewController,
                    style: TextStyle(color: Colors.black),
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: "Write about your experience",
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  SizedBox(height: 24),

                  ElevatedButton(
                    onPressed: _imageSelector,
                    child: Text('Upload Images'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade700),
                  ),
                  SizedBox(height: 24),

                  _imageDisplay(),
                  SizedBox(height: 24),

                  ElevatedButton(
                    onPressed: _submitReview,
                    child: Text('Submit Review'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade700),
                  ),
                ],
              ),
            ),
    );
  }
}
