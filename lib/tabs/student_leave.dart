import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../applications/applications.dart';
import '../settings/colors.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

FirebaseAuth _auth = FirebaseAuth.instance;
CollectionReference application_ref =
    FirebaseFirestore.instance.collection('applications');

class student_leave extends StatelessWidget {
  const student_leave({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder(
            stream: application_ref.snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var items = snapshot.data.docs.length - 1;
                    var applicationStatus =
                        snapshot.data.docs[items - index]['status'];

                    return snapshot.data.docs[items - index]["uid"] ==
                            _auth.currentUser!.uid
                        ? Card(
                            child: Column(
                              children: [
                                ListTile(
                                    title: Text(
                                      snapshot.data.docs[items - index]
                                          ['application'],
                                      style: const TextStyle(
                                        fontFamily: 'ShantellSans',
                                      ),
                                    ),
                                    subtitle: Text(
                                      snapshot.data.docs[items - index]['date'],
                                      style: const TextStyle(
                                        fontFamily: 'ShantellSans',
                                      ),
                                    ),
                                    trailing: applicationStatus == 0
                                        ? IconButton(
                                            icon: const Icon(
                                              Icons.close_outlined,
                                            ),
                                            onPressed: () {
                                              Get.defaultDialog(
                                                title: "",
                                                middleText:
                                                    'Delete application',
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      application_ref
                                                          .doc(
                                                            snapshot.data.docs[
                                                                    items -
                                                                        index]
                                                                ['id'],
                                                          )
                                                          .delete();
                                                      Get.back();
                                                    },
                                                    child:
                                                        const Text('Confirm'),
                                                  ),
                                                  SizedBox(
                                                    width: Get.width * .07,
                                                  ),
                                                  TextButton(
                                                      onPressed: () {
                                                        Get.back();
                                                      },
                                                      child: const Text(
                                                        'Cancel',
                                                      )),
                                                ],
                                              );
                                            },
                                          )
                                        : null),
                                Container(
                                  height: Get.height * .07,
                                  decoration: BoxDecoration(
                                    color: custom_Colors.status_colors_students[
                                        applicationStatus],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Text(
                                      applications.status[applicationStatus],
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontFamily: 'ShantellSans'),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        : const SizedBox();
                  },
                );
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text('There is some Error'),
                );
              } else {
                return Center(
                  child: LoadingAnimationWidget.discreteCircle(
                    color: Colors.green,
                    secondRingColor: Colors.orange,
                    thirdRingColor: Colors.red,
                    size: 40,
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
