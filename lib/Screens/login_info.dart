import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import '../functions/sign_in.dart';
import '../widgets/flat_switch.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class login_info extends StatefulWidget {
  const login_info({super.key});
  @override
  State<login_info> createState() => _login_infoState();
}

bool _switch = false;
FirebaseFirestore _firestore = FirebaseFirestore.instance;
FirebaseAuth _auth = FirebaseAuth.instance;
TextEditingController _namecontroller = TextEditingController();
TextEditingController _smestercontroller = TextEditingController();
TextEditingController _rollNocontroller = TextEditingController();
final _namekey = GlobalKey<FormState>();
final _rollnokey = GlobalKey<FormState>();
final _smesterkey = GlobalKey<FormState>();

class _login_infoState extends State<login_info> {
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
              SizedBox(
                height: Get.height * .05,
              ),
              FlatSwitch(
                switch_: _switch,
                toogle: () {
                  _switch = !_switch;
                  setState(() {});
                },
              ),
              SizedBox(
                height: Get.height * .1,
              ),
              Form(
                key: _namekey,
                child: TextFormField(
                  validator: (value) {
                    if (value!.isNotEmpty) {
                      return null;
                    } else {
                      return 'Invalid input';
                    }
                  },
                  controller: _namecontroller,
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
              SizedBox(
                height: Get.height * .06,
              ),
              SizedBox(
                width: Get.width,
                child: Form(
                  key: _rollnokey,
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isNotEmpty & value.isNumericOnly) {
                        return null;
                      } else {
                        return 'Invalid input';
                      }
                    },
                    controller: _rollNocontroller,
                    keyboardType: TextInputType.number,
                    enabled: _switch ? false : true,
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
              SizedBox(
                height: Get.height * .06,
              ),
              SizedBox(
                width: Get.width,
                child: Form(
                  key: _smesterkey,
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isNotEmpty & value.isNumericOnly) {
                        if ((int.parse(value.toString()) > 0) &
                            (int.parse(value.toString()) < 9)) {
                          return null;
                        } else {
                          return '1-8';
                        }
                      } else {
                        return 'Invalid input';
                      }
                    },
                    controller: _smestercontroller,
                    keyboardType: TextInputType.number,
                    enabled: _switch ? false : true,
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
              SizedBox(
                height: Get.height * .1,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_switch) {
                    if (_namekey.currentState!.validate()) {
                      _firestore
                          .collection('admins')
                          .doc(_auth.currentUser!.uid)
                          .set({
                        'id': _auth.currentUser!.uid,
                        'name': _namecontroller.text,
                        'auth': 1,
                        'profile': _auth.currentUser!.photoURL,
                        'mail': _auth.currentUser!.email
                      }).then(
                        (value) async {
                          Hive.box("users").put("Auth", "admin");
                          await signInCheck();
                        },
                      ).onError(
                        (error, stackTrace) {
                          Get.snackbar(
                            'Error',
                            error.toString(),
                          );
                        },
                      );
                    }
                  } else {
                    if (_namekey.currentState!.validate() &
                        _rollnokey.currentState!.validate() &
                        _smesterkey.currentState!.validate()) {
                      await _firestore
                          .collection("initCollection")
                          .doc(_rollNocontroller.text.toString())
                          .get()
                          .then((value) {
                        if (value.exists) {
                          var StudentName =
                              value.get("name").toString().toLowerCase();
                          if (StudentName ==
                              _namecontroller.text.toLowerCase().trim()) {
                            _firestore
                                .collection('users')
                                .doc(_auth.currentUser!.uid)
                                .set({
                              'id': _auth.currentUser!.uid,
                              'name': _namecontroller.text,
                              'semester': _smestercontroller.text,
                              'rollno': _rollNocontroller.text,
                              "mail": _auth.currentUser!.email,
                              'profile': _auth.currentUser!.photoURL,
                              'allowed': true
                            }).then(
                              (value) async {
                                Hive.box("users").put("Auth", "student");
                                await signInCheck();
                              },
                            ).onError(
                              (error, stackTrace) {
                                Get.snackbar(
                                  'Error',
                                  error.toString(),
                                );
                              },
                            );
                          } else {
                            Get.snackbar(
                              'Error',
                              'Your name is not correct',
                            );
                            _auth.signOut();
                            GoogleSignIn().signOut();
                          }
                        } else {
                          Get.snackbar(
                            'Error',
                            'Roll number does not exist in our database',
                          );
                          _auth.signOut();
                          GoogleSignIn().signOut();
                        }
                      });
                    }
                  }
                  _rollNocontroller.clear();
                  _namecontroller.clear();
                  _smestercontroller.clear();
                },
                child: const Text('Proceed'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
