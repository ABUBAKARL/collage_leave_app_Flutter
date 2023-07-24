import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../functions/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class login_screen extends StatefulWidget {
  const login_screen({super.key});

  @override
  State<login_screen> createState() => _login_screenState();
}

FirebaseAuth _auth = FirebaseAuth.instance;

class _login_screenState extends State<login_screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign in'),
        titleTextStyle: const TextStyle(
          fontFamily: 'ShantellSans',
          fontSize: 20,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: Get.height * .1,
                    ),
                    Container(
                      height: Get.height * .3,
                      width: Get.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        image: const DecorationImage(
                          image: AssetImage('assets/ggcsf.png'),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Get.height * .2,
                    ),
                    InkWell(
                      onTap: () {
                        SignIn().googleSignIn();
                      },
                      child: Container(
                        height: Get.height * .08,
                        width: Get.width * .9,
                        decoration: BoxDecoration(
                          color: Colors.deepOrange[400],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Center(
                          child: Image(
                            width: 30,
                            height: 30,
                            image: AssetImage(
                              'assets/google.png',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
