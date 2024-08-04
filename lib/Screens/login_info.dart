import 'package:collage_leave_app/Screens/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import '../functions/sign_in.dart';
import '../widgets/flat_switch.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginInfo extends StatefulWidget {
  const LoginInfo({super.key});

  @override
  State<LoginInfo> createState() => _LoginInfoState();
}

class _LoginInfoState extends State<LoginInfo> {
  bool _switch = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _semesterController = TextEditingController();
  final TextEditingController _rollNoController = TextEditingController();
  final GlobalKey<FormState> _nameKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _rollNoKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _semesterKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Give details'),
        titleTextStyle: const TextStyle(
          fontFamily: 'ShantellSans',
          fontSize: 20,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              SizedBox(height: Get.height * .05),
              FlatSwitch(
                switch_: _switch,
                toogle: () {
                  setState(() {
                    _switch = !_switch;
                  });
                },
              ),
              SizedBox(height: Get.height * .1),
              Form(
                key: _nameKey,
                child: TextFormField(
                  validator: (value) => value!.isNotEmpty ? null : 'Invalid input',
                  controller: _nameController,
                  decoration: const InputDecoration(
                    hintText: 'Name',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.deepPurple,
                        width: 8,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: Get.height * .06),
              SizedBox(
                width: Get.width,
                child: Form(
                  key: _rollNoKey,
                  child: TextFormField(
                    validator: (value) => value!.isNotEmpty && value.isNumericOnly ? null : 'Invalid input',
                    controller: _rollNoController,
                    keyboardType: TextInputType.number,
                    enabled: !_switch,
                    decoration: const InputDecoration(
                      hintText: 'Roll number',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.deepPurple,
                          width: 8,
                          style: BorderStyle.solid,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: Get.height * .06),
              SizedBox(
                width: Get.width,
                child: Form(
                  key: _semesterKey,
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isNotEmpty && value.isNumericOnly) {
                        int semester = int.parse(value);
                        if (semester > 0 && semester < 9) {
                          return null;
                        } else {
                          return '1-8';
                        }
                      } else {
                        return 'Invalid input';
                      }
                    },
                    controller: _semesterController,
                    keyboardType: TextInputType.number,
                    enabled: !_switch,
                    decoration: const InputDecoration(
                      hintText: 'Semester',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.deepPurple,
                          width: 8,
                          style: BorderStyle.solid,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: Get.height * .1),
              ElevatedButton(
                onPressed: _proceed,
                child: const Text('Proceed'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _proceed() async {
    if (_switch) {
      if (_nameKey.currentState!.validate()) {
        await _createAdmin();
      }
    } else {
      if (_nameKey.currentState!.validate() &&
          _rollNoKey.currentState!.validate() &&
          _semesterKey.currentState!.validate()) {
        await _checkOrCreateStudent();
      }
    }
    _clearFields();
  }

  Future<void> _createAdmin() async {
    try {
      await _firestore.collection('admins').doc(_auth.currentUser!.uid).set({
        'id': _auth.currentUser!.uid,
        'name': _nameController.text,
        'auth': 1,
        'profile': _auth.currentUser!.photoURL,
        'mail': _auth.currentUser!.email
      });
      Hive.box("users").put("Auth", "admin");
      await signInCheck();
    } catch (error) {
      Get.snackbar('Error', error.toString());
    }
  }

  Future<void> _checkOrCreateStudent() async {
    DocumentReference docRef = _firestore.collection("initCollection").doc(_rollNoController.text);
    try {
      DocumentSnapshot doc = await docRef.get();
      if (doc.exists) {
        var studentName = doc.get("name").toString().toLowerCase();
        if (studentName == _nameController.text.toLowerCase().trim()) {
          await _createStudent();
        } else {
          _signOutWithError('Your name is not correct');
        }
      } else {
        await _createStudent();
      }
    } catch (error) {
      Get.snackbar('Error', error.toString());
    }
  }

  Future<void> _createStudent() async {
    try {
      await _firestore.collection('users').doc(_auth.currentUser!.uid).set({
        'id': _auth.currentUser!.uid,
        'name': _nameController.text,
        'semester': _semesterController.text,
        'rollno': _rollNoController.text,
        "mail": _auth.currentUser!.email,
        'profile': _auth.currentUser!.photoURL,
        'allowed': true
      });
      Hive.box("users").put("Auth", "student");
      await signInCheck();
    } catch (error) {
      Get.snackbar('Error', error.toString());
    }
  }

  void _signOutWithError(String message) {
    Get.snackbar('Error', message);
    _auth.signOut();
    GoogleSignIn().signOut();
    Get.offAll(() => login_screen());
  }

  void _clearFields() {
    _rollNoController.clear();
    _nameController.clear();
    _semesterController.clear();
  }
}
