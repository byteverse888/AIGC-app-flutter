import 'package:get/get.dart';

import 'aicreate_logic.dart';

class AICreateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AICreateLogic());
  }
}
