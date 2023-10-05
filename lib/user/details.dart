// detail_page.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailsPage extends StatelessWidget {
  final String index;

  DetailsPage({required this.index});

  // Get a reference to the Firestore collection
  final CollectionReference spots = FirebaseFirestore.instance.collection('spots');

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      // Use the index to fetch the document from Firestore
      future: spots.doc(index).get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(child: Text("Error: ${snapshot.error}")),
            );
          }

          // Extract the data from the document snapshot
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            appBar: AppBar(
              title: Text(data['name'] ?? 'No Name'),
              backgroundColor: Colors.deepPurpleAccent,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Name: ${data['name']}'),
                  SizedBox(height: 20.0),
                  Text('Pic: ${data['pic']}'),
                ],
              ),
            ),
          );
        }

        // Show a loading indicator while waiting for the data
        return Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
