import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ReviewCard extends StatelessWidget {
  final QueryDocumentSnapshot review;

  const ReviewCard({Key? key, required this.review}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> reviewData = review.data() as Map<String, dynamic>;
    List<dynamic> imageUrls = reviewData['imageUrls'] ?? [];

    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // display customer profile picture
                    CircleAvatar(
                      backgroundImage: NetworkImage(reviewData["customerProfilePicture"] ?? 'https://firebasestorage.googleapis.com/v0/b/authtutorial-a4202.appspot.com/o/profilepictures%2Ftasklocaltransparent.png?alt=media&token=31e20dcc-4b9a-41cb-85ed-bc82166ac836'),
                      radius: 20,
                    ),
                    SizedBox(width: 8),

                    // display customer username
                    Text(reviewData['customerUsername'] ?? ['Anonymous'], style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                RatingBarIndicator(
                  rating: reviewData['rating'] ?? 0.0,
                  itemBuilder: (context, index) => Icon(Icons.star, color: Colors.amber),
                  itemCount: 5,
                  itemSize: 20.0,
                  direction: Axis.horizontal,
                ),
              ],
            ),
            SizedBox(height: 8.0),

            // output the task completed
            Text("Task Completed: ${reviewData['taskType'] ?? 'Not specified'}", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8.0),

            // output the customer's message
            Text("Description: ${reviewData['reviewText'] ?? ''}"),
            if (imageUrls.isNotEmpty)
              Container(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: imageUrls.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Image.network(imageUrls[index]),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
