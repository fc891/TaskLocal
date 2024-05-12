import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:tasklocal/screens/rateandreview/review_card.dart';

// create class for review page
class ReviewsPage extends StatefulWidget {
  final String taskerEmail;  

  const ReviewsPage({Key? key, required this.taskerEmail}) : super(key: key);

  @override
  _ReviewsPageState createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {

  // build overlay
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reviews for Tasker'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // determine tasker by email
            FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection('Taskers').where('email', isEqualTo: widget.taskerEmail).limit(1).get().then((snapshot) => snapshot.docs.first),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (!snapshot.hasData || snapshot.data!.data() == null) {
                  return Text("Tasker not found");
                }
                var taskerData = snapshot.data!.data() as Map<String, dynamic>;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 16),
                    // display profile picture
                    CircleAvatar(
                      backgroundImage: NetworkImage(taskerData['profile picture'] ?? 'https://yourdefaultimageurl.com/default.png'),
                      radius: 50,
                    ),
                    SizedBox(height: 8),

                    // display tasker's username
                    Text(taskerData['username'] ?? 'Username', style: TextStyle(fontSize: 24)), 
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('Taskers')
                          .doc(snapshot.data!.id)
                          .collection('Reviews')
                          .orderBy('createdAt', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Text("No reviews yet");
                        }
                        // calculate overall rating
                        double overallRating = 0;
                        snapshot.data!.docs.forEach((doc) {
                          overallRating += (doc.data() as Map<String, dynamic>)['rating'];
                        });
                        double averageRating = overallRating / snapshot.data!.docs.length;
                        return Column(
                          children: [
                            // display overall rating
                            Text("Overall Rating: ${averageRating.toStringAsFixed(1)}"),
                            RatingBarIndicator(
                              rating: averageRating,
                              itemBuilder: (context, index) => Icon(Icons.star, color: Colors.amber),
                              itemCount: 5,
                              itemSize: 20.0,
                              direction: Axis.horizontal,
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                var reviewDoc = snapshot.data!.docs[index];
                                return ReviewCard(review: reviewDoc);
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
