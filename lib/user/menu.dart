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
        padding: const EdgeInsets.all(15.0),  // More space from the edges
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: getDocId(),
                builder: (context, snapshot) {
                  return ListView.builder(
                    itemCount: docIDs.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),  // Increase space between tiles
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailsPage(
                                  index: docIDs[index],
                                ),
                              ),
                            );
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 5,
                            child: Container(
                              height: 300,  // Adjust as per your requirements
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GetData(documentId: docIDs[index]),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            )
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
    CollectionReference cities = FirebaseFirestore.instance.collection('spots');

    return FutureBuilder<DocumentSnapshot>(
      future: cities.doc(documentId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          Widget imageWidget = Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Placeholder(
                fallbackHeight: 200,  // Adjust as per your requirements
                fallbackWidth: double.infinity,
                color: Colors.grey,
              ),
            ),
          );

          if (data.containsKey('pic1') && data['pic1'].contains(",")) {
            String base64Image = data['pic1'].split(",")[1];
            Uint8List bytes;
            try {
              bytes = base64Decode(base64Image);
              imageWidget = Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.memory(bytes, fit: BoxFit.cover, width: double.infinity, height: 200),  // Adjust as per your requirements
                ),
              );
            } catch (e) {
              print("Failed to decode image data: $e");
            }
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              imageWidget,
              SizedBox(height: 8),
              Text(
                '${data['name']}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                '${data['date']}',
                style: TextStyle(color: Colors.grey),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          );
        }
        return Text('Loading..', style: TextStyle(color: Colors.grey));
      },
    );
  }
}