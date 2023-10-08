import 'package:custommedia/common/login.dart';
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
    borderSide: BorderSide(color: Color.fromARGB(255, 159, 168, 218), width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

class EmailVerificationScreen extends StatefulWidget {
  @override
  _EmailVerificationScreenState createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify Email'),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
         child: Center(
        child: Column(
          
          crossAxisAlignment : CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          
          children: [
            Image.asset('assets/logo.png', height: 200,), // Logo
            Text("TRAVEL APP",
                    style: TextStyle(
                      color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold
                    )),
                SizedBox(height: 10.0),
            Text('Please verify your email to continue.'),
            SizedBox(height: 20.0),
            ElevatedButton(
              child: Text('Resend Verification Email'),
              onPressed: () async {
                User user = _auth.currentUser!;
                if (!user.emailVerified) {
                  await user.sendEmailVerification();
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Verification email sent!')));
                }
              },
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
              child: Text('Check Verification Status'),
              onPressed: () async {
                User user = _auth.currentUser!;
                await user.reload();
                if (user.emailVerified) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Email verified!')));
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Email not yet verified!')));
                }
              },
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
      )
    );
  }
}
