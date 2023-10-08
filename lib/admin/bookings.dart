import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Define the theme colors
const Color primaryColor = Color.fromARGB(213, 116, 203, 224);
const Color secondaryColor = Colors.white;
const Color tertiaryColor = Colors.grey;

// Updated text field decoration for theme consistency
const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter a value',
  hintStyle: TextStyle(color: tertiaryColor),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: primaryColor, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: primaryColor, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

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
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: StreamBuilder<QuerySnapshot>(
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

                return Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    tileColor: primaryColor.withOpacity(0.2),
                    title: Text(
                      "SpotID: ${request['spotName']}",
                      style: TextStyle(color: Colors.black),
                    ),
                    subtitle: Text(
                      "UserID: ${request['userId']}",
                      style: TextStyle(color: tertiaryColor),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
