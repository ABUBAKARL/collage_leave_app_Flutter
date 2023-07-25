import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../settings/colors.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../Screens/user_info.dart';

CollectionReference application_ref =
    FirebaseFirestore.instance.collection('applications');
CollectionReference user_ref = FirebaseFirestore.instance.collection('users');

class teacher_leave extends StatelessWidget {
  const teacher_leave({super.key});
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
                    final userdoc =
                        user_ref.doc(snapshot.data.docs[items - index]['uid']);
                    return Card(
                      child: Column(
                        children: [
                          ListTile(
                            onTap: () async {
                              final userdata = await userdoc.get();
                              Get.to(
                                () => user_info(
                                  name: userdata.get('name'),
                                  gmail: userdata.get('mail'),
                                  profile: userdata.get('profile'),
                                  rollno: int.parse(
                                    userdata.get('rollno'),
                                  ),
                                  semester: int.parse(
                                    userdata.get('semester'),
                                  ),
                                ),
                              );
                            },
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                snapshot.data.docs[items - index]['dp'],
                                scale: 8,
                              ),
                            ),
                            title: Text(
                              snapshot.data.docs[items - index]['name'],
                              style: const TextStyle(
                                fontFamily: 'ShantellSans',
                              ),
                            ),
                            subtitle: Text(
                              snapshot.data.docs[items - index]['application'],
                              style: const TextStyle(
                                fontFamily: 'ShantellSans',
                              ),
                            ),
                            trailing: Text(
                              snapshot.data.docs[items - index]['date'],
                            ),
                          ),
                          Container(
                            height: Get.height * .07,
                            width: Get.width * 1,
                            decoration: BoxDecoration(
                              color: custom_Colors
                                  .status_color_teacher[applicationStatus],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: applicationStatus == 0
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          application_ref
                                              .doc(snapshot.data
                                                  .docs[items - index]['id'])
                                              .update(
                                            {
                                              'status': 1,
                                            },
                                          );
                                        },
                                        child: Container(
                                          height: Get.height * .07,
                                          width: Get.width * .48,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: Colors.green,
                                          ),
                                          child: const Center(
                                            child: Text(
                                              'Approve',
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.white,
                                                fontFamily: 'ShantellSans',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          application_ref
                                              .doc(snapshot.data
                                                  .docs[items - index]['id'])
                                              .update(
                                            {
                                              'status': 2,
                                            },
                                          );
                                        },
                                        child: Container(
                                          height: Get.height * .07,
                                          width: Get.width * .48,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: Colors.red,
                                          ),
                                          child: const Center(
                                            child: Text(
                                              'Reject',
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.white,
                                                fontFamily: 'ShantellSans',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : applicationStatus == 1
                                    ? const Center(
                                        child: Text(
                                          'Approved',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontFamily: 'ShantellSans',
                                          ),
                                        ),
                                      )
                                    : const Center(
                                        child: Text(
                                          'Rejected',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white,
                                              fontFamily: 'ShantellSans'),
                                        ),
                                      ),
                          )
                        ],
                      ),
                    );
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
