import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:houseskape/model/user_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;

  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.orange,
          ),
          child: const Padding(
            padding: EdgeInsets.only(left: 80, right: 80, top: 20, bottom: 20),
            child: Text(
              'Login',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
          ),
          onPressed: () {
            signIn();
          },
        ),
      ),
    );
  }

  void signIn() async {
    try {
      await _auth.signInAnonymously().then((uid) => {
            Fluttertoast.showToast(msg: "Login Successful"),
            Navigator.pushReplacementNamed(context, '/menu_screen'),
          });
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case "operation-not-allowed":
          errorMessage = "Anonymous auth hasn't been enabled for this project.";
          break;
        default:
          errorMessage = "An undefined Error happened.";
      }
      Fluttertoast.showToast(msg: errorMessage!);
      // print(error.code);
    }
  }
}
