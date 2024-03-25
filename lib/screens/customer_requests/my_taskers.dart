import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyTaskersPage extends StatefulWidget {
  @override
  _MyTaskersPageState createState() => _MyTaskersPageState();
}

class _MyTaskersPageState extends State<MyTaskersPage> {
  // fetch selected taskers data from Firestore
  Future<List<Map<String, dynamic>>> fetchSelectedTaskers() async {
    // replace 'selected_taskers' with the actual collection name where the selected taskers data is stored
    // TODO: change collection name
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('selected_taskers').get();
    List<Map<String, dynamic>> selectedTaskers = [];
    querySnapshot.docs.forEach((doc) {
      // ! COMMENTED OUT
      // selectedTaskers.add(doc.data());
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
                  title: Text(snapshot.data![index]['name']),
                  subtitle: Text(snapshot.data![index]['description']),
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
