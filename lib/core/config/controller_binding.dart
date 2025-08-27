
import 'package:get/get.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

import '../lang/lang_controller.dart';
import 'navigation_controller.dart';

class ControllerBinding extends Bindings {

  @override
  void dependencies(){
    Get.put(LanguageController());
    Get.put(NavigationController());
  }
}