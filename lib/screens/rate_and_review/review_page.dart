import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:tasklocal/screens/rate_and_review/review_card.dart';

class ReviewsPage extends StatefulWidget {
  final String taskerEmail;

  const ReviewsPage({Key? key, required this.taskerEmail}) : super(key: key);

  @override
  _ReviewsPageState createState() => _ReviewsPageState();
}


class _ReviewsPageState extends State<ReviewsPage> {
  
  // build layout
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Review'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // gather the taskers info since we'll be using it for displaying the reviews
            FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection('Taskers').doc(widget.taskerEmail).get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                var taskerData = snapshot.data?.data() as Map<String, dynamic>?;
                if (taskerData == null) {
                  return Text("Tasker not found");
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 16),
                    // display the taskers avatar
                    CircleAvatar(
                      backgroundImage: NetworkImage(taskerData['profile picture'] ?? 'https://firebasestorage.googleapis.com/v0/b/authtutorial-a4202.appspot.com/o/profilepictures%2Ftasklocaltransparent.png?alt=media&token=31e20dcc-4b9a-41cb-85ed-bc82166ac836'),
                      radius: 50,
                    ),
                    SizedBox(height: 8),
                    // display the taskers username
                    Text(taskerData['username'] ?? 'Username', style: TextStyle(fontSize: 24)),
                    // get the taskers review information
                    FutureBuilder<QuerySnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('Taskers')
                          .doc(widget.taskerEmail)
                          .collection('Reviews')
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }
                        final reviews = snapshot.data?.docs ?? [];
                        // if couldn't find data
                        if (reviews.isEmpty) {
                          return Text("Overall Rating: N/A");
                        }
                        // create double to store overall rating for tasker
                        double overallRating = 0;
                        for (var review in reviews) {
                          overallRating += (review.data() as Map<String, dynamic>)['rating'];
                        }
                        double averageRating = overallRating / reviews.length;

                        return Column(
                          children: [
                            // display the taskers overall rating
                            Text("Overall Rating: ${averageRating.toStringAsFixed(1)}"),
                            // use flutter rating bar API
                            RatingBarIndicator(
                              rating: averageRating,
                              itemBuilder: (context, index) => Icon(Icons.star, color: Colors.amber),
                              itemCount: 5,
                              itemSize: 20.0,
                              direction: Axis.horizontal,
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                );
              },
            ),
            // get the customer reviews to see if theres data
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Taskers')
                  .doc(widget.taskerEmail)
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
                // display the review cards
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(), 
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var reviewDoc = snapshot.data!.docs[index];
                    return ReviewCard(review: reviewDoc); 
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}