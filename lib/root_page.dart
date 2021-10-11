import 'package:develop/main_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home.dart';
import 'package:firebase_core/firebase_core.dart';

import 'login_page.dart';


class RootPage extends StatefulWidget {
  RootPage({Key? key}) : super(key: key);

  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  @override

  void handleLogin() {
    print('handleLogin');
    // ログイン画面へ
    Navigator.of(context).pushReplacementNamed("/login_page");
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => MyAuthPage()));
  }
  void handleMain() {
    print('handleMain');
    // ログイン画面へ
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => MainPage()));
  }

  initState() {
    User? user = FirebaseAuth.instance
        .currentUser;
    super.initState();
    new Future.delayed(const Duration(seconds: 1))
        .then((value) => user == null ? handleLogin():handleMain());
  }
  @override
  Widget build(BuildContext context) {
print('build');
    return Scaffold(
      body: Center(
        child: Container(
          child: Text("Loading..."),
        ),
      ),
    );
  }
}