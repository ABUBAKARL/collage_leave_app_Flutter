import 'package:flutter/material.dart';
import 'package:get/get.dart';

class details_chip extends StatelessWidget {
  final String data;
  const details_chip({super.key, required this.data});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height * .1,
      width: Get.width * .9,
      child: Card(
        elevation: 5,
        child: Center(
          child: Text(
            data.toString(),
            style: const TextStyle(
              fontSize: 25,
              fontFamily: 'ShantellSans',
            ),
          ),
        ),
      ),
    );
  }
}
