import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

CollectionReference _firestore =
    FirebaseFirestore.instance.collection('announcement');

class announcement extends StatelessWidget {
 final bool userType;
  const announcement({super.key, required this.userType});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        StreamBuilder(
          stream: _firestore.snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text(
                  'There is some error',
                  style: TextStyle(fontSize: 20),
                ),
              );
            } else if (snapshot.hasData) {
              return Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    var items = snapshot.data.docs.length - 1;
                    return Card(
                      child: Column(
                        children: [
                          ListTile(
                            isThreeLine: true,
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                snapshot.data.docs[items - index]['profile'],
                              ),
                            ),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  snapshot.data.docs[items - index]['name'],
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'ShantellSans',
                                  ),
                                ),
                                SizedBox(
                                  width: Get.width * .03,
                                ),
                                const Icon(
                                  Icons.verified,
                                  color: Colors.cyan,
                                  size: 20,
                                )
                              ],
                            ),
                            subtitle: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  snapshot.data.docs[items - index]['notice'],
                                  style: const TextStyle(
                                      fontSize: 15, fontFamily: 'ShantellSans'),
                                ),
                                SizedBox(
                                  height: Get.height * 0.01,
                                ),
                                Text(
                                  snapshot.data.docs[items - index]['date']
                                      .toString(),
                                  style: const TextStyle(
                                      fontSize: 12, fontFamily: 'ShantellSans'),
                                ),
                              ],
                            ),
                            trailing: userType
                                ? PopupMenuButton(
                                    icon: const Icon(
                                      Icons.more_vert,
                                    ),
                                    itemBuilder: (context) {
                                      return [
                                        PopupMenuItem(
                                          child: const Text('Delete'),
                                          onTap: () {
                                            _firestore
                                                .doc(
                                                  snapshot.data
                                                          .docs[items - index]
                                                      ['id'],
                                                )
                                                .delete();
                                          },
                                        ),
                                      ];
                                    },
                                  )
                                : null,
                          ),
                        ],
                      ),
                    );
                  },
                ),
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
        )
      ],
    );
  }
}
