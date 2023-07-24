import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class menage_scr extends StatefulWidget {
  const menage_scr({super.key});

  @override
  State<menage_scr> createState() => _menage_scrState();
}

FirebaseFirestore _firestore = FirebaseFirestore.instance;
CollectionReference admins_firestore =
    FirebaseFirestore.instance.collection('admins');
TextEditingController _controller = TextEditingController();

class _menage_scrState extends State<menage_scr> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CupertinoTextFormFieldRow(
          onChanged: (value) {
            setState(() {});
          },
          controller: _controller,
          placeholder: 'Search',
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              width: 2,
              color: Colors.black.withOpacity(
                .2,
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const Text(
              'Teachers',
              style: TextStyle(
                fontSize: 25,
                fontFamily: 'ShantellSans',
              ),
            ),
            StreamBuilder(
              stream: admins_firestore.snapshots(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        if (snapshot.data.docs[index]['name']
                            .toLowerCase()
                            .contains(_controller.text.toLowerCase())) {
                          return CupertinoContextMenu(
                            actions: [
                              CupertinoContextMenuAction(
                                onPressed: () {
                                  _firestore
                                      .collection('admins')
                                      .doc(snapshot.data.docs[index]['id'])
                                      .update({"auth": 1});
                                  Get.back();
                                },
                                trailingIcon: Icons.verified_user,
                                child: const Text(
                                  "Allow",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontFamily: 'ShantellSans',
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                              CupertinoContextMenuAction(
                                onPressed: () {
                                  _firestore
                                      .collection('admins')
                                      .doc(snapshot.data.docs[index]['id'])
                                      .update({"auth": 0});
                                  Get.back();
                                },
                                trailingIcon: Icons.delete_forever,
                                child: const Text(
                                  "Restrict",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontFamily: 'ShantellSans',
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                            child: SizedBox(
                              width: Get.width * .8,
                              height: Get.height * .1,
                              child: Material(
                                child: ListTile(
                                  subtitle: Text(
                                    snapshot.data.docs[index]['mail'],
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontFamily: 'ShantellSans',
                                    ),
                                  ),
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      snapshot.data.docs[index]['profile'],
                                    ),
                                  ),
                                  title: Text(
                                    snapshot.data.docs[index]['name'],
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontFamily: 'ShantellSans',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else if (_controller.text.isEmpty) {
                          return CupertinoContextMenu(
                            actions: [
                              CupertinoContextMenuAction(
                                onPressed: () {
                                  _firestore
                                      .collection('admins')
                                      .doc(snapshot.data.docs[index]['id'])
                                      .update({"auth": 1});
                                  Get.back();
                                },
                                trailingIcon: Icons.verified_user,
                                child: const Text(
                                  "Allow",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontFamily: 'ShantellSans',
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                              CupertinoContextMenuAction(
                                onPressed: () {
                                  _firestore
                                      .collection('admins')
                                      .doc(snapshot.data.docs[index]['id'])
                                      .update({"auth": 0});
                                  Get.back();
                                },
                                trailingIcon: Icons.delete_forever,
                                child: const Text(
                                  "Restrict",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontFamily: 'ShantellSans',
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                            child: SizedBox(
                              width: Get.width * .8,
                              height: Get.height * .1,
                              child: Material(
                                child: ListTile(
                                  subtitle: Text(
                                    snapshot.data.docs[index]['mail'],
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontFamily: 'ShantellSans',
                                    ),
                                  ),
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      snapshot.data.docs[index]['profile'],
                                    ),
                                  ),
                                  title: Text(
                                    snapshot.data.docs[index]['name'],
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontFamily: 'ShantellSans',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else {
                          return const SizedBox();
                        }
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
            ),
          ],
        ),
      ),
    );
  }
}
