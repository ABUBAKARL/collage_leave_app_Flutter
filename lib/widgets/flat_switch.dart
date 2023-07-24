// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../functions/controllers.dart';

class fl_switch extends StatefulWidget {
  const fl_switch({super.key});

  @override
  State<fl_switch> createState() => _fl_switchState();
}

class _fl_switchState extends State<fl_switch> {
  final Switch_controller _switch = Get.put(
    Switch_controller(),
  );

  Color selected_color = Colors.white;

  Color unselected_color = Colors.grey.shade500;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          _switch.toggle();
        },
        child: Container(
          width: Get.width * .9,
          height: Get.height * .08,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: unselected_color,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: Get.height * .07,
                width: Get.width * .44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: _switch.selected.value
                      ? selected_color
                      : unselected_color,
                ),
                child: const Center(
                  child: Text('Teacher'),
                ),
              ),
              Container(
                height: Get.height * .07,
                width: Get.width * .44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: !_switch.selected.value
                      ? selected_color
                      : unselected_color,
                ),
                child: const Center(
                  child: Text('Student'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
