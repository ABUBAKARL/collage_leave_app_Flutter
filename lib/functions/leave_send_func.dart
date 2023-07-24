// ignore_for_file: non_constant_identifier_names, camel_case_types

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class date_controller extends GetxController {
  final date = DateTime.now().obs;
}

FirebaseAuth _auth = FirebaseAuth.instance;
CollectionReference application_ref =
    FirebaseFirestore.instance.collection('applications');
final user =
    FirebaseFirestore.instance.collection('users').doc(_auth.currentUser!.uid);

date_controller _date_ = Get.put(date_controller());
void date_select(context, String application) {
  Get.bottomSheet(
    Padding(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
      ),
      child: Container(
        height: Get.height * .5,
        decoration: const BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: CupertinoDatePicker(
                initialDateTime: _date_.date.value,
                mode: CupertinoDatePickerMode.date,
                onDateTimeChanged: ((value) {
                  _date_.date.value = value;
                }),
              ),
            ),
            FilledButton(
              onPressed: () async {
                var id = DateTime.now().microsecondsSinceEpoch;
                final username = await user.get();
                if (!_date_.date.value.isBefore(
                  DateTime.now().subtract(
                    const Duration(days: 1),
                  ),
                )) {
                  application_ref.doc(id.toString()).set(
                    {
                      'id': id.toString(),
                      'uid': _auth.currentUser!.uid.toString(),
                      'date':
                          '${_date_.date.value.day}/${_date_.date.value.month}/${_date_.date.value.year}',
                      'application': application,
                      'status': 0,
                      'dp': _auth.currentUser!.photoURL.toString(),
                      "name": username.get("name"),
                    },
                  );
                  Get.back();
                } else {
                  Get.snackbar(
                    "Error",
                    'Please correct date',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                }
              },
              child: const Text('Send'),
            ),
            const SizedBox(
              height: 15,
            )
          ],
        ),
      ),
    ),
  );
}
