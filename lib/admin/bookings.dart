import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ApprovedRequestsPage extends StatefulWidget {
  @override
  _ApprovedRequestsPageState createState() => _ApprovedRequestsPageState();
}

class _ApprovedRequestsPageState extends State<ApprovedRequestsPage> {
  final requestsRef = FirebaseFirestore.instance.collection('requests');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Approved Requests"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: requestsRef.where('status', isEqualTo: 'approved').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              DocumentSnapshot request = snapshot.data!.docs[index];

              return ListTile(
                title: Text("SpotID: ${request['spotName']}"),
                subtitle: Text("UserID: ${request['userId']}"),
              );
            },
          );
        },
      ),
    );
  }
}
