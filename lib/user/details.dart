import 'dart:convert';
import 'dart:typed_data';

import 'package:custommedia/checkout.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DetailsPage extends StatelessWidget {
  final String index;

  DetailsPage({required this.index});

  final CollectionReference spots =
      FirebaseFirestore.instance.collection('spots');
  final CollectionReference requests =
      FirebaseFirestore.instance.collection('requests');
  final currentUserId = FirebaseAuth.instance.currentUser!.email;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: spots.doc(index).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(child: Text("Error: ${snapshot.error}")),
            );
          }

          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          Uint8List getImageBytes(String key) {
            String base64String = data[key];
            String base64Image = base64String.split(",")[1];
            return base64Decode(base64Image);
          }

          return FutureBuilder<QuerySnapshot>(
            future: requests
                .where('userId', isEqualTo: currentUserId)
                .where('spotId', isEqualTo: index)
                .get(),
            builder: (context, bookingSnapshot) {
              String buttonText = "Book";
              bool isButtonDisabled = false;

              if (bookingSnapshot.connectionState == ConnectionState.done) {
                if (bookingSnapshot.hasData &&
                    bookingSnapshot.data!.docs.isNotEmpty) {
                  String status =
                      bookingSnapshot.data!.docs.first['status'] ?? "";
                  if (["pending", "approved"].contains(status)) {
                    buttonText = status.capitalize();
                    isButtonDisabled = true;
                  }
                }
              }

              return Scaffold(
                appBar: AppBar(
                  leading: const CircleAvatar(
                    radius: 1, // Reducing the size of the circle
                    backgroundColor: Color.fromARGB(143, 2, 141, 187),
                    child:
                        Icon(Icons.arrow_back, color: Colors.white, size: 20),
                  ),
                  title: Text('Details'),
                  centerTitle: true,
                  backgroundColor: Colors.white,
                  elevation: 0,
                ),
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.memory(getImageBytes('pic1')),
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.memory(
                                getImageBytes('pic2'),
                                width: 150,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 10),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.memory(
                                getImageBytes('pic3'),
                                width: 150,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              data['name'] ?? 'No Name',
                              style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          data['description'] ?? 'No Description',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 50),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              data['date'] ?? 'No Date',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: isButtonDisabled
                                  ? null
                                  : () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CheckoutPage(
                                              spotid: index,
                                              spotName: data['name']),
                                        ),
                                      );
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromARGB(234, 184, 209, 235),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: Text(
                                buttonText,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromARGB(143, 2, 141, 187),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
        return Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
