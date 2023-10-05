import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  List<Map<dynamic, dynamic>> items = [];

  @override
  void initState() {
    super.initState();
    fetchMenuItems();
  }

  Future<void> fetchMenuItems() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref().child('spot');

    try {
      DataSnapshot snap = (await ref.once()) as DataSnapshot;

      if (snap.value is Map<dynamic, dynamic>) {
        Map<dynamic, dynamic> rawData = snap.value as Map<dynamic, dynamic>;
        rawData.forEach((key, value) {
          items.add(value as Map<dynamic, dynamic>);
        });
        setState(() {});
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Custommedia travel app"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('spot').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          // Handle error state
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }

          // Loading state
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final document = snapshot.data!.docs[index];
              // Access fields safely
              final text = document.get('spot1') ?? 'N/A';
              return Container(
                child: Center(child: Text(text['name'])),
              );
            },
          );
        },
      ),
    );
  }
}
