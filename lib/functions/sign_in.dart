import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import '../Screens/login.dart';
import '../Screens/login_info.dart';
import '../Screens/home.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;
Future<void> signInCheck() async {
  if (_auth.currentUser == null) {
    // If user is not logged in, redirect to login screen
    Get.offAll(() => const login_screen());
  } else {
    // Otherwise, open the userBox to check for user type
    final userBox = await Hive.openBox('users');
    final userType = userBox.get("Auth");

    if (userType == null) {
      // If user type is not defined, redirect to login info screen
      Get.offAll(() => const LoginInfo());
    } else if (userType == "student") {
      Get.off(() => const home(userType: false));
    } else if (userType == "admin") {
      Get.off(() => const home(userType: true));
    } else {
      Get.bottomSheet(
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Sorry you Don't have access to this page or blocked by admin",
                  style: TextStyle(
                    color: Colors.tealAccent[300],
                    fontSize: 25,
                    fontFamily: "ShantellSans",
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: Get.height * 0.1),
            IconButton(
              onPressed: () {
                _auth.signOut();
                GoogleSignIn().signOut();
                Get.back();
                signInCheck();
              },
              icon: Icon(
                Icons.logout_outlined,
                size: 175,
                color: Colors.tealAccent[300],
              ),
            )
          ],
        ),
        backgroundColor: Colors.red,
      );
    }
  }
}

class SignIn {
  Future<void> googleSignIn() async {
    try {
      // Perform Google Sign-In
      final googleSignIn = await GoogleSignIn().signIn();
      final auth = await googleSignIn!.authentication;
      await _auth.signInWithCredential(
        GoogleAuthProvider.credential(
          idToken: auth.idToken,
          accessToken: auth.accessToken,
        ),
      );
      // Check Firestore for user type and store it in userBox
      final userBox = await Hive.openBox('users');
      final teacher = await _firestore
          .collection('admins')
          .doc(_auth.currentUser!.uid)
          .get();
      final student = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get();
      if (teacher.exists) {
        // If user is an admin, set Auth to true in userBox
        userBox.put("Auth", teacher.get("auth") == 0 ? "no_access" : "admin");
      } else if (student.exists) {
        // If user is a regular user, set Auth to false in userBox
        userBox.put(
            "Auth", student.get("allowed") != true ? "no_access" : "student");
      } else {
        // If user is not found in either collection, delete the Auth key from userBox
        userBox.delete("Auth");
      }

      await signInCheck();
      Get.snackbar('Done', 'Sign in successful');
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message!);
    } catch (e) {
      debugPrint(e.toString());
      Get.snackbar('Error', '$e');
    }
  }
}
