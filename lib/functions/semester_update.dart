import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';

FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseFirestore _firestore = FirebaseFirestore.instance;
semester_update(TextEditingController controller,
    GlobalKey<FormState> semesterKey) async {
  var docRef =
      await _firestore.collection('users').doc(_auth.currentUser!.uid).get();
  DateTime timeShould = DateTime.now().subtract(
    const Duration(days: 59),
  );
  Get.defaultDialog(
    title: 'Update',
    content: Column(
      children: [
        const Text(
          'Can\'t be changed again in 60 days',
          style: TextStyle(
            color: Colors.red,
          ),
        ),
        SizedBox(
          height: Get.height * .02,
        ),
        SizedBox(
          width: Get.width * .3,
          child: Form(
            key: semesterKey,
            child: CupertinoTextFormFieldRow(
              keyboardType: TextInputType.number,
              controller: controller,
              validator: (value) {
                if (value!.isNotEmpty & value.isNumericOnly) {
                  if ((int.parse(value) > 0) & (int.parse(value) < 9)) {
                    return null;
                  } else {
                    return '1-8';
                  }
                } else {
                  return 'Invalid input';
                }
              },
              placeholder: 'Semester',
              maxLength: 1,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.blue.withOpacity(.7),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    ),
    actions: [
      TextButton(
        onPressed: () {
          if (semesterKey.currentState!.validate()) {
            if (timeShould.isAfter(
              DateTime.parse(
                docRef.data()!['delay'].toString(),
              ),
            )) {
              _firestore.collection('users').doc(_auth.currentUser!.uid).update(
                {
                  "semester": controller.text,
                  'delay': DateTime.now().toString()
                },
              );
              Get.back();
              Get.snackbar(
                'Done',
                'Semester updated',
              );
              controller.clear();
            } else {
              Get.snackbar("Sorry", 'Try after some days');
            }
          }
        },
        child: const Text('Confirm'),
      ),
      TextButton(
        onPressed: () {
          Get.back();
        },
        child: const Text('Cancel'),
      )
    ],
  );
}
