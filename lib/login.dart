import 'package:custommedia/user/menu.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String _email, _password;
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Log In')),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              validator: (input) {
                if (input!.isEmpty) return 'Please type an email';
                return null;
              },
              onSaved: (input) => _email = input!,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextFormField(
              validator: (input) {
                if (input!.length < 6)
                  return 'Your password needs to be at least 6 characters';
                return null;
              },
              onSaved: (input) => _password = input!,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: signIn,
              child: Text('Log In'),
            ),
            Text(
              _errorMessage,
              style: TextStyle(color: Colors.red),
            ),
          ],
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

        // Navigate to next page or show a successful login message here
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MenuPage()));
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

class NextPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Welcome')),
      body: Center(child: Text('Logged in successfully!')),
    );
  }
}
