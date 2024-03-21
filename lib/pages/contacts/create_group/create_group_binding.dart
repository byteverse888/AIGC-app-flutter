import 'package:get/get.dart';

import 'create_group_logic.dart';

class CreateGroupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CreateGroupLogic());
  }
}
