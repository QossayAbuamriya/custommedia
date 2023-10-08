import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custommedia/admin/menu_edit.dart';
import 'package:custommedia/user/menu.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    borderSide: BorderSide(color: Colors.indigo, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide:
        BorderSide(color: Color.fromARGB(255, 159, 168, 218), width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late String _email, _password;
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Log In'),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/logo.png', height: 200), // Logo
                SizedBox(height: 10.0),
                TextFormField(
                  validator: (input) {
                    if (input!.isEmpty) return 'Please type an email';
                    return null;
                  },
                  onSaved: (input) => _email = input!,
                  decoration: kTextFieldDecoration.copyWith(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email, color: tertiaryColor),
                  ),
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  validator: (input) {
                    if (input!.length < 6)
                      return 'Your password needs to be at least 6 characters';
                    return null;
                  },
                  onSaved: (input) => _password = input!,
                  decoration: kTextFieldDecoration.copyWith(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock, color: tertiaryColor),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: signIn,
                  child: Text('Log In'),
                  style: ElevatedButton.styleFrom(
                    primary: primaryColor,
                    onPrimary: secondaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void signIn() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await _auth.signInWithEmailAndPassword(
            email: _email, password: _password);

        // After a successful login, retrieve the user role
        DocumentSnapshot userDoc = await _firestore
            .collection('admins')
            .doc(_auth.currentUser!.email)
            .get();
        String userRole;

        if (userDoc.data() != null) {
          userRole =
              (userDoc.data() as Map<String, dynamic>)?['role'] ?? 'user';
        } else {
          userRole = 'user';
        }

        if (userRole == 'admin') {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      AdminSpotsList())); // Assuming MenuEdit is your admin page
        } else {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      SpotsList())); // Menu page for regular users
        }
      } catch (e) {
        if (e is FirebaseAuthException) {
          setState(() {
            _errorMessage = e.message!;
          });
        } else {
          setState(() {
            _errorMessage = e.toString();
          });
        }
      }
    }
  }
}
