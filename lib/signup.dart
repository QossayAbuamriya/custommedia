import 'package:custommedia/verification.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'login.dart';

// Define the theme colors
const Color primaryColor = Color.fromARGB(213, 116, 203, 224); // 1. Set to light blue
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

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String _email, _password;
  late bool _isSuccess;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          // Added this widget
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/logo.png',
                  height: 200,
                ), // 3. Added logo
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
                  onPressed: signUp,
                  child: Text('Sign Up'),
                  style: ElevatedButton.styleFrom(
                    primary: primaryColor,
                    onPrimary: secondaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  child: Text('Login'),
                  style: ElevatedButton.styleFrom(
                    primary: primaryColor,
                    onPrimary: secondaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Function to handle user signup
  void signUp() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await _auth.createUserWithEmailAndPassword(
            email: _email, password: _password);
        setState(() {
          _isSuccess = true;
        });

        // Navigate to Verification Page after successful signup
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => EmailVerificationScreen()));
      } catch (e) {
        setState(() {
          _isSuccess = false;
        });
      }
    }
  }
}
