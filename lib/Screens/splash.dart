import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../functions/sign_in.dart';
class splash extends StatefulWidget {
  const splash({super.key});

  @override
  State<splash> createState() => splashState();
}
FirebaseAuth _auth = FirebaseAuth.instance;
class splashState extends State<splash> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(seconds: 1), () async {
      await signInCheck();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/ggcsf.png'),
      ),
    );
  }
}
