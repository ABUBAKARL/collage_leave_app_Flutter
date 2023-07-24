import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

FirebaseAuth _auth = FirebaseAuth.instance;
final announcement_key = GlobalKey<FormState>();
CollectionReference _collectionReference =
    FirebaseFirestore.instance.collection('announcement');
TextEditingController _textEditingController = TextEditingController();
DocumentReference user_data =
    FirebaseFirestore.instance.collection('admins').doc(_auth.currentUser!.uid);
class announcement_send extends StatelessWidget {
  const announcement_send({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Announce",
          style: TextStyle(fontFamily: 'ShantellSans'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Form(
              key: announcement_key,
              child: TextFormField(
                controller: _textEditingController,
                style: const TextStyle(
                  fontSize: 20,
                  fontFamily: 'ShantellSans',
                  color: Colors.indigoAccent,
                ),
                validator: (value) {
                  if (value!.length > 8) {
                    return null;
                  } else {
                    return "Use more characters";
                  }
                },
                maxLines: 5,
                decoration: const InputDecoration(
                  enabled: true,
                  helperText: 'Announcement',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            FilledButton(
              onPressed: () async {
                if (announcement_key.currentState!.validate()) {
                  final info = await user_data.get();
                  final id = DateTime.now().microsecondsSinceEpoch.toString();
                  _collectionReference.doc(id).set(
                    {
                      'id': id,
                      "notice": _textEditingController.text,
                      'name': info.get('name'),
                      'uid':_auth.currentUser!.uid,
                      'profile':_auth.currentUser!.photoURL,
                      'date':DateTime.now().toString().substring(0,15)
                    },
                  ).then(
                    (value) {
                      _textEditingController.clear();
                      Get.snackbar(
                          'Done', 'Announcement successfully published');
                    },
                  ).onError(
                    (error, stackTrace) {
                      Get.snackbar(
                        "Error",
                        error.toString(),
                      );
                    },
                  );
                }
              },
              child: const Text(
                'Publish announcement',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

