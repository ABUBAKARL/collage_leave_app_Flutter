import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import '../Screens/menage.dart';
import '../functions/semester_update.dart';
import '../functions/sign_in.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
TextEditingController _controller = TextEditingController();
final _semester_key = GlobalKey<FormState>();
FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseFirestore _firestore = FirebaseFirestore.instance;
class info_drawer extends StatelessWidget {
  final bool userType;
  const info_drawer({super.key, required this.userType});
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: StreamBuilder(
        stream: _firestore
            .collection(userType ? 'admins' : 'users')
            .doc(_auth.currentUser!.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                UserAccountsDrawerHeader(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomRight,
                      end: Alignment.topLeft,
                      colors: [
                        Colors.amber,
                        Colors.red,
                        Colors.blue,
                      ],
                      stops: [
                        .1,
                        .5,
                        1,
                      ],
                    ),
                  ),
                  currentAccountPicture: Image.network(
                    snapshot.data['profile'],
                  ),
                  accountName: Text(
                    snapshot.data['name'],
                    style: const TextStyle(
                      fontSize: 20,
                      fontFamily: 'ShantellSans',
                    ),
                  ),
                  accountEmail: Text(
                    snapshot.data['mail'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'ShantellSans',
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    !userType
                        ? semester_update(_controller, _semester_key)
                        : Get.to(const menage_scr());
                  },
                  title: Text(!userType?'Update Semester':'Manage',
                          style: const TextStyle(
                            fontSize: 20,
                            fontFamily: 'ShantellSans',
                          ),
                        ),
                  tileColor: Colors.amber.withOpacity(
                    .7,
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton.icon(
                      icon: const Icon(
                        Icons.logout_rounded,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('logout and exit'),
                              actions: [
                                TextButton(
                                  onPressed: () async {
                                    await GoogleSignIn().signOut();
                                    await _auth.signOut();
                                    final box = Hive.box("users");
                                    await box.delete("auth");
                                    await signInCheck();
                                  },
                                  child: const Text('Confirm'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: const Text('Cancel'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      label: const Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'ShantellSans',
                        ),
                      ),
                    ),
                  ),
                ),
              ],
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
    );
  }
}
