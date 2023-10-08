import 'dart:convert';
import 'dart:typed_data';

import 'package:custommedia/admin/bookings.dart';
import 'package:custommedia/admin/details_edit.dart';
import 'package:custommedia/admin/review_requests.dart';
import 'package:custommedia/user/details.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const Color primaryColor = Color.fromARGB(213, 116, 203, 224);
const Color secondaryColor = Colors.white;
const Color tertiaryColor = Colors.grey;

class AdminSpotsList extends StatefulWidget {
  @override
  _SpotsListState createState() => _SpotsListState();
}

class _SpotsListState extends State<AdminSpotsList> {
  List<String> docIDs = [];
  int currentIndex = 0; // To keep track of the active page
  List<Widget> pages = [
    AdminSpotsList(), // Assuming you want the same list page as the first page
    AdminReviewPage(), // Assuming you have a separate widget for this
    ApprovedRequestsPage(), // Assuming you have a separate widget for this
  ];

  Future getDocId() async {
    docIDs = [];
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

  Widget _renderAdminSpotsList() {
    return Column(
      children: [
        AppBar(
          title: Text("Spots List"),
          backgroundColor: primaryColor,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal:
                    15.0), // This adds padding on the left and right sides
            child: FutureBuilder(
              future: getDocId(),
              builder: (context, snapshot) {
                return ListView.builder(
                  itemCount: docIDs.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
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
                          surfaceTintColor: Color.fromRGBO(58, 145, 203, 0.98),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 5,
                          child: Container(
                            height: 320,
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
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentIndex == 0
          ? _renderAdminSpotsList()
          : currentIndex == 1
              ? AdminReviewPage() // Assuming you have a separate widget for this
              : ApprovedRequestsPage(), // Assuming you have a separate widget for this
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Menu Edit',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.preview),
            label: 'Review Requests',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Bookings',
          ),
        ],
        backgroundColor: Color.fromARGB(213, 116, 203, 224), // Consistent color
        selectedItemColor: Colors.black,
        unselectedItemColor: tertiaryColor,
      ),
    );
  }
}

class GetData extends StatelessWidget {
  final String documentId;

  GetData({required this.documentId});

  Future<void> _deleteData(String docId) async {
    await FirebaseFirestore.instance.collection('spots').doc(docId).delete();
  }

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
                fallbackHeight: 200,
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
                  child: Image.memory(bytes,
                      fit: BoxFit.cover, width: double.infinity, height: 200),
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
              SizedBox(height: 6),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailsEdit(
                            index: documentId,
                          ),
                        ),
                      );
                    },
                    child:
                        Text("Edit", style: TextStyle(color: Colors.black)),
                    style: ElevatedButton.styleFrom(
                      surfaceTintColor: Color.fromARGB(213, 116, 203, 224),
                      backgroundColor: Color.fromARGB(213, 116, 203, 224),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await _deleteData(documentId);
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Deleted Successfully')));
                    },
                    child:
                        Text("Delete", style: TextStyle(color: Colors.black)),
                    style: ElevatedButton.styleFrom(
                      primary: const Color.fromARGB(255, 227, 100, 91),
                      onPrimary: secondaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        }
        return Text('Loading..', style: TextStyle(color: Colors.grey));
      },
    );
  }
}
