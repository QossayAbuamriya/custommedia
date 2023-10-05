import 'package:custommedia/user/details.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SpotsList extends StatefulWidget {
  @override
  _SpotsListState createState() => _SpotsListState();
}

class _SpotsListState extends State<SpotsList> {
  final CollectionReference spots =
      FirebaseFirestore.instance.collection('spots');

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
        backgroundColor: Colors.deepPurpleAccent,
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
                          leading: Icon(Icons.location_on, color: Colors.deepPurpleAccent),
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
    CollectionReference users = FirebaseFirestore.instance.collection('spots');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(documentId).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Text('${data['pic']} ' + ' ' + '${data['name']}',
              style: TextStyle(fontWeight: FontWeight.bold));
        }
        return Text('Loading..', style: TextStyle(color: Colors.grey));
      }),
    ); // FutureBuilder
  }
}

