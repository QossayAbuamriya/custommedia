import 'package:custommedia/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      appBar: AppBar(title: Text('Verify Email')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Please verify your email to continue.'),
          ),
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
          ),
          ElevatedButton(
            child: Text('Check Verification Status'),
            onPressed: () async {
              User user = _auth.currentUser!;
              await user.reload();
              if (user.emailVerified) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Email not yet verified!')));
              }
            },
          )
        ],
      ),
    );
  }
}
