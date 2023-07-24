import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../functions/controllers.dart';
import '../functions/sign_in.dart';
import '../widgets/flat_switch.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class login_info extends StatefulWidget {
  const login_info({super.key});
  @override
  State<login_info> createState() => _login_infoState();
}

FirebaseFirestore _firestore = FirebaseFirestore.instance;
FirebaseAuth _auth = FirebaseAuth.instance;
Switch_controller _switch = Get.put(Switch_controller(), permanent: true);
TextEditingController _namecontroller = TextEditingController();
TextEditingController _smestercontroller = TextEditingController();
TextEditingController _rollNocontroller = TextEditingController();
TextEditingController _departmentcontroller = TextEditingController();
final _namekey = GlobalKey<FormState>();
final _rollnokey = GlobalKey<FormState>();
final _smesterkey = GlobalKey<FormState>();
final _departementkey = GlobalKey<FormState>();

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
              const fl_switch(),
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
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: Get.width * .4,
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
                          enabled: _switch.selected.value ? false : true,
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
                      width: Get.width * .4,
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
                          enabled: _switch.selected.value ? false : true,
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
                  ],
                ),
              ),
              SizedBox(
                height: Get.height * .06,
              ),
              Obx(
                () => Form(
                  key: _departementkey,
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isNotEmpty) {
                        return null;
                      } else {
                        return 'Invalid input';
                      }
                    },
                    controller: _departmentcontroller,
                    decoration: InputDecoration(
                      hintText: _switch.selected.value
                          ? 'Department/Subject'
                          : "Department",
                      border: const OutlineInputBorder(
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
                onPressed: () {
                  if (_switch.selected.value) {
                    if (_departementkey.currentState!.validate() &
                        _namekey.currentState!.validate()) {
                      _firestore
                          .collection('admins')
                          .doc(_auth.currentUser!.uid)
                          .set({
                        'id': _auth.currentUser!.uid,
                        'name': _namecontroller.text,
                        'department': _departmentcontroller.text,
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
                    if (_departementkey.currentState!.validate() &
                        _namekey.currentState!.validate() &
                        _rollnokey.currentState!.validate() &
                        _smesterkey.currentState!.validate()) {
                      _firestore
                          .collection('users')
                          .doc(_auth.currentUser!.uid)
                          .set({
                        'id': _auth.currentUser!.uid,
                        'name': _namecontroller.text,
                        'semester': _smestercontroller.text,
                        'rollno': _rollNocontroller.text,
                        'department': _departmentcontroller.text,
                        "mail": _auth.currentUser!.email,
                        'profile': _auth.currentUser!.photoURL,
                        'allowed': true
                      }).then(
                        (value) async{
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
                    }
                  }
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
