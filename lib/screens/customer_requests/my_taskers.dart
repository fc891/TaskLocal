import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyTaskersPage extends StatefulWidget {
  @override
  _MyTaskersPageState createState() => _MyTaskersPageState();
}

class _MyTaskersPageState extends State<MyTaskersPage> {
  // Fetch selected taskers data from Firestore
  Future<List<Map<String, dynamic>>> fetchSelectedTaskers() async {
    // Get the currently logged-in user's email
    String currentUserEmail = FirebaseAuth.instance.currentUser!.email!;
  
    // Query the "Selected Taskers" collection under the current customer's document
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Customers').doc(currentUserEmail).collection('Selected Taskers').get();

    List<Map<String, dynamic>> selectedTaskers = [];
    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic> taskerData = doc.data() as Map<String, dynamic>;
      selectedTaskers.add(taskerData);
    });
    return selectedTaskers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Taskers'),
      ),
      body: FutureBuilder(
        future: fetchSelectedTaskers(),
        builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No selected taskers.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data![index]['name'] ?? ''),
                  subtitle: Text(snapshot.data![index]['description'] ?? ''),
                  // You can customize the display of selected taskers data as per your UI requirements
                );
              },
            );
          }
        },
      ),
    );
  }
}
