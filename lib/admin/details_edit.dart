import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailsEdit extends StatefulWidget {
  final String index;

  DetailsEdit({required this.index});

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsEdit> {
  final CollectionReference spots = FirebaseFirestore.instance.collection('spots');

  // Define TextEditingControllers for each attribute
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  Future<void> updateData() async {
    await spots.doc(widget.index).update({
      'name': nameController.text,
      'description': descriptionController.text,
      'date': dateController.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: spots.doc(widget.index).get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(child: Text("Error: ${snapshot.error}")),
            );
          }

          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;

          Uint8List getImageBytes(String key) {
            String base64String = data[key];
            String base64Image = base64String.split(",")[1];
            return base64Decode(base64Image);
          }

          // Initialize TextEditingControllers with fetched data
          nameController.text = data['name'] ?? '';
          descriptionController.text = data['description'] ?? '';
          dateController.text = data['date'] ?? '';

          return Scaffold(
            appBar: AppBar(
              leading: const CircleAvatar(
                radius: 1,
                backgroundColor: Color.fromARGB(143, 2, 141, 187),
                child: Icon(Icons.arrow_back, color: Colors.white, size: 20),
              ),
              title: Text('Edit Details'),
              centerTitle: true,
              backgroundColor: Colors.white,
              elevation: 0,
              actions: [
                IconButton(
                  icon: Icon(Icons.save),
                  onPressed: () async {
                    await updateData();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Saved Successfully')),
                    );
                  },
                )
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Your image and other UI remains here ...

                    SizedBox(height: 20),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: "Name",
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        labelText: "Description",
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: dateController,
                      decoration: InputDecoration(
                        labelText: "Date",
                      ),
                    ),
                    // ... Continue with your remaining UI
                  ],
                ),
              ),
            ),
          );
        }

        return Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
