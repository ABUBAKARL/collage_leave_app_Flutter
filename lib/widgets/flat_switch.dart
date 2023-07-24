import 'package:flutter/material.dart';
import 'package:get/get.dart';

class fl_switch extends StatefulWidget {
  bool switch_;
  VoidCallback toogle;

  fl_switch({super.key, required this.switch_,required this.toogle});

  @override
  State<fl_switch> createState() => _fl_switchState();
}

class _fl_switchState extends State<fl_switch> {
  Color selected_color = Colors.white;

  Color unselected_color = Colors.grey.shade500;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          //toogle switch
          widget.toogle();
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
                  color: widget.switch_ ? selected_color : unselected_color,
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
                  color: !widget.switch_ ? selected_color : unselected_color,
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
