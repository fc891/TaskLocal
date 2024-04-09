import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class RateandReviewPage extends StatefulWidget {
  final String taskerEmail; 

  const RateandReviewPage({super.key, required this.taskerEmail});

  @override
  _RateandReviewPage createState() => _RateandReviewPage();
}

class _RateandReviewPage extends State<RateandReviewPage> {
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

  // create image selector function
  Future<void> _imageSelector() async {
  // set up the maximum amount images a cutsomer can upload
  const int maxImages = 5;

  // if customer attempts to add more when 5 images are already selected
  if (_images.length >= maxImages) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.green, 
          title: Text(
            'Maximum Images Reached',
            style: TextStyle(color: Colors.white), 
          ),
          content: Text(
            'You can only add up to 5 images.',
            style: TextStyle(color: Colors.white), 
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
              backgroundColor: Colors.green, 
              ),
              child: Text(
                'OK',
                style: TextStyle(color: Colors.white), 
              ),
            ),
          ],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 24.0,
        );
      },
    );
    return; 
  }

  // if customer adds more than 5 images when first selecting images
  final List<XFile>? selectedImages = await _picker.pickMultiImage();
  if (selectedImages != null) {
    if ((_images.length + selectedImages.length) > maxImages) {
      // calculate how many will have to be discarded 
      int availableSlots = maxImages - _images.length;
      // only take 5 of the amount selected
      List<XFile> imagesToAdd = selectedImages.take(availableSlots).toList();

      // add the images to the space
      setState(() {
        _images.addAll(imagesToAdd);
      });

      // output that not all was selected
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.green, 
            title: Text(
              'Image Limit Reached',
              style: TextStyle(color: Colors.white),
            ),
            content: Text(
              'Only $availableSlots of the selected images were added. You can only add up to 5 images.',
            style: TextStyle(color: Colors.white), 
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                backgroundColor: Colors.green, 
                ),
                child: Text(
                  'OK',
                style: TextStyle(color: Colors.white), 
                ),
              ),
            ],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 24.0,
          );
        },
      );
      // if user adds 5 or less
    } else {
      setState(() {
        _images.addAll(selectedImages);
      });
    }
  }
}

// upload images to firebase
Future<List<String>> _imageUpload(List<XFile> images) async {
  List<String> imageUrls = [];

  for (XFile image in images) {
    // create a reference to Firebase Storage
    String fileName = 'reviews/${DateTime.now().millisecondsSinceEpoch}_${image.name}';
    Reference ref = FirebaseStorage.instance.ref().child(fileName);

    // upload the file
    File file = File(image.path);
    UploadTask uploadTask = ref.putFile(file);

    // wait for the upload to complete
    await uploadTask;

    // Get the download URL
    String downloadUrl = await ref.getDownloadURL();
    imageUrls.add(downloadUrl);
  }

  return imageUrls;
}

// display the images
Widget _imageDisplay() {
  return _images.isNotEmpty
      ? StaggeredGridView.countBuilder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          itemCount: _images.length,
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
          staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
        )
      : Text('No images selected', style: TextStyle(color: Color.fromARGB(255, 99, 97, 97)));
}

// get tasker info for username and profile picture display
Future<Map<String, dynamic>?> fetchTaskerInfo(String taskerEmail) async {
  try {
    final DocumentSnapshot taskerDoc = await FirebaseFirestore.instance
        .collection('Taskers') // Make sure this is your correct collection name
        .doc(taskerEmail)
        .get();

    if (taskerDoc.exists) {
      return taskerDoc.data() as Map<String, dynamic>?;
    } else {
      print("No document found for $taskerEmail");
      return null;
    }
  } catch (e) {
    print("Error fetching tasker info: $e");
    return null;
  }
}

// get customer info as well to know who created the review
Future<Map<String, dynamic>?> fetchCustomerInfo(String customerEmail) async {
  try {
    final DocumentSnapshot customerDoc = await FirebaseFirestore.instance
        .collection('Customers')
        .doc(customerEmail)
        .get();

    if (customerDoc.exists) {
      return customerDoc.data() as Map<String, dynamic>?;
    } else {
      print("No document found for $customerEmail");
      return null;
    }
  } catch (e) {
    print("Error fetching customer info: $e");
    return null;
  }
}

// submit button to store information
Future<void> _submitReview() async {
  if (!mounted) return;
  setState(() {
    // set loading wheel so user knows information is loading
    _isLoading = true; 
  });

  // if info is left blank 
  if (_taskTypeController.text.isEmpty || _rating == 0 || _reviewController.text.isEmpty) {
    setState(() {
      _isLoading = false; 
    });
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.green,
        title: Text('Missing Information', style: TextStyle(color: Colors.white)),
        content: Text('Please make sure all areas of field are filled out.', style: TextStyle(color: Colors.white)),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK', style: TextStyle(color: Colors.white)),
            style: TextButton.styleFrom(foregroundColor: Colors.white, backgroundColor: Colors.green),
          ),
        ],
      ),
    );
    return;
  }

  // make sure the customer is logged in so we know who wrote the review
  final User? user = FirebaseAuth.instance.currentUser;
  if (user == null || user.email == null) {
    setState(() => _isLoading = false);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.green,
        title: Text('Error', style: TextStyle(color: Colors.white)),
        content: Text('You must be logged in to submit a review.', style: TextStyle(color: Colors.white)),
        actions: <Widget>[
          TextButton(
            child: Text('OK', style: TextStyle(color: Colors.white)),
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(foregroundColor: Colors.white, backgroundColor: Colors.green),
          ),
        ],
      ),
    );
    return;
  }

// if customer information can't be accessed or isn't correct
  Map<String, dynamic>? customerInfo = await fetchCustomerInfo(user.email!);
  if (customerInfo == null) {
    setState(() => _isLoading = false);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.green,
        title: Text('Error', style: TextStyle(color: Colors.white)),
        content: Text('Could not load your information. Try Again or Relog.', style: TextStyle(color: Colors.white)),
        actions: <Widget>[
          TextButton(
            child: Text('OK', style: TextStyle(color: Colors.white)),
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(foregroundColor: Colors.white, backgroundColor: Colors.green),
          ),
        ],
      ),
    );
    return;
  }

  // gather the images
  List<String> imageUrls = [];
  try {
    imageUrls = await _imageUpload(_images); 

    // gather the output for the review as well as the customers info for later display
    final reviewData = {
      "taskType": _taskTypeController.text,
      "rating": _rating,
      "reviewText": _reviewController.text,
      "imageUrls": imageUrls,
      "createdAt": FieldValue.serverTimestamp(),
      "customerEmail": user.email,
      "customerFirstName": customerInfo["first name"],
      "customerLastName": customerInfo["last name"],
      "customerProfilePicture": customerInfo["profile picture"],
      "customerUsername": customerInfo["username"],
    };

    await FirebaseFirestore.instance
        .collection('Taskers')
        .doc(widget.taskerEmail)
        .collection('Reviews')
        .add(reviewData);

    // pop out for when submission has gone through and worked correctly
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
  } catch (e) {
    // if error when submitting
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.green,
        title: Text('Error', style: TextStyle(color: Colors.white)),
        content: Text('Error occured when attempting to submit. Try Again.', style: TextStyle(color: Colors.white)),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(backgroundColor: Colors.red),
            child: Text('OK', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    // turn off when finished
  } finally {
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }
}

  // build layout
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
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // display tasker username and profile picture
                  FutureBuilder<Map<String, dynamic>?>(
                    // get tasker info
                    future: fetchTaskerInfo(widget.taskerEmail), 
                    builder: (context, snapshot) {
                      // if information is still loading 
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasData) {
                        Map<String, dynamic>? taskerInfo = snapshot.data;
                        return Row(
                          children: [
                            CircleAvatar(
                              // display profile picture of default pfp if none
                              backgroundImage: NetworkImage(taskerInfo?["profile picture"] ?? 'https://firebasestorage.googleapis.com/v0/b/authtutorial-a4202.appspot.com/o/profilepictures%2Ftasklocaltransparent.png?alt=media&token=31e20dcc-4b9a-41cb-85ed-bc82166ac836'), 
                              radius: 30, 
                              child: taskerInfo?["profile picture"] == null ? Icon(Icons.person) : null,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                taskerInfo?["username"] ?? "Unknown", 
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(fontSize: 18),
                                ),
                              ),
                            )
                          ],
                        );
                      } else {
                        // if information can't be found or identified
                        return Text("Tasker information not available");
                      }
                    },
                  ),
                  SizedBox(height: 32),
            
            // Task Performed
            Text('Task Completed', style: GoogleFonts.lato(textStyle: Theme.of(context).textTheme.titleLarge)),
            SizedBox(height: 8),
            // Inputbox 
            TextFormField(
              controller: _taskTypeController,
              style: TextStyle(
                color: Colors.black,
              ),
              decoration: InputDecoration(
                hintText: "Enter the type of task", 
                hintStyle: GoogleFonts.lato(),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 24),

            // Star Rating
            Text('Your Rating', style: GoogleFonts.lato(textStyle: Theme.of(context).textTheme.titleLarge)),
            SizedBox(height: 8),
            // Implement rating bar
            RatingBar.builder(
              initialRating: _rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(Icons.star, color: Colors.yellow),
              onRatingUpdate: (rating) {
                setState(() {
                  _rating = rating;
                });
              },
            ),
            SizedBox(height: 24),

            // Write Review
            Text('Your Review', style: GoogleFonts.lato(textStyle: Theme.of(context).textTheme.titleLarge)),
            SizedBox(height: 8),
            // Inputbox
            TextFormField(
              controller: _reviewController,
              style: TextStyle(
                color: Colors.black,
              ),
              decoration: InputDecoration(
                hintText: "Write about your Experience", 
                hintStyle: GoogleFonts.lato(),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              maxLines: 4,
              textInputAction: TextInputAction.done, 
              onFieldSubmitted: (value) {
                FocusScope.of(context).unfocus(); 
              },
            ),
            SizedBox(height: 24),

            // Upload Images
            Text('Upload Images', style: GoogleFonts.lato(textStyle: Theme.of(context).textTheme.titleLarge)),
            SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _imageSelector,
              icon: Icon(Icons.add_a_photo),
              label: Text(
                "Add Images",
                style: GoogleFonts.lato(), // Apply Lato font here
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 22, 56, 23),
                textStyle: GoogleFonts.lato(), // Optionally, apply Lato font to all text within the button
              ),
            ),
            SizedBox(height: 8),
            _imageDisplay(),
            SizedBox(height: 65),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitReview,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 22, 56, 23),
                  padding: EdgeInsets.symmetric(vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                ),
                child: Text('Submit Review', style: GoogleFonts.lato()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}