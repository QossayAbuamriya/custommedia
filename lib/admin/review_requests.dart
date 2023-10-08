import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminReviewPage extends StatefulWidget {
  @override
  _AdminReviewPageState createState() => _AdminReviewPageState();
}

class _AdminReviewPageState extends State<AdminReviewPage> {
  final requestsRef = FirebaseFirestore.instance.collection('requests');

  // Function to approve a booking request
  Future<void> approveRequest(DocumentSnapshot requestDocument) async {
    await requestsRef.doc(requestDocument.id).update({'status': 'approved'});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Admin Review Page"),
          backgroundColor: Color.fromARGB(213, 116, 203, 224)),
      body: StreamBuilder<QuerySnapshot>(
        stream: requestsRef.where('status', isEqualTo: 'pending').snapshots(),
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
                leading: CircleAvatar(
                  // Add an avatar or image here, for example:
                  // backgroundImage: NetworkImage(request['imageUrl']),
                  child: Icon(Icons
                      .calendar_month_outlined, color: Color.fromARGB(213, 116, 203, 224)), // Or some other placeholder content
                ),
                title: Text("Spot Name: ${request['spotName']}"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("User Id: ${request['userId']}"),
                    Text("Amount Paid: ${request['amount paid']}"),
                  ],
                ),
                isThreeLine: true, // to allow for three lines of text
                trailing: ElevatedButton(
                  onPressed: () => approveRequest(request),
                  child: Text("Approve", style: TextStyle(color: Colors.black)),
                  style: ElevatedButton.styleFrom(
                    surfaceTintColor: Color.fromARGB(213, 116, 203, 224),
                    backgroundColor: Color.fromARGB(213, 116, 203, 224),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
