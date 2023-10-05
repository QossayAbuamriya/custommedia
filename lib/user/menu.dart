import 'dart:convert';
import 'dart:typed_data';

import 'package:custommedia/user/details.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SpotsList extends StatefulWidget {
  @override
  _SpotsListState createState() => _SpotsListState();
}

class _SpotsListState extends State<SpotsList> {


  // document IDS
  List<String> docIDs = [];

  // get docIDS
  Future getDocId() async {
    await FirebaseFirestore.instance
        .collection('spots')
        .get()
        .then((snapshot) => snapshot.docs.forEach(
              (document) {
                print(document.reference);
                docIDs.add(document.reference.id);
              },
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Spots List"),
        backgroundColor: Color.fromARGB(143, 2, 141, 187),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
                child: FutureBuilder(
              future: getDocId(),
              builder: ((context, snapshot) {
                return ListView.builder(
                  itemCount: docIDs.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DetailsPage(index: docIDs[index],)),
                        );
                      },
                      child: Card(
                        elevation: 5,
                        child: ListTile(
                          title: GetData(documentId: docIDs[index]),
                        ),
                      ),
                    );
                  },
                );
              }),
            ))
          ],
        ),
      ),
    );
  }
}

class GetData extends StatelessWidget {
  final String documentId;

  GetData({required this.documentId});

  @override
  Widget build(BuildContext context) {
    // get the collection
    CollectionReference cities = FirebaseFirestore.instance.collection('spots');

    return FutureBuilder<DocumentSnapshot>(
      future: cities.doc(documentId).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;

          // Default to a 'Loading...' image if 'pic' doesn't exist or can't be parsed
          Widget imageWidget = Text('Loading...', style: TextStyle(color: Colors.grey));

          // If 'pic' exists, try to decode and display it
          if (data.containsKey('pic1') && data['pic1'].contains(",")) {
            String base64Image = data['pic1'].split(",")[1];
            Uint8List bytes;
            try {
              bytes = base64Decode(base64Image);
              imageWidget = Image.memory(bytes, fit: BoxFit.cover);  // Displaying the Image
            } catch (e) {
              print("Failed to decode image data: $e");
            }
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              imageWidget,  // Image
              SizedBox(height: 8),  // Space between image and text
              Text('${data['name']}', style: TextStyle(fontWeight: FontWeight.bold))  // Name
            ],
          );

        }
        return Text('Loading..', style: TextStyle(color: Colors.grey));
      }),
    ); // FutureBuilder
  }
}

