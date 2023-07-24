import 'package:get/get.dart';
class Switch_controller extends GetxController {
  var selected = false.obs;
  toggle() {
    selected.value = !selected.value;
  }
}
